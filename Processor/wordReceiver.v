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

    wire update = dataOnPin | reset;

    always @(posedge update) begin
        counter_val = (counter_val + 1) & ~reset;
        ready = (counter_val == 5'b11111) & ~reset;
    end

    wire addr_update = ready | reset;

    always @(posedge addr_update) begin
        addr_val <= (addr_val + 1) & ~reset;
    end

    wire next_reg = {dataPin, out[31:1]};
    
    register32 out_reg(.out(out), .clk(dataOnPin), .input_enable(1'b1), .in(next_reg), .reset(reset));
endmodule