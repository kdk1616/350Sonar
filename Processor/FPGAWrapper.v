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

module FPGAWrapper (CLK100MHZ, CPU_RESETN, LED, PINS, hSync, vSync, VGA_R, VGA_G, VGA_B);		// H Sync Signal
	output vSync, hSync; 		// Veritcal Sync Signal);
	input CLK100MHZ, CPU_RESETN;
	output[7:0] LED;
	output[3:0] VGA_R;  // Red Signal Bits
	output[3:0] VGA_G;  // Green Signal Bits
	output[3:0] VGA_B;  // Blue Signal Bits;
	
	wire reset = ~CPU_RESETN;
	inout[15:0] PINS;

	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;


	wire CLK;
	tff clock_tff(CLK, 1'b1, CLK100MHZ, 1'b0);
	

	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "read_seq";
	
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
	
	assign LED[7:0] = memAddr;
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(CLK), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
	
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
		.dataOut(memDataOut)
	);
		
		
		
		//VGA STUFFFFFF:
	
	
	
	wire clk, rst, write_data, read_data, busy, err;
	wire [7:0] tx_data, rx_data;
	
	// Lab Memory Files Location
	localparam FILES_PATH = "C:/Users/kdk33/Desktop/radar/";

	// Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock

	reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
	always @(posedge clk) begin
		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
	end
	

	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480; // Standard VGA Height

	wire active, screenEnd;
	wire[9:0] x;
	wire[8:0] y;
	
	VGATimingGenerator #(
		.HEIGHT(VIDEO_HEIGHT), // Use the standard VGA Values
		.WIDTH(VIDEO_WIDTH))
	Display( 
		.clk25(clk25),  	   // 25MHz Pixel Clock
		.reset(reset),		   // Reset Signal
		.screenEnd(screenEnd), // High for one cycle when between two frames
		.active(active),	   // High when drawing pixels
		.hSync(hSync),  	   // Set Generated H Signal
		.vSync(vSync),		   // Set Generated V Signal
		.x(x), 				   // X Coordinate (from left)
		.y(y)); 			   // Y Coordinate (from top)	   

	// Image Data to Map Pixel Location to Color Address
	localparam 
		PIXEL_COUNT = VIDEO_WIDTH*VIDEO_HEIGHT, 	             // Number of pixels on the screen
		PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,           // Use built in log2 command
		BITS_PER_COLOR = 12, 	  								 // Nexys A7 uses 12 bits/color
		PALETTE_COLOR_COUNT = 256, 								 // Number of Colors available
		PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1; // Use built in log2 Command

	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress;  	 // Image address for the image data
	wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddr; 	 // Color address for the color palette
    wire[PALETTE_ADDRESS_WIDTH-1:0] colorRadarAddr; 	 // Color address for the color palette

	assign imgAddress = x + 640*y;				 // Address calculated coordinate``

	assign colorWritEn = inSquare;

	RAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "image.mem"})) // Memory initialization
	ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading

	// Color Palette to Map Color Address to 12-Bit Color
	wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel

	RAM #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "colors.mem"}))  // Memory initialization
		
	ColorPalette(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorData),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading

//EXTRA SPECIAL DUAL PORT RAM

wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddressB;  	 // Image address for the image data
	wire[PALETTE_ADDRESS_WIDTH-1:0] datainB; 	 // Color address for the color a
		wire[PALETTE_ADDRESS_WIDTH-1:0] radarDataOut; 	 // Color address for the color palette

	wire colorWritEn;

  	DPRAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(1),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH))//,     // Set address with according to the pixel count
//		.MEMFILE({FILES_PATH, "image.mem"})) // Memory initialization
	RadarRam(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr0(imgAddress),					 // Image data address
		.dataOut0(radarDataOut),				 // Color palette address
		.wEn0(1'b0),
		.wEn1(colorWritEn),
		.dataIn1(datainB),
		.addr1(imgAddressB)
		); 						 // We're always reading

    reg[9:0] square_top_left_reference[1:0]; //Coordinates of top left corner of square (x,y)
    
    initial begin
    square_top_left_reference[0] = 10'd100;
    square_top_left_reference[1] = 10'd100;   //Initial coordinates at 100,100
    end

    wire inSquare;
    
    assign inSquare = (x <= square_top_left_reference[0] + 50) && (x >= square_top_left_reference[0]) &&  (y <= square_top_left_reference[1] + 50) && (y >= square_top_left_reference[1]);

    assign imgAddressB = (imgAddress == 0) ? 480 * 640 - 1 : imgAddress - 1 ;
    assign datainB = 12'hfff;

    wire[BITS_PER_COLOR-1:0] colorToDisplay; 
    assign colorToDisplay = radarDataOut ? 8'd5 : colorData; 



	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] colorOut; 			  // Output color 
	assign colorOut = active ? colorToDisplay : 12'd0; // When not active, output black

	// Quickly assign the output colors to their channels using concatenation
	assign {VGA_R, VGA_G, VGA_B} = colorOut;

endmodule
