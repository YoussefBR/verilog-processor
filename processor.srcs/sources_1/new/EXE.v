`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2022 05:37:02 PM
// Design Name: 
// Module Name: 
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module EXE(
    input alu_imm,
    input [3:0] alu_op,
    input [31:0] qa,
    input [31:0] qb,
    input [31:0] imm32,

    output [31:0] alu_out
);

    wire [31:0] b;

    ALU_In_Mux alu_mux(
        // Inputs
        .alu_imm(alu_imm),
        .qb(qb),
        .imm32(imm32),

        // Outputs
        .b(b)
    );

    ALU alu(
        // Inputs
        .alu_op(alu_op),
        .qa(qa),
        .b(b),

        // Outputs
        .alu_out(alu_out)
    );
endmodule

module ALU_In_Mux(
    input               alu_imm,
    input       [31:0]  qb,
    input       [31:0]  imm32,
    
    output reg  [31:0]  b
);

    always@(*)begin
        if(alu_imm)begin
            b = imm32;
        end
        else begin
            b = qb;
        end
    end

endmodule

module ALU(
    input [3:0] alu_op,
    input [31:0] qa,
    input [31:0] b,

    output reg [31:0] alu_out
);

    always@(*)begin
        case(alu_op)
            4'b0010:
            begin
                alu_out = qa + b;
            end
        endcase
    end

endmodule
