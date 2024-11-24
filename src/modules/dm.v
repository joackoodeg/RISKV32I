module DM #(
    parameter N = 32  // Ancho de los datos
)(
    input clk,                  // Reloj
    input [4:0] addressDM,      // Dirección de memoria (5 bits para 32 direcciones)
    input [N-1:0] wd,           // Datos a escribir
    input we,                   // Señal de escritura habilitada
    output [N-1:0] rd           // Datos leídos
);

    // Memoria de 32 registros de N bits
    reg [N-1:0] mem [31:0];  

    // Inicialización opcional de la memoria a 0
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            mem[i] = {N{1'b0}};  // Cada posición se inicializa a 0
        end
    end

    // Lectura: Asignación directa del dato en la dirección especificada
    assign rd = mem[addressDM];

    // Escritura sincrónica: Solo si we está habilitado
    always @(posedge clk) begin
        if (we) begin
            mem[addressDM] <= wd;
        end
    end
endmodule

//ACT : Inicializacion de memoria


/*
Memoria de datos: es la región de la memoria del sistema donde se alojan los datos
utilizados por el programa (datos dinamicos y estaticos, pila)

Sus entradas son la dirección de memoria accedida (A), los datos que se escriben (WD), la
señal de escritura (WE) y el reloj del sistema (CLK), la salida es la información (RD) que se
halla en dicha dirección. Las señales RD, WD y A tienen 32 bits de ancho.
*/