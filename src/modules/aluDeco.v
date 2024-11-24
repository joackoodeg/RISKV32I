module aluDeco(
    input [1:0] aluOp,
    input [2:0] func3,
    input func7,
    output reg [2:0] aluControl
);

    always @(*) begin
        case (aluOp)
            2'b00: aluControl = 3'b000; // lw, sw (add)
            2'b01: aluControl = 3'b001; // beq (subtract)
            2'b10: begin
                // R-type operations
                case (func3)
                    3'b000: aluControl = (func7 == 1'b0) ? 3'b000 : 3'b001; // add / sub
                    3'b010: aluControl = 3'b101; // slt (set less than)
                    3'b110: aluControl = 3'b011; // or
                    3'b111: aluControl = 3'b010; // and
                    default: aluControl = 3'b000; // Default case
                endcase
            end
            default: aluControl = 3'b000; 
        endcase
    end

endmodule
