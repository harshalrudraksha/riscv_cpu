`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.06.2025 04:16:31
// Design Name: 
// Module Name: maindec
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


module maindec(
    input [6:0] op,
    output [1:0] ResultSrc,
    output MemWrite,
    output Branch,
    output ALUSrcA,         // for lui
    output ALUSrcB,
    output RegWrite,
    output Jump,
    output [2:0] ImmSrc,
    output [1:0] ALUOp
);

    reg [12:0] controls;

    assign {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite,
            ResultSrc, Branch, ALUOp, Jump} = controls;

    always @(*) begin
        case (op)
            7'b0000011: controls = 13'b1_000_0_1_0_01_0_00_0; // lw 
      7'b0100011: controls = 13'b0_001_0_1_1_xx_0_00_0; // sw 
      7'b0110011: controls = 13'b1_xxx_0_0_0_00_0_10_0; // R-type  
      7'b1100011: controls = 13'b0_010_0_0_0_xx_1_01_0; // beq 
      7'b0010011: controls = 13'b1_000_0_1_0_00_0_10_0; // I-type ALU 
      7'b1101111: controls = 13'b1_011_0_0_0_10_0_00_1; // jal 
      7'b0110111: controls = 13'b1_100_1_1_0_00_0_00_0; // lui 
      7'b0000000: controls = 13'b0_000_0_0_0_00_0_00_0; // for nop and reset instr
      default: controls = 13'bx_xxx_x_x_x_xx_x_xx_x; // non-implemented  
                                                        // instruction 
        endcase   // few dont cares are replaced by zeroes
    end
    
    

endmodule

