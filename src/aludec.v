`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.06.2025 04:59:02
// Design Name: 
// Module Name: aludec
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


module aludec(
input [1:0] ALUOp ,
input [2:0] funct3 ,
input opb5 , funct7b5 ,
output reg [2:0] ALUControl 
);

wire RtypeSub; 
  assign RtypeSub = funct7b5 & opb5;  // TRUE for R-type subtract instruction
 
  always @(*) begin
    case(ALUOp) 
      2'b00:                ALUControl = 3'b000; // addition 
      2'b01:                ALUControl = 3'b001; // subtraction 
      default: case(funct3) // R-type or I-type ALU 
                 3'b000:  if (RtypeSub)  
                            ALUControl = 3'b001; // sub 
                          else           
                            ALUControl = 3'b000; // add, addi 
                 3'b010:    ALUControl = 3'b101; // slt, slti 
                 3'b100:    ALUControl = 3'b100; // xor 
                 3'b110:    ALUControl = 3'b011; // or, ori 
                 3'b111:    ALUControl = 3'b010; // and, andi 
                 default:   ALUControl = 3'bxxx; // ??? 
               endcase
                endcase 
    end 
endmodule 

