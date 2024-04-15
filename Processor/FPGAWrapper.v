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

module FPGAWrapper (CLK100MHZ, CPU_RESETN, LED, PINS, BOOTLOADER_READY_PIN, BOOTLOADER_PIN, BOOTLOADER_CLOCK);
	input CLK100MHZ, CPU_RESETN, BOOTLOADER_PIN, BOOTLOADER_CLOCK;
	output[4:0] LED;
	output BOOTLOADER_READY_PIN;
	
	wire reset = ~CPU_RESETN;
	inout[7:0] PINS;

	assign BOOTLOADER_READY_PIN = CPU_RESETN;

	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;


	wire CLK;
	tff clock_tff(CLK, 1'b1, CLK100MHZ, 1'b0);

	assign LED[3:0] = instAddr[3:0];
	
	assign LED[4] = CLK;
	

	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "program";
	
	// Main Processing Unit
	processor CPU(
		// .debug(debug),
		.clock(CLK), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut),
		
		.io_pins(PINS)); 

	wire[11:0] memWriteAddr;
	wire[31:0] memWriteData;
	wire mem_ready;

	wordReceiver bootloader(
		.ready(mem_ready), .out(memWriteData), .addr(memWriteAddr), 
		.dataOnPin(BOOTLOADER_CLOCK), .dataPin(BOOTLOADER_PIN), .reset(CPU_RESETN)
	);
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(CLK), 
		.addr(instAddr[11:0]), 
		.dataOut(instData),
		.writeAddr(memWriteAddr), .dataIn(memWriteData), .wEn(reset & mem_ready));
	
	// Register File
	regfile RegisterFile(.clock(CLK), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB));
						
	// Processor Memory (RAM)
	RAM ProcMem(.clk(CLK), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));

endmodule
