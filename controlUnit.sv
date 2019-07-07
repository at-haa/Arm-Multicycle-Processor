module controlUnit (input logic  clk, reset,
					     input logic Funct5, Funct4, Funct2, Funct0,
					     input logic [1:0] Op,
					     output logic RegW, MemW, IRWrite, NextPC,
					     output logic AdrSrc,
					     output logic [1:0] ResultSrc, ALUSrcA, ALUSrcB,
					     output logic Branch, ALUOp, LDRB);

	logic[4:0] branchTarget;
  	logic[4:0] currentAddress;
 	logic[31:0] controlLine;
 	logic[31:0] controlLineQ;

	
	always_ff @(negedge clk, posedge reset) 
    	if (reset)  currentAddress<= 5'b00000; 
    	else currentAddress <= branchTarget ;

    sequenceLogic seq_logic (controlLineQ[4:0], Op, Funct0, Funct2, Funct4, Funct5, branchTarget);

    rom memory (currentAddress , controlLine);

    flopr #(32) cont_buffer_reg(clk , reset , controlLine , controlLineQ);
	 
	 assign {LDRB, ALUOp, Branch, NextPC, RegW, MemW, IRWrite, AdrSrc, ResultSrc, ALUSrcA, ALUSrcB} = controlLineQ[18:5];


endmodule 