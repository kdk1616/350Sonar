`timescale 1ns / 1ps
module RAM #( parameter DATA_WIDTH = 32, ADDRESS_WIDTH = 12, DEPTH = 4096, MEMFILE="") (
    input wire                     clk,
    input wire                     wEn,
    input wire [ADDRESS_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0]    dataIn,
    output reg [DATA_WIDTH-1:0]    dataOut = 0);
    
    reg[DATA_WIDTH-1:0] MemoryArray[0:DEPTH-1];
    
    integer i;
    initial begin
//        for (i = 0; i < DEPTH; i = i + 1) begin
//            MemoryArray[i] <= 0;
//        end
         if(MEMFILE > 0) begin
             $readmemh(MEMFILE, MemoryArray);
         end
    end
    
    always @(posedge clk) begin
        if(wEn) begin
            MemoryArray[addr] <= dataIn;
        end else begin
            dataOut <= MemoryArray[addr];
        end
    end
endmodule


//Dual port ram!
module DPRAM #( parameter DATA_WIDTH = 32, ADDRESS_WIDTH = 12, DEPTH = 4096) (
    input wire                     clk,
    input wire                     wEn0,
    input wire                     wEn1,
    input wire [ADDRESS_WIDTH-1:0] addr0,
    input wire [ADDRESS_WIDTH-1:0] addr1,
    input wire [DATA_WIDTH-1:0]    dataIn0,
    input wire [DATA_WIDTH-1:0]    dataIn1,
    output reg [DATA_WIDTH-1:0]    dataOut0 = 0,
    output reg [DATA_WIDTH-1:0]    dataOut1 = 0);
    
    reg[DATA_WIDTH-1:0] MemoryArray[0:DEPTH-1];
    
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            MemoryArray[i] <= 0;
        end
//         if(MEMFILE > 0) begin
//             $readmemh(MEMFILE, MemoryArray);
//         end
    end
    
    always @(posedge clk) begin
        if(wEn0) begin
            MemoryArray[addr0] <= dataIn0;
        end else begin
            dataOut0 <= MemoryArray[addr0];
        end
    end
    always @(posedge clk) begin
        if(wEn1) begin
            MemoryArray[addr1] <= dataIn1;
        end else begin
            dataOut1 <= MemoryArray[addr1];
        end
    end
    
endmodule