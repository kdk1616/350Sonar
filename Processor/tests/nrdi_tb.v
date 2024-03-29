`timescale 1 ns / 100 ps
module nrdi_tb;
    reg reset = 1'b1;
    wire[31:0] out;
    wire clock;

    wire[63:0] s;
    wire done, overflow;

    wire[63:0] reg_s;
    wire reg_reset;

    reg enable = 1'b1;
    
    reg[31:0] a = 6;
    reg[31:0] b = 2;

    integer i;
    assign clock = i[0];
    assign reg_reset = i[4];

    wire[63:0] init_value, set_val;
    assign init_value = b[63:0];
    assign set_val = a[63:0];

    nrdi divider(out, done, overflow, a, b, clock, reset);

    initial begin
        $display("TESTING MULTIPLIER");
        $display("dividend: %b\ndivisor: %b", a, b);
        for (i = 0; i < 64; i = i + 1) begin
            #20;
            if (i % 2 == 0) begin
                $display("i: %d, done:%b, out:%b", i, done, out);
                assign reset = 1'b0;
            end
        end
        $display("done:%b, a:%d, b:%d, out:%d, overflow: %b", done, a[5:0], b[5:0], $signed(out), overflow);

        $finish;
    end

endmodule