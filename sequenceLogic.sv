module sequenceLogic    (input  logic  [4:0]  tempNextAdr,
                         input  logic  [1:0]  op,
                         input  logic  funct0, funct2, funct4, funct5,
                         output logic  [4:0]  realNextAdr);					 
								 
    logic [4:0] temp10, temp11;

    assign realNextAdr = (tempNextAdr == 5'b11111) ? temp10 : ((tempNextAdr == 5'b11110) ? temp11 : tempNextAdr); 
    assign temp10 = (op == 2'b01) ? 5'b00010 : (op == 2'b10 & funct4 == 1'b0) ? 5'b01001 : (op == 2'b10 & funct4 == 1'b1) ? 5'b01010 :(funct5) ? 5'b00111 : 5'b00110;
    assign temp11 = (funct0) ? ((funct2)? 5'b01011:5'b00011): 5'b00101;
	 
endmodule 