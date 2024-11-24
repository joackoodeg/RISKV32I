module Mux2x1 (
    input [31:0] e1,    // Primera entrada
    input [31:0] e2,    // Segunda entrada
    input sel,          // Señal de selección
    output [31:0] salMux // Salida seleccionada
);

    assign salMux = sel ? e2 : e1; // Si sel es 1, selecciona e2, de lo contrario selecciona e1

endmodule
/*
module Mux2x1 (
    input [31:0] e1,    // Primera entrada
    input [31:0] e2,    // Segunda entrada
    input sel,          // Señal de selección
    output [31:0] salMux // Salida seleccionada
);

    assign salMux = sel ? e2 : e1; // Si sel es 1, selecciona e2, de lo contrario selecciona e1

endmodule
*/
//Multiplexor 2x1 de 32 bits