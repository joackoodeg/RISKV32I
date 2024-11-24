`default_nettype none
`timescale 100 ns / 10 ns

module DM_tb;
    reg clk;
    reg [4:0] addressDM;
    reg [31:0] wd;
    reg we;
    wire [31:0] rd;

    DM uut (
        .clk(clk),
        .addressDM(addressDM),
        .wd(wd),
        .we(we),
        .rd(rd)
    );

    initial begin
        $dumpfile("DM_tb.vcd");
        $dumpvars(0, DM_tb);
        clk = 0;
        we = 0;
        addressDM = 5'd0;
        wd = 32'h00000000;

        #10 we = 1; addressDM = 5'd0; wd = 32'hA5A5A5A5; // Escritura
        #10 we = 0; addressDM = 5'd0;                    // Lectura
        #10 $display("Valor leido en rd: %h", rd);       // Verificación de lectura
        #10 $stop;
    end

    always #5 clk = ~clk;
endmodule
