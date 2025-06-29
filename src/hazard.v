`timescale 1ns / 1ps
module hazard(
    input  [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,
    input        PCSrcE, ResultSrcEb0,
    input        RegWriteM, RegWriteW,
    output [1:0] ForwardAE, ForwardBE,
    output       StallF, StallD, FlushD, FlushE
);

    wire lwStallD;
    reg  [1:0] ForwardAE_reg, ForwardBE_reg;

    assign ForwardAE = ForwardAE_reg;
    assign ForwardBE = ForwardBE_reg;

    // forwarding logic
    always @(*) begin
        ForwardAE_reg = 2'b00;
        ForwardBE_reg = 2'b00;

        if (Rs1E != 5'b0) begin
            if ((Rs1E == RdM) && RegWriteM)
                ForwardAE_reg = 2'b10;
            else if ((Rs1E == RdW) && RegWriteW)
                ForwardAE_reg = 2'b01;
        end

        if (Rs2E != 5'b0) begin
            if ((Rs2E == RdM) && RegWriteM)
                ForwardBE_reg = 2'b10;
            else if ((Rs2E == RdW) && RegWriteW)
                ForwardBE_reg = 2'b01;
        end
    end

    // stalls and flushes
    assign lwStallD = ResultSrcEb0 & ((Rs1D == RdE) | (Rs2D == RdE));
    assign StallD   = lwStallD;
    assign StallF   = lwStallD;
    assign FlushD   = PCSrcE;
    assign FlushE   = lwStallD | PCSrcE;

endmodule
