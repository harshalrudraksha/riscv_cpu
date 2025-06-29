`timescale 1ns / 1ps
module flopenrc #(parameter WIDTH = 8) (
    input clk,
    input reset,
    input clear,
    input en,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 0;
        else if (en) begin
            if (clear)
                q <= 0;
            else
                q <= d;
        end
    end

endmodule
