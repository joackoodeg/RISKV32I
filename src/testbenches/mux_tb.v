`timescale 1ns / 1ps

`include "../src/modules/mux2x1.v"

module Mux2x1_tb;

    reg [31:0] e1;      // Primera entrada
    reg [31:0] e2;      // Segunda entrada
    reg sel;            // Señal de selección
    wire [31:0] salMux; // Salida seleccionada

    // Instanciar el módulo Mux2x1
    Mux2x1 uut (
        .e1(e1),
        .e2(e2),
        .sel(sel),
        .salMux(salMux)
    );

    initial begin
        // Pruebas del multiplexor
        e1 = 32'h00000001; // Entrada 1
        e2 = 32'h00000002; // Entrada 2
        
        sel = 0; // Selecciona e1
        #10;
        
        sel = 1; // Selecciona e2
        #10;

        // Fin de la simulación
        $finish;
    end

endmodule
