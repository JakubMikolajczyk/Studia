module memory(
	input wr, clk,
	input [9:0] rdaddr, wraddr,
	input signed [15:0] in,
	output signed [15:0] out);
  
  	logic [15:0] mem [0:1023];
   	assign out = mem[rdaddr];
  	always_ff @(posedge clk)
    	if (wr) mem[wraddr] <= in;
endmodule

module calc(input clk, nrst, en, push, input [15:0] d, input [2:0] op,
            output logic signed [15:0] out, output logic [9:0] cnt);
  
  const logic [2:0] G = 3'b000, SUB = 3'b001, ADD = 3'b010, 
  	MUL = 3'b011, S = 3'b100, L = 3'b101, P1 = 3'b110, P2 = 3'b111;
  
  	logic [15:0] temp;
  	logic swap, load;
  	logic [9:0] newSubCnt;
  	assign newSubCnt = cnt == 0 ? 0 : cnt - 1;
  	assign swap = !push && (op == S);
  	assign load = op == L;
  	memory calcRAM(push || swap, clk, (load ? cnt - out: cnt) - 1, swap ? cnt - 1 : cnt, out, temp);
  
  	always_ff @(posedge clk or negedge nrst)
    	if (!nrst) begin out <= 0; cnt <= 0; end  
    	else if (en)
  				if(push) begin out <= d; cnt <= cnt + 1; end
  				else unique case (op)
             		G: out <= out > 0;
             		SUB: out <= -out;
             		ADD: begin out <= out + temp; cnt <= newSubCnt;end
             		MUL: begin out <= out * temp; cnt <= newSubCnt; end
             		S: begin out <= temp; end
             		L: begin out <= temp; end
             		P1: begin out <= temp; cnt <= cnt - 1; end
             		P2: begin out <= temp; cnt <= cnt - 1; end
          		 endcase
endmodule          
     

module ctl(input clk, nrst, wr, start, input [9:0] addr, input [15:0] datain, 
           output ready, output logic signed [15:0] out);
  
  const logic READY = 1'b1, BUSY =1'b0;
  logic s, en, push;
  logic [9:0] pc;
  logic [15:0] p;
  
  assign ready = s; 						// !s <=> s == BUSY
  assign en = !(s || (p[15] && p[14])); 	// !s && (!p[15] || !p[14])
  assign push = !(s || p[15]); 				// !s && !p[15]
  memory codeRAM(ready && !start && wr, clk, pc, addr, datain, p);
  
  calc calculator(clk, nrst, en, push, p, p[2:0],out, ); 
  
  always_ff @(posedge clk or negedge nrst)
    if(!nrst) s <= READY;
  	else unique case (s)
        	READY: if (start) begin s <= BUSY; pc <= 0; end
      		BUSY: if (p[15:14] == 2'b11) s <= READY;
      		else if (p[15] && p[2:0] == 7) pc <= out;
  					else pc <= pc + 1;
		endcase
  

endmodule

