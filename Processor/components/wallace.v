module is_not_zero(out, in);
    input[31:0] in;
    output out;

    wire[3:0] zeros;
    wire not_zero;
    genvar c;
    for (c = 0; c < 4; c = c + 1) begin
        or o1(zeros[c], in[8*c], in[8*c+1], in[8*c+2], in[8*c+3], in[8*c+4], in[8*c+5], in[8*c+6], in[8*c+7]);
    end
    or o1(out, zeros[3], zeros[2], zeros[1], zeros[0]);
endmodule

module is_not_all_1(out, in);
    input[31:0] in;
    output out;

    wire[3:0] ones;
    wire all_1;
    genvar c;
    for (c = 0; c < 4; c = c + 1) begin
        and a1(ones[c], in[8*c], in[8*c+1], in[8*c+2], in[8*c+3], in[8*c+4], in[8*c+5], in[8*c+6], in[8*c+7]);
    end
    and(all_1, ones[3], ones[2], ones[1], ones[0]);
    not n1(out, all_1);
endmodule

module is_not_mult_by_0(out, in1, in2);
    input[31:0] in1, in2;
    output out;

    wire nz1, nz2;
    is_not_zero left_is_not_zero(nz1, in1);
    is_not_zero right_is_not_zero(nz2, in2);
    and a(out, nz1, nz2);
endmodule

module signs_mismatch(out, left_sign, right_sign, result_sign);
    input left_sign, right_sign, result_sign;
    output out;

    xor x1(out, left_sign, right_sign, result_sign);
endmodule

module nums_mismatch(out, extension, result_sign);
    input result_sign;
    input[31:0] extension;
    output out;

    wire nums_dont_match;

    wire not_all_zeros;
    is_not_zero z1(not_all_zeros, extension);

    wire not_all_1s;
    is_not_all_1 a1(not_all_1s, extension);
    assign out = result_sign ? not_all_1s : not_all_zeros;
endmodule

module check_overflow(out, extension, result, in_1, in_2);
    input[31:0] extension, result, in_1, in_2;
    output out;

    wire in_1_sign, in_2_sign;
    assign in_1_sign = in_1[31];
    assign in_2_sign = in_2[31];

    wire not_mult_by_zero, sign_mismatch, nums_missmatch;
    is_not_mult_by_0 check_mult_zero(not_mult_by_zero, in_1, in_2);
    signs_mismatch check_signs_mismatch(
        .out(sign_mismatch), 
        .left_sign(in_1_sign), 
        .right_sign(in_2_sign), 
        .result_sign(result[31])
    );
    nums_mismatch check_nums_match(nums_missmatch, extension, result[31]);

    // overflow if: not mult by zero, sign mismatch or nums mismatch
    wire sign_or_nums_mismatch;
    or o1(sign_or_nums_mismatch, sign_mismatch, nums_missmatch);

    and(out, not_mult_by_zero, sign_or_nums_mismatch);
endmodule

module bit_multiply(out, num, bit);
    input[31:0] num;
    input bit;
    output[31:0] out;

    genvar c;
    generate
        for (c = 0; c < 32; c = c + 1) begin : mult
            and a(out[c], num[c], bit);
        end
    endgenerate
endmodule

module wallace(out, overflow, a, b);
    input[31:0] a, b;
    output[31:0] out;
    output overflow;

    wire[31:0][31:0] layers;
    wire[31:0][31:0] sums;
    wire[31:0] couts;

    genvar c1;
    generate
        for (c1 = 0; c1 < 31; c1 = c1 + 1) begin : layer
            wire[31:0] layer_out;
            bit_multiply layer_multiply(
                .out(layer_out),
                .num(a),
                .bit(b[c1])
            );
            assign layers[c1] = {~layer_out[31], layer_out[30:0]};
        end
    endgenerate
    wire[31:0] layer_32_out;
    bit_multiply layer_multiply(
        .out(layer_32_out),
        .num(a),
        .bit(b[31])
    );
    assign layers[31] = {layer_32_out[31], ~layer_32_out[30:0]};

    assign sums[0] = layers[0];
    assign couts[0] = 1'b0;
    assign out[0] = sums[0][0];
    genvar c2;
    generate
        for (c2 = 0; c2 < 31; c2 = c2 + 1) begin : sum_layer
            wire[31:0] sum_full = {couts[c2], sums[c2][31:1]};
            cla_adder adder(
                .S(sums[c2+1]), 
                .Cout(couts[c2+1]), 
                .X(sum_full), 
                .Y(layers[c2+1]),
                .Cin(1'b0)
            );
            assign out[c2+1] = sums[c2+1][0];
        end
    endgenerate

    wire[31:0] extension;
    wire[31:0] extension_actual;
    wire ext_cout;
    wire[31:0] sum_32_full = {couts[31], sums[31][31:1]};
    cla_adder adder(
        .S(extension), 
        .Cout(ext_cout), 
        .X(sum_32_full), 
        .Y(32'b0),
        .Cin(1'b1)
    );

    assign extension_actual = {~extension[31], extension[30:0]};

    check_overflow isOvf(overflow, extension_actual, out, a, b);
endmodule
