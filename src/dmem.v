`timescale 1ns / 1ps

module dmem(input  clk, we,
 input  [31:0] a, wd,    //address of data , data to be written
 output  [31:0] rd);     // data read
  reg[31:0] RAM[63:0];
initial $readmemh("rvtest.hex",RAM);
 assign rd = RAM[a[31:2]]; // word aligned
 always @(posedge clk)
 if (we) RAM[a[31:2]] <= wd;
endmodule