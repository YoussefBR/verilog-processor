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


module ID(
    input [31:0] insToDecode,
    input wb_reg,
    input [4:0] wb_dest,
    input [31:0] wb_result,

    output reg wr_reg,
    output reg mem_to_reg,
    output reg wr_mem,
    output reg alu_op,
    output reg alu_imm,
    output reg [4:0] dest_reg,
    output reg [31:0] qa,
    output reg [31:0] qb,
    output reg [31:0] imm32
);
    // Only used internally
    reg dest_rt;

    // Wires to aid in legibility and clarity
    wire [5:0] op = insToDecode[31:26];
    wire [4:0] rs = insToDecode[25:21];
    wire [4:0] rt = insToDecode[20:16];
    wire [4:0] rd = insToDecode[15:11];
    wire [4:0] shamt = insToDecode[10:6];
    wire [5:0] func = insToDecode[5:0];
    wire [15:0] imm = insToDecode[15:0];
    
    ControlUnit ctrl(.op(op), .func(func), .wr_reg(wr_reg), .mem_to_reg(mem_to_reg), .wr_mem(wr_mem), .alu_op(alu_op), .alu_imm(alu_imm), .dest_rt(dest_rt));
    DestMult dMult(.rt(rt), .rd(rd), .dest_rt(dest_rt), .dest_reg(dest_reg));
    RegisterFile regFile(.rs(rs), .rt(rt), .qa(qa), .qb(qb));
    ImmediateExtender immExt(.imm(imm), .imm32(imm32));

endmodule

module ControlUnit(
    input [5:0] op,
    input [5:0] func,

    output reg wr_reg,
    output reg mem_to_reg,
    output reg wr_mem,
    output reg [3:0] alu_op,
    output reg alu_imm,
    output reg dest_rt
);

    always@(*) begin
        case(op)
            6'b000000:
            begin
                case(func)
                    // Add signals
                    6'b100000:
                    begin
                        wr_reg <= 1'b1;
                        mem_to_reg <= 1'b0;
                        wr_mem <= 1'b0;
                        alu_op <= 4'b0010;
                        alu_imm <= 1'b0;
                        dest_rt <= 1'b0;
                    end
                endcase 
            end
            // Load word signals
            6'b100011:
            begin
                wr_reg <= 1'b1;
                mem_to_reg <= 1'b1;
                wr_mem <= 1'b0;
                alu_op <= 4'b0010;
                alu_imm <= 1'b1;
                dest_rt <= 1'b1;
            end
        endcase
    end

endmodule

module DestMult(
    input [4:0] rd,
    input [4:0] rt,
    input dest_rt,

    output reg [4:0] destReg
);

    always@(*)begin
        if(dest_rt)begin
            destReg = rt;
        end
        else begin
            destReg = rd;
        end
    end

endmodule

module RegisterFile(
    input [4:0] rs,
    input [4:0] rt,
    input wb_reg,
    input [4:0] wb_dest,
    input [31:0] wb_result,

    output reg [31:0] qa,
    output reg [31:0] qb
);

    reg [31:0] registers [0:31];

    initial begin
        registers[0] = 32'd0;
        registers[1] = 32'd0;
    end

    always@(*)begin
        if(wb_reg)begin
            registers[wb_dest] = wb_result;
        end
        qa <= registers[rs];
        qb <= registers[rt];
    end

endmodule

module ImmediateExtender(
    input [15:0] imm,

    output reg [31:0] imm32
);

    always@(*)begin
        imm32 = {{16{imm[15]}}, imm};
    end

endmodule



