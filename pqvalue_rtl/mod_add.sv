//mod_add.sv
//Modular addition
//Computes c_o = (a_i + b_i) % q_i

`timescale 1 ns/ 1 ps

module mod_add (
	input logic [23:0] a_i, b_i,
	input logic [22:0] q_i,
	output logic [22:0] c_o
	);
	logic borrow_s;
	logic [23:0] c1_s, c2_s;

	assign c1_s = a_i + b_i;

	subtractor_n #(.nb_bit(24)) subtractor(//24 bits subtractor
		.a_i(c1_s),
		.b_i({1'b0, q_i}),
		.borrow_o(borrow_s),
		.diff_o(c2_s)	
	);
	
	assign c_o = borrow_s?c1_s[22:0]:c2_s[22:0];

endmodule : mod_add
