// 16-Bit Multiply Add Unit, test design for Standard Cell Design
// F = A * B + C
// Author: Ivan Castellanos
// email: ivan.castellanos@okstate.edu
// VLSI Computer Architecture Research Group,
// Oklahoma Stata University

module multiplyadd(result, a, b, reset, clk);

   output [16:0] result;
   input  [7:0] a;
   input  [7:0] b;
   input  reset;
   input  clk;
   
   wire [15:0] multiplication;
   wire [16:0] sum;

// Custom cell block:
   multi multi_module(.P(multiplication), .A(a), .B(b));

   cla16 cla16_module(sum, multiplication, result[15:0]);

// Output register is 17-bits long to include Carry out in the result.
   dffr_17 accu_output(result, sum, clk, reset);

endmodule
