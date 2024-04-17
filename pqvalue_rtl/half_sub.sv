//half_sub.sv
// 1 bit subtractor with borrow output
// Computes diff_o = a_i - b_i with borrow_o

`timescale 1 ns/ 1 ps

module half_sub (
	input logic a_i, b_i,
	output logic borrow_o, diff_o
	);

	assign diff_o = a_i ^ b_i;
	assign borrow_o = (~a_i) & b_i;

endmodule : half_sub
