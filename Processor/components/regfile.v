module tri32(out, enable, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32);
	input [31:0] enable;
	input [31:0] in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, in32;
	output[31:0] out;

	tristate t1(out, in1, enable[0]);
	tristate t2(out, in2, enable[1]);
	tristate t3(out, in3, enable[2]);
	tristate t4(out, in4, enable[3]);
	tristate t5(out, in5, enable[4]);
	tristate t6(out, in6, enable[5]);
	tristate t7(out, in7, enable[6]);
	tristate t8(out, in8, enable[7]);
	tristate t9(out, in9, enable[8]);
	tristate t10(out, in10, enable[9]);
	tristate t11(out, in11, enable[10]);
	tristate t12(out, in12, enable[11]);
	tristate t13(out, in13, enable[12]);
	tristate t14(out, in14, enable[13]);
	tristate t15(out, in15, enable[14]);
	tristate t16(out, in16, enable[15]);
	tristate t17(out, in17, enable[16]);
	tristate t18(out, in18, enable[17]);
	tristate t19(out, in19, enable[18]);
	tristate t20(out, in20, enable[19]);
	tristate t21(out, in21, enable[20]);
	tristate t22(out, in22, enable[21]);
	tristate t23(out, in23, enable[22]);
	tristate t24(out, in24, enable[23]);
	tristate t25(out, in25, enable[24]);
	tristate t26(out, in26, enable[25]);
	tristate t27(out, in27, enable[26]);
	tristate t28(out, in28, enable[27]);
	tristate t29(out, in29, enable[28]);
	tristate t30(out, in30, enable[29]);
	tristate t31(out, in31, enable[30]);
	tristate t32(out, in32, enable[31]);
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
	wire[31:0] out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15, out16, out17, out18, out19, out20, out21, out22, out23, out24, out25, out26, out27, out28, out29, out30, out31;
	assign out0 = 32'b0;

	wire[31:0] us_clock;
	us_counter_32bit us_counter(us_clock, clock, ctrl_reset);

	register r1(out1, clock, ins[1], data_writeReg, ctrl_reset);
	register r2(out2, clock, ins[2], data_writeReg, ctrl_reset);

	register r3(out3, clock, 1'b1, us_clock, ctrl_reset);

	register r4(out4, clock, ins[4], data_writeReg, ctrl_reset);
	register r5(out5, clock, ins[5], data_writeReg, ctrl_reset);
	register r6(out6, clock, ins[6], data_writeReg, ctrl_reset);
	register r7(out7, clock, ins[7], data_writeReg, ctrl_reset);
	register r8(out8, clock, ins[8], data_writeReg, ctrl_reset);
	register r9(out9, clock, ins[9], data_writeReg, ctrl_reset);
	register r10(out10, clock, ins[10], data_writeReg, ctrl_reset);
	register r11(out11, clock, ins[11], data_writeReg, ctrl_reset);
	register r12(out12, clock, ins[12], data_writeReg, ctrl_reset);
	register r13(out13, clock, ins[13], data_writeReg, ctrl_reset);
	register r14(out14, clock, ins[14], data_writeReg, ctrl_reset);
	register r15(out15, clock, ins[15], data_writeReg, ctrl_reset);
	register r16(out16, clock, ins[16], data_writeReg, ctrl_reset);
	register r17(out17, clock, ins[17], data_writeReg, ctrl_reset);
	register r18(out18, clock, ins[18], data_writeReg, ctrl_reset);
	register r19(out19, clock, ins[19], data_writeReg, ctrl_reset);
	register r20(out20, clock, ins[20], data_writeReg, ctrl_reset);
	register r21(out21, clock, ins[21], data_writeReg, ctrl_reset);
	register r22(out22, clock, ins[22], data_writeReg, ctrl_reset);
	register r23(out23, clock, ins[23], data_writeReg, ctrl_reset);
	register r24(out24, clock, ins[24], data_writeReg, ctrl_reset);
	register r25(out25, clock, ins[25], data_writeReg, ctrl_reset);
	register r26(out26, clock, ins[26], data_writeReg, ctrl_reset);
	register r27(out27, clock, ins[27], data_writeReg, ctrl_reset);
	register r28(out28, clock, ins[28], data_writeReg, ctrl_reset);
	register r29(out29, clock, ins[29], data_writeReg, ctrl_reset);
	register r30(out30, clock, ins[30], data_writeReg, ctrl_reset);
	register r31(out31, clock, ins[31], data_writeReg, ctrl_reset);

	wire[31:0] oe1, oe2;
	decoder32 d1(oe1, ctrl_readRegA, 1'b1);
	decoder32 d2(oe2, ctrl_readRegB, 1'b1);

	tri32 t321(data_readRegA, oe1, out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15, out16, out17, out18, out19, out20, out21, out22, out23, out24, out25, out26, out27, out28, out29, out30, out31);
	tri32 t322(data_readRegB, oe2, out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15, out16, out17, out18, out19, out20, out21, out22, out23, out24, out25, out26, out27, out28, out29, out30, out31);
endmodule
