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

module wallace_layer_mult(out, in, bit);
    input[31:0] in;
    input bit;
    output[31:0] out;

    wire[31:0] layer;
    bit_multiply mult(layer, in, bit);
    assign out = {~layer[31], layer[30:0]};
endmodule

module wallace_layer_sum(out, next_sum, next_cout, cur_sum, layer, cin);
    input[31:0] cur_sum, layer;
    input cin;
    output next_cout;
    output out;
    output[31:0] next_sum;

    wire[31:0] sum_full = {cin, cur_sum[31:1]};
    cla_adder adder(
        .S(next_sum), 
        .Cout(next_cout), 
        .X(sum_full), 
        .Y(layer),
        .Cin(1'b0)
    );
    assign out = next_sum[0];
endmodule

module wallace(out, overflow, a, b);
    input[31:0] a, b;
    output[31:0] out;
    output overflow;

    // wire[31:0][31:0] layers;
    wire[31:0] layer0, layer1, layer2, layer3, layer4, layer5, layer6, layer7, layer8, layer9, layer10, layer11, layer12, layer13, layer14, layer15, layer16, layer17, layer18, layer19, layer20, layer21, layer22, layer23, layer24, layer25, layer26, layer27, layer28, layer29, layer30, layer31;
    // wire[31:0][31:0] sums;
    wire[31:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7, sum8, sum9, sum10, sum11, sum12, sum13, sum14, sum15, sum16, sum17, sum18, sum19, sum20, sum21, sum22, sum23, sum24, sum25, sum26, sum27, sum28, sum29, sum30, sum31;
    wire[31:0] couts;

    wallace_layer_mult w0(layer0, a, b[0]); wallace_layer_mult w1(layer1, a, b[1]); wallace_layer_mult w2(layer2, a, b[2]); wallace_layer_mult w3(layer3, a, b[3]);
    wallace_layer_mult w4(layer4, a, b[4]); wallace_layer_mult w5(layer5, a, b[5]); wallace_layer_mult w6(layer6, a, b[6]); wallace_layer_mult w7(layer7, a, b[7]);
    wallace_layer_mult w8(layer8, a, b[8]); wallace_layer_mult w9(layer9, a, b[9]); wallace_layer_mult w10(layer10, a, b[10]); wallace_layer_mult w11(layer11, a, b[11]);
    wallace_layer_mult w12(layer12, a, b[12]); wallace_layer_mult w13(layer13, a, b[13]); wallace_layer_mult w14(layer14, a, b[14]); wallace_layer_mult w15(layer15, a, b[15]);
    wallace_layer_mult w16(layer16, a, b[16]); wallace_layer_mult w17(layer17, a, b[17]); wallace_layer_mult w18(layer18, a, b[18]); wallace_layer_mult w19(layer19, a, b[19]);
    wallace_layer_mult w20(layer20, a, b[20]); wallace_layer_mult w21(layer21, a, b[21]); wallace_layer_mult w22(layer22, a, b[22]); wallace_layer_mult w23(layer23, a, b[23]);
    wallace_layer_mult w24(layer24, a, b[24]); wallace_layer_mult w25(layer25, a, b[25]); wallace_layer_mult w26(layer26, a, b[26]); wallace_layer_mult w27(layer27, a, b[27]);
    wallace_layer_mult w28(layer28, a, b[28]); wallace_layer_mult w29(layer29, a, b[29]); wallace_layer_mult w30(layer30, a, b[30]);

    wire[31:0] layer_32_out;
    bit_multiply layer_multiply(
        .out(layer_32_out),
        .num(a),
        .bit(b[31])
    );
    assign layer31 = {layer_32_out[31], ~layer_32_out[30:0]};

    assign sum0 = layer0;
    assign couts[0] = 1'b0;
    assign out[0] = sum0[0];

    wallace_layer_sum wls0(out[1], sum1, couts[1], sum0, layer1, couts[0]);
    wallace_layer_sum wls1(out[2], sum2, couts[2], sum1, layer2, couts[1]);
    wallace_layer_sum wls2(out[3], sum3, couts[3], sum2, layer3, couts[2]);
    wallace_layer_sum wls3(out[4], sum4, couts[4], sum3, layer4, couts[3]);
    wallace_layer_sum wls4(out[5], sum5, couts[5], sum4, layer5, couts[4]);
    wallace_layer_sum wls5(out[6], sum6, couts[6], sum5, layer6, couts[5]);
    wallace_layer_sum wls6(out[7], sum7, couts[7], sum6, layer7, couts[6]);
    wallace_layer_sum wls7(out[8], sum8, couts[8], sum7, layer8, couts[7]);
    wallace_layer_sum wls8(out[9], sum9, couts[9], sum8, layer9, couts[8]);
    wallace_layer_sum wls9(out[10], sum10, couts[10], sum9, layer10, couts[9]);
    wallace_layer_sum wls10(out[11], sum11, couts[11], sum10, layer11, couts[10]);
    wallace_layer_sum wls11(out[12], sum12, couts[12], sum11, layer12, couts[11]);
    wallace_layer_sum wls12(out[13], sum13, couts[13], sum12, layer13, couts[12]);
    wallace_layer_sum wls13(out[14], sum14, couts[14], sum13, layer14, couts[13]);
    wallace_layer_sum wls14(out[15], sum15, couts[15], sum14, layer15, couts[14]);
    wallace_layer_sum wls15(out[16], sum16, couts[16], sum15, layer16, couts[15]);
    wallace_layer_sum wls16(out[17], sum17, couts[17], sum16, layer17, couts[16]);
    wallace_layer_sum wls17(out[18], sum18, couts[18], sum17, layer18, couts[17]);
    wallace_layer_sum wls18(out[19], sum19, couts[19], sum18, layer19, couts[18]);
    wallace_layer_sum wls19(out[20], sum20, couts[20], sum19, layer20, couts[19]);
    wallace_layer_sum wls20(out[21], sum21, couts[21], sum20, layer21, couts[20]);
    wallace_layer_sum wls21(out[22], sum22, couts[22], sum21, layer22, couts[21]);
    wallace_layer_sum wls22(out[23], sum23, couts[23], sum22, layer23, couts[22]);
    wallace_layer_sum wls23(out[24], sum24, couts[24], sum23, layer24, couts[23]);
    wallace_layer_sum wls24(out[25], sum25, couts[25], sum24, layer25, couts[24]);
    wallace_layer_sum wls25(out[26], sum26, couts[26], sum25, layer26, couts[25]);
    wallace_layer_sum wls26(out[27], sum27, couts[27], sum26, layer27, couts[26]);
    wallace_layer_sum wls27(out[28], sum28, couts[28], sum27, layer28, couts[27]);
    wallace_layer_sum wls28(out[29], sum29, couts[29], sum28, layer29, couts[28]);
    wallace_layer_sum wls29(out[30], sum30, couts[30], sum29, layer30, couts[29]);
    wallace_layer_sum wls30(out[31], sum31, couts[31], sum30, layer31, couts[30]);

    wire[31:0] extension;
    wire[31:0] extension_actual;
    wire ext_cout;
    wire[31:0] sum_32_full = {couts[31], sum31[31:1]};
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
