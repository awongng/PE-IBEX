//mod_mul.sv
//Modular multiplication, using Barrett reduction algorithm
//Computes c_o = (a_i * b_i) % q

//q is not a signal here bacuse it is constant for each algorithm, and is thus present only in the reductions
//select_i
//	0 : Dilithium (q=8380417)
//	1 : Kyber (q=3329)

`timescale 1ns/1ps

module mod_mul(
	       input logic [22:0]  a_i, b_i,
	       input logic         select_i, 
	       output logic [22:0] c_o
	       );
   logic [45:0] 		   product_s;
   logic [11:0] 		   reduced_K;
   logic [22:0] 		   reduced_D;

   assign product_s = a_i * b_i;

   red_k reduction_K(//Barrett reduction for Kyber
		     .product_i(product_s[23:0]),
		     .result_o(reduced_K)
		     );
   red_d reduction_D(//Barrett reduction for Dilithium
		     .product_i(product_s),
		     .result_o(reduced_D)
		     );
   
   assign c_o = select_i ? {11'b0,reduced_K} : reduced_D;

endmodule:mod_mul
