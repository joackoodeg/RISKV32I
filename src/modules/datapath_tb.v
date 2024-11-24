module datapath_tb;
    reg clk;
    reg reset;
    reg [31:0] instr;
    reg [31:0] readData;
    wire [31:0] pc;
    wire [31:0] aluResult;
    wire [31:0] writeData;
    wire memWrite;

    // DUT instantiation
    dataPath uut (
        .clk(clk),
        .reset(reset),
        .instr(instr),
        .readData(readData),
        .pc(pc),
        .aluResult(aluResult),
        .writeData(writeData),
        .memWrite(memWrite)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Task for instruction injection
    task execute_instruction;
        input [31:0] new_instr;
        input [8*20:1] instr_name;
        begin
            @(posedge clk);
            instr = new_instr;
            $display("\nExecuting %s", instr_name);
            $display("PC=%h, Instruction=%h", pc, instr);
            @(posedge clk);
            #1;
            $display("ALUResult=%h, WriteData=%h, MemWrite=%b", 
                    aluResult, writeData, memWrite);
        end
    endtask

    initial begin
        // Initialize
        clk = 0;
        reset = 1;
        instr = 0;
        readData = 0;

        // Reset sequence
        @(posedge clk);
        reset = 0;

        // Test sequence - While loop example
        $display("\n=== Starting Loop Test ===\n");

        // Initialize variables
        execute_instruction(32'h00100293, "addi x5, x0, 1");    // var = 1
        execute_instruction(32'h01000913, "addi x18, x0, 16");  // limit = 16
        execute_instruction(32'h00000313, "addi x6, x0, 0");    // counter = 0

        // Loop sequence
        $display("\n=== Loop Start ===\n");
        repeat(10) begin
            // Loop body
            execute_instruction(32'h01228463, "beq x5, x18, 8");    // if var==limit, exit
            execute_instruction(32'h00528293, "add x5, x5, x5");    // var = var + var
            execute_instruction(32'h00130313, "addi x6, x6, 1");    // counter++
            execute_instruction(32'hfe000ae3, "beq x0, x0, -12");   // jump to start
            
            // Show loop state
            $display("\n=== Loop State ===");
            $display("Program Counter = %h", pc);
            $display("Variable (x5)   = %h", uut.reg_x5);
            $display("Counter (x6)    = %h", uut.reg_x6);
            $display("Limit (x18)     = %h", uut.reg_x18);
            $display("==================\n");
        end

        // End test
        $display("\n=== Loop Test Complete ===\n");
        #100 $finish;
    end

    // VCD dump
    initial begin
        $dumpfile("datapath_tb.vcd");
        $dumpvars(0, datapath_tb);
    end

endmodule

/*
`timescale 1ns / 1ps

module dataPath_tb;
    // Inputs
    reg clk;
    reg reset;
    reg [31:0] instr;
    reg [31:0] readData;

    // Outputs
    wire [31:0] pc;
    wire [31:0] aluResult;
    wire [31:0] writeData;
    wire memWrite;
    wire [31:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9;
    wire [31:0] reg10, reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19;
    wire [31:0] reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29;
    wire [31:0] reg30, reg31;

    // Instantiate DUT
    dataPath uut (
        .clk(clk),
        .reset(reset),
        .instr(instr),
        .readData(readData),
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

    // Task for monitoring control signals
    task display_control_signals;
        begin
            $display("\nControl Signals:");
            $display("regWrite=%b, aluSrc=%b, resSrc=%b", 
                    uut.regWrite, uut.aluSrc, uut.resSrc);
            $display("memWrite=%b, branch=%b, pcSrc=%b", 
                    uut.memWrite, uut.branch, uut.pcSrc);
        end
    endtask

    // Task for displaying register values
    task display_registers;
        begin
            $display("\nRegister Values:");
            $display("reg0=%h, reg1=%h, reg2=%h, reg3=%h", reg0, reg1, reg2, reg3);
            $display("reg4=%h, reg5=%h, reg6=%h, reg7=%h", reg4, reg5, reg6, reg7);
        end
    endtask

    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        instr = 32'b0;
        readData = 32'b0;

        // Wait 100 ns for global reset
        #100;
        reset = 0;
        
        // Test 1: Load Word (lw)
        @(posedge clk);
        instr = 32'b00000000000100000000000010000011; // lw x1, 0(x0)
        readData = 32'h12345678;
        @(posedge clk);
        #1;
        $display("\nTest lw:");
        display_control_signals();
        display_registers();

        // Test 2: Store Word (sw)
        @(posedge clk);
        instr = 32'b00000000000100000010000010100011; // sw x1, 0(x0)
        @(posedge clk);
        #1;
        $display("\nTest sw:");
        display_control_signals();
        display_registers();

        // Test 3: Add
        @(posedge clk);
        instr = 32'b00000000000100001000000110110011; // add x3, x1, x2
        @(posedge clk);
        #1;
        $display("\nTest add:");
        display_control_signals();
        display_registers();

        // Test 4: Branch Equal (beq)
        @(posedge clk);
        instr = 32'b00000000000100001000000001100011; // beq x1, x2, offset
        @(posedge clk);
        #1;
        $display("\nTest beq:");
        display_control_signals();
        display_registers();

        // Test 5: Add Immediate (addi)
        @(posedge clk);
        instr = 32'b00000000000100001000000010010011; // addi x1, x2, 1
        @(posedge clk);
        #1;
        $display("\nTest addi:");
        display_control_signals();
        display_registers();

        // Test 6: Jump and Link (jal)
        @(posedge clk);
        instr = 32'b00000000000100000000000011101111; // jal x1, offset
        @(posedge clk);
        #1;
        $display("\nTest jal:");
        display_control_signals();
        display_registers();

        
        // Final register dump
        $display("\nFinal Register State:");
        display_registers();

        // End simulation
        #100;
        $finish;
    end

    // Optional: Monitor changes
    initial begin
        $monitor("Time=%0t pc=%h aluResult=%h writeData=%h memWrite=%b",
                 $time, pc, aluResult, writeData, memWrite);
    end

endmodule

*/

