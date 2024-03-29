
module isNotZero(Out, A);
    input[31:0] A;
    output Out;

    wire w1, w2, w3, w4;
    or o1(w1, A[0], A[1], A[2], A[3], A[4], A[5], A[6], A[7]);
    or o2(w2, A[8], A[9], A[10], A[11], A[12], A[13], A[14], A[15]);
    or o3(w3, A[16], A[17], A[18], A[19], A[20], A[21], A[22], A[23]);
    or o4(w4, A[24], A[25], A[26], A[27], A[28], A[29], A[30], A[31]);
    or o5(Out, w1, w2, w3, w4);
endmodule

module isLT(Out, A, B, S);
    input A, B, S;
    output Out;
    wire bsw, asw, abw;

    and bs(bsw, B, S);
    and as(asw, A, S);
    and ab(abw, A, B);
    or o1(Out, bsw, asw, abw);
endmodule

module isOvf(Out, A, B, Result);
    input A, B, Result;
    output Out;
    wire wna, wnb, wnr, w4, w5;
    wire one = 'b1;

    not na(wna, A);
    not nb(wnb, B);
    not nr(wnr, Result);

    and a1(w4, A, B, wnr);
    and a2(w5, wna, wnb, Result);
    or o1(Out, w4, w5);
endmodule

module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    // add your code here:
    wire[7:0] decoder_out;
    wire[31:0] and_out, or_out, add_out, sll_out, mult_out;
    wire[31:0] zero = 32'b0;
    wire signed[31:0] sra_out;

    wire b31 = data_operandB[31] ^ ctrl_ALUopcode[0];

    add_sub adder(add_out, data_operandA, data_operandB, ctrl_ALUopcode[0]);

    assign and_out = data_operandA & data_operandB;
    assign or_out = data_operandA | data_operandB;
    sll_32 sl(sll_out, data_operandA, ctrl_shiftamt);
    sra sa(sra_out, data_operandA, ctrl_shiftamt);

    wire mult_overflow;
    wallace multiplier(mult_out, mult_overflow, data_operandA, data_operandB);

    mux8 result_mux(data_result, ctrl_ALUopcode[2:0], add_out, add_out, and_out, or_out, sll_out, sra_out, mult_out, zero);

    isNotZero nz(isNotEqual, data_result);
    isLT lt(isLessThan, data_operandA[31], b31, data_result[31]);
    wire add_ovf;
    isOvf ovf(add_ovf, data_operandA[31], b31, data_result[31]);
    assign overflow = ctrl_ALUopcode == 5'b00110 ? mult_overflow : add_ovf;
endmodule
