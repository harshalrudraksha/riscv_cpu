`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2025 18:24:37
// Design Name: 
// Module Name: riscv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module riscv(
input clk , reset ,
input [31:0] InstrF ,
input [31:0] ReadDataM ,
output [31:0] PCF ,
output [31:0] ALUResultM ,WriteDataM,
output MemWriteM 
 );
 
 wire StallF,FlushD,StallD,ALUSrcAE ,ALUSrcBE  ;
 wire [2:0] ImmSrcD ;
 wire [6:0] opD ;
 wire [2:0] funct3D ;
 wire funct7b5D ;
 wire [4:0] Rs1D , Rs2D ;
 wire [2:0] ALUControlE ;
 wire PCSrcE ;
 wire [4:0] RdE ,Rs1E ,Rs2E ; 
 wire [1:0] ForwardAE , ForwardBE ;
 wire FlushE,ZeroE ;
  wire [4:0] RdM ; 
  wire [1:0] ResultSrcW;
wire  RegWriteW ;
wire [4:0] RdW ;
wire  ResultSrcEb0 ;
 wire RegWriteM ;
 
 
 
  datapath mpd (clk,reset,StallF,PCF,InstrF,ImmSrcD,FlushD,StallD,opD,funct3D,funct7b5D,Rs1D ,Rs2D , ALUSrcAE ,ALUSrcBE ,ALUControlE,PCSrcE ,
  RdE ,Rs1E ,Rs2E ,ForwardAE , ForwardBE ,  FlushE ,ZeroE,ReadDataM ,MemWriteM , WriteDataM , ALUResultM, RdM , 
  ResultSrcW, RegWriteW ,RdW ) ;
  
  controller mpc (clk,reset,opD , funct3D ,funct7b5D ,FlushE , ZeroE ,ImmSrcD , ALUControlE , PCSrcE ,ALUSrcAE , ALUSrcBE ,
   ResultSrcEb0 , RegWriteM ,MemWriteM , RegWriteW , ResultSrcW ) ;
  
  hazard huc ( Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,PCSrcE, ResultSrcEb0, RegWriteM, RegWriteW,ForwardAE, ForwardBE,
  StallF, StallD, FlushD, FlushE) ;
  
endmodule
