module datapath(input  logic        clk, reset,
                output logic [31:0] Adr, WriteData,
                input  logic [31:0] ReadData,
                output logic [31:0] Instr,
                output logic [3:0]  ALUFlags,
                input  logic        PCWrite, RegWrite,
                input  logic        IRWrite,
                input  logic        AdrSrc,
					      input  logic	  		LDRB,
                input  logic [1:0]  RegSrc, 
                input  logic [1:0]  ALUSrcA, ALUSrcB, ResultSrc,
                input  logic [1:0]  ImmSrc, ALUControl);


  logic [31:0] Data, DataD, RD1, RD2, WD3, A, ALUResult, ALUOut, ShiftedData, PC, SrcA, SrcB, Result, ExtImm;
  logic [3:0]  RA1, RA2, WA3, Shamt;
  logic [7:0]  ReadDataMuxOut;
  
  flopenr #(32) pcflopner(clk, reset, PCWrite, Result, PC);
  
  mux2 #(32) adrmux(PC, Result, AdrSrc, Adr);
  mux4 #(8) ReadDataMux(ReadData[7:0], ReadData[15:8], ReadData[23:16], ReadData[31:24], Adr[1:0], ReadDataMuxOut);
  mux2 #(32) dataMux(ReadData, {24'b0, ReadDataMuxOut}, LDRB, DataD);
  flopr #(32) datareg(clk, reset, DataD, Data);
  flopenr #(32) instrreg(clk, reset, IRWrite, ReadData, Instr);
  mux2 #(4) RA1mux(Instr[19:16], 4'b1111, RegSrc[0], RA1);
  mux2 #(4) RA2mux(Instr[3:0], Instr[15:12], RegSrc[1], RA2);
  mux2 #(4) WA3mux(Instr[15:12], 4'b1110, RegSrc[0],WA3);
  mux2 #(32) WD3mux(Result, PC, RegSrc[0], WD3);

  regfile regfile(clk, RegWrite, RA1, RA2, WA3, WD3, Result, RD1, RD2);
  flopr #(32) areg(clk, reset, RD1, A);
  flopr #(32) wdreg(clk, reset, RD2, WriteData);
  extend extend(Instr[23:0], ImmSrc, ExtImm);
  mux3 #(32) aluSrcAMux(A, PC, ALUOut, ALUSrcA, SrcA);
  shifter shifter(WriteData, Instr[11:7], Instr[6:5], ShiftedData);
  mux3 #(32) aluSrcBMux(ShiftedData, ExtImm, 32'b100,  ALUSrcB, SrcB);
  alu alu(SrcA, SrcB, ALUControl, ALUResult, ALUFlags);
  flopr #(32) aluOutReg(clk, reset, ALUResult, ALUOut);
  mux3 #(32) resultMux(ALUOut, Data, ALUResult, ResultSrc, Result);
  
endmodule