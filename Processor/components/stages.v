module Fetch(out_pc, out_ir, address_imem, q_imem, jump, do_jump, clock, reset, stall);
    input do_jump, clock, reset, stall;
    input[31:0] jump, q_imem;
    output[31:0] out_pc, out_ir, address_imem;

    wire[31:0] cur_pc, pc_p1, next_pc;

    register32 pc_reg(.out(cur_pc), .in(next_pc), .clk(~clock), .input_enable(~stall), .reset(reset));

    assign address_imem = cur_pc;

    wire dummy_wire;
    cla_adder pc_adder(.S(pc_p1), .Cout(dummy_wire), .X(address_imem), .Y(32'b0), .Cin(1'b1));

    assign next_pc = do_jump ? jump : pc_p1;

    wire[31:0] next_ir = do_jump ? 32'b0 : q_imem;

    register32 FD_IR_reg(
        .out(out_ir), 
        .in(next_ir),
        .clk(~clock),
        .input_enable(~stall),
        .reset(reset)
    );

    assign out_pc = cur_pc;
endmodule

module detect_hazard(out_hazard, fd_ir, dx_ir);
    input[31:0] fd_ir, dx_ir;
    output out_hazard;

    wire[3:0] fd_optype; // [R, I, JI, JII]
    op_type optype_inst(.out(fd_optype), .op(fd_ir[31:27]));

    wire fd_is_jr = fd_ir[31:27] == 5'b00100;

    wire[4:0] dx_opcode = dx_ir[31:27];
    wire[4:0] fd_opcode = fd_ir[31:27];
    wire[4:0] fd_rs1 = fd_ir[21:17];
    wire[4:0] fd_rs2 = fd_optype[0] ? fd_ir[16:12] : fd_ir[26:22];
    wire[4:0] dx_rd = dx_ir[26:22];

    wire fd_rs1_not_0 = fd_rs1 != 5'b00000;
    wire fd_rs2_not_0 = fd_rs2 != 5'b00000;

    wire dx_is_load = (dx_opcode == 5'b01000);
    wire fd_rs1_is_dx_rd = (fd_rs1 == dx_rd) & fd_rs1_not_0;
    wire fd_rs2_is_dx_rd = (fd_rs2 == dx_rd) & fd_rs2_not_0;
    wire fd_is_not_store = fd_opcode != 5'b00111;

    assign out_hazard = dx_is_load & (
        fd_rs1_is_dx_rd | (fd_rs2_is_dx_rd & fd_is_not_store)
    );

    // wire comp1 = dx_is_load & (fd_rs1 == dx_rd) & fd_rs1_not_0 & dx_rd_not_0;
    // wire comp2 = (fd_rs2 == dx_rd) & fd_is_not_store & fd_rs2_not_0 & dx_rd_not_0;
    // assign out_hazard = comp1 | comp2;
endmodule

module Decode(
    out_pc,         // out PC
    out_A,          // value from register A
    out_B,          // value from register B
    out_ir,         // instruction
    ctrl_readRegA,  // control for register A
    ctrl_readRegB,  // control for register B
    do_stall,       // stall signal for data hazards
    
    pc,             // current PC
    ir,             // current instruction
    dx_ir, xm_ir,   // instructions from DX and XM stages (for data hazards)
    data_readRegA,  // value from register A
    data_readRegB,  // value from register B
    flush,          // flush signal
    other_stall,    // stall signal from other stages (flush with nop)
    do_halt,        // halt signal (sets target in IR to halt value)
    halt_value,     // value to set target in IR to when halting
    div_halt,       // halt signal from divider
    clock,          // clock signal
    reset           // reset signal
    );
    input[31:0] pc, ir, data_readRegA, data_readRegB, dx_ir, xm_ir;
    input clock, reset, other_stall, do_halt, div_halt, flush;
    input[26:0] halt_value;

    output[31:0] out_pc, out_A, out_B, out_ir;
    output[4:0] ctrl_readRegA, ctrl_readRegB;
    output do_stall;

    wire[3:0] optype; // [R, I, JI, JII]
    op_type optype_inst(.out(optype), .op(ir[31:27]));

    wire is_bex = ir[31:27] == 5'b10110;

    // rd = [26:22], rs = [21:17], rt = [16:12]
    wire[4:0] rs = ir[21:17];
    assign ctrl_readRegA = is_bex ? 5'b11110 : (flush ? 5'b00000 : rs);
    // if no rt, then replace with rd to use for store word and the like
    assign ctrl_readRegB = (is_bex | do_halt | flush) ? 5'b00000 : (optype[0] ? ir[16:12] : ir[26:22]);

    detect_hazard hazard_inst(.out_hazard(do_stall), .fd_ir(ir), .dx_ir(dx_ir));

    wire should_do_halt = do_halt | div_halt;
    wire[31:0] act_halt_value = do_halt ? {5'b10101, halt_value} : {5'b10101, 24'b0, 3'b101};

    // wire[31:0] ir_next = (do_stall | other_stall | flush) ? 32'b0 : (should_do_halt ? act_halt_value : ir);
    wire[31:0] ir_next = should_do_halt ? act_halt_value : ((do_stall | other_stall | flush) ? 32'b0 : ir);

    // store numbers from regfile
    register32 DX_A_reg(.out(out_A), .in(data_readRegA), .clk(~clock), .input_enable(1'b1), .reset(reset));
    register32 DX_B_reg(.out(out_B), .in(data_readRegB), .clk(~clock), .input_enable(1'b1), .reset(reset));
    register32 DX_PC_reg(.out(out_pc), .in(pc), .clk(~clock), .input_enable(1'b1), .reset(reset));
    register32 DX_IR_reg(.out(out_ir), .in(ir_next), .clk(~clock), .input_enable(1'b1), .reset(reset));
endmodule

module xecute_alu(
    ne, out, lt, ovf,
    a, b, ir
    );
    input[31:0] a, b, ir;
    output[31:0] out;
    output ne, lt, ovf;

    wire[3:0] optype; // [R, I, JI, JII]
    op_type optype_inst(.out(optype), .op(ir[31:27]));

    // alu A = {A if R or I}, {0 if JI or JII}
    wire use_a = optype[0] | optype[1];
    wire[31:0] alu_a = use_a ? a : 32'b0;

    // alu B = {imm ig I-type and not bne or blt}, {b otherwise}
    wire[31:0] imm;
    sign_extender_17 imm_extender(.in(ir[16:0]), .out(imm));
    wire use_imm = optype[1] & ~((ir[31:27] == 5'b00010) | (ir[31:27] == 5'b00110));
    wire[31:0] alu_b = use_imm ? imm : b;

    wire[4:0] alu_r_opcode = ir[6:2];

    // alu opcode = r_opcode if R-type, 0 otherwise, unless subtraction (opcode = 00001)
    // wire[4:0] alu_opcode = optype[0] ? alu_r_opcode : 5'b00000;
    wire is_blt = ir[31:27] == 5'b00110;
    wire is_bne = ir[31:27] == 5'b00010;
    wire is_bex = ir[31:27] == 5'b10110;
    wire is_b = is_blt | is_bne | is_bex;
    wire[4:0] alu_opcode = optype[0] ? alu_r_opcode : (is_b ? 5'b00001 : 5'b00000);

    wire[31:0] alu_actual_a = is_blt ? alu_b : alu_a;
    wire[31:0] alu_actual_b = is_blt ? alu_a : alu_b;

    alu alu(
        .data_operandA(alu_actual_a), 
        .data_operandB(alu_actual_b), 
        .ctrl_ALUopcode(alu_opcode), 
        .ctrl_shiftamt(ir[11:7]), 
        .data_result(out),
        .isNotEqual(ne), 
        .isLessThan(lt), 
        .overflow(ovf)
    );
endmodule

module xecute_branch(
    jump, do_jump,
    ir, pc, rd, lt, ne, rstatus
    );
    input[31:0] pc, rd, ir, rstatus;
    input lt, ne;

    output[31:0] jump;
    output do_jump;

    wire[31:0] imm, target, jmp_pc_1_n;
    sign_extender_17 imm_extender(.in(ir[16:0]), .out(imm));
    sign_extender_27 target_extender(.in(ir[26:0]), .out(target));

    wire dummy_wire;
    cla_adder pc_adder(.S(jmp_pc_1_n), .Cout(dummy_wire), .X(pc), .Y(imm), .Cin(1'b0));

    wire is_jump = (ir[31:27] == 5'b00001) | (ir[31:27] == 5'b00011) | (ir[31:27] == 5'b00100);

    wire is_bne = ir[31:27] == 5'b00010;
    wire is_blt = ir[31:27] == 5'b00110;
    wire is_b = is_bne | is_blt;

    wire is_bex = ir[31:27] == 5'b10110;
    //                           jr
    wire is_rd = ir[31:27] == 5'b00100;
    // jump = jmp_pc_1_n if is_b, rd if is_rd, target otherwise
    assign jump = is_b ? jmp_pc_1_n : (is_rd ? rd : target);

    wire rstatus_is_not_0;
    is_not_zero rstatus_is_not_0_inst(.out(rstatus_is_not_0), .in(rstatus));
    
    assign do_jump = is_jump | ((is_bne | is_bex) & ne) | (is_blt & lt) | (is_bex & rstatus_is_not_0);
endmodule

module alu_halt_val(out, ir);
    input[31:0] ir;
    output[3:0] out;
    // add = 1, addi = 2, sub = 3, mul=4
    wire is_add = (ir[31:27] == 5'b00000) & (ir[6:2] == 5'b00000);
    wire is_addi = (ir[31:27] == 5'b00101);
    wire is_sub = (ir[31:27] == 5'b00000) & (ir[6:2] == 5'b00001);
    wire is_mul = (ir[31:27] == 5'b00000) & (ir[6:2] == 5'b00110);
    wire is_halt = is_add | is_addi | is_sub | is_mul;

    tristate_4 add_tri(.out(out), .in(4'b0001), .oe(is_add));
    tristate_4 addi_tri(.out(out), .in(4'b0010), .oe(is_addi));
    tristate_4 sub_tri(.out(out), .in(4'b0011), .oe(is_sub));
    tristate_4 mul_tri(.out(out), .in(4'b0100), .oe(is_mul));
    tristate_4 halt_tri(.out(out), .in(4'b0000), .oe(~is_halt));
endmodule

module choose_alu_input(
    out,

    reg_val,
    reg_num,
    dx_ir,
    xm_ir,
    mw_ir,
    xm_o,
    mw_o,
    mw_wren);

    input[31:0] reg_val, dx_ir, xm_ir, mw_ir, xm_o, mw_o;
    input[4:0] reg_num;
    input mw_wren;
    output[31:0] out;

    wire[4:0] xm_opcode = xm_ir[31:27];
    wire[4:0] xm_rd = (xm_opcode == 5'b10101) ? 5'b11110 : xm_ir[26:22];
    wire[4:0] mw_rd = mw_ir[26:22];

    wire[1:0] select;

    wire xm_writes = (xm_opcode == 5'b00000) | (xm_opcode == 5'b00101) | (xm_opcode == 5'b10101);

    assign select[0] = (reg_num == xm_rd) & (reg_num != 5'b00000) & xm_writes; // set xm
    assign select[1] = (reg_num == mw_rd) & (reg_num != 5'b00000) & mw_wren & (!select[0]); // set mw

    mux4 m(
        .out(out),
        .select(select),
        .in0(reg_val),
        .in1(xm_o),
        .in2(mw_o),
        .in3(reg_val)
    );
endmodule

module Xecute(
    out_O,          // output from ALU
    out_B,          // output from register B
    out_IR,         // instruction
    out_jump,       // jump target
    out_do_jump,    // dsignal to jump
    out_halt,       // halt signal if overflow
    out_halt_value, // value to set IR to when halting (to write to rstatus)
    // division things
    out_div_stall,  // divider stall signal while div is running
    out_div,        // divider output 
    out_div_error,  // divider error signal if div by 0
    out_div_write,  // divider signal to write to register
    out_div_reg,    // divider register to write to

    pc,             // current PC
    A,              // value from register A
    B,              // value from register B
    ir,             // current instruction
    xm_ir,          // (bypassing) instruction from XM stage (1 stage before)
    mw_ir,          // (bypassing) instruction from MW stage (2 stages before)
    xm_o,           // (bypassing) output from XM stage
    mw_o,           // (bypassing) output from MW stage
    reg_wren,       // (bypassing) write enable for register
    clock,          // clock signal
    reset           // reset signal
    );
    input[31:0] pc, A, B, ir, xm_ir, mw_ir, xm_o, mw_o;
    input clock, reset, reg_wren;
    output[31:0] out_O, out_B, out_IR, out_jump;
    output out_do_jump, out_halt;
    output[26:0] out_halt_value;
    // divider outputs
    output out_div_stall, out_div_error, out_div_write;
    output[31:0] out_div;
    output[4:0] out_div_reg;

    wire[31:0] alu_a, alu_b;

    wire is_jr = ir[31:27] == 5'b00100;
    wire is_bne = ir[31:27] == 5'b00010;
    wire is_blt = ir[31:27] == 5'b00110;
    wire is_b = is_bne | is_blt;

    wire[3:0] optype;
    op_type optype_inst(.out(optype), .op(ir[31:27]));

    wire[4:0] bypass_reg_a = ir[21:17];
    wire[4:0] bypass_reg_b = optype[0] ? ir[16:12] : ir[26:22];
    
    
    choose_alu_input get_alu_a(
        .out(alu_a),

        .reg_val(A),
        .reg_num(bypass_reg_a),
        .dx_ir(ir),
        .xm_ir(xm_ir),
        .mw_ir(mw_ir),
        .xm_o(xm_o),
        .mw_o(mw_o),
        .mw_wren(reg_wren)
    );
    choose_alu_input get_alu_b(
        .out(alu_b),

        .reg_val(B),
        .reg_num(bypass_reg_b),
        .dx_ir(ir),
        .xm_ir(xm_ir),
        .mw_ir(mw_ir),
        .xm_o(xm_o),
        .mw_o(mw_o),
        .mw_wren(reg_wren)
    );

    divider div(
        .out_div_stall(out_div_stall),
        .out_div(out_div),
        .out_div_error(out_div_error),
        .out_div_write(out_div_write),
        .out_div_reg(out_div_reg),
        
        .ir(ir),
        .a(alu_a),
        .b(alu_b),
        .clock(clock),
        .reset(reset)
    );

    wire ne, lt, ovf;
    wire[31:0] alu_out;

    xecute_alu alu_section(
        .ne(ne), .out(alu_out), .lt(lt), .ovf(ovf), 
        .a(alu_a), .b(alu_b), .ir(ir)
    );

    xecute_branch branch_section(
        .jump(out_jump), .do_jump(out_do_jump), 
        .ir(ir), .pc(pc), .rd(alu_b), .lt(lt), .ne(ne), .rstatus(alu_a)
    );
    wire[3:0] halt_val;
    alu_halt_val halt_val_inst(.out(halt_val), .ir(ir));
    assign out_halt = ovf & (halt_val != 5'b00000);
    assign out_halt_value = {22'b0, halt_val};

    wire is_setx = ir[31:27] == 5'b10101;
    wire[31:0] target;
    sign_extender_27 target_extender(.in(ir[26:0]), .out(target));

    wire is_jal = ir[31:27] == 5'b00011;

    wire[31:0] out_o = is_jal ? pc : (is_setx ? target : alu_out);

    register32 O_reg(.out(out_O), .in(out_o), .clk(~clock), .input_enable(1'b1), .reset(reset));
    register32 B_reg(.out(out_B), .in(alu_b), .clk(~clock), .input_enable(1'b1), .reset(reset));
    register32 IR_reg(.out(out_IR), .in(ir), .clk(~clock), .input_enable(1'b1), .reset(reset));
endmodule

module divider(
    out_div_stall,  // stall signal while div is running
    out_div,        // output from divider
    out_div_error,  // error signal if div by 0
    out_div_write,  // signal to write to register
    out_div_reg,    // register to write to

    ir,             // instruction
    a,              // numerator
    b,              // denominator
    clock,          // clock signal
    reset           // reset signal
    );

    input[31:0] a, b, ir;
    input clock, reset;
    output out_div_stall, out_div_error, out_div_write;
    output[31:0] out_div;
    output[4:0] out_div_reg;

    wire[4:0] opcode = ir[31:27];
    wire[4:0] alu_code = ir[6:2];
    wire is_div = (opcode == 5'b00000) & (alu_code == 5'b00111);
    wire div_done, div_error;

    wire do_stall;

    assign out_div_stall = do_stall;

    wire div_diff_in = is_div | (do_stall & ~div_done);

    wire[31:0] div_a, div_b;

    dffe_ref div_dff(.q(do_stall), .d(div_diff_in), .clk(clock), .en(1'b1), .clr(1'b0));
    register32 div_a_reg(.out(div_a), .in(a), .clk(clock), .input_enable(is_div), .reset(reset));
    register32 div_b_reg(.out(div_b), .in(b), .clk(clock), .input_enable(is_div), .reset(reset));
    register5 div_reg(.out(out_div_reg), .in(ir[26:22]), .clk(clock), .input_enable(is_div), .reset(reset));

    assign out_div_write = div_done & do_stall;

    nrdi div_inst(
        .out(out_div), 
        .done(div_done), 
        .error(out_div_error), 
        .numerator(div_a), 
        .denominator(div_b), 
        .clk(clock),
        .reset(is_div)
    );
endmodule

module choose_data_mem_input(
    out,

    reg_val,
    reg_num,
    reg_wren,
    xm_ir,
    xm_b);

    input[31:0] reg_val, xm_ir, xm_b;
    input reg_wren;
    input[4:0] reg_num;
    output[31:0] out;
    // if reg for data write (xm_rd) is being written to, use mw_b
    // otherwise use xm_b

    wire[4:0] xm_rd = xm_ir[26:22];
    
    wire select = (reg_num == xm_rd) & reg_wren;

    mux2 m(
        .out(out),
        .select(select),
        .in0(xm_b),
        .in1(reg_val)
    );
endmodule

module write_to_pins(out, pins, ir, o, data_dmem, q_dmem, clk);
    inout[7:0] pins;
    input clk;
    input[31:0] ir, o, data_dmem, q_dmem;
    output[31:0] out;

    assign data_wren = (ir[31:27] == 5'b00111) & o[12];
    assign read_io = (ir[31:27] == 5'b01000) & o[12];

    wire mode_we = o[13] & o[12] & data_wren;
    wire val_we = ~o[13] & o[12] & data_wren;

    wire[2:0] pin_num = o[2:0];

    wire[7:0] pins_out;
    io_pin_set io_pins(.out(pins_out), .pins(pins), .pin_num(pin_num), 
                       .in(data_dmem[0]), .val_we(val_we), .mode_we(mode_we),
                       .clk(clk));

    wire pin_reading;
    mux8_1bit read_io_mux(pin_reading, pin_num, pins_out[0], pins_out[1], pins_out[2], pins_out[3], pins_out[4], pins_out[5], pins_out[6], pins_out[7]);

    assign out = read_io ? {31'b0, pin_reading} : q_dmem;
endmodule

module Memory(
    out_O,          // ALU output (unchanged)
    out_D,          // data from memory
    out_IR,         // instruction
    address_dmem,   // address to read/write from
    data_dmem,      // data to write
    data_wren,      // dmem write enable

    pins,           // IO pins

    O,              // ALU output
    B,              // value from register B
    ir,             // instruction
    write_reg,     // (bypassing) register currently being written to
    write_reg_val, // (bypassing) value currently being written to register
    reg_wren,      // (bypassing) write enable for register
    q_dmem,         // data from memory at address_dmem
    clock,          // clock signal
    reset           // reset signal
    );

    input[31:0] O, B, ir, q_dmem, write_reg_val;
    input[4:0] write_reg;
    input reg_wren, clock, reset;
    output[31:0] out_O, out_D, out_IR, data_dmem;
    output[31:0] address_dmem;
    output data_wren;

    inout[7:0] pins;

    wire[31:0] data_dmem;

    choose_data_mem_input set_data_dmem(
        .out(data_dmem),

        .reg_val(write_reg_val),
        .reg_num(write_reg),
        .xm_ir(ir),
        .xm_b(B),
        .reg_wren(reg_wren)
    );

    assign address_dmem = O;

    assign data_wren = (ir[31:27] == 5'b00111) & ~O[12];

    wire[31:0] mem_reading;
    write_to_pins io(mem_reading, pins, ir, O, data_dmem, q_dmem, clock);

    register32 IR_reg(.out(out_IR), .in(ir), .clk(~clock), .input_enable(1'b1), .reset(reset));
    register32 O_reg(.out(out_O), .in(O), .clk(~clock), .input_enable(1'b1), .reset(reset));
    register32 D_reg(.out(out_D), .in(mem_reading), .clk(~clock), .input_enable(1'b1), .reset(reset));
endmodule
