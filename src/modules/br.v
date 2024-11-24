module BR #(parameter N = 32) (
    input clk,
    input [4:0] a1, a2, a3,    // Register addresses
    input [N-1:0] wd3,         // Write data
    input we,                   // Write enable
    output [N-1:0] rd1, rd2,    // Read data outputs

      // Add debug outputs
    output [N-1:0] reg_x5,
    output [N-1:0] reg_x6,
    output [N-1:0] reg_x7,
    output [N-1:0] reg_x8,
    output [N-1:0] reg_x9,
    output [N-1:0] reg_x18
);

    reg [N-1:0] regFile [0:31]; // 32 registers of N bits each
    
    // Assign debug outputs directly
    assign reg_x5 = regFile[5];
    assign reg_x6 = regFile[6];
    assign reg_x7 = regFile[7];
    assign reg_x8 = regFile[8];
    assign reg_x9 = regFile[9];
    assign reg_x18 = regFile[18];
    
    integer i;
    // Initialize all registers to 0
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            regFile[i] = {N{1'b0}};
        end
    end

    // Read operations (asynchronous)
    assign rd1 = regFile[a1];
    assign rd2 = regFile[a2];

    // Write operation (synchronous)
    always @(posedge clk) begin
        if (we && a3 != 0) begin  // x0 is hardwired to 0
            regFile[a3] <= wd3;
        end
    end

endmodule
/*
module BR #(parameter N = 32) (
    input clk,
    input [4:0] a1, a2, a3,
    input [N-1:0] wd3,
    input we,
    output [N-1:0] rd1, rd2
);
//Posiblemente: inicializar en 0 regFile
    reg [N-1:0] regFile [31:0]; // 32 registros de 32 bits

    assign rd1 = regFile[a1];
    assign rd2 = regFile[a2];

    always @(posedge clk) begin
        if (we) begin
            regFile[a3] <= wd3;
        end
    end
endmodule
*/

/*
Banco de registros: El banco de registro contiene todos los registros y tiene dos
puertos de lectura y uno de escritura. El banco genera el contenido de los registros
correspondientes a la entradas de lectura (A1, A2) en las salidas (RD1, RD2). Una
escritura debe indicarse explícitamente mediante la señal de control de escritura.

Como las escrituras se activan por flancos, se puede leer y escribir el mismo registro
dentro de un ciclo de reloj: la lectura obtendrá el valor escrito en el
ciclo anterior, mientras que el valor escrito estará disponible para
una lectura en el ciclo posterior.

Las entradas que seleccionan los registros (A1, A2 y A3) tienen 5 bits de ancho,
mientras que las líneas que llevan los datos (RD1, RD2 y WD3) tienen 32 bits de ancho.
*/