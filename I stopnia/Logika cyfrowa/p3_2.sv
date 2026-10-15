// Write your modules here!
module carry1(input c0, 
              input p0, 
              input g0, 
              output car1);
 	 assign car1 = c0 && p0 || g0;
endmodule

module carry2(input c0, 
              input p0, p1, 
              input g0, g1,
              output car2);
  	assign car2 = c0 && p1 && p0 
  	 	 || g0 && p1 
  	 	 || g1;
endmodule

module carry3(input c0, 
              input p0, p1, p2, 
              input g0, g1, g2,
              output car3);
  	assign car3 = c0 && p0 && p1 && p2 
  	  	|| g0 && p1 && p2
  	  	|| g1 && p2
  	  	|| g2;
endmodule

// Obliczanie wszystkich carry na danym poziomie
module carry(input c0, input [3:0] p, g, output [3:0]c);
  //assign c[0] = c0 || (p[3] && !p[3]) || (g[3] && !g[3]); // sztuczna eliminacja warningu o nieuzywanym inpucie
  assign c[0] = c0;
  carry1 c1(c0, p[0], g[0], c[1]);
  carry2 c2(c0, p[0], p[1], g[0], g[1], c[2]);
  carry3 c3(c0, p[0], p[1], p[2], g[0], g[1], g[2], c[3]);
endmodule
//**************************************************************

 module bigPG(input [3:0] p,
              input [3:0] g,
            output P, G);
    assign P = p[0] && p[1] && p[2] && p[3];
    assign G = (g[0] && p[1] && p[2] && p[3]) 
               || (g[1] && p[2] && p[3]) 
               || (g[2] && p[3]) 
               || g[3];
endmodule

module blockgenprop(input [3:0] a, b, 
                output [3:0] p, g);
  assign p = a ^ b;
  assign g = a & b;
endmodule
  
module sumblk(input [3:0] p, c, output [3:0] sum);
    assign sum = p ^ c;
endmodule

module toplevel(input [15:0] a, b, 
                output [15:0] o);

  logic [3:0]a0, a1, a2, a3;
  logic [3:0]b0, b1, b2, b3;
  
  assign {a3, a2, a1, a0} = a; //1 poziom
  assign {b3, b2, b1, b0} = b;
  
  logic [3:0] p0, p1, p2, p3; //2 poziom
  logic [3:0] g0, g1, g2, g3;
  
  //1 -> 2 poziom
  blockgenprop blk0(a0, b0, p0, g0); 
  blockgenprop blk1(a1, b1, p1, g1);
  blockgenprop blk2(a2, b2, p2, g2);
  blockgenprop blk3(a3, b3, p3, g3);
  
  logic [3:0] P; // 3 poziom
  logic [3:0] G;
  
  // 2 -> 3 poziom
  bigPG PG_0(p0, g0, P[0], G[0]); 
  bigPG PG_1(p1, g1, P[1], G[1]);
  bigPG PG_2(p2, g2, P[2], G[2]);
  bigPG PG_3(p3, g3, P[3], G[3]);	//zbędne, ale umożliwia łatwe dołożenie kolejnych poziomów przy zwiększaniu bitów wejścia
  
  logic [3:0] C; //carry dla 3 poziomu
  
  carry _3poziom(0, P, G, C);//carry na 3 poziomie
  logic [3:0] c0, c1, c2, c3; //carry dla 2 poziom
  
  // 3 -> 2 poziom
  carry _2poziom0(C[0],p0, g0, c0); //carry na 2 poziomie
  carry _2poziom1(C[1], p1, g1, c1);
  carry _2poziom2(C[2], p2, g2, c2);
  carry _2poziom3(C[3], p3, g3, c3);
  
  logic [3:0]o0, o1, o2, o3;
  
  // 2 -> 1 poziom
  sumblk sblk0(p0, c0, o0); //suma na 1 poziomie
  sumblk sblk1(p1, c1, o1);
  sumblk sblk2(p2, c2, o2);
  sumblk sblk3(p3, c3, o3);
  
  assign o = {o3, o2, o1, o0};
  
endmodule