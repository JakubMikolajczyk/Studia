// Write your modules here!
module toplevel(input [3:0] i, output o);
  logic x = i[0], y = i[1], z = i[2], w = i[3];
  assign o = (x || y || z) &&
             (x || y || w) &&
             (x || z || w) &&
             (y || z || w) &&
             !(x && y && z && w);
endmodule