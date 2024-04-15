module wordReceiver(ready, out, addr, dataOnPin, dataPin, reset);
    output ready;
    output [31:0] out;
    output[11:0] addr;

    input dataOnPin, reset;
    input dataPin;

    reg [11:0] addr_val;

    assign addr = addr_val;

    wire[4:0] counter_val;
    counter32 counter(.Q(counter_val), .clk(dataOnPin), .reset(reset));
    assign ready = counter_val == 31;

    always @(posedge ready) begin
        addr_val <= addr_val + 1;
    end

    wire[31:0] next_reg = {dataPin, out[31:1]};

    register32 out_reg(.out(out), .clk(dataOnPin), .input_enable(1'b1), .in(next_reg), .reset(reset));
endmodule