module toplevel(input [31:0] i, output [31:0] o);
  
  integer iter;
  logic temp;
  always_comb
    begin
      o[31] = i[31];
      temp = i[31];
      for(iter = 30; iter >= 0; iter = iter - 1)
        begin
          o[iter] = temp ^ i[iter];
          temp = o[iter];
        end
    end
  
endmodule