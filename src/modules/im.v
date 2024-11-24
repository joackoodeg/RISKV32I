module IM #(parameter N = 32) (
    input [4:0] addressIM,
    output [N-1:0] inst
);
    reg [N-1:0] mem [31:0]; // 32 registros de 32 bits

    initial begin
        //$readmemb("instructions.mem", mem); // Carga instrucciones desde un archivo
    end

    assign inst = mem[addressIM];
endmodule


/*
Memoria de programa: es la región de la memoria del sistema donde se
aloja el programa que se está ejecutando.

Sus entradas son la dirección de memoria accedida (A) y la salida es la
información (RD) que se halla en dicha dirección, la cual puede ser una
instrucción o un dato. Supondremos que todas las señales son de 32 bits
de ancho.

En esta implementacion suponemos que la memoria de programa es de
solo lectura (ROM)
*/

