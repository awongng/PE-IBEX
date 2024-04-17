//pqvalue_top.sv
//Custom ALU top module
//Adapted for register files with 2 read ports and 1 write port

//sel_op_i :
//00 : Unused
//01 : pq.mod_add
//10 : pq.mod_sub
//11 : pq.mod_mul

//sel_red_i :
//0 : Dilithium
//1 : Kyber

module pqvalue_top (
	input logic [22:0] a_i, b_i,
	input logic sel_red_i,
	input logic [1:0] sel_op_i,
	output logic [22:0] operand_o;
	);
	logic [22:0] add_out_s, sub_out_s, mul_out_s;

	mod_add mod_add (//Modular addition
		.a_i({1'b0,a_i}),
		.b_i({1'b0,b_i}),
		.q_i(sel_red_i ? 3329 : 8380417),
		.c_o(add_out_s)	
		);

	mod_sub mod_sub (//Modular subtraction
		.a_i({1'b0,a_i}),
		.b_i({1'b0,b_i}),
		.q_i(sel_red_i ? 3329 : 8380417),
		.c_o(sub_out_s)	
	);

	mod_mul mod_mul (//Modular multiplication
		.a_i({1'b0,a_i}),
		.b_i({1'b0,b_i}),
		.select_i(sel_red_i),
		.c_o(mul_out_s)	
	);

	assign operand_o = 0;//WIP

endmodule : butterfly
