`default_nettype none
`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

`include "../src/modules/im.v"

module IM_tb;

    //-- Simulation time: 1us (10 * 100ns)
    parameter DURATION = 10;

    //-- Clock signal. It is not used in this simulation
    reg clk = 0;
    always #0.5 clk = ~clk;

    reg [4:0] addressIM;
    wire [31:0] inst;

    IM uut (
        .addressIM(addressIM),
        .inst(inst)
    );

    initial begin
        $dumpfile(`DUMPSTR(`VCD_OUTPUT));
        $dumpvars(0, IM_tb);
        
        addressIM = 5'd0;
        #10 addressIM = 5'd1;
        #10 addressIM = 5'd2;
          
        #(DURATION) $display("End of simulation");
        $finish;
    end
endmodule
