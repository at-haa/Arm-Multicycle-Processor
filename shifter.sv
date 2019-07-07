module shifter(input logic [31:0] in, input logic[4:0] shamt, input logic [1:0] sh, output logic [31:0] out);


	logic [63:0] rotator;
	
	assign rotator	= {in, in};

	always_comb
		case(sh)
			2'b00:
				out = in << shamt;
			2'b01:
				out = in >> shamt;
			2'b10:
				out = in >>> shamt;
			2'b11:
				out = rotator >> shamt;
		endcase

endmodule 