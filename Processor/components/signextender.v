module sign_extender_17(in, out);
    input [16:0] in;
    output [31:0] out;

    assign out[16:0] = in;

    genvar c;
    generate
        for (c = 17; c < 32; c = c + 1) begin: sign_extender_gen
            assign out[c] = in[16];
        end
    endgenerate
endmodule

module sign_extender_27(in, out);
    input [26:0] in;
    output [31:0] out;

    assign out[26:0] = in;

    genvar c;
    generate
        for (c = 27; c < 32; c = c + 1) begin: sign_extender_gen
            assign out[c] = in[26];
        end
    endgenerate
endmodule
