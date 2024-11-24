`default_nettype none
`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

`include "../src/modules/pc.v"

module PC_tb;

    //-- Simulation time: 1us (10 * 100ns)
    parameter DURATION = 10;

    //-- Clock signal. It is not used in this simulation
    reg clk = 0;
    always #0.5 clk = ~clk;

    reg [31:0] pcNext;
    wire [31:0] pc;

    PC uut (
        .clk(clk),
        .pcNext(pcNext),
        .pc(pc)
    );

    initial begin
        $dumpfile(`DUMPSTR(`VCD_OUTPUT));
        $dumpvars(0, PC_tb);

        clk = 0;
        pcNext = 32'h00000000; // Inicializamos pcNext
        #10;
        pcNext = 32'h00000004;
        #10;
        pcNext = 32'h00000008;
        #10;
        
        #(DURATION) $display("End of simulation");
        $finish;
    end

endmodule
