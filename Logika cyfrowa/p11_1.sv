// Write your modules here!
module toplevel(input clk, nrst, start, input [15:0] inx, input [7:0] inn, 
               output logic ready, output logic [15:0] out);
  
  logic [15:0] x, a, temp;
  logic [7:0] n;
  logic s, mod2;
  const logic READY = 1'b1, BUSY = 1'b0;
  
  always_comb begin
    mod2 = !n[0];
  	temp = x * (mod2 ? x : a);
    ready = s;
    // out = a; //likwidujemy 1 przerzutnik, ale niezgodne z diagramem
  end
  
  always_ff @(posedge clk or negedge nrst)
    begin
    if(!nrst) s <= READY;
    else case (s)
        READY: 
          	if (start) begin x <= inx; n <= inn; a <= 1; s <= BUSY; end
      	BUSY: 
          	if (n == 0) begin out <= a; s <= READY; end // out <= a można zlikwidować, ale będzie niezgodne z diagramem
      		else if (mod2) begin x <= temp; n <= n >> 1; end 
      		else begin a <= temp; n <= n - 1; end
   endcase end
     
endmodule
 