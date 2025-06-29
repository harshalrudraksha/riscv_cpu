`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.06.2025 05:16:33
// Design Name: 
// Module Name: controller
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


module controller(
input clk , reset,
input [6:0] opD ,
input [2:0] funct3D ,
input funct7b5D ,
input FlushE , ZeroE ,
//decode stage output
output [2:0] ImmSrcD ,
//execute stage output
output [2:0] ALUControlE ,
output PCSrcE ,  //input for datapath and hazard unit 
output ALUSrcAE , ALUSrcBE ,
output  ResultSrcEb0 ,
//memory stage output
output RegWriteM ,
output MemWriteM ,
//writeback stage output
output RegWriteW ,
output [1:0] ResultSrcW 
  );
  
  // pipelined control signals
wire        RegWriteD, RegWriteE;
wire [1:0]  ResultSrcD, ResultSrcE, ResultSrcM;
wire        MemWriteD, MemWriteE;
wire        JumpD, JumpE;
wire        BranchD, BranchE;
wire [1:0]  ALUOpD;
wire [2:0]  ALUControlD;
wire        ALUSrcAD;
wire        ALUSrcBD;  // for lui

//decode stage logic 
maindec m1 (opD,ResultSrcD,MemWriteD,BranchD,ALUSrcAD,ALUSrcBD,RegWriteD,JumpD,ImmSrcD,ALUOpD);
 aludec  a1 (ALUOpD,funct3D,opD[5],funct7b5D,ALUControlD); 
 
 //execute state logic
floprc #(11) exctrl (clk,reset,FlushE,{RegWriteD,ResultSrcD,MemWriteD, ALUControlD, JumpD,BranchD, ALUSrcAD , ALUSrcBD}
,{RegWriteE,ResultSrcE,MemWriteE, ALUControlE, JumpE,BranchE, ALUSrcAE , ALUSrcBE}) ;

assign PCSrcE = (BranchE & ZeroE) | JumpE ;
assign ResultSrcEb0=ResultSrcE[0] ;

//memory stage logic 

flopr #(4) memctrl(clk,reset,{ RegWriteE, ResultSrcE,MemWriteE}, {RegWriteM, ResultSrcM,MemWriteM}) ;

//WB stage logic 
flopr #(3) wbctrl(clk,reset,{RegWriteM , ResultSrcM}, {RegWriteW , ResultSrcW}) ;

endmodule
