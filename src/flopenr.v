`timescale 1ns / 1ps

module flopenr#(parameter WIDTH =4)(
input clock,reset,en,
input [WIDTH-1:0] d,
output reg [WIDTH-1:0] q
    );
    
    always @(posedge clock, posedge reset) begin 
    if(reset) q<=0;
    else if(en) q<=d;
    end
    
endmodule
