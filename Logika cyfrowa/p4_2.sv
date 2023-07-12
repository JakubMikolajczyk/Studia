module funnelShifter(
  input [7:0]a,b,
  input [3:0]n, 
  output [7:0]o
);
  logic [15:0] temp;
  assign temp = {a, b};
  assign o = temp >> n;
 
endmodule

module toplevel(
  input [7:0]i,
  input [3:0]n,
  input ar, lr, rot,
  output [7:0]o
);
  logic [3:0] newN;
  logic [7:0] a, b;
  assign newN = lr? (4'b1000 - n) : n;
  assign a = lr || rot ? i : (ar? {8{i[7]}} : 8'b0);
  assign b = lr && !rot ? 8'b0 : i;
  
  funnelShifter fun(a, b, newN, o);
endmodule