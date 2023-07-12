//z wykładu 
module memory(
    input clk, wr,
  	input [2:0] rdaddr, wraddr,
    input [7:0] in,
    output logic [7:0] out);
  
	logic [7:0] mem [0:7];
	always_ff @(posedge clk)
		out <= mem[rdaddr];
	always_ff @(posedge clk)
		if (wr) mem[wraddr] <= in;
endmodule
  
module toplevel(input clk, nrst, start, wr, 
                input [2:0] addr, 
                input [7:0] datain, 
                output [7:0] dataout,
              	output ready);
  
    logic [2:0] i, j, jm;
  	logic [7:0] c, m;
  	logic start_o, wr_o, add1, load, swap, fswap, loadi, newMin, innerBegin;
  	
  
  cltpath clt(clk, nrst, start, wr, i, j, jm, c, m, 
              ready, wr_o, start_o, add1, load, swap, fswap, loadi, newMin, innerBegin);
  datapath data(clk, addr, datain,
               ready, wr_o, start_o, add1, load, swap, fswap, loadi, newMin, innerBegin,
               dataout, c, m,
                i, j, jm);
endmodule

module cltpath(input clk, nrst, start, wr, input [2:0] i, j, jm, input [7:0] c, m,
               output logic ready, wr_o, start_o, add1, load, swap, fswap, loadi, newMin, innerBegin);
  
  const logic [2:0] READY = 3'b000, OUTER = 3'b001, 
  INNER = 3'b010, END = 3'b011, SWAP = 3'b100;
  logic [2:0] s;
  
  always_ff @(posedge clk or negedge nrst)
    if(!nrst)
      s <= READY;
        else unique case (s)
          READY: if (start) s <= OUTER;
          OUTER: if (i == 7) s <= READY;
              		else s <= INNER;
          INNER: if (j == 7) s <= END;
          END:	if (i == jm) s <= OUTER;
          		else s <= SWAP;
          SWAP: s <= OUTER;
        endcase
   
  assign wr_o = wr;
  assign start_o = start;
  
  always_comb begin
    swap = 1'b0;
    fswap = 1'b0;
    load = 1'b1;
    case (s)
      END: if(i != jm) begin swap = 1'b1; fswap = 1'b1; load = 1'b0; end
      SWAP: swap = 1'b1;
    endcase
  end
  
  always_comb begin
    loadi = 1'b1;
    add1 = 1'b1;
    newMin = 1'b0;
    case (s)
      INNER: begin
        newMin = c < m;
        loadi = (j == 7);
        add1 = !loadi;
      end
     endcase
  end
  
  always_comb begin
    innerBegin = 1'b0;
    case (s)
      OUTER: innerBegin = (i != 7);
    endcase
  end
      
  always_comb begin
    ready = 1'b0;
    case (s)
      READY: ready = 1'b1;
    endcase
  end
        
  
endmodule

module datapath(input clk,
                input [2:0] addr, 
                input [7:0] datain,
                input ready, wr, start, add1, load, swap, fswap, loadi, newMin, innerBegin,
                output logic [7:0] dataout, c, m,
                output logic [2:0] i, j, jm);
  
  logic memrd, memwr;
  logic [2:0] memRdAddr, memWrAddr;
  logic [7:0] memWrIn;
  
  assign memrd = (ready && !start && !wr) || (ready && start) || (!ready && load);
  assign memwr = (ready && !start && wr) || (!ready && swap);
  
  assign memRdAddr = (ready && !start && !wr) ? addr : 
                     (ready && start) ? 0 : 
                     (loadi ? (add1 ? i + 1: i) : (add1 ? j + 1: j));
  assign memWrAddr = (ready && !start && wr) ? addr : 
                     (fswap ? jm : i);
  
  assign memWrIn = (ready && !start && wr) ? datain : 
                   (fswap ? c : m);
  
  memory ram(clk, memwr, memRdAddr, memWrAddr, memWrIn, c);
  assign dataout = c;
  
  always_ff @(posedge clk)
    if (start && ready) i <= 0;
  else if (innerBegin) begin j <= i + 1; jm <= i; m <= c; end
  else begin
    if (newMin) begin m <= c; jm <= j; end
    if (load && !loadi && add1) j <= j + 1;
    if (load && loadi && add1) i <= i + 1;
  end
  
endmodule