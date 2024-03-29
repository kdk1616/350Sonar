module register(out, clk, input_enable, in, reset);

input clk, input_enable, output_enable;
input[31:0] in;
input reset;
output[31:0] out;

genvar c;
generate
    for(c=0; c<32; c=c+1) begin: loop1
        dffe_ref dff(out[c], in[c], clk, input_enable, reset);
    end
endgenerate

endmodule