`default_nettype none
`timescale 100 ns / 10 ns


module aluDeco_tb;

    // Entradas
    reg [1:0] aluOp;
    reg [2:0] func3;
    reg func7;

    // Salidas
    wire [2:0] aluControl;

    // Instancia del módulo a probar
    aluDeco uut (
        .aluOp(aluOp),
        .func3(func3),
        .func7(func7),
        .aluControl(aluControl)
    );

    // Procedimiento inicial para realizar las pruebas
    initial begin
        $dumpfile("aluDeco_tb.vcd");
        $dumpvars(0, aluDeco_tb);
        // Test 1: lw/sw (add)
        aluOp = 2'b00;
        func3 = 3'b000;
        func7 = 1'b0;
        #10;
        $display("Test lw/sw: aluControl=%b (esperado 000)", aluControl);

        // Test 2: beq (subtract)
        aluOp = 2'b01;
        func3 = 3'b000;
        func7 = 1'b0;
        #10;
        $display("Test beq: aluControl=%b (esperado 001)", aluControl);

        // Test 3: R-type add (add/sub)
        aluOp = 2'b10;
        func3 = 3'b000;
        func7 = 1'b0; // add
        #10;
        $display("Test R-type add: aluControl=%b (esperado 000)", aluControl);

        // Test 4: R-type sub (add/sub)
        aluOp = 2'b10;
        func3 = 3'b000;
        func7 = 1'b1; // sub
        #10;
        $display("Test R-type sub: aluControl=%b (esperado 001)", aluControl);

        // Test 5: R-type slt (set less than)
        aluOp = 2'b10;
        func3 = 3'b010;
        func7 = 1'b0;
        #10;
        $display("Test R-type slt: aluControl=%b (esperado 101)", aluControl);

        // Test 6: R-type or
        aluOp = 2'b10;
        func3 = 3'b110;
        func7 = 1'b0;
        #10;
        $display("Test R-type or: aluControl=%b (esperado 011)", aluControl);

        // Test 7: R-type and
        aluOp = 2'b10;
        func3 = 3'b111;
        func7 = 1'b0;
        #10;
        $display("Test R-type and: aluControl=%b (esperado 010)", aluControl);

        // Test 8: Default case
        aluOp = 2'b11;
        func3 = 3'b000;
        func7 = 1'b0;
        #10;
        $display("Test default: aluControl=%b (esperado 000)", aluControl);

        // Finalizar simulación
        $finish;
    end

endmodule
