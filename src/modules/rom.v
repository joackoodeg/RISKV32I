module rom (
    input reset,
    input [4:0] address,
    output reg [31:0] data
);

    // Declaración de contenido de la memoria ROM
    reg [31:0] memory [0:31];

    // Inicialización de la memoria ROM
    initial begin
        memory[0] = 32'h00300413; // addi s0, zero, 3 # a = 3
        memory[1] = 32'h00100493; // addi s1, zero, 1 # b = 1
        memory[2] = 32'h01000913; // addi s2, zero, 16 # cte = 16
        memory[3] = 32'h009462b3; // or t0, s0, s1 # c = 3
        memory[4] = 32'h00947333; // and t1, s0, s1 # d = 1
        memory[5] = 32'h009403b3; // add t2, s0, s1 # e = 4
        memory[6] = 32'h40940e33; // sub t3, s0, s1 # f = 2
        memory[7] = 32'h40848eb3; // sub t4, s1, s0 # g = 0xfffffffe = -2
        memory[8] = 32'h00942f33; // slt t5, s0, s1 # h = 0
        memory[9] = 32'h0084afb3; // slt t6, s1, s0 # i = 1
        memory[10] = 32'h01d4afb3; // slt t6, s1, t4, # j = 0
        memory[11] = 32'h00100293; // addi t0, zero, 1 # var = 1, variable de trabajo
        memory[12] = 32'h00000313; // addi t1, zero, 0 # cuenta = 0, un contador
        memory[13] = 32'h01228863; // beq t0, s2, sal1 # si var == cte, sale del while
        memory[14] = 32'h005282b3; // add t0, t0, t0 # var = var + var
        memory[15] = 32'h00130313; // addi t1, t1, 1 # cuenta = cuenta + 1
        memory[16] = 32'hff5ff06f; // j while
        memory[17] = 32'h000004b3; // add s1, zero, zero # var = 0, $s0
        memory[18] = 32'h00000293; // addi t0, zero, 0 # indice = 0, $t0
        memory[19] = 32'h00a00313; // addi t1, zero, 10 # veces = 10, $t1
        memory[20] = 32'h00628863; // beq t0, t1, sal2 # if indice == veces, branch to done
        memory[21] = 32'h008484b3; // add s1, s1, s0 # var = var + cte
        memory[22] = 32'h00128293; // addi t0, t0, 1 # incremento indice
        memory[23] = 32'hff5ff06f; // j for
        memory[24] = 32'h00802023; // sw s0, 0(zero) # guarda $s0 en registro 0
        memory[25] = 32'h00902223; // sw s1, 4(zero) # guarda $s1 en registro 4
        memory[26] = 32'h01202423; // sw s2, 8(zero) # guarda $s2 en registro 8
        memory[27] = 32'h00002283; // lw t0, 0(zero) # lee registro 0 en $t0
        memory[28] = 32'h00402303; // lw t1, 4(zero) # lee registro 4 en $t1
        memory[29] = 32'h00802383; // lw t2, 8(zero) # lee registro 8 en $t2
        memory[30] = 32'h00000000;
        memory[31] = 32'h00000000;
    end

    // Proceso de lectura de la ROM
     always @(address or reset) begin
        if (!reset)  // Activo cuando reset = 0
            data = memory[address];
        else
            data = 32'h00000000;  // NOP cuando reset = 1
    end

endmodule

/*
module rom (
    input [4:0] address, // Entrada de dirección de 5 bits
    output reg [31:0] data // Salida de datos de 32 bits
);

    // Declaración de contenido de la memoria ROM
    reg [31:0] memory [0:31];

    // Inicialización de la memoria ROM
    initial begin
        memory[0] = 32'h00300413; // addi s0, zero, 3
        memory[1] = 32'h00100493; // addi s1, zero, 1
        memory[2] = 32'h01000913; // addi s2, zero, 16
        memory[3] = 32'h009462b3; // or t0, s0, s1
        memory[4] = 32'h00947333; // and t1, s0, s1
        memory[5] = 32'h009403b3; // add t2, s0, s1
        memory[6] = 32'h40940e33; // sub t3, s0, s1
        memory[7] = 32'h40848eb3; // sub t4, s1, s0
        memory[8] = 32'h001484b3; // slt t5, s0, s1
        memory[9] = 32'h001494b3; // slt t6, s1, s0
        memory[10] = 32'hfe1494b3; // slt t6, s1, t4
        memory[11] = 32'h00100093; // addi t0, zero, 1
        memory[12] = 32'h00000113; // addi t1, zero, 0
        memory[13] = 32'h01228863; // beq t0, s2, sal1
        memory[14] = 32'h002000b3; // add t0, t0, t0
        memory[15] = 32'h00108093; // addi t1, t1, 1
        memory[16] = 32'hff5ff06f; // j while
        memory[17] = 32'h00000000; // sal1:
        memory[18] = 32'h00000093; // addi t0, zero, 0
        memory[19] = 32'h00a00113; // addi t1, zero, 10
        memory[20] = 32'h00628863; // beq t0, t1, sal2
        memory[21] = 32'h003081b3; // add s1, s1, s0
        memory[22] = 32'h00108093; // addi t0, t0, 1
        memory[23] = 32'hff5ff06f; // j for
        memory[24] = 32'h00000000; // sal2:
        memory[25] = 32'h00302023; // sw s0, 0(zero)
        memory[26] = 32'h00302223; // sw s1, 4(zero)
        memory[27] = 32'h00302423; // sw s2, 8(zero)
        memory[28] = 32'h00002003; // lw t0, 0(zero)
        memory[29] = 32'h00402083; // lw t1, 4(zero)
        memory[30] = 32'h00802103; // lw t2, 8(zero)
        memory[31] = 32'h00000000; // NOP
    end

    // Proceso de lectura de la ROM
    always @ (address) begin
        data <= memory[address]; // Leer datos de la dirección de entrada
    end

endmodule
*/