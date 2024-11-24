`include "../src/modules/br.v"

module tb_BR;
    reg clk;
    reg [4:0] a1, a2, a3;
    reg [31:0] wd3;
    reg we;
    wire [31:0] rd1, rd2;

    BR uut (
        .clk(clk),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .wd3(wd3),
        .we(we),
        .rd1(rd1),
        .rd2(rd2)
    );

    initial begin
        clk = 0;
        we = 0;
        a1 = 5'd1;
        a2 = 5'd2;
        a3 = 5'd1;
        wd3 = 32'h0000000A;
        #10 we = 1; // Habilita la escritura
        #10 we = 0; a1 = 5'd1; // Lee el registro 1
        #10 a2 = 5'd2;
        #10 $stop;
    end

    always #5 clk = ~clk;
endmodule
