module toplevel(input clk, 
                input [15:0] d, 
                input [1:0] sel, 
                output logic [15:0] cnt, cmp, top,
               	output logic out);
  
  PWM sol(clk, d, sel, cnt, cmp, top, out);
endmodule


module PWM(input clk, 
                input [15:0] d, 
                input [1:0] sel, 
                output logic [15:0] cnt, cmp, top,
               	output out);
  
  always_ff @(posedge clk)
    if (sel == 2'b01) 		cmp <= d;
  	else if(sel == 2'b10) 	top <= d; 
  
  always_ff @(posedge clk)
    if (sel == 2'b11) 	cnt <= d;
 	else if(cnt < top) 	cnt <= cnt + 16'b1;
 	else				cnt <= 16'b0;
  
	assign out = cnt < cmp;
endmodule

