`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2025 19:50:26
// Design Name: 
// Module Name: top
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


 
module top(input          clk, reset,  
           output  [31:0] WriteDataM, ALUResultM,  //ALUResultM is also data address for memory
           output        MemWriteM); 
 
  wire [31:0] PCF, InstrF, ReadDataM; 
  
  riscv mp(clk,reset, InstrF ,ReadDataM ,PCF ,ALUResultM ,WriteDataM,MemWriteM ) ;
  imem memi(PCF , InstrF) ;
  dmem memd (clk,MemWriteM ,ALUResultM,WriteDataM,ReadDataM) ;
  
  endmodule
  