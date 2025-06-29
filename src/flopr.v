

`timescale 1ns / 1ps

module flopr#(parameter WIDTH =4)(
input clock,reset,
input [WIDTH-1:0] d,
output reg [WIDTH-1:0] q
    );
    
    always @(posedge clock, posedge reset) begin 
    if(reset) q<=0;
    else q<=d;
    end
    
endmodule
