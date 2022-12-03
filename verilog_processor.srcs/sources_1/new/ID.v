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
    input clk,
    input wb_reg,
    input [4:0] wb_dest,
    input [31:0] insToDecode,
    input [31:0] wb_data,

    output wr_reg,
    output mem_to_reg,
    output wr_mem,
    output alu_imm,
    output [3:0] alu_op,
    output [4:0] dest_reg,
    output [31:0] qa,
    output [31:0] qb,
    output [31:0] imm32
);
    // Only used internally
    wire dest_rt;

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
    RegisterFile regFile(.clk(clk), .rs(rs), .rt(rt), .wb_reg(wb_reg), .wb_dest(wb_dest), .wb_data(wb_data), .qa(qa), .qb(qb));
    ImmediateExtender immExt(.imm(imm), .imm32(imm32));

endmodule

// Combinational - Calculates the control signals for the given instruction
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
                    // Subtract signals 
                    6'b100010:
                    begin
                        wr_reg <= 1'b1;
                        mem_to_reg <= 1'b0;
                        wr_mem <= 1'b0;
                        alu_op <= 4'b0110;
                        alu_imm <= 1'b0;
                        dest_rt <= 1'b0;
                    end
                    // AND signals 
                    6'b100100:
                    begin
                        wr_reg <= 1'b1;
                        mem_to_reg <= 1'b0;
                        wr_mem <= 1'b0;
                        alu_op <= 4'b0000;
                        alu_imm <= 1'b0;
                        dest_rt <= 1'b0;
                    end
                    // OR signals 
                    6'b100101:
                    begin
                        wr_reg <= 1'b1;
                        mem_to_reg <= 1'b0;
                        wr_mem <= 1'b0;
                        alu_op <= 4'b0001;
                        alu_imm <= 1'b0;
                        dest_rt <= 1'b0;
                    end
                    // XOR signals 
                    6'b100110:
                    begin
                        wr_reg <= 1'b1;
                        mem_to_reg <= 1'b0;
                        wr_mem <= 1'b0;
                        alu_op <= 4'b1100;
                        alu_imm <= 1'b0;
                        dest_rt <= 1'b0;
                    end
                    // Shift left signals 
                    6'b000000:
                    begin
                        wr_reg <= 1'b1;
                        mem_to_reg <= 1'b0;
                        wr_mem <= 1'b0;
                        alu_op <= 4'b1000;
                        alu_imm <= 1'b0;
                        dest_rt <= 1'b0;
                    end
                    // Logic shift right signals 
                    6'b000010:
                    begin
                        wr_reg <= 1'b1;
                        mem_to_reg <= 1'b0;
                        wr_mem <= 1'b0;
                        alu_op <= 4'b1001;
                        alu_imm <= 1'b0;
                        dest_rt <= 1'b0;
                    end
                    // Arithmetic shift right signals 
                    6'b000011:
                    begin
                        wr_reg <= 1'b1;
                        mem_to_reg <= 1'b0;
                        wr_mem <= 1'b0;
                        alu_op <= 4'b1011;
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
            // Load upper immediate signals
            6'b001111:
            begin
                wr_reg <= 1'b1;
                mem_to_reg <= 1'b0;
                wr_mem <= 1'b0;
                alu_op <= 4'b0010;
                alu_imm <= 1'b1;
                dest_rt <= 1'b1;
            end
        endcase
    end

endmodule

// Combinational - returns the proper destination register based on instruction type
module DestMult(
    input [4:0] rd,
    input [4:0] rt,
    input dest_rt,

    output reg [4:0] dest_reg
);

    always@(*)begin
        if(dest_rt)begin
            dest_reg = rt;
        end
        else begin
            dest_reg = rd;
        end
    end

endmodule

// Combinational - Stores the register file and returns the corresponding value at the registers used in the instruction
module RegisterFile(
    input clk,
    input wb_reg,
    input [4:0] rs,
    input [4:0] rt,
    input [4:0] wb_dest,
    input [31:0] wb_data,

    output reg [31:0] qa,
    output reg [31:0] qb
);

    reg [31:0] registers [0:31];

    initial begin
        registers[0] = 32'd0;
        registers[1] = 32'd0;
        registers[10] = 32'd0;
    end

    always@(*)begin
        qa <= registers[rs];
        qb <= registers[rt];
    end
    
    always@(negedge clk)begin
        if(wb_reg)begin
            registers[wb_dest] = wb_data;
        end
    end

endmodule

// Combinational - Sign extends the immediate from 16 bits to 32 bits so it can be used properly
module ImmediateExtender(
    input [15:0] imm,

    output reg [31:0] imm32
);

    always@(*)begin
        imm32 = {{16{imm[15]}}, imm};
    end

endmodule



