module compare_swap(input [3:0] a, b, output [3:0] newA, newB);
  assign newA = a > b? a : b;
  assign newB = a > b? b : a;
endmodule



module toplevel(input [15:0] i, output [15:0] o);
  logic [3:0] a1,b1,c1,d1;
  assign {a1,b1,c1,d1} = i;
  
  logic [3:0] a2, b2, c2, d2;
  compare_swap first_1_3(a1, c1, a2, c2);
  compare_swap first_2_4(b1, d1, b2, d2);
  
  logic [3:0] a, b3, c3, d;
  compare_swap second_1_2(a2, b2, a, b3);
  compare_swap second_3_4(c2, d2, c3, d);
  
  logic [3:0] b, c;
  compare_swap third_2_3(b3, c3, b, c);
  
  assign o = {a,b,c,d};
endmodule