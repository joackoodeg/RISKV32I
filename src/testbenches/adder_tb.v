`timescale 1ns / 1ps

`include "../src/modules/adder.v"

module Adder_tb;

    reg [31:0] op1;  // Primer operando
    reg [31:0] op2;  // Segundo operando
    wire [31:0] res; // Resultado de la suma

    // Instanciar el módulo Adder
    Adder uut (
        .op1(op1),
        .op2(op2),
        .res(res)
    );

    initial begin
        // Pruebas de suma
        op1 = 32'h00000001; // 1
        op2 = 32'h00000002; // 2
        #10;
        
        op1 = 32'hFFFFFFFF; // -1
        op2 = 32'h00000001; // 1
        #10;

        op1 = 32'h7FFFFFFF; // Maximo positivo
        op2 = 32'h00000001; // 1
        #10;

        // Fin de la simulación
        $finish;
    end

endmodule
