module tff(output q, nq, 
           input t, clk, nrst);
  logic ns, nr, ns1, nr1, j, k;
  nand n1(ns, clk, j), n2(nr, clk, k),
  n3(q, ns, nq), n4(nq, nr,  q, nrst), n5(ns1,!clk, t, nq), 
  n6(nr1, !clk, t, q), n7(j, ns1, k), n8(k, nr1, j, nrst);
  endmodule
module syncnt(output  [3:0] q,
              input  clk, nrst,step, down);
  logic [3:0]nq;
  logic [3:0] t;
  logic [3:0] nt;
  assign t = { q & t, !step};
  tff t1(q[0],nq[0], !step, clk, nrst);
  tff t2(q[1],nq[1], ((down? nq[0] || step : q[0] || step)), clk, nrst );
  tff t3(q[2],nq[2], ((down? nq[0] && nq[1] || nq[1] && step: q[0] && q[1] || q[1] && step)), clk, nrst);
  tff t4(q[3],nq[3], ((down? nq[0] && nq[1] && nq[2] || nq[1] && nq[2] && step : q[0] && q[1] && q[2] || q[1] && q[2] && step)), clk, nrst);
endmodule

module toplevel(output  [3:0] out,
              input  clk, nrst, step, down);
  syncnt a(out, clk, nrst,step, down);
  
endmodule