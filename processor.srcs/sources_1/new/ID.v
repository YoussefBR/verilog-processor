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

    output reg wr_reg,
    output reg m_2_reg,
    output reg wr_mem,
    output reg alu_op,
    output reg alu_imm
);

endmodule

module ControlUnit(
    input [5:0] op,
    input [5:0] func,

    output reg wr_reg,
    output reg mem_to_reg,
    output reg wr_me,
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

    output reg [31:0] qa,
    output reg [31:0] qb
);

    reg [31:0] registers [0:31];

    initial begin
        registers[0] = 32'd0;
        registers[1] = 32'd0;
    end

    always@(*)begin
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



