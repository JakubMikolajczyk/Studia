module memory(
    input clk, wr,
  	input [7:0] addr,
    input [7:0] in,
    output [7:0] out
);
  logic [7:0] mem [0:255];
	assign out = mem[addr];
  always_ff @(posedge clk)
      if (wr) mem[addr] <= in;
endmodule

module toplevel(input clk, nrst, in_valid, out_ack, start, input [7:0] in_data, 
                output out_valid, in_ack, ready, output [7:0] out_data);

logic [7:0] code, mem, c;
logic [1:0] hdOP, memOP, pcOP, cOP;
logic writeCode, memWrite, nrst_out, hd_1_zero;

ctlpath ctl(clk, start, nrst, in_valid, hd_1_zero ,in_ack, out_valid, out_ack,
code, mem, c, 
ready, writeCode, memWrite, nrst_out, 
hdOP, memOP, pcOP, cOP);
datapath data(clk, nrst_out, writeCode, memWrite, hdOP, memOP, pcOP, cOP, code, mem, c, in_data, out_data, hd_1_zero);

endmodule

module datapath(input clk, nrst,
                writeCode, memWrite,
                input [1:0] hdOP,
                memOP,
                pcOP,
                cOP,
                output logic [7:0] codeOut,
                output logic [7:0] memOut,
                output logic [7:0] cOut,
                input [7:0] datain,
                output logic [7:0] dataout,
                output hd_1_zero);
  
 
  logic [7:0] pc, hd;
  
  const logic [1:0] NONE = 2'b00, ADD = 2'b01, SUB = 2'b10, ZERO = 2'b11;

  always_ff @(posedge clk or negedge nrst)
    if (!nrst) hd <= 0;
    else unique case (hdOP)
        ZERO: hd <= 0;
        ADD: hd <= hd + 1;
        SUB: hd <= hd - 1;
        NONE: ;
      endcase
  
  always_ff @(posedge clk or negedge nrst)
  if (!nrst) pc <= 0;
  else unique case (pcOP)
        ZERO: pc <= 0;
        ADD: pc <= pc + 1;
        SUB: pc <= pc - 1;
       NONE: ;
     endcase
  
  always_ff @(posedge clk)
    unique case (cOP)
      ZERO: cOut <= 0;
      ADD: cOut <= cOut + 1;
      SUB: cOut <= cOut - 1;
      NONE: ;
    endcase
  
  logic [7:0] memIn;
  
  always_comb
    unique case (memOP)
      ZERO: memIn = 0;
      ADD: memIn = memOut + 1;
      SUB: memIn = memOut - 1;
      NONE: memIn = datain;
    endcase
  

  memory text(clk, writeCode, pc, datain, codeOut);
  memory mem(clk, memOP != NONE || memWrite, hd, memIn, memOut);
  
  assign dataout = memOut;
  assign hd_1_zero = hd == 255;
endmodule
                
                
module ctlpath(input clk, start, nrst, 
              in_valid, hd_1_zero_in, output logic in_ack, 
              out_valid, input out_ack,
              input [7:0] codeIn, memIn, cIn,
              output logic readyOut, writeCodeOut, memWriteOut, nrst_out,
              output logic [1:0] hdOPOut,
              memOPOut,
              pcOPOut,
              cOPOut);
   
  
  const logic [1:0] NONE = 2'b00, ADD = 2'b01, SUB = 2'b10, ZERO = 2'b11;
  
  const logic [2:0] READY = 3'b000, ZERO_S = 3'b001,
          WORK = 3'b010, RIGHT = 3'b011, LEFT = 3'b100,
          WRITE = 3'b101, READ = 3'b110; 

  const logic [7:0] NULL = 8'h00, DOT = 8'h2E, COMMA = 8'h2C, PLUS = 8'h2B, 
          MINUS = 8'h2D, LESS = 8'h3C, GREATER = 8'h3E, OPEN = 8'h5B, CLOSE = 8'h5D;

  logic [2:0] s;
  logic is_c_grt, is_code_close, is_code_open, is_mem_zero;
  assign is_c_grt = cIn > 0;
  assign is_code_close = codeIn == CLOSE;
  assign is_code_open = codeIn == OPEN;
  assign is_mem_zero = memIn == 0;

  always_ff @(posedge clk or negedge nrst)
    if (!nrst) s <= READY;
    else unique case (s)
      READY: if (start) s <= ZERO_S;
      ZERO_S: if (hd_1_zero_in) s <= WORK;
      READ: if (in_valid) s <= WORK;
      WRITE: if (out_ack) s <= WORK;
      WORK: 
        unique case (codeIn)
          NULL: s <= READY;
          DOT: s <= WRITE;
          COMMA: s <= READ;
          OPEN: if (is_mem_zero) s <= RIGHT;
          CLOSE: if (!is_mem_zero) s <= LEFT;
          PLUS: ;
          MINUS: ;
          LESS: ;
          GREATER: ;
        endcase
      RIGHT: if (is_code_close && !is_c_grt) s <= WORK;
      LEFT:  if (is_code_open && !is_c_grt) s <= WORK;
  endcase


  always_comb begin
    nrst_out = nrst;
    writeCodeOut = 1'b0;
    memWriteOut = 1'b0;
    readyOut = 1'b0;
    in_ack = 1'b0;
    out_valid = 1'b0;

    hdOPOut = NONE;
    pcOPOut = ADD;
    memOPOut = NONE;
    cOPOut = NONE;
    case (s)
      READY: begin readyOut = 1'b1;
            if(!start && in_valid) begin writeCodeOut = 1'b1; in_ack = 1'b1; end
            if(!start && !in_valid) pcOPOut = NONE; end
      ZERO_S: begin memOPOut = ZERO; pcOPOut = ZERO; hdOPOut = ADD; end
      WRITE: begin out_valid = 1'b1; if (!out_ack) pcOPOut = NONE; end
      READ: begin in_ack = 1'b1; 
        if (in_valid) memWriteOut = 1'b1;
        else pcOPOut = NONE; end
      RIGHT: begin if (is_code_open) cOPOut = ADD;
                  if(is_code_close && is_c_grt) cOPOut = SUB; end
      LEFT: begin pcOPOut = SUB;
                  if (is_code_close) cOPOut = ADD;
        		  else if (is_code_open)
                    if (is_c_grt) cOPOut = SUB;
        			else pcOPOut = ADD; end
      WORK: unique case (codeIn)
        PLUS: memOPOut = ADD;
        MINUS: memOPOut = SUB;
        GREATER: hdOPOut = ADD;
        LESS: hdOPOut = SUB;
        CLOSE: begin cOPOut = ZERO; pcOPOut = is_mem_zero? ADD: SUB; end
        OPEN: cOPOut = ZERO;
        DOT: pcOPOut = NONE;
        COMMA: pcOPOut = NONE;
        NULL: begin pcOPOut = ZERO; hdOPOut = ZERO; end
      endcase
   endcase
  end

endmodule