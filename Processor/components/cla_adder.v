module cla_carry_1(Out, Cin, P, G);
    input Cin, P, G;
    output Out;
    wire and1;
    and a(and1, P, Cin);
    or or1(Out, and1, G);
endmodule

module cla_carry_2(Out, Cin, P, G);
    input Cin;
    input[1:0] P, G;
    output Out;

    wire and1, and2;

    and a1(and1, Cin, P[0], P[1]);
    and a2(and2, G[0], P[1]);
    or or1(Out, and1, and2, G[1]);
endmodule

module cla_carry_3(Out, Cin, P, G);
    input Cin;
    input[2:0] P, G;
    output Out;

    wire and1, and2, and3;
    and a1(and1, Cin, P[0], P[1], P[2]);
    and a2(and2, G[0], P[1], P[2]);
    and a3(and3, G[1], P[2]);
    or or1(Out, and1, and2, and3, G[2]);
endmodule

module cla_carry_4(Out, Cin, P, G);
    input Cin;
    input[3:0] P, G;
    output Out;

    wire and1, and2, and3, and4;
    and a1(and1, Cin, P[0], P[1], P[2], P[3]);
    and a2(and2, G[0], P[1], P[2], P[3]);
    and a3(and3, G[1], P[2], P[3]);
    and a4(and4, G[2], P[3]);
    or or1(Out, and1, and2, and3, and4, G[3]);
endmodule

module cla_carry_5(Out, Cin, P, G);
    input Cin;
    input[4:0] P, G;
    output Out;

    wire and1, and2, and3, and4, and5;
    and a1(and1, Cin, P[0], P[1], P[2], P[3], P[4]);
    and a2(and2, G[0], P[1], P[2], P[3], P[4]);
    and a3(and3, G[1], P[2], P[3], P[4]);
    and a4(and4, G[2], P[3], P[4]);
    and a5(and5, G[3], P[4]);
    or or1(Out, and1, and2, and3, and4, and5, G[4]);
endmodule

module cla_carry_6(Out, Cin, P, G);
    input Cin;
    input[5:0] P, G;
    output Out;

    wire and1, and2, and3, and4, and5, and6;
    and a1(and1, Cin, P[0], P[1], P[2], P[3], P[4], P[5]);
    and a2(and2, G[0], P[1], P[2], P[3], P[4], P[5]);
    and a3(and3, G[1], P[2], P[3], P[4], P[5]);
    and a4(and4, G[2], P[3], P[4], P[5]);
    and a5(and5, G[3], P[4], P[5]);
    and a6(and6, G[4], P[5]);
    or or1(Out, and1, and2, and3, and4, and5, and6, G[5]);
endmodule

module cla_carry_7(Out, Cin, P, G);
    input Cin;
    input[6:0] P, G;
    output Out;

    wire and1, and2, and3, and4, and5, and6, and7;
    and a1(and1, Cin, P[0], P[1], P[2], P[3], P[4], P[5], P[6]);
    and a2(and2, G[0], P[1], P[2], P[3], P[4], P[5], P[6]);
    and a3(and3, G[1], P[2], P[3], P[4], P[5], P[6]);
    and a4(and4, G[2], P[3], P[4], P[5], P[6]);
    and a5(and5, G[3], P[4], P[5], P[6]);
    and a6(and6, G[4], P[5], P[6]);
    and a7(and7, G[5], P[6]);
    or or1(Out, and1, and2, and3, and4, and5, and6, and7, G[6]);
endmodule

module and_8(Out, A, B);
    input[7:0] A, B;
    output[7:0] Out;

    and and1(Out[0], A[0], B[0]);
    and and2(Out[1], A[1], B[1]);
    and and3(Out[2], A[2], B[2]);
    and and4(Out[3], A[3], B[3]);
    and and5(Out[4], A[4], B[4]);
    and and6(Out[5], A[5], B[5]);
    and and7(Out[6], A[6], B[6]);
    and and8(Out[7], A[7], B[7]);
endmodule

module or_8(Out, A, B);
    input[7:0] A, B;
    output[7:0] Out;

    or or1(Out[0], A[0], B[0]);
    or or2(Out[1], A[1], B[1]);
    or or3(Out[2], A[2], B[2]);
    or or4(Out[3], A[3], B[3]);
    or or5(Out[4], A[4], B[4]);
    or or6(Out[5], A[5], B[5]);
    or or7(Out[6], A[6], B[6]);
    or or8(Out[7], A[7], B[7]);
endmodule

module cla_gen_p(Out, Ps);
    input[7:0] Ps;
    output Out;
    and a(Out, Ps[0], Ps[1], Ps[2], Ps[3], Ps[4], Ps[5], Ps[6], Ps[7]);
endmodule

module cla_gen_g(Out, Gs, Ps);
    input[7:0] Gs, Ps;
    output Out;

    wire w1, w2, w3, w4, w5, w6, w7;

    and a0(w1, Gs[0], Ps[1], Ps[2], Ps[3], Ps[4], Ps[5], Ps[6], Ps[7]);
    and a1(w2, Gs[1], Ps[2], Ps[3], Ps[4], Ps[5], Ps[6], Ps[7]);
    and a2(w3, Gs[2], Ps[3], Ps[4], Ps[5], Ps[6], Ps[7]);
    and a3(w4, Gs[3], Ps[4], Ps[5], Ps[6], Ps[7]);
    and a4(w5, Gs[4], Ps[5], Ps[6], Ps[7]);
    and a5(w6, Gs[5], Ps[6], Ps[7]);
    and a6(w7, Gs[6], Ps[7]);

    or o(Out, w1, w2, w3, w4, w5, w6, w7, Gs[7]);
endmodule

module cla_block(S, G, P, X, Y, Cin);
    input[7:0] X, Y;
    input Cin;
    output[7:0] S;
    output G, P;

    wire[7:0] C, G_bits, P_bits;

    and_8 gand(G_bits, X, Y);
    or_8 por(P_bits, X, Y);

    assign C[0] = Cin;
    cla_carry_1 c1(C[1], Cin, P_bits[0], G_bits[0]);
    cla_carry_2 c2(C[2], Cin, P_bits[1:0], G_bits[1:0]);
    cla_carry_3 c3(C[3], Cin, P_bits[2:0], G_bits[2:0]);
    cla_carry_4 c4(C[4], Cin, P_bits[3:0], G_bits[3:0]);
    cla_carry_5 c5(C[5], Cin, P_bits[4:0], G_bits[4:0]);
    cla_carry_6 c6(C[6], Cin, P_bits[5:0], G_bits[5:0]);
    cla_carry_7 c7(C[7], Cin, P_bits[6:0], G_bits[6:0]);

    cla_gen_p p_(P, P_bits);
    cla_gen_g g_(G, G_bits, P_bits);


    xor x0(S[0], C[0], X[0], Y[0]);
    xor x1(S[1], C[1], X[1], Y[1]);
    xor x2(S[2], C[2], X[2], Y[2]);
    xor x3(S[3], C[3], X[3], Y[3]);
    xor x4(S[4], C[4], X[4], Y[4]);
    xor x5(S[5], C[5], X[5], Y[5]);
    xor x6(S[6], C[6], X[6], Y[6]);
    xor x7(S[7], C[7], X[7], Y[7]);
endmodule

module cla_gen_c(Out, G, P, C);
    input G, P, C;
    output Out;

    wire a;
    and a1(a, P, C);
    or o(Out, a, G);
endmodule

module cla_adder(S, Cout, X, Y, Cin);
    input [31:0] X, Y;
    input Cin;
    output [31:0] S;
    output Cout;

    wire[7:0] Gs;
    wire[7:0] Ps;
    wire[2:0] Cs;

    cla_block b1(S[7:0], Gs[0], Ps[0], X[7:0], Y[7:0], Cin);
    cla_gen_c gc0(Cs[0], Gs[0], Ps[0], Cin);

    cla_block b2(S[15:8], Gs[1], Ps[1], X[15:8], Y[15:8], Cs[0]);
    cla_gen_c gc1(Cs[1], Gs[1], Ps[1], Cs[0]);

    cla_block b3(S[23:16], Gs[2], Ps[2], X[23:16], Y[23:16], Cs[1]);
    cla_gen_c gc2(Cs[2], Gs[2], Ps[2], Cs[1]);

    cla_block b4(S[31:24], Gs[3], Ps[3], X[31:24], Y[31:24], Cs[2]);
    cla_gen_c gc3(Cout, Gs[3], Ps[3], Cs[2]);
endmodule

module add_sub(S, X, Y, doSub);
    input [31:0] X, Y;
    input doSub;
    output [31:0] S;

    wire[31:0] Y2;

    genvar c;
    generate
        for(c=0; c<32; c=c+1) begin: loop1
            xor x(Y2[c], Y[c], doSub);
        end
    endgenerate
    wire Cout;
    cla_adder c1(S, Cout, X, Y2, doSub);
endmodule