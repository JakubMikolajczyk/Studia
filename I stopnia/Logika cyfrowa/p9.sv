module solution(input clk,nrst,door,start,finish,
                output logic heat,light,bell);
  const logic [2:0] CLOSED =  3'b000, COOK =  3'b001, PAUSE = 3'b010,
  					OPEN =3'b011, BELL = 3'b100;
  
  logic [2:0] q;
  
  always_comb begin
  	light = 0; heat = 0; bell = 0;
    unique case (q)
      CLOSED: ;
      COOK:	begin light = 1; heat = 1; end 
      PAUSE: light = 1;
      BELL:	bell = 1;
      OPEN: light = 1;
    endcase
  end
  
  always_ff @(posedge clk or negedge nrst)
    if (!nrst) q <= CLOSED;
    else if (door) 
      unique case (q)
        CLOSED: q <= OPEN;
        COOK: q <= PAUSE;
        BELL: q <= OPEN;
      endcase
  else unique case (q) // !door
            CLOSED: if (start) q <= COOK;
            COOK:	if (finish) q <= BELL;
            PAUSE: 	q <= COOK;
            OPEN: 	q <= CLOSED;
          endcase
  endmodule