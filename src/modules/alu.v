module ALU (
    input [31:0] srcA,      // Primer operando de 32 bits
    input [31:0] srcB,      // Segundo operando de 32 bits
    input [2:0] ALUControl, // Señal de control de 3 bits
    output reg [31:0] result // Resultado de la operación
);

    always @(*) begin
        case (ALUControl)
            3'b000: result = srcA + srcB;      // Suma
            3'b001: result = srcA - srcB;      // Resta
            3'b010: result = srcA & srcB;      // AND
            3'b011: result = srcA | srcB;      // OR
            3'b101: result = (srcA < srcB) ? 32'b1 : 32'b0; // Set Less Than (SLT)
            default: result = 32'b0;           // Default en caso de error
        endcase
    end

endmodule

/*
Explicación:

    Entradas:
        srcA y srcB: Son los operandos de 32 bits sobre los que se realizan las operaciones.
        ALUControl: Señal que controla qué operación realiza la ALU, según la tabla de verdad (suma, resta, AND, OR, SLT).
    Operaciones:
        Suma (ALUControl = 000): Se realiza una suma de los dos operandos.
        Resta (ALUControl = 001): Se resta srcB de srcA.
        AND (ALUControl = 010): Se realiza la operación lógica AND bit a bit entre srcA y srcB.
        OR (ALUControl = 011): Se realiza la operación lógica OR bit a bit entre srcA y srcB.
        SLT (ALUControl = 101): Si srcA es menor que srcB, el resultado es 1, de lo contrario, 0.

Consideraciones adicionales:

    SLT: La operación SLT es una comparación para ver si srcA es menor que srcB. Devuelve 1 si es cierto, o 0 en caso contrario.
    Si necesito más operaciones o un comportamiento distinto para el default, deberia ajustar el código.
*/

/*
    Entradas:
        srcA(32): Primer operando de 32 bits.
        srcB(32): Segundo operando de 32 bits.
        ALUControl(3): Señal de control de 3 bits que selecciona la operación a realizar.
    Salidas:
        result(32): Resultado de la operación de 32 bits.

    Tabla de verdad (según la imagen):
        ALUControl (2:0)	Función
        000	                add
        001	                subtract
        010	                and
        011	                or
        101	                SLT
*/
