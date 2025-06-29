`timescale 1ns / 1ps

module testbench;

    reg clk;
    reg reset;

    reg [31:0] WriteData;
    reg [31:0] DataAdr;
    reg MemWrite;

    // Wires for DUT outputs
    wire [31:0] w_WriteData, w_DataAdr;
    wire w_MemWrite;

    // Instantiate the device under test
    top dut (
        .clk(clk),
        .reset(reset),
        .WriteDataM(w_WriteData),
        .ALUResultM(w_DataAdr),
        .MemWriteM(w_MemWrite)
    );

    // Assign outputs to local testbench signals
    always @(*) begin
        WriteData = w_WriteData;
        DataAdr   = w_DataAdr;
        MemWrite  = w_MemWrite;
    end

    // Initialize test
    initial begin
        reset = 1;
        #22;
        reset = 0;
    end

    // Generate clock to sequence tests
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    // Check results on negative clock edge
    always @(negedge clk) begin
        if (MemWrite) begin
            if (DataAdr == 32'd132 && WriteData == 32'hABCDE02E) begin
                $display("Simulation succeeded");
                $stop;
            end
        end
    end

endmodule
