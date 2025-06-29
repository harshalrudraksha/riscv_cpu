module regfile (
    input         clk,             // Clock
    input         we3,             // Write enable signal
    input  [4:0]  ra1, ra2, wa3,   // Read addresses (ra1, ra2), Write address (wa3)
    input  [31:0] wd3,             // Write data of 32 bits
    output [31:0] rd1, rd2         // Read data outputs
);

    // Register array: 32 registers of 32 bits
    reg [31:0] rf[31:0];

    // Initialize register file from HEX file at simulation start
    initial begin
        $readmemh("regfile.hex", rf);
    end

    // Combinational read ports
    assign rd1 = (ra1 == 5'd0) ? 32'b0 : rf[ra1];
    assign rd2 = (ra2 == 5'd0) ? 32'b0 : rf[ra2];

    // Synchronous write port (ignores x0)
    always @(negedge clk) begin
        if (we3 && (wa3 != 5'd0)) begin
            rf[wa3] <= wd3;
        end
    end

endmodule
