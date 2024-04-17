//subtractor.sv
//1 bit subtraction with borrow input and borrow output
//Computes a_i - b_i - c_i

`timescale 1 ns/ 1 ps

module subtractor (
	input logic a_i, b_i, c_i,
	output logic borrow_o, diff_o
	);
	logic diff_s, borrow_hs1_s, borrow_hs2_s;
	
	half_sub half_sub1 (
		.a_i(a_i),
		.b_i(b_i),
		.borrow_o(borrow_hs1_s),
		.diff_o(diff_s)	
	);

	half_sub half_sub2 (
		.a_i(diff_s),
		.b_i(c_i),
		.borrow_o(borrow_hs2_s),
		.diff_o(diff_o)	
	);
	
	assign borrow_o = borrow_hs1_s | borrow_hs2_s;

endmodule : subtractor
