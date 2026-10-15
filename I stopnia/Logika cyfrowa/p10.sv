//przerobione z wykładu
module memory(
  input wr, clk,
  input [9:0] rdaddr, wraddr,
  input [15:0] in,
  output [15:0] out
);
  logic [15:0] mem [0:1023];
  assign out = mem[rdaddr];
	always_ff @(posedge clk)
		if (wr) mem[wraddr] <= in;
endmodule


module ONP(input nrst, step, push, input [15:0] d, input [1:0] op,
               output logic [15:0] out, output logic [9:0] cnt);
  
  logic [15:0] temp;
  memory RAM(push, step, cnt - 1, cnt, out, temp);
  
  always_ff @(posedge step or negedge nrst) begin
    if(!nrst) begin out <= 0; cnt <= 0; end
    else if(push) begin out <= d; cnt <= cnt + 1; end
	else if(op == 2'b01) out <= -out;
    else if(op == 2'b10) begin out <= out + temp; cnt <= cnt - 1;end
    else if(op == 2'b11) begin out <= out * temp; cnt <= cnt - 1; end
  end

endmodule


module toplevel(input nrst, step, push, input [15:0] d, input [1:0] op,
                output logic [15:0] out, output logic [9:0] cnt);
  ONP onp(nrst, step, push, d, op, out, cnt);
endmodule