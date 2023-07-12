module toplevel(input [3:0] i, input l, r, output [3:0] o);
  logic norlr;
  assign norlr = ~(l || r);
  assign o[0] = (l && 1'b0) || (r && i[1]) || (norlr && i[0]);
  assign o[1] = (l && i[0]) || (r && i[2]) || (norlr && i[1]);
  assign o[2] = (l && i[1]) || (r && i[3]) || (norlr && i[2]);
  assign o[3] = (l && i[2]) || (r && 1'b0) || (norlr && i[3]);
  
endmodule