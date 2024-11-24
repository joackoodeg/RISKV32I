module Adder (
    input [31:0] op1,  // Primer operando
    input [31:0] op2,  // Segundo operando
    output [31:0] res  // Resultado de la suma
);

    assign res = op1 + op2; // Realiza la suma de op1 y op2

endmodule

//CHECK 