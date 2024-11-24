module rv32i_tb;
    reg clk;
    reg reset;
    wire [31:0] pc;
    wire [31:0] aluResult;
    wire [31:0] writeData;
    wire memWrite;
    wire [31:0] reg_x5;
    wire [31:0] reg_x6;
    wire [31:0] reg_x7;
    wire [31:0] reg_x8;
    wire [31:0] reg_x9;
    wire [31:0] reg_x18;

    // Instance of RV32I
    rv32i uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .aluResult(aluResult),
        .writeData(writeData),
        .memWrite(memWrite),
        .reg_x5(reg_x5),
        .reg_x6(reg_x6),
        .reg_x7(reg_x7),
        .reg_x8(reg_x8),
        .reg_x9(reg_x9),
        .reg_x18(reg_x18)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Task for displaying key registers
    task display_key_registers;
        begin
            $display("\n--- Register State ---");
            $display("x5  (t0) = 0x%h", reg_x5);
            $display("x6  (t1) = 0x%h", reg_x6);
            $display("x7  (t2) = 0x%h", reg_x7);
            $display("x8  (s0) = 0x%h", reg_x8);
            $display("x9  (s1) = 0x%h", reg_x9);
            $display("x18 (s2) = 0x%h", reg_x18);
        end
    endtask

    // Task for displaying instruction details
    task display_instruction;
        begin
            $display("\nCurrent Instruction:");
            $display("PC: %h", pc);
            $display("Instruction: %h", uut.dp.instr);
            $display("ALU Result: %h", aluResult);
            $display("Memory Write: %b", memWrite);
            display_key_registers();
        end
    endtask

    // Task for displaying control signals
    task display_control_signals;
        begin
            $display("\nControl Signals:");
            $display("memWrite=%b branch=%b", 
                    memWrite, uut.dp.branch);
            $display("ALU Control=%b", uut.dp.aluControl);
        end
    endtask

    initial begin
        // Initialize
        clk = 0;
        reset = 1;

        // Reset sequence
        #20;
        reset = 0;

        // Monitor execution
        $monitor("Time=%0t PC=%h Instr=%h ALUResult=%h memWrite=%b",
                 $time, pc, uut.dp.instr, aluResult, memWrite);

        // Monitor PC and registers
        forever @(posedge clk) begin
            display_instruction();
            if (memWrite) begin
                $display("\n--- Memory Write Operation ---");
                $display("Address: %h Data: %h", aluResult, writeData);
            end
            if (uut.dp.branch) begin
                $display("\n--- Branch Operation ---");
                $display("Branch Target: %h", uut.dp.pcBranch);
            end
        end
    end

    // Dump waveform
    initial begin
        $dumpfile("rv32i_tb.vcd");
        $dumpvars(0, rv32i_tb);
        // Specific signals to monitor
        $dumpvars(0, uut.dp.pcNext);
        $dumpvars(0, uut.dp.pcSrc);
        $dumpvars(0, uut.dp.pcBranch);
        #1000
        $display("\nFinal State:");
        display_key_registers();
        display_control_signals();
        $finish;
    end

endmodule

/*
module rv32i_tb;
    reg clk;
    reg reset;
    wire [31:0] pc;
    wire [31:0] aluResult;
    wire [31:0] writeData;
    wire memWrite;

    // Test counter
    reg [31:0] counter;

    // DUT instantiation
    rv32i uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .aluResult(aluResult),
        .writeData(writeData),
        .memWrite(memWrite)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("rv32i_tb.vcd");
        $dumpvars(0, rv32i_tb);
        // Initialize ROM with loop test
        uut.instructionMemory.memory[0] = 32'h00100293; // addi x5, x0, 1
        uut.instructionMemory.memory[1] = 32'h00a00313; // addi x6, x0, 10
        uut.instructionMemory.memory[2] = 32'h00628863; // beq x5, x6, DONE
        uut.instructionMemory.memory[3] = 32'h00128293; // addi x5, x5, 1
        uut.instructionMemory.memory[4] = 32'hfe000ae3; // beq x0, x0, LOOP
        uut.instructionMemory.memory[5] = 32'h00502223; // sw x5, 4(x0)

        // Initialize
        clk = 0;
        reset = 1;
        counter = 0;
        #20 reset = 0;

        // Enhanced monitoring
        $monitor("Time=%0t PC=%h Instr=%h ALUResult=%h", 
                 $time, pc, uut.dp.instr, aluResult);

        #200 $finish;
    end

    // Monitor register writes
    always @(posedge clk) begin
        if (uut.dp.regWrite && uut.dp.instr[11:7] == 5) begin
            counter = aluResult;
            $display("Counter updated: x5 = %h", aluResult);
        end
        if (uut.dp.branch) begin
            $display("\n--- Branch at Time=%0t ---", $time);
            $display("PC=%h Target=%h Counter=%h", pc, uut.dp.pcBranch, counter);
        end
    end

endmodule
*/

/*

*/

/*
module rv32i_tb;
    reg clk;
    reg reset;
    
    wire [31:0] pc;
    wire [31:0] aluResult;
    wire [31:0] writeData;
    wire memWrite;

    // Instance of RV32I
    rv32i uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .aluResult(aluResult),
        .writeData(writeData),
        .memWrite(memWrite)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Task for displaying instruction details
    task display_instruction;
        begin
            $display("\nCurrent Instruction:");
            $display("PC: %h", pc);
            $display("Instruction: %h", uut.dp.instr);
            $display("ALU Result: %h", aluResult);
            $display("Memory Write: %b", memWrite);
        end
    endtask

    // Task for displaying control signals
    task display_control_signals;
        begin
            $display("\nControl Signals:");
            $display("memWrite=%b branch=%b", 
                    memWrite, uut.dp.branch);
            $display("ALU Control=%b", uut.dp.aluControl);
        end
    endtask

    initial begin
        clk = 0;
        reset = 1;

        // Reset sequence
        #10;
        reset = 0;

        // Monitor execution
        $monitor("Time=%0t PC=%h Instr=%h ALUResult=%h memWrite=%b",
                 $time, pc, uut.dp.instr, aluResult, memWrite);

        // Monitor key events
        forever @(posedge clk) begin
            display_instruction();
            if (memWrite) begin
                $display("\n--- Memory Write Operation ---");
                $display("Address: %h Data: %h", aluResult, writeData);
            end
            if (uut.dp.branch) begin
                $display("\n--- Branch Operation ---");
                $display("Branch Target: %h", uut.dp.pcBranch);
            end
        end
    end

    // Timeout and finish simulation
    initial begin
        $dumpfile("rv32i_tb.vcd");
        $dumpvars(0, rv32i_tb);
        #10000 
        $display("\nFinal State:");
        display_control_signals();
        $finish;
    end

endmodule
*/

/*
module rv32i_tb;
    reg clk;
    reg reset;
    
    wire [31:0] pc;
    wire [31:0] aluResult;
    wire [31:0] writeData;
    wire memWrite;

    // Instance of RV32I
    rv32i uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .aluResult(aluResult),
        .writeData(writeData),
        .memWrite(memWrite)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Task for displaying instruction details
    task display_instruction;
        begin
            $display("\nCurrent Instruction:");
            $display("PC: %h", pc);
            $display("Instruction: %h", uut.dp.instr);
            $display("ALU Result: %h", aluResult);
            $display("Memory Write: %b", memWrite);
        end
    endtask

    // Task for displaying control signals
    task display_control_signals;
        begin
            $display("\nControl Signals:");
            $display("memWrite=%b branch=%b", 
                    memWrite, uut.dp.branch);
            $display("ALU Control=%b", uut.dp.aluControl);
        end
    endtask

    initial begin
        clk = 0;
        reset = 1;

        // Reset sequence
        #100;
        reset = 0;

        // Monitor execution
        $monitor("Time=%0t PC=%h Instr=%h ALUResult=%h memWrite=%b",
                 $time, pc, uut.dp.instr, aluResult, memWrite);

        // Monitor key events
        forever @(posedge clk) begin
            display_instruction();
            if (memWrite) begin
                $display("\n--- Memory Write Operation ---");
                $display("Address: %h Data: %h", aluResult, writeData);
            end
            if (uut.dp.branch) begin
                $display("\n--- Branch Operation ---");
                $display("Branch Target: %h", uut.dp.pcBranch);
            end
        end
    end

    // Timeout and finish simulation
    initial begin
        $dumpfile("rv32i_tb.vcd");
        $dumpvars(0, rv32i_tb);
        #1000 
        $display("\nFinal State:");
        display_control_signals();
        $finish;
    end

endmodule
*/

/*
module rv32i_tb;
    reg clk;
    reg reset;
    wire [31:0] pc;
    wire [31:0] aluResult;
    wire [31:0] writeData;
    wire memWrite;

    // Test counter
    reg [31:0] counter;

    // DUT instantiation
    rv32i uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .aluResult(aluResult),
        .writeData(writeData),
        .memWrite(memWrite)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize ROM with loop test
        uut.instructionMemory.memory[0] = 32'h00100293; // addi x5, x0, 1
        uut.instructionMemory.memory[1] = 32'h00a00313; // addi x6, x0, 10
        uut.instructionMemory.memory[2] = 32'h00628863; // beq x5, x6, DONE
        uut.instructionMemory.memory[3] = 32'h00128293; // addi x5, x5, 1
        uut.instructionMemory.memory[4] = 32'hfe000ae3; // beq x0, x0, LOOP
        uut.instructionMemory.memory[5] = 32'h00502223; // sw x5, 4(x0)

        // Initialize
        clk = 0;
        reset = 1;
        counter = 0;
        #20 reset = 0;

        // Enhanced monitoring
        $monitor("Time=%0t PC=%h Instr=%h ALUResult=%h", 
                 $time, pc, uut.dp.instr, aluResult);

        #200 $finish;
    end

    // Monitor register writes
    always @(posedge clk) begin
        if (uut.dp.regWrite && uut.dp.instr[11:7] == 5) begin
            counter = aluResult;
            $display("Counter updated: x5 = %h", aluResult);
        end
        if (uut.dp.branch) begin
            $display("\n--- Branch at Time=%0t ---", $time);
            $display("PC=%h Target=%h Counter=%h", pc, uut.dp.pcBranch, counter);
        end
    end

endmodule
*/

/*
`timescale 1ns / 1ps

module rv32i_tb;
    // Inputs
    reg clk;
    reg reset;

    // Outputs
    wire [31:0] pc;
    wire [31:0] aluResult;
    wire [31:0] writeData;
    wire memWrite;
    wire [31:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9;
    wire [31:0] reg10, reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19;
    wire [31:0] reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29;
    wire [31:0] reg30, reg31;

    // Instantiate RV32I
    rv32i uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .aluResult(aluResult),
        .writeData(writeData),
        .memWrite(memWrite),
        .reg0(reg0), .reg1(reg1), .reg2(reg2), .reg3(reg3),
        .reg4(reg4), .reg5(reg5), .reg6(reg6), .reg7(reg7),
        .reg8(reg8), .reg9(reg9), .reg10(reg10), .reg11(reg11),
        .reg12(reg12), .reg13(reg13), .reg14(reg14), .reg15(reg15),
        .reg16(reg16), .reg17(reg17), .reg18(reg18), .reg19(reg19),
        .reg20(reg20), .reg21(reg21), .reg22(reg22), .reg23(reg23),
        .reg24(reg24), .reg25(reg25), .reg26(reg26), .reg27(reg27),
        .reg28(reg28), .reg29(reg29), .reg30(reg30), .reg31(reg31)
    );

    // Clock generator
    always #5 clk = ~clk;

    // Task to display instruction details
    task display_instruction_info;
        input [31:0] pc_val;
        input [31:0] instr;
        begin
            $display("\nTime=%0t PC=%h Instruction=%h", $time, pc_val, instr);
            $display("Control Signals: regWrite=%b, aluSrc=%b, memWrite=%b",
                    uut.dp.regWrite, uut.dp.aluSrc, uut.dp.memWrite);
            $display("ALU Result=%h", aluResult);
        end
    endtask

    // Task to verify register values
    task verify_register_values;
        input [31:0] expected_s0;
        input [31:0] expected_s1;
        input [31:0] expected_s2;
        begin
            if (reg8 !== expected_s0)
                $display("Error: s0(reg8) = %h, Expected = %h", reg8, expected_s0);
            if (reg9 !== expected_s1)
                $display("Error: s1(reg9) = %h, Expected = %h", reg9, expected_s1);
            if (reg18 !== expected_s2)
                $display("Error: s2(reg18) = %h, Expected = %h", reg18, expected_s2);
        end
    endtask

    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;

        // Wait 100 ns for global reset
        #100;
        reset = 0;

        // Monitor instruction execution
        $monitor("Time=%0t PC=%h Instr=%h ALUResult=%h memWrite=%b",
                 $time, pc, uut.dp.instr, aluResult, memWrite);

        // Wait for initial instructions to execute
        #50;
        
        // Verify initial register setup
        $display("\nVerifying initial register setup:");
        verify_register_values(32'h3, 32'h1, 32'h10);

        // Wait for ALU operations
        #100;
        
        // Verify ALU operations
        $display("\nVerifying ALU operations:");
        if (reg5 !== 32'h3)  // OR result
            $display("Error: OR operation failed. t0(reg5) = %h", reg5);
        if (reg6 !== 32'h1)  // AND result
            $display("Error: AND operation failed. t1(reg6) = %h", reg6);
        if (reg7 !== 32'h4)  // ADD result
            $display("Error: ADD operation failed. t2(reg7) = %h", reg7);
        if (reg28 !== 32'h2) // SUB result
            $display("Error: SUB operation failed. t3(reg28) = %h", reg28);
        if (reg29 !== 32'hfffffffe) // Negative SUB result
            $display("Error: Negative SUB failed. t4(reg29) = %h", reg29);

        
        // Final register dump
        #100;
        $display("\nFinal Register State:");
        $display("reg0=%h reg1=%h reg2=%h reg3=%h", reg0, reg1, reg2, reg3);
        $display("reg4=%h reg5=%h reg6=%h reg7=%h", reg4, reg5, reg6, reg7);
        $display("reg8=%h reg9=%h reg10=%h reg11=%h", reg8, reg9, reg10, reg11);
        $display("reg12=%h reg13=%h reg14=%h reg15=%h", reg12, reg13, reg14, reg15);
        $display("reg16=%h reg17=%h reg18=%h reg19=%h", reg16, reg17, reg18, reg19);
        $display("reg20=%h reg21=%h reg22=%h reg23=%h", reg20, reg21, reg22, reg23);
        $display("reg24=%h reg25=%h reg26=%h reg27=%h", reg24, reg25, reg26, reg27);
        $display("reg28=%h reg29=%h reg30=%h reg31=%h", reg28, reg29, reg30, reg31);
        // End simulation
        #100;
        $finish;
    end

endmodule
*/

/*
`timescale 1ns / 1ps

module rv32i_tb;

    // Entradas
    reg clk;
    reg reset;

    // Salidas
    wire [31:0] pc;
    wire [31:0] aluResult;
    wire [31:0] writeData;
    wire memWrite;
    wire [31:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31;

    // Instancia del módulo a probar
    rv32i uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .aluResult(aluResult),
        .writeData(writeData),
        .memWrite(memWrite),
        .reg0(reg0), .reg1(reg1), .reg2(reg2), .reg3(reg3), .reg4(reg4), .reg5(reg5), .reg6(reg6), .reg7(reg7), .reg8(reg8), .reg9(reg9), .reg10(reg10), .reg11(reg11), .reg12(reg12), .reg13(reg13), .reg14(reg14), .reg15(reg15), .reg16(reg16), .reg17(reg17), .reg18(reg18), .reg19(reg19), .reg20(reg20), .reg21(reg21), .reg22(reg22), .reg23(reg23), .reg24(reg24), .reg25(reg25), .reg26(reg26), .reg27(reg27), .reg28(reg28), .reg29(reg29), .reg30(reg30), .reg31(reg31)
    );

    // Generador de reloj
    always #5 clk = ~clk;

    initial begin
        // Inicialización de señales
        clk = 0;
        reset = 1;

        // Reset del sistema
        #10;
        reset = 0;

        // Esperar un tiempo para que el procesador ejecute las instrucciones
        #200;

        // Verificar los valores de los registros
        $display("reg0 = %h", reg0);
        $display("reg1 = %h", reg1);
        $display("reg2 = %h", reg2);
        $display("reg3 = %h", reg3);
        $display("reg4 = %h", reg4);
        $display("reg5 = %h", reg5);
        $display("reg6 = %h", reg6);
        $display("reg7 = %h", reg7);
        $display("reg8 = %h", reg8);
        $display("reg9 = %h", reg9);
        $display("reg10 = %h", reg10);
        $display("reg11 = %h", reg11);
        $display("reg12 = %h", reg12);
        $display("reg13 = %h", reg13);
        $display("reg14 = %h", reg14);
        $display("reg15 = %h", reg15);
        $display("reg16 = %h", reg16);
        $display("reg17 = %h", reg17);
        $display("reg18 = %h", reg18);
        $display("reg19 = %h", reg19);
        $display("reg20 = %h", reg20);
        $display("reg21 = %h", reg21);
        $display("reg22 = %h", reg22);
        $display("reg23 = %h", reg23);
        $display("reg24 = %h", reg24);
        $display("reg25 = %h", reg25);
        $display("reg26 = %h", reg26);
        $display("reg27 = %h", reg27);
        $display("reg28 = %h", reg28);
        $display("reg29 = %h", reg29);
        $display("reg30 = %h", reg30);
        $display("reg31 = %h", reg31);

        // Finalizar simulación
        $finish;
    end

endmodule
*/