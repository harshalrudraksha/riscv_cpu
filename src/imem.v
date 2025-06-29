`timescale 1ns / 1ps

module imem(
input [31:0]a,
output[31:0] rd
    );
    reg [31:0]RAM[0:63];
   initial $readmemh("rvpfinal.hex",RAM);
    assign rd=RAM[a[31:2]];
    
    endmodule
 