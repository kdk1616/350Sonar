/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */

    //////////////////////// Fetch STAGE ////////////////////////

    wire[31:0] FD_IR, FD_PC, FD_jump;
    wire FD_do_jump, dummy_wire, FD_stall;

    Fetch fetch_layer(
        .out_pc(FD_PC), 
        .out_ir(FD_IR), 

        .address_imem(address_imem), 
        .q_imem(q_imem), 
        .jump(FD_jump), 
        .do_jump(FD_do_jump), 
        .clock(clock), 
        .reset(reset),
        .stall(FD_stall)
    );

    //////////////////////// Decode STAGE ////////////////////////

    wire[31:0] DX_PC, DX_A, DX_B, DX_IR;
    wire DX_stall;

    Decode decode_layer(
        .out_pc(DX_PC), 
        .out_A(DX_A), 
        .out_B(DX_B), 
        .out_ir(DX_IR), 
        .ctrl_readRegA(ctrl_readRegA), 
        .ctrl_readRegB(ctrl_readRegB), 
        .do_stall(DX_stall),
        
        .pc(FD_PC), 
        .ir(FD_IR), 
        .dx_ir(DX_IR), .xm_ir(XM_IR),
        .data_readRegA(data_readRegA), 
        .data_readRegB(data_readRegB), 
        .flush(FD_do_jump),
        .other_stall(div_stall),
        .do_halt(alu_halt),
        .halt_value(alu_halt_value),
        .div_halt(div_write_err),
        .clock(clock), 
        .reset(reset)
    );

    //////////////////////// Execute STAGE ////////////////////////

    wire[31:0] XM_O, XM_B, XM_IR;
    wire div_stall, div_error, div_write;
    wire div_write_err = div_write & div_error;
    wire[31:0] div_result;
    wire[4:0] div_reg;

    wire alu_halt;
    wire[26:0] alu_halt_value;

    // DX_stall: stall on data hazards
    // div_stall: stall while div is running
    // alu_halt: on ALU overflow / error, halt to insert an instruction to write to $rstatus
    // div_write_err: on div write error, halt to insert an instruction to write to $rstatus
    assign FD_stall = DX_stall | div_stall | alu_halt | div_write_err;

    Xecute execute_layer(
        .out_O(XM_O), 
        .out_B(XM_B), 
        .out_IR(XM_IR), 
        .out_jump(FD_jump),
        .out_do_jump(FD_do_jump),
        .out_halt(alu_halt),
        .out_halt_value(alu_halt_value),
        // division things
        .out_div_stall(div_stall),
        .out_div(div_result),
        .out_div_error(div_error),
        .out_div_write(div_write),
        .out_div_reg(div_reg),

        .pc(DX_PC), 
        .A(DX_A),
        .B(DX_B),
        .ir(DX_IR), 
        .xm_ir(XM_IR),
        .mw_ir(MW_IR),
        .xm_o(XM_O),
        .mw_o(data_writeReg),
        .reg_wren(ctrl_writeEnable),
        .clock(clock), 
        .reset(reset)
    );

    //////////////////////// Memory STAGE ////////////////////////

    wire[31:0] MW_O, MW_D, MW_IR;
    wire MW_NEXT_WE;

    Memory memory_stage(
        .out_O(MW_O),
        .out_D(MW_D),
        .out_IR(MW_IR),
        .address_dmem(address_dmem),
        .data_dmem(data),
        .data_wren(wren),

        .O(XM_O),
        .B(XM_B),
        .ir(XM_IR),
        .write_reg(ctrl_writeReg),
        .write_reg_val(data_writeReg),
        .reg_wren(ctrl_writeEnable),
        .q_dmem(q_dmem),
        .clock(clock),
        .reset(reset)
    );

    //////////////////////// Writeback STAGE ////////////////////////

    wire[3:0] wb_optype;
    op_type wb_optype_inst(.out(wb_optype), .op(MW_IR[31:27]));

    wire[31:0] normal_writereg = (MW_IR[31:27] == 5'b01000) ? MW_D : MW_O;
    wire[4:0] jal_writereg = 5'b11111;
    wire[4:0] status_reg = 5'b11110;
    wire is_jal = MW_IR[31:27] == 5'b00011;
    wire is_setx = MW_IR[31:27] == 5'b10101;

    wire is_jump_with_set = is_jal | is_setx;
    wire[4:0] jump_set_reg = is_jal ? jal_writereg : status_reg;


    // assign writeReg
    assign ctrl_writeReg = div_write ? div_reg : (is_jump_with_set ? jump_set_reg : MW_IR[26:22]);

    // check for loadword for data to set to writeReg
    assign data_writeReg = div_write ? div_result : normal_writereg;

    assign ctrl_writeEnable = div_write | wb_optype[0] | is_jump_with_set | (MW_IR[31:27] == 5'b01000) | (MW_IR[31:27] == 5'b00101);
endmodule
