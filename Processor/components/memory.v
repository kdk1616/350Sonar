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
    input in, val_we, mode_we, clk, we;
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
