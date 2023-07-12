//Z wykładu
module DFF(output q, nq, input c, d);
  logic r, s, nr, ns;
    nand gq(q, nr, nq), gnq(nq, ns, q),
         gr(nr, c, r), gs(ns, nr, c, s),
         gr1(r, nr, s), gs1(s, ns, d);
endmodule

module multi(input s1, s0, a0, a1, a2, a3, output o);
  logic _1, _2;
  assign _1 = s0 ? a1 : a0;
  assign _2 = s0 ? a3 : a2;
  assign o = s1 ? _2 : _1;
endmodule

module _1BitRegister(output Q, input l, r, c, li, i,  ri, d);
  logic newI;
  multi m(l, r, i, li, ri, d, newI);
  DFF dff(Q, , c, newI);
endmodule

module toplevel(output [7:0] q, input [7:0] d, input i, c, l, r);
  _1BitRegister r0(q[0], l, r, c, i,    q[0], q[1], d[0]);
  _1BitRegister r1(q[1], l, r, c, q[0], q[1], q[2], d[1]);
  _1BitRegister r2(q[2], l, r, c, q[1], q[2], q[3], d[2]);
  _1BitRegister r3(q[3], l, r, c, q[2], q[3], q[4], d[3]);
  _1BitRegister r4(q[4], l, r, c, q[3], q[4], q[5], d[4]);
  _1BitRegister r5(q[5], l, r, c, q[4], q[5], q[6], d[5]);
  _1BitRegister r6(q[6], l, r, c, q[5], q[6], q[7], d[6]);
  _1BitRegister r7(q[7], l, r, c, q[6], q[7], i,    d[7]);
endmodule     