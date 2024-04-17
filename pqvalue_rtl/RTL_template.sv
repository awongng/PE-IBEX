//Name of file
//Description of module and its behavior

//Additional information
//input_example_2_i :
//  0 : case 0
//  1 : case 1

`timescale 1ps/1ns

module module_name (
    input logic [31:0] input_example_1_i, input_example_3_i;
    input logic input_example_2_i
    output logic [15:0] output_example_o;
);
    logic [31:0] internal_example_1_s;
    logic [15:0] internal_example_2_s

    assign internal_example_1_s = input_example_1_i + (input_example_2_i << 7);//Additional information about operation

    sub_module sub_module_name (//short description of the submodule
        .sub_input_i(internal_example_1_s),
        .sub_output_o(internal_example_2_s[14:0])
    );

    assign output_example_o = internal_example_2_s + input_example_3_i[14:0];

endmodule : module_name
