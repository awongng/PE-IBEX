//red_d.sv
//Barrett reduction for Dilithium
//Computes result_o = product_i % 8380417

`timescale 1ns/1ps

module red_d (
	input logic [45:0]  product_i,
	output logic [22:0] result_o
	);
	logic [68:0] step1_s;//The steps are numbered
	logic [22:0] step2_s;//the same way they are
	logic [45:0] step3_s;//in the provided Python script
	logic [23:0] step4_s, step5_s;//in Tools/barrett_reduction.py
	logic borrow_s;

	assign step1_s = (product_i << 23) + (product_i << 13) + (product_i << 3) - product_i;//Multiplication by 8396807
	assign step2_s = step1_s >> 46;
	assign step3_s = (step2_s << 23) - (step2_s <<13) + step2_s;//Multiplication by 8380417
	assign step4_s = product_i - step3_s;

	subtractor_n #(.nb_bit(24)) DUT (//24 bits subtractor
			.a_i(step4_s),
			.b_i(24'd8380417),
			.borrow_o(borrow_s),
			.diff_o(step5_s)	
		);
  
	assign result_o = (borrow_s) ? (step4_s[22:0]) : step5_s[22:0];

endmodule:red_d
