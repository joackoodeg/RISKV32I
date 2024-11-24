module dataPath (
    input clk,
    input reset,
    input [31:0] instr,       // Instrucción desde la memoria de instrucciones
    input [31:0] readData,    // Datos leídos desde la memoria de datos
    output [31:0] pc,         // Contador de programa
    output [31:0] aluResult,  // Resultado de la ALU
    output [31:0] writeData,  // Datos a escribir en la memoria de datos
    output memWrite,          // Señal de escritura de memoria

    output [31:0] reg_x5,
    output [31:0] reg_x6,
    output [31:0] reg_x7,
    output [31:0] reg_x8,
    output [31:0] reg_x9,
    output [31:0] reg_x18

);

    // Señales internas
    wire [31:0] pcNext, pcPlus4, pcBranch;
    wire [31:0] immExt;
    wire [31:0] srcA, srcB, writeDataReg;
    wire [2:0] aluControl;
    wire [1:0] immSrc;
    wire aluSrc, regWrite, pcSrc, branch, resSrc;

    // Instancia del Contador de Programa
    PC pcReg (
        .clk(clk),
        .reset(reset),
        .pcNext(pcNext),
        .pc(pc)
    );

    // Suma PC + 4
    assign pcPlus4 = pc + 4;

    // Instancia del Banco de Registros
    BR regFile (
        .clk(clk),
        .a1(instr[19:15]),
        .a2(instr[24:20]),
        .a3(instr[11:7]),
        .wd3(writeDataReg),
        .we(regWrite),
        .rd1(srcA),
        .rd2(writeData),

        .reg_x5(reg_x5),
        .reg_x6(reg_x6),
        .reg_x7(reg_x7),
        .reg_x8(reg_x8),
        .reg_x9(reg_x9),
        .reg_x18(reg_x18)
    );

   // Instancia de la Extensión de Signo
    SE signExt (
        .instr(instr),
        .src(immSrc),
        .immExt(immExt)
    );

    // Multiplexor para seleccionar la entrada B de la ALU
    Mux2x1 muxALUSrc (
        .e1(writeData),
        .e2(immExt),
        .sel(aluSrc),
        .salMux(srcB)
    );

    // Instancia de la ALU
    ALU alu (
        .srcA(srcA),
        .srcB(srcB),
        .ALUControl(aluControl),
        .result(aluResult)
    );

    // Suma para calcular la dirección de salto
    assign pcBranch = pc + immExt;

    // Multiplexor para seleccionar la siguiente dirección del PC
    Mux2x1 muxPCSrc (
        .e1(pcPlus4),
        .e2(pcBranch),
        .sel(pcSrc),
        .salMux(pcNext)
    );

    // Multiplexor para seleccionar el dato a escribir en el registro
    Mux2x1 muxResSrc (
        .e1(aluResult),
        .e2(readData),
        .sel(resSrc),
        .salMux(writeDataReg)
    );

    // Instancia de la Unidad de Control
    UC controlUnit (
        .reset(reset),
        .op(instr[6:0]),
        .func3(instr[14:12]),
        .func7(instr[30]),
        .zero(aluResult == 0),
        .pcSrc(pcSrc),
        .branch(branch),
        .resSrc(resSrc),
        .memWrite(memWrite),
        .aluSrc(aluSrc),
        .regWrite(regWrite),
        .aluControl(aluControl),
        .immSrc(immSrc)
    );

endmodule

/*
module dataPath (
    input clk,
    input reset,
    input [31:0] instr,       // Instrucción desde la memoria de instrucciones
    input [31:0] readData,    // Datos leídos desde la memoria de datos
    output [31:0] pc,         // Contador de programa
    output [31:0] aluResult,  // Resultado de la ALU
    output [31:0] writeData,  // Datos a escribir en la memoria de datos
    output memWrite           // Señal de escritura de memoria
);

    // Señales internas
    wire [31:0] pcNext, pcPlus4, pcBranch;
    wire [31:0] immExt;
    wire [31:0] srcA, srcB, writeDataReg;
    wire [2:0] aluControl;
    wire [1:0] immSrc;
    wire aluSrc, regWrite, pcSrc, branch, resSrc;

    // Instancia del Contador de Programa
    PC pcReg (
        .clk(clk),
        .pcNext(pcNext),
        .pc(pc)
    );

    // Suma PC + 4
    assign pcPlus4 = pc + 4;

    // Instancia del Banco de Registros
    BR regFile (
        .clk(clk),
        .a1(instr[19:15]),
        .a2(instr[24:20]),
        .a3(instr[11:7]),
        .wd3(writeDataReg),
        .we(regWrite),
        .rd1(srcA),
        .rd2(writeData)
    );

    // Instancia de la Extensión de Signo
    SE signExt (
        .instr(instr),
        .src(immSrc),
        .immExt(immExt)
    );

    // Multiplexor para seleccionar la entrada B de la ALU
    Mux2x1 muxALUSrc (
        .e1(writeData),
        .e2(immExt),
        .sel(aluSrc),
        .salMux(srcB)
    );

    // Instancia de la ALU
    ALU alu (
        .srcA(srcA),
        .srcB(srcB),
        .ALUControl(aluControl),
        .result(aluResult)
    );

    // Suma para calcular la dirección de salto
    assign pcBranch = pc + immExt;

    // Multiplexor para seleccionar la siguiente dirección del PC
    Mux2x1 muxPCSrc (
        .e1(pcPlus4),
        .e2(pcBranch),
        .sel(pcSrc),
        .salMux(pcNext)
    );

    // Multiplexor para seleccionar el dato a escribir en el registro
    Mux2x1 muxResSrc (
        .e1(aluResult),
        .e2(readData),
        .sel(resSrc),
        .salMux(writeDataReg)
    );

    // Instancia de la Unidad de Control
    UC controlUnit (
        .op(instr[6:0]),
        .func3(instr[14:12]),
        .func7(instr[30]),
        .zero(aluResult == 0),
        .pcSrc(pcSrc),
        .branch(branch),
        .resSrc(resSrc),
        .memWrite(memWrite),
        .aluSrc(aluSrc),
        .regWrite(regWrite),
        .aluControl(aluControl),
        .immSrc(immSrc)
    );

endmodule
*/

/*
module dataPath (
    input clk,
    input reset,
    input [31:0] instr,       // Instrucción desde la memoria de instrucciones
    input [31:0] readData,    // Datos leídos desde la memoria de datos
    output [31:0] pc,         // Contador de programa
    output [31:0] aluResult,  // Resultado de la ALU
    output [31:0] writeData,  // Datos a escribir en la memoria de datos
    output memWrite           // Señal de escritura de memoria
);

    // Señales internas
    wire [31:0] pcNext, pcPlus4, pcBranch;
    wire [31:0] immExt;
    wire [31:0] srcA, srcB, writeDataReg;
    wire [2:0] aluControl;
    wire [1:0] immSrc;
    wire aluSrc, regWrite, pcSrc, branch, resSrc;

    // Instancia del Contador de Programa
    PC pcReg (
        .clk(clk),
        .pcNext(pcNext),
        .pc(pc)
    );

    // Suma PC + 4
    assign pcPlus4 = pc + 4;

    // Instancia del Banco de Registros
    BR regFile (
        .clk(clk),
        .a1(instr[19:15]),
        .a2(instr[24:20]),
        .a3(instr[11:7]),
        .wd3(writeDataReg),
        .we(regWrite),
        .rd1(srcA),
        .rd2(writeData)
    );

    // Instancia de la Extensión de Signo
    SE signExt (
        .instr(instr),
        .src(immSrc),
        .immExt(immExt)
    );

    // Multiplexor para seleccionar la entrada B de la ALU
    Mux2x1 muxALUSrc (
        .e1(writeData),
        .e2(immExt),
        .sel(aluSrc),
        .salMux(srcB)
    );

    // Instancia de la ALU
    ALU alu (
        .srcA(srcA),
        .srcB(srcB),
        .ALUControl(aluControl),
        .result(aluResult)
    );

    // Suma para calcular la dirección de salto
    assign pcBranch = pc + immExt;

    // Multiplexor para seleccionar la siguiente dirección del PC
    Mux2x1 muxPCSrc (
        .e1(pcPlus4),
        .e2(pcBranch),
        .sel(pcSrc),
        .salMux(pcNext)
    );

    // Multiplexor para seleccionar el dato a escribir en el registro
    Mux2x1 muxResSrc (
        .e1(aluResult),
        .e2(readData),
        .sel(resSrc),
        .salMux(writeDataReg)
    );

    // Instancia de la Unidad de Control
    UC controlUnit (
        .op(instr[6:0]),
        .func3(instr[14:12]),
        .func7(instr[30]),
        .zero(aluResult == 0),
        .pcSrc(pcSrc),
        .branch(branch),
        .resSrc(resSrc),
        .memWrite(memWrite),
        .aluSrc(aluSrc),
        .regWrite(regWrite),
        .aluControl(aluControl),
        .immSrc(immSrc)
    );

endmodule
*/