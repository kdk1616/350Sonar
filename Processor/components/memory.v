module dffe_ref (q, d, clk, en, clr);
   //Inputs
   input d, clk, en, clr;
   
   //Internal wire
   wire clr;

   //Output
   output q;
   
   //Register
   reg q;

   //Intialize q to 0
   initial
   begin
       q = 1'b0;
   end

   //Set value of q on positive edge of the clock or clear
   always @(posedge clk or posedge clr) begin
       //If clear is high, set q to 0
       if (clr) begin
           q <= 1'b0;
       //If enable is high, set q to the value of d
       end else if (en) begin
           q <= d;
       end
   end
endmodule


module bitmem(out, in, reset, clk);
    input in, reset, clk;
    output out;
    wire dff_in;

    or o1(dff_in, in, out);
    dffe_ref d(out, dff_in, clk, 1'b1, reset);
endmodule

module register32(out, clk, input_enable, in, reset);
    input clk, input_enable;
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

module register5(out, clk, input_enable, in, reset);
    input clk, input_enable;
    input[4:0] in;
    input reset;
    output[4:0] out;

    genvar c;
    generate
        for(c=0; c<5; c=c+1) begin: loop1
            dffe_ref dff(out[c], in[c], clk, input_enable, reset);
        end
    endgenerate
endmodule

module reg32_init(out, in, initial_value, clk, input_en, reset);
    input[31:0] initial_value, in;
    input clk, input_en, reset;
    output[31:0] out;

    // feed initial_value on reset, in when not reset
    wire[31:0] value = reset ? initial_value : in;
    wire[31:0] reg_out;

    register32 r1(
        .out(reg_out), 
        .clk(clk), 
        .input_enable(input_en), 
        .in(value), 
        .reset(1'b0)
    );
    assign out = reset ? initial_value : reg_out;
endmodule

module register64(out, clk, input_enable, in, reset);
    input clk, input_enable;
    input[63:0] in;
    input reset;
    output[63:0] out;

    genvar c;
    generate
        for(c=0; c<64; c=c+1) begin: loop1
            dffe_ref dff(out[c], in[c], clk, input_enable, reset);
        end
    endgenerate
endmodule

module reg64_init(out, in, initial_value, clk, input_en, reset);
    input[63:0] initial_value, in;
    input clk, input_en, reset;
    output[63:0] out;

    // feed initial_value on reset, in when not reset
    wire[63:0] value = reset ? initial_value : in;
    wire[63:0] reg_out;

    register64 r1(
        .out(reg_out), 
        .in(in), 
        .input_enable(input_en), 
        .clk(clk),
        .reset(1'b0)
    );
    assign out = reset ? initial_value : reg_out;
endmodule

module tff(Q, T, clk, reset);
    input T, clk, reset;
    output Q;

    wire w1, w2, w3, w4, Qb;

    not n1(w1, T);
    and a1(w2, w1, Q);

    and a2(w3, T, Qb);
    or o1(w4, w2, w3);

    dffe_ref d1(Q, w4, clk, 1'b1, reset);
    not n2(Qb, Q);
endmodule

module counter32(Q, clk, reset);
    input clk, reset;
    output[4:0] Q;

    wire inb12, inb23, inb34;

    tff tff0(Q[0], 1'b1, clk, reset);
    tff tff1(Q[1], Q[0], clk, reset);
    and(inb12, Q[0], Q[1]);
    tff tff2(Q[2], inb12, clk, reset);
    and(inb23, inb12, Q[2]);
    tff tff3(Q[3], inb23, clk, reset);
    and(inb34, inb23, Q[3]);
    tff tff4(Q[4], inb34, clk, reset);
endmodule

module counter_6bit(Q, clk, reset);
    input clk, reset;
    output[5:0] Q;

    wire inb12, inb23, inb34, inb45;

    tff tff0(Q[0], 1'b1, clk, reset);
    tff tff1(Q[1], Q[0], clk, reset);
    and(inb12, Q[0], Q[1]);
    tff tff2(Q[2], inb12, clk, reset);
    and(inb23, inb12, Q[2]);
    tff tff3(Q[3], inb23, clk, reset);
    and(inb34, inb23, Q[3]);
    tff tff4(Q[4], inb34, clk, reset);
    and(inb45, inb34, Q[4]);
    tff tff5(Q[5], inb45, clk, reset);
endmodule

module counter_32bit(Q, clk, reset);
    input clk, reset;
    output[31:0] Q;

    wire inb12, inb23, inb34, inb45, inb56, inb6, inb78, inb89, inb910, inb1011, inb1112, inb1213, inb1314, inb1415, inb1516, inb1617, inb1718, inb1819, inb1920, inb2021, inb2122, inb2223, inb2324, inb2425, inb2526, inb2627, inb2728, inb2829, inb2930, inb3031;

    tff tff0(Q[0], 1'b1, clk, reset);
    tff tff1(Q[1], Q[0], clk, reset);
    and(inb12, Q[0], Q[1]);
    tff tff2(Q[2], inb12, clk, reset);
    and(inb23, inb12, Q[2]);
    tff tff3(Q[3], inb23, clk, reset);
    and(inb34, inb23, Q[3]);
    tff tff4(Q[4], inb34, clk, reset);
    and(inb45, inb34, Q[4]);
    tff tff5(Q[5], inb45, clk, reset);
    and(inb56, inb45, Q[5]);
    tff tff6(Q[6], inb56, clk, reset);
    and(inb67, inb56, Q[6]);
    tff tff7(Q[7], inb67, clk, reset);
    and(inb78, inb67, Q[7]);
    tff tff8(Q[8], inb78, clk, reset);
    and(inb89, inb78, Q[8]);
    tff tff9(Q[9], inb89, clk, reset);
    and(inb910, inb89, Q[9]);
    tff tff10(Q[10], inb910, clk, reset);
    and(inb1011, inb910, Q[10]);
    tff tff11(Q[11], inb1011, clk, reset);
    and(inb1112, inb1011, Q[11]);
    tff tff12(Q[12], inb1112, clk, reset);
    and(inb1213, inb1112, Q[12]);
    tff tff13(Q[13], inb1213, clk, reset);
    and(inb1314, inb1213, Q[13]);
    tff tff14(Q[14], inb1314, clk, reset);
    and(inb1415, inb1314, Q[14]);
    tff tff15(Q[15], inb1415, clk, reset);
    and(inb1516, inb1415, Q[15]);
    tff tff16(Q[16], inb1516, clk, reset);
    and(inb1617, inb1516, Q[16]);
    tff tff17(Q[17], inb1617, clk, reset);
    and(inb1718, inb1617, Q[17]);
    tff tff18(Q[18], inb1718, clk, reset);
    and(inb1819, inb1718, Q[18]);
    tff tff19(Q[19], inb1819, clk, reset);
    and(inb1920, inb1819, Q[19]);
    tff tff20(Q[20], inb1920, clk, reset);
    and(inb2021, inb1920, Q[20]);
    tff tff21(Q[21], inb2021, clk, reset);
    and(inb2122, inb2021, Q[21]);
    tff tff22(Q[22], inb2122, clk, reset);
    and(inb2223, inb2122, Q[22]);
    tff tff23(Q[23], inb2223, clk, reset);
    and(inb2324, inb2223, Q[23]);
    tff tff24(Q[24], inb2324, clk, reset);
    and(inb2425, inb2324, Q[24]);
    tff tff25(Q[25], inb2425, clk, reset);
    and(inb2526, inb2425, Q[25]);
    tff tff26(Q[26], inb2526, clk, reset);
    and(inb2627, inb2526, Q[26]);
    tff tff27(Q[27], inb2627, clk, reset);
    and(inb2728, inb2627, Q[27]);
    tff tff28(Q[28], inb2728, clk, reset);
    and(inb2829, inb2728, Q[28]);
    tff tff29(Q[29], inb2829, clk, reset);
    and(inb2930, inb2829, Q[29]);
    tff tff30(Q[30], inb2930, clk, reset);
    and(inb3031, inb2930, Q[30]);
    tff tff31(Q[31], inb3031, clk, reset);
endmodule

module mod_50_counter(Q, clk, reset);
    input clk, reset;
    output[5:0] Q;

    wire reset_50;

    assign reset_50 = reset | (Q == 6'b110010);

    counter_6bit counter(Q, clk, reset_50);
endmodule

module us_counter_32bit(Q, clk, reset);
    input clk, reset;
    output[31:0] Q;

    wire[5:0] counter;
    mod_50_counter mod_50(counter, clk, reset);
    wire incr = counter == 50;

    counter_32bit counter_32(Q, incr, reset);
endmodule

module io_pin(out, pin, in, val_we, mode_we, clk);
    // mode: 0 = input, 1 = output
    input clk, val_we, mode_we, in;
    output out;

    inout pin;

    wire val, mode;
    dffe_ref val_reg(val, in, ~clk, val_we, 1'b0);
    dffe_ref mode_reg(mode, in, ~clk, mode_we, 1'b0);

    assign pin = mode ? val : 1'bz;
    assign out = mode ? val : pin;
endmodule

module io_pin_set(out, pins, pin_num, in, val_we, mode_we, clk);
    // mode: 0 = input, 1 = output
    input in, val_we, mode_we, clk;
    input[2:0] pin_num;

    inout[7:0] pins;

    output[7:0] out;

    genvar c;
    generate
        for(c=0; c<8; c=c+1) begin: loop1
            io_pin io_pin1(
                .out(out[c]),
                .pin(pins[c]),
                .in(in),
                .val_we(val_we & (pin_num == c)),
                .mode_we(mode_we & (pin_num == c)),
                .clk(clk)
            );
        end
    endgenerate
endmodule
