module toplevel(
  input a, b, c, d, x, y,
  output o
);
  
  assign nx = !x;
  assign ny = !y;
  assign a1 = nx && ny && a;
  assign b1 = nx && y && b;
  assign c1 = x && ny && c;
  assign d1 = x && y && d;
  assign o = a1 || b1 || c1 || d1;
  

endmodule
