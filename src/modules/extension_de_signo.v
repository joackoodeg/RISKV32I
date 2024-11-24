module ASD(
    input [31:0] inst, // Intruccion
    input [1:0] inmSrc, // Codigo de operacion
    output reg [31:0] inmExt // Inmediato de 32 bits
);

always @(*) begin
    case (inmSrc)
        2'b00: inmExt = { {20{inst[31]}}, inst[31:20] }; // I-Type
        2'b01: inmExt = { {20{inst[31]}}, inst[31:25], inst[11:7] }; // S-Type
        2'b11: inmExt = {{19{inst[31]}}, inst[31], inst[7], inst[30:25],inst[11:8], 1'b0};// B-Type
        2'b11: inmExt = { {12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0 }; // J-Type
        default: inmExt = 32'b0; 
    endcase
end

endmodule