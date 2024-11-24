`default_nettype none
`timescale 100 ns / 10 ns

module mainDeco_tb;

    // Entradas
    reg [6:0] op;

    // Salidas
    wire branch;
    wire resSrc;
    wire memWrite;
    wire aluSrc;
    wire regWrite;
    wire [1:0] immSrc;
    wire [1:0] aluOp;

    // Instancia del módulo a probar
    mainDeco uut (
        .op(op),
        .branch(branch),
        .resSrc(resSrc),
        .memWrite(memWrite),
        .aluSrc(aluSrc),
        .regWrite(regWrite),
        .immSrc(immSrc),
        .aluOp(aluOp)
    );

    // Procedimiento inicial para realizar las pruebas
    initial begin
        $dumpfile("mainDeco_tb.vcd");
        $dumpvars(0, mainDeco_tb);
        // Test 1: lw (load word)
        op = 7'b0000011;
        #10;
        $display("Test lw: branch=%b, resSrc=%b, memWrite=%b, aluSrc=%b, regWrite=%b, immSrc=%b, aluOp=%b", branch, resSrc, memWrite, aluSrc, regWrite, immSrc, aluOp);

        // Test 2: sw (store word)
        op = 7'b0100011;
        #10;
        $display("Test sw: branch=%b, resSrc=%b, memWrite=%b, aluSrc=%b, regWrite=%b, immSrc=%b, aluOp=%b", branch, resSrc, memWrite, aluSrc, regWrite, immSrc, aluOp);

        // Test 3: R-type
        op = 7'b0110011;
        #10;
        $display("Test R-type: branch=%b, resSrc=%b, memWrite=%b, aluSrc=%b, regWrite=%b, immSrc=%b, aluOp=%b", branch, resSrc, memWrite, aluSrc, regWrite, immSrc, aluOp);

        // Test 4: beq (branch if equal)
        op = 7'b1100011;
        #10;
        $display("Test beq: branch=%b, resSrc=%b, memWrite=%b, aluSrc=%b, regWrite=%b, immSrc=%b, aluOp=%b", branch, resSrc, memWrite, aluSrc, regWrite, immSrc, aluOp);

        // Test 5: Default (opcode desconocido)
        op = 7'b1111111;
        #10;
        $display("Test default: branch=%b, resSrc=%b, memWrite=%b, aluSrc=%b, regWrite=%b, immSrc=%b, aluOp=%b", branch, resSrc, memWrite, aluSrc, regWrite, immSrc, aluOp);

        // Finalizar simulación
        $finish;
    end

endmodule
