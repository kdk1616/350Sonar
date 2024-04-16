module wordReceiver(ready, out, addr, clk, dataOnPin, dataPin, reset);
    output ready;
    output [31:0] out;
    output[11:0] addr;

    input dataOnPin, reset;
    input dataPin, clk;

    reg [11:0] addr_val;

    assign addr = addr_val;
    reg[4:0] counter_val;
    reg ready = 0;

    always @(posedge dataOnPin) begin
        counter_val = counter_val + 1;
        ready = counter_val == 0;
    end

    always @(posedge ready) begin
        addr_val <= addr_val + 1;
    end
    
    register32 out_reg(.out(out), .clk(clk), .input_enable(dataOnPin), .in(next_reg), .reset(reset));
endmodule