module sll1_32(Out, A);
    input[31:0] A;
    output[31:0] Out;
    assign Out = {A[30:0], 1'b0};
endmodule

module sll2_32(Out, A);
    input[31:0] A;
    output[31:0] Out;
    assign Out = {A[29:0], 2'b0};
endmodule

module sll4_32(Out, A);
    input[31:0] A;
    output[31:0] Out;
    assign Out = {A[27:0], 4'b0};
endmodule

module sll8_32(Out, A);
    input[31:0] A;
    output[31:0] Out;
    assign Out = {A[23:0], 8'b0};
endmodule

module sll16_32(Out, A);
    input[31:0] A;
    output[31:0] Out;
    assign Out = {A[15:0], 16'b0};
endmodule

module sll_32(Out, A, Shamt);
    input[31:0] A;
    input[4:0] Shamt;
    output[31:0] Out;

    wire[31:0] w1, w2, w4, w8, w16;
    wire[31:0] sw2, sw4, sw8, sw16;
    
    sll16_32 s16(w16, A);
    mux2 m16(sw16, Shamt[4], A, w16);

    sll8_32 s8(w8, sw16);
    mux2 m8(sw8, Shamt[3], sw16, w8);

    sll4_32 s4(w4, sw8);
    mux2 m4(sw4, Shamt[2], sw8, w4);

    sll2_32 s2(w2, sw4);
    mux2 m2(sw2, Shamt[1], sw4, w2);

    sll1_32 s1(w1, sw2);
    mux2 m1(Out, Shamt[0], sw2, w1);
endmodule

module sra1_32(Out, A);
    input[31:0] A;
    output[31:0] Out;

    assign Out[30:0] = A[31:1];
    assign Out[31] = A[31];
endmodule

module sra2_32(Out, A);
    input[31:0] A;
    output[31:0] Out;

    assign Out[29:0] = A[31:2];
    assign Out[30] = A[31];
    assign Out[31] = A[31];
endmodule

module sra4_32(Out, A);
    input[31:0] A;
    output[31:0] Out;

    assign Out[27:0] = A[31:4];
    assign Out[28] = A[31];
    assign Out[29] = A[31];
    assign Out[30] = A[31];
    assign Out[31] = A[31];
endmodule

module sra8_32(Out, A);
    input[31:0] A;
    output[31:0] Out;

    assign Out[23:0] = A[31:8];
    genvar c;
    generate
        for(c=24; c<32; c=c+1) begin
            assign Out[c] = A[31];
        end
    endgenerate
endmodule

module sra16_32(Out, A);
    input[31:0] A;
    output[31:0] Out;

    assign Out[15:0] = A[31:16];
    genvar c;
    generate
        for(c=16; c<32; c=c+1) begin
            assign Out[c] = A[31];
        end
    endgenerate
endmodule

module sra(Out, A, Shamt);
    input[31:0] A;
    input[4:0] Shamt;
    output[31:0] Out;
    
    wire[31:0] w1, w2, w4, w8, w16;
    wire[31:0] sw2, sw4, sw8, sw16;
    
    sra16_32 s16(w16, A);
    mux2 m16(sw16, Shamt[4], A, w16);

    sra8_32 s8(w8, sw16);
    mux2 m8(sw8, Shamt[3], sw16, w8);

    sra4_32 s4(w4, sw8);
    mux2 m4(sw4, Shamt[2], sw8, w4);

    sra2_32 s2(w2, sw4);
    mux2 m2(sw2, Shamt[1], sw4, w2);

    sra1_32 s1(w1, sw2);
    mux2 m1(Out, Shamt[0], sw2, w1);
endmodule