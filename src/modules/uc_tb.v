`default_nettype none
`timescale 100 ns / 10 ns

module UC_tb;

    // Entradas
    reg [6:0] op;
    reg [2:0] func3;
    reg func7;
    reg zero;

    // Salidas
    wire pcSrc;
    wire branch;
    wire resSrc;
    wire memWrite;
    wire aluSrc;
    wire regWrite;
    wire [2:0] aluControl;
    wire [1:0] immSrc;

    // Instancia del módulo UC
    UC uut (
        .op(op),
        .func3(func3),
        .func7(func7),
        .zero(zero),
        .pcSrc(pcSrc),
        .branch(branch),
        .resSrc(resSrc),
        .memWrite(memWrite),
        .aluSrc(aluSrc),
        .regWrite(regWrite),
        .aluControl(aluControl),
        .immSrc(immSrc)
    );

    // Procedimiento inicial para realizar las pruebas
    initial begin
        $dumpfile("UC_tb.vcd");
        $dumpvars(0, UC_tb);
        // Test 1: Instrucción lw (load word)
        op = 7'b0000011;
        func3 = 3'b000;
        func7 = 1'b0;
        zero = 1'b0;
        #10;
        $display("Test lw: pcSrc=%b, branch=%b, resSrc=%b, memWrite=%b, aluSrc=%b, regWrite=%b, aluControl=%b, immSrc=%b",
                 pcSrc, branch, resSrc, memWrite, aluSrc, regWrite, aluControl, immSrc);

        // Test 2: Instrucción sw (store word) 
        op = 7'b0100011;
        func3 = 3'b000;
        func7 = 1'b0;
        zero = 1'b0;
        #10;
        $display("Test sw: pcSrc=%b, branch=%b, resSrc=%b, memWrite=%b, aluSrc=%b, regWrite=%b, aluControl=%b, immSrc=%b",
                 pcSrc, branch, resSrc, memWrite, aluSrc, regWrite, aluControl, immSrc);

        // Test 3: Instrucción beq (branch if equal) con zero = 1
        op = 7'b1100011;
        func3 = 3'b000;
        func7 = 1'b0;
        zero = 1'b1;
        #10;
        $display("Test beq (zero=1): pcSrc=%b, branch=%b, resSrc=%b, memWrite=%b, aluSrc=%b, regWrite=%b, aluControl=%b, immSrc=%b",
                 pcSrc, branch, resSrc, memWrite, aluSrc, regWrite, aluControl, immSrc);

        // Test 4: Instrucción R-type (add)
        op = 7'b0110011;
        func3 = 3'b000;
        func7 = 1'b0;
        zero = 1'b0;
        #10;
        $display("Test R-type add: pcSrc=%b, branch=%b, resSrc=%b, memWrite=%b, aluSrc=%b, regWrite=%b, aluControl=%b, immSrc=%b",
                 pcSrc, branch, resSrc, memWrite, aluSrc, regWrite, aluControl, immSrc);

        // Test 5: Instrucción R-type (sub)
        op = 7'b0110011;
        func3 = 3'b000;
        func7 = 1'b1;
        zero = 1'b0;
        #10;
        $display("Test R-type sub: pcSrc=%b, branch=%b, resSrc=%b, memWrite=%b, aluSrc=%b, regWrite=%b, aluControl=%b, immSrc=%b",
                 pcSrc, branch, resSrc, memWrite, aluSrc, regWrite, aluControl, immSrc);

        // Test 6: Instrucción R-type (and)
        op = 7'b0110011;
        func3 = 3'b111;
        func7 = 1'b0;
        zero = 1'b0;
        #10;
        $display("Test R-type and: pcSrc=%b, branch=%b, resSrc=%b, memWrite=%b, aluSrc=%b, regWrite=%b, aluControl=%b, immSrc=%b",
                 pcSrc, branch, resSrc, memWrite, aluSrc, regWrite, aluControl, immSrc);

        // Test 7: Instrucción R-type (or)
        op = 7'b0110011;
        func3 = 3'b110;
        func7 = 1'b0;
        zero = 1'b0;
        #10;
        $display("Test R-type or: pcSrc=%b, branch=%b, resSrc=%b, memWrite=%b, aluSrc=%b, regWrite=%b, aluControl=%b, immSrc=%b",
                 pcSrc, branch, resSrc, memWrite, aluSrc, regWrite, aluControl, immSrc);

        // Finalizar simulación
        $finish;
    end

endmodule
