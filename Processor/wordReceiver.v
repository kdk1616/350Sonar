module wordReceiver(ready, out, addr, clk, dataOnPin, dataPin, reset);
    output ready;
    output [31:0] out;
    output[11:0] addr;

    input dataOnPin, reset;
    input dataPin, clk;

    reg [11:0] addr_val = -1;

    assign addr = addr_val;
    reg[4:0] counter_val = 0;
    reg ready_val = 0;
    assign ready = ready_val;

    wire update = dataOnPin | reset;

    always @(posedge update) begin
        counter_val = reset ? 0 : counter_val + 1;
        ready_val = reset ? 0 : counter_val == 5'b0;
    end

    wire addr_update = ~ready_val | reset;

    always @(posedge addr_update) begin
        addr_val <= reset ? -1 : addr_val + 1;
    end

    wire[31:0] next_reg = {dataPin, out[31:1]};
    
    register32 out_reg(.out(out), .clk(dataOnPin), .input_enable(1'b1), .in(next_reg), .reset(reset));
endmodule