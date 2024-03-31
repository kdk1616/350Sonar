module mux2 (out, select, in0, in1);
    input select;
    input[31:0] in0, in1;
    output[31:0] out;
    assign out = select ? in1 : in0;
endmodule

module mux4 (out, select, in0, in1, in2, in3);
    input[1:0] select;
    input[31:0] in0, in1, in2, in3;
    output[31:0] out;
    wire[31:0] w1, w2;
    mux2 first_top(w1, select[0], in0, in1);
    mux2 first_bottom(w2, select[0], in2, in3);
    mux2 second(out, select[1], w1, w2);
endmodule

module mux8 (out, select, in0, in1, in2, in3, in4, in5, in6, in7);
    input[2:0] select;
    input[31:0] in0, in1, in2, in3, in4, in5, in6, in7;
    output[31:0] out;
    wire[31:0] w1, w2;
    mux4 first_top(w1, select[1:0], in0, in1, in2, in3);
    mux4 first_bottom(w2, select[1:0], in4, in5, in6, in7);
    mux2 second(out, select[2], w1, w2);
endmodule

module mux8_1bit(out, select, in0, in1, in2, in3, in4, in5, in6, in7);
    input[2:0] select;
    input in0, in1, in2, in3, in4, in5, in6, in7;
    output out;

    assign out = (select == 3'b000) ? in0 : 
                 (select == 3'b001) ? in1 : 
                 (select == 3'b010) ? in2 : 
                 (select == 3'b011) ? in3 : 
                 (select == 3'b100) ? in4 : 
                 (select == 3'b101) ? in5 : 
                 (select == 3'b110) ? in6 : 
                 in7;
endmodule

module tristate(out, in, oe);
    input[31:0] in;
    input oe;
    output[31:0] out;

    assign out = oe ? in : 32'bz;
endmodule

module tristate_4(out, in, oe);
    input[3:0] in;
    input oe;
    output[3:0] out;

    assign out = oe ? in : 4'bz;
endmodule

module decoder32(out, select, enable);
input [4:0] select;
input enable;
output [31:0] out;
assign out = enable << select;
endmodule