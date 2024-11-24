`timescale 1ns / 1ps

`include "../src/modules/se.v"

module SE_tb;

    reg [24:0] inm;         // Entrada del inmediato
    reg [2:0] src;         // Selección del tipo de instrucción
    wire [31:0] inmExt;    // Salida extendida

    // Instancia del módulo SE
    SE uut (
        .inm(inm),
        .src(src),
        .inmExt(inmExt)
    );

    initial begin
        // Tipo I
        inm = 25'b1111111111111111111111111; // Ejemplo de inmediato
        src = 3'b000; // Tipo I
        #10;
        $display("Tipo I: inmExt = %h", inmExt);

        // Tipo S
        inm = 25'b0000000000000000000000010; // Ejemplo de inmediato
        src = 3'b001; // Tipo S
        #10;
        $display("Tipo S: inmExt = %h", inmExt);

        // Tipo B
        inm = 25'b0000000000000000000000111; // Ejemplo de inmediato
        src = 3'b010; // Tipo B
        #10;
        $display("Tipo B: inmExt = %h", inmExt);

        // Tipo U
        inm = 25'b0000000000000000000000001; // Ejemplo de inmediato
        src = 3'b011; // Tipo U
        #10;
        $display("Tipo U: inmExt = %h", inmExt);

        // Tipo J
        inm = 25'b0000000000000000000000001; // Ejemplo de inmediato
        src = 3'b100; // Tipo J
        #10;
        $display("Tipo J: inmExt = %h", inmExt);

        // Finalizar la simulación
        #10;
        $finish;
    end

endmodule
