module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;


    wire which_result;
    dffe_ref d(which_result, ctrl_MULT, clock, ctrl_MULT | ctrl_DIV, 1'b0);

    wire[31:0] div_result;
    wire div_exception, div_resultRDY;

    nrdi divider(
        .out(div_result), 
        .done(div_resultRDY), 
        .error(div_exception), 
        .numerator(data_operandA), 
        .denominator(data_operandB), 
        .clk(clock), 
        .reset(ctrl_DIV)
    );

    wire[31:0] mult_result;
    wire mult_exception;
    wire mult_resultRDY = 1'b1;

    wallace wallace(
        .out(mult_result), 
        .overflow(mult_exception), 
        .a(data_operandA), 
        .b(data_operandB)
    );

    assign data_result = which_result ? mult_result : div_result;
    assign data_exception = which_result ? mult_exception : div_exception;
    assign data_resultRDY = which_result ? mult_resultRDY : div_resultRDY;
    
endmodule