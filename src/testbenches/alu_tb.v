`default_nettype none
`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module ALU_tb;

    reg [31:0] srcA;
    reg [31:0] srcB;
    reg [2:0] ALUControl;
    wire [31:0] result;

    // Instanciar la ALU
    ALU uut (
        .srcA(srcA),
        .srcB(srcB),
        .ALUControl(ALUControl),
        .result(result)
    );

    initial begin
        $dumpfile(`DUMPSTR(`VCD_OUTPUT));
        $dumpvars(0, ALU_tb);
        // Prueba de suma
        srcA = 32'd10;
        srcB = 32'd5;
        ALUControl = 3'b000; // Suma
        #10;
        
        // Prueba de resta
        ALUControl = 3'b001; // Resta
        #10;
        
        // Prueba de AND
        ALUControl = 3'b010; // AND
        #10;
        
        // Prueba de OR
        ALUControl = 3'b011; // OR
        #10;
        
        // Prueba de SLT (Set Less Than)
        srcA = 32'd5;
        srcB = 32'd10;
        ALUControl = 3'b101; // SLT
        #10;

        // Fin de la simulación
        $finish;
    end

endmodule
