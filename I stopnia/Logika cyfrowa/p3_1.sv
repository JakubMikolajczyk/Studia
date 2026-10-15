module _1bitadder(input a, b, c, output c0, s);
  assign s = a ^ b ^ c;
  assign c0 = a&&b || a&&c || b&&c;
endmodule


module _4bitadder(input [3:0] a, b, input c0, output c4, output [3:0]s);
  logic c1, c2, c3;
  _1bitadder f0(a[0], b[0], c0, c1, s[0]);
  _1bitadder f1(a[1], b[1], c1, c2, s[1]);
  _1bitadder f2(a[2], b[2], c2, c3, s[2]);
  _1bitadder f3(a[3], b[3], c3, c4, s[3]);
endmodule 

//Jeśli było carry lub mamy taką konfigurację bitów 1x1x 11xx to dodajemy 6
module bcdfixer(input [3:0]bcd, input c4, output newc4, output [3:0] bcdfix);
  logic fix, c2, c3, tempc;
  assign fix = c4 || bcd[1] && bcd[3] || bcd[3] && bcd[2];
  assign bcdfix[0] = bcd[0];
  _1bitadder fix1(bcd[1], fix, 'b0, c2, bcdfix[1]);
  _1bitadder fix2(bcd[2], fix, c2, c3, bcdfix[2]);
  _1bitadder fix3(bcd[3], 'b0, c3, tempc, bcdfix[3]);
	
  assign newc4 = tempc | c4;
  
endmodule

module _4bitbcdadder(input [3:0] a, b, input c0, output c4, output [3:0] s);
  logic tempc;
  logic [3:0] beffix;
  _4bitadder bcdAdd(a, b, c0, tempc, beffix);
  bcdfixer fixing(beffix, tempc, c4, s);
  
endmodule

module _8bitbcdAdder(input [7:0] a, b, input c0, output [7:0] s);
  
  logic c4, c8, tempc;
  logic [7:0] beffix;
  
  _4bitadder bcdAdd1(a[3:0], b[3:0], c0, c4, beffix[3:0]);
  bcdfixer	fix1(beffix[3:0], c4, tempc, s[3:0]);
  
  _4bitadder bcdAdd2(a[7:4], b[7:4], tempc, c8, beffix[7:4]);
  bcdfixer	fix2(beffix[7:4], c8, , s[7:4]);
                     
endmodule


module complimentto9(input [3:0] i, output [3:0] o);
  assign o[3] = !i[3] && !i[2] && !i[1];
  assign o[2] = i[2] && !i[1] || !i[2] && i[1];
  assign o[1] = i[1];
  assign o[0] = !i[0];

endmodule

module toplevel(input [7:0] a, b, input sub, output [7:0] o);
  
  logic [7:0] _8sub, compb, newb;
  assign _8sub = {8{sub}};
  
  complimentto9 comp1(b[7:4], compb[7:4]);
  complimentto9 comp2(b[3:0], compb[3:0]);
  
  assign newb = _8sub & compb | (~_8sub & b); //przy odejmowaniu bierzemy dopelnienie b
  
  _8bitbcdAdder _8bcdAdder(a, newb, sub, o); //jesli odejmujemy to na koncu musimy dodac 1, zatem mozemy to przekazac jako startowe carry
  
endmodule  
  
  
  