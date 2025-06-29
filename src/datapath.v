`timescale 1ns / 1ps


module datapath(
input clk , reset ,
//Fetch stage signals
input StallF,
output [31:0] PCF ,
input [31:0] InstrF ,
//Decode stage signals
input [2:0]  ImmSrcD ,
input FlushD,StallD ,
output [6:0] opD ,
output [2:0] funct3D ,
output funct7b5D ,
output [4:0] Rs1D , Rs2D ,   //hazard unit signals
//Execute stage signals
input ALUSrcAE ,ALUSrcBE ,
input [2:0] ALUControlE ,
input PCSrcE ,
output [4:0] RdE ,Rs1E ,Rs2E , //hazard unit signals
input [1:0] ForwardAE , ForwardBE ,
input FlushE ,  //hazard unit signal
output ZeroE ,
//Memory Stage Signal
input [31:0] ReadDataM ,
input MemWriteM ,
output [31:0] WriteDataM , ALUResultM,
output [4:0] RdM , //hazard unit signal
//Writeback Stage signal
input [1:0] ResultSrcW,
input RegWriteW ,
output [4:0] RdW //hazard unit signal 
 );
 
 // Fetch stage signals
wire [31:0] PCNextF, PCPlus4F;

// Decode stage signals
wire [31:0] InstrD;
wire [31:0] PCD, PCPlus4D;
wire [31:0] RD1D, RD2D;
wire [31:0] ImmExtD;
wire [4:0]  RdD;

// Execute stage signals
wire [31:0] RD1E, RD2E;
wire [31:0] PCE, ImmExtE;
wire [31:0] SrcAE, SrcBE;
wire [31:0] SrcAEforward;
wire [31:0] ALUResultE;
wire [31:0] WriteDataE;
wire [31:0] PCPlus4E;
wire [31:0] PCTargetE;

// Memory stage signals
wire [31:0] PCPlus4M;

// Writeback stage signals
wire [31:0] ALUResultW;
wire [31:0] ReadDataW;
wire [31:0] PCPlus4W;
wire [31:0] ResultW;

//Decode Stage signals and elements 
assign opD = InstrD[6:0] ;
assign funct3D = InstrD[14:12];
assign funct7b5D = InstrD[30] ;
assign Rs1D = InstrD[19:15] ;
assign Rs2D = InstrD[24:20] ;
assign RdD = InstrD[11:7] ;

regfile rf (clk,RegWriteW,Rs1D,Rs2D,RdW,ResultW,RD1D,RD2D) ;
extend ex(InstrD[31:7],ImmSrcD,ImmExtD) ;

//Fetch Stage 
mux2 #(32) pcmux (PCPlus4F,PCTargetE,PCSrcE,PCNextF) ;
flopenr #(32) pcflop (clk , reset ,~StallF,PCNextF,PCF) ;

//Decode Stage 
adder pcadd (PCF,32'b100,PCPlus4F) ;
flopenrc #(96) dec(clk , reset,FlushD,~StallD,{InstrF,PCF,PCPlus4F},{InstrD,PCD,PCPlus4D}) ;

//Execute Stage elements

floprc #(175) regE(clk, reset, FlushE,
    {RD1D, RD2D, PCD, Rs1D, Rs2D, RdD, ImmExtD, PCPlus4D},
    {RD1E, RD2E, PCE, Rs1E, Rs2E, RdE, ImmExtE, PCPlus4E});

mux3 #(32) faemux(RD1E, ResultW, ALUResultM, ForwardAE, SrcAE);
mux2 #(32) srcamux(SrcAEforward, 32'b0, ALUSrcAE, SrcAE); // for lui
mux3 #(32) fbemux(RD2E, ResultW, ALUResultM, ForwardBE, WriteDataE);
mux2 #(32) srcbmux(WriteDataE, ImmExtE, ALUSrcBE, SrcBE);
alu alu(SrcAE, SrcBE, ALUControlE, ALUResultE, ZeroE);
adder branchadd(ImmExtE, PCE, PCTargetE);

// Memory stage pipeline register
flopr #(101) regM(clk, reset,
    {ALUResultE, WriteDataE, RdE, PCPlus4E},
    {ALUResultM, WriteDataM, RdM, PCPlus4M});

// Writeback stage pipeline register and logic
flopr #(101) regW(clk, reset,
    {ALUResultM, ReadDataM, RdM, PCPlus4M},
    {ALUResultW, ReadDataW, RdW, PCPlus4W});

mux3 #(32) resultmux(ALUResultW, ReadDataW, PCPlus4W, ResultSrcW, ResultW);
endmodule





