module rom(input logic [4:0] adr,
			  output logic [31:0] dout);
		always_comb
			case(adr)
				//LDRB_Aluop_B_NextPc_RegW_MemW_IrWrite_AdrSrc_ResultSrc[2]_AluSrcA[2]_AluSrcB[2]_Ne0tAdr[5]
            5'b00000: dout = {13'b0, 1'b0, 18'b001001010011000001}; //Fetch
            5'b00001: dout = {13'b0, 1'b0, 18'b000000010011011111}; //Decode
            5'b00010: dout = {13'b0, 1'b0, 18'b000000000000111110}; //MemAdr
            5'b00011: dout = {13'b0, 1'b0, 18'b000000100000000100}; //memread
            5'b00100: dout = {13'b0, 1'b0, 18'b000100001000000000}; //memwb
            5'b00101: dout = {13'b0, 1'b0, 18'b000010100000000000}; //memwrite
				5'b00110: dout = {13'b0, 1'b0, 18'b100000000000001000}; //E0ecuteR
				5'b00111: dout = {13'b0, 1'b0, 18'b100000000000101000}; //E0ecuteI
            5'b01000: dout = {13'b0, 1'b0, 18'b000100000000000000}; //AluWb
            5'b01001: dout = {13'b0, 1'b0, 18'b010000010000100000}; //Branch
				5'b01010: dout = {13'b0, 1'b0, 18'b010100010000100000}; //BL
				5'b01011: dout = {13'b0, 1'b1, 18'b000000100000000100}; //MemReadByte
				default:  dout = {13'b0, 1'b0, 18'b001001010011000001}; //Fetch
			endcase
endmodule