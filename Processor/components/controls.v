module op_type(out, op);
    input[4:0] op;
    output[3:0] out;

    // R = 00000, 01000 - 11111
    // I = 00101, 00111, 01000, 00010, 00110
    // JI = 00001, 00011, 10110, 10101
    // JII = 00100
    

    // out order: [R, I, JI, JII]
    assign out[1] = (op == 5'b00101) | (op == 5'b00111) | (op == 5'b01000) | (op == 5'b00010) | (op == 5'b00110);
    assign out[2] = (op == 5'b00001) | (op == 5'b00011) | (op == 5'b10110) | (op == 5'b10101);
    assign out[3] = (op == 5'b00100);
    assign out[0] = ((op == 5'b00000) | (op >= 5'b01000) ) & ~out[1] & ~out[2] & ~out[3];
endmodule

module register_we(out, op);
    input[4:0] op;
    output out;

    // R = 00000, 01000 - 11111
    // I = 00101, 00111, 01000, 00010, 00110
    // JI = 00001, 00011, 10110, 10101
    // JII = 00100

    // out order: [R, I, JI, JII]
    assign out = ((op == 5'b00000) | (op >= 5'b01000) | (op == 5'b00101) );
endmodule
