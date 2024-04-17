`timescale 1 ns / 100 ps

module receiver_tb;
    wire[31:0] out;

	wire[159:0] debug;

    integer i;
    reg clock;

    wire mem_ready;
    wire[11:0] memWriteAddr;
    wire[31:0] memWriteData;

    reg BOOTLOADER_CLOCK = 1'b0;
    reg BOOTLOADER_PIN = 1'b0;
    reg CPU_RESETN = 1'b0;

    wordReceiver bootloader(
		.ready(mem_ready), .out(memWriteData), .addr(memWriteAddr), .clk(clock),
		.dataOnPin(BOOTLOADER_CLOCK), .dataPin(BOOTLOADER_PIN), .reset(CPU_RESETN)
	);

    wire[63:0] bit;
    assign bit[31:0]= 32'b00101111000000000000000000000001;
    assign bit[63:32] = 32'b00101111011110100000011111111111;
    

    initial begin
        $display("TESTING");
        for (i = 0; i < 64; i = i + 1) begin
            BOOTLOADER_PIN = bit[i];
            #10;
            BOOTLOADER_CLOCK = 1'b1;
            #10;
            BOOTLOADER_CLOCK = 1'b0;
            #10;
            $display("------------");
            $display("DATA: %b", memWriteData);
            $display("ADDR: %b", memWriteAddr);
            $display("Ready: %b", mem_ready);
        end

        CPU_RESETN = 1'b1;
        #40;
        CPU_RESETN = 1'b0;
        #40;

        $display("\n\n\n");

        for (i = 0; i < 64; i = i + 1) begin
            BOOTLOADER_PIN = bit[i];
            #10;
            BOOTLOADER_CLOCK = 1'b1;
            #10;
            BOOTLOADER_CLOCK = 1'b0;
            #10;
            $display("------------");
            $display("DATA: %b", memWriteData);
            $display("ADDR: %b", memWriteAddr);
            $display("Ready: %b", mem_ready);
        end

        

        

        $finish;
    end

    always
        #10 clock = ~clock;

    initial begin
        $dumpfile("receiver.vcd");
        $dumpvars(0, receiver_tb);
    end

endmodule