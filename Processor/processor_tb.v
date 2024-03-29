`timescale 1 ns / 100 ps

module processor_tb;
    reg reset = 1'b1;
    wire[31:0] out;
    wire clock;

	wire[159:0] debug;

    integer i;
    assign clock = i[0];
    
    Wrapper wrapper(clock, reset, debug);

    initial begin
        $display("TESTING STAGES");

		
        // $display("dividend: %b\ndivisor: %b", a, b);
        for (i = 0; i < 1100; i = i + 1) begin
            #20;
            if (i % 2 == 0) begin
                // $display("i: %d, done:%b, out:%b", i, done, out);
				// $display("PC: %b\n------------------------------------\nFD: %b\nDX: %b\nXM: %b\nMW: %b\n\n", debug[31:0], debug[159:128], debug[127:96], debug[95:64], debug[63:32]);
                $display("%d %d) rd: %d, write: %b, we: %b     |     addr: %d, write: %d, mwe: %b", i[11:0]/2, debug[55:48], debug[14:10], $signed(debug[46:15]), debug[47], debug[111:80], $signed(debug[143:112]), debug[144]);
				assign reset = 1'b0;
            end
        end
        // $display("done:%b, a:%d, b:%d, out:%d, overflow: %b", done, a[5:0], b[5:0], $signed(out), overflow);

        $finish;
    end

    initial begin
        $dumpfile("processor.vcd");
        $dumpvars(0, processor_tb);
    end

endmodule