// Write your modules here!
module toplevel(input clk, nrst, start, input [7:0] ina, inb, 
               output ready, output [7:0] out);
  logic [7:0] a, b;
  logic load, swap, endCalc;
  
  ctlpath clt(clk, nrst, start, a, b, ready, load, swap, endCalc);
  datapath data(clk, ready, load, swap, endCalc, ina, inb, a, b, out);
endmodule
 
module datapath(input clk, ready, load, swap, endCalc, input [7:0] ina, inb, 
                output logic [7:0] a, b, out);
    
  always_ff @(posedge clk)
    if (ready) begin
      if(load) begin a <= ina; b <= inb; end
    end
  else begin
    if (endCalc) out <= a;
    else if (swap) begin a <= b; b <= a; end
  	else a <= a - b;
  end
  
endmodule


module ctlpath(input clk, nrst, start, input [7:0] a, b, 
               output logic ready, load, swap, endCalc);
  
  const logic READY = 1'b1, BUSY = 1'b0;
  
  logic s;
  
  always_ff @(posedge clk or negedge nrst)
    if (!nrst) s <= READY;
  else case (s)
    READY: if (start) s <= BUSY;
    BUSY:  if (a == b) s <= READY;
  endcase

  always_comb begin
  ready = s;
  load = start;
  swap = a < b;
  endCalc = a == b;
  end
  
endmodule  