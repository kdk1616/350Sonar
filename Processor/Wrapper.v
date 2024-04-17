`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module Wrapper (clock, reset,
	debug
	);
	input clock, reset;
	output[159:0] debug;

	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;

	assign debug[14:10] = rd;
	assign debug[46:15] = rData;
	assign debug[47] = rwe;
	assign debug[79:48] = instAddr;
	assign debug[111:80] = memAddr;
	assign debug[143:112] = memDataIn;
	assign debug[144] = mwe;

	wire[7:0] pins;


	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "processor_tests";
	
	// Main Processing Unit
	processor CPU(
		// .debug(debug),
		.clock(clock), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut),
		.io_pins(pins)
		); 
	

	wire[11:0] memWriteAddr;
	wire[31:0] memWriteData;
	wire mem_ready;
	wire BOOTLOADER_CLOCK = 1'bz;
	wire BOOTLOADER_PIN = 1'bz;
	wire CPU_RESETN = ~reset;
	wordReceiver bootloader(
		.ready(mem_ready), .out(memWriteData), .addr(memWriteAddr), 
		.dataOnPin(BOOTLOADER_CLOCK), .dataPin(BOOTLOADER_PIN), .reset(CPU_RESETN)
	);

	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData),
		.writeAddr(memWriteAddr),
		.dataIn(memWriteData),
		.wEn(memWren & mem_ready));

	wire[31:0] us_clock;
	
	// Register File
	regfile RegisterFile(.clock(clock), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
		.reg3(us_clock));
						
	// Processor Memory (RAM)
	RAM ProcMem(.clk(clock), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));

endmodule
