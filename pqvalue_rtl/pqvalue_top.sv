//pqvalue_top.sv
//Single-cycle Cooley-Tukey and Gentleman-Sande butterflies

//sel_butterfly_i :
//0 : Cooley-Tukey
//1 : Gentleman-Sande

//sel_red_i :
//0 : Dilithium
//1 : Kyber

`timescale 1 ns/ 1 ps

module pqvalue_top (
	input logic [23:0] a_i, b_i,
	input logic [22:0] twiddle_i,
	input logic sel_red_i, sel_butterfly_i,
	output logic [22:0] a_o, b_o
	);
	logic [23:0] add_in_s, sub_in_s;
	logic [22:0] mul_in_s, mul_out_s, sub_out_s, q_s;

	assign add_in_s = sel_butterfly_i ? b_i : {1'b0,mul_out_s};
	assign sub_in_s = sel_butterfly_i ? b_i : {1'b0,mul_out_s};
	assign mul_in_s = sel_butterfly_i ? sub_out_s : b_i[22:0];
	assign q_s = sel_red_i ? 3329 : 8380417;

	mod_add mod_add (//Modular addition
		.a_i(a_i),
		.b_i(add_in_s),
		.q_i(q_s),
		.c_o(a_o)	
		);

	mod_sub mod_sub (//Modular subtraction
		.a_i(a_i),
		.b_i(sub_in_s),
		.q_i(q_s),
		.c_o(sub_out_s)	
	);

	mod_mul mod_mul (//Modular multiplication
		.a_i(twiddle_i),
		.b_i(mul_in_s),
		.select_i(sel_red_i),
		.c_o(mul_out_s)	
	);

	assign b_o = sel_butterfly_i ? mul_out_s : sub_out_s;

endmodule : butterfly
