module decode(input  logic       clk, reset,
              input  logic [1:0] Op,
              input  logic [5:0] Funct,
              input  logic [3:0] Rd,
              output logic [1:0] FlagW,
              output logic       PCS, NextPC, RegW, MemW,
              output logic       IRWrite, AdrSrc, LDRB,
              output logic [1:0] ResultSrc, ALUSrcA, ALUSrcB, 
              output logic [1:0] ImmSrc, RegSrc, ALUControl, NoWrite);


	logic Branch, ALUOp;
	controlUnit cu (clk, reset, Funct[5], Funct[4], Funct[2], Funct[0], Op, 
						 RegW, MemW, IRWrite, NextPC, AdrSrc, ResultSrc, ALUSrcA, ALUSrcB, Branch, ALUOp, LDRB);

  
	// ALU Decoder
	always_comb
	if (ALUOp) 
		begin // which DP Instr?
			case(Funct[4:1])
				4'b0100:	ALUControl = 2'b00; //ADD
				4'b0010: ALUControl = 2'b01; //SUB
				4'b0000:	ALUControl = 2'b10; //AND
				4'b1100: ALUControl = 2'b11; //OR
				4'b1010: ALUControl = 2'b01; //CMP
				default:	ALUControl = 2'bx;  // unimplemented
			endcase
		
	
			NoWrite = (Funct[4:1] == 4'b1010);
			// update flags if S bit is set (C & V only for arith)
			FlagW[1] = Funct[0];
			FlagW[0] = Funct[0] & (ALUControl == 2'b00 | ALUControl == 2'b01);
		end
	else begin
		NoWrite = 1'b0;
		ALUControl = 2'b00; // add for non-DP instructions
		FlagW = 2'b00; // don't update Flags
	end



 	// PC Logic
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;

	


  // Instr Decoder
  assign ImmSrc = Op;
  assign RegSrc[0] = (Op == 2'b10);
  assign RegSrc[1] = (Op == 2'b01);

endmodule
