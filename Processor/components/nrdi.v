module sll1(S, X);
    input [63:0] X;
    output [63:0] S;
    assign S = {X[62:0], 1'b0};
endmodule

module is_all_1s(out, in);
    input [4:0] in;
    output out;
    assign out = in[0] & in[1] & in[2] & in[3] & in[4];
endmodule

module div_control(out_doSub, out_reg_en, out_q0, reg_MSB, add_msb, clk, reset);
    input reg_MSB, add_msb;
    input clk, reset;
    output out_doSub, out_reg_en, out_q0;

    // dosub, q0
    not n1(out_doSub, reg_MSB);
    not n2(out_q0, add_msb);

    // reg enable / done
    
    wire[4:0] counter_val;
    wire is_end, out_enable, shift_disable;
    counter32 counter(counter_val, clk, reset);
    is_all_1s is1_1(is_end, counter_val);

    bitmem bmem(shift_disable, is_end, reset, clk);
    not(out_reg_en, shift_disable);
endmodule

module nrdi(out, done, error, numerator, denominator, clk, reset);
    input [31:0] numerator, denominator;
    input reset, clk;
    output [31:0] out;
    output error, done;

    wire expected_sign = numerator[31] ^ denominator[31];

    wire[31:0] dividend, divisor;

    wire[31:0] neg_divisor, neg_dividend;
    add_sub neg2(neg_dividend, 32'b0, numerator, 1'b1);
    add_sub neg1(neg_divisor, 32'b0, denominator, 1'b1);

    assign dividend = numerator[31] ? neg_dividend : numerator;
    assign divisor = denominator[31] ? neg_divisor : denominator;

    wire not_0;
    is_not_zero divisor_not_zero(not_0, divisor);
    not div_is_0(error, not_0);

    wire[63:0] full_reg_out;

    wire[63:0] shifted;
    sll1 s1(shifted, full_reg_out);

    wire doSub;

    wire[31:0] adder_out;
    wire adder_cout;
    add_sub adder(.S(adder_out), .X(shifted[63:32]), .Y(divisor), .doSub(doSub));

    wire q0, reg_en;
    wire[63:0] reg_in = {adder_out, shifted[31:1], q0};
    wire[63:0] reg_init = {32'b0, dividend};

    reg64_init register(.out(full_reg_out), .in(reg_in), .initial_value(reg_init), .clk(~clk), .input_en(reg_en), .reset(reset));

    div_control control(doSub, reg_en, q0, full_reg_out[63], adder_out[31], clk, reset);

    not is_done(done, reg_en);
    
    wire[31:0] pos_out;
    bit_multiply pos_ands(pos_out, full_reg_out[31:0], !error);

    add_sub sign_adder(out, 32'b0, pos_out, expected_sign);
endmodule

