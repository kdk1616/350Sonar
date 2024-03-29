module tri32(out, enable, ins);
	input [31:0] enable;
	input [31:0][31:0] ins;
	output[31:0] out;

	genvar c;
	generate
		for(c=0; c<32; c=c+1) begin: loop1
			tristate t(out, ins[c], enable[c]);
		end
	endgenerate
endmodule

module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	// add your code here
	wire[31:0] ins;
	decoder32 d(ins, ctrl_writeReg, ctrl_writeEnable);

	// ins to input_enable
	// clock to clk
	// data_writeReg to in
	// ctrl_reset to reset
	wire[31:0][31:0] out;
	assign out[0] = 32'b0;

	genvar c;
	generate
		for(c=1; c<32; c=c+1) begin: loop1
			register r(out[c], clock, ins[c], data_writeReg, ctrl_reset);
		end
	endgenerate

	wire[31:0] oe1, oe2;
	decoder32 d1(oe1, ctrl_readRegA, 1'b1);
	decoder32 d2(oe2, ctrl_readRegB, 1'b1);

	tri32 t321(data_readRegA, oe1, out);
	tri32 t322(data_readRegB, oe2, out);
endmodule
