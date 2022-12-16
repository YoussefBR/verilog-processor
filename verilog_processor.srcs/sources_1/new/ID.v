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
    output jump,
    output jr,
    output branch,
    output link,
    output i_rs,
    output i_rt,
    output [3:0] alu_op,
    output [4:0] dest_reg,
    output reg [31:0] qa,
    output [31:0] qb,
    output [31:0] imm32
);
    // Only used internally
    wire dest_rt;
    wire rsrtequ;
    wire linkreg;
    wire [31:0] rqa;
    assign link = linkreg;

    // Wires to aid in legibility and clarity
    wire [5:0] op = insToDecode[31:26];
    wire [4:0] rs = insToDecode[25:21];
    wire [4:0] rt = insToDecode[20:16];
    wire [4:0] rd = insToDecode[15:11];
    wire [4:0] shamt = insToDecode[10:6];
    wire [5:0] func = insToDecode[5:0];
    wire [15:0] imm = insToDecode[15:0];
    
    ControlUnit ctrl(.op(op), .func(func), .wr_reg(wr_reg), .mem_to_reg(mem_to_reg), .wr_mem(wr_mem), .alu_op(alu_op), .alu_imm(alu_imm), .dest_rt(dest_rt), .jump(jump), .linkreg(linkreg), .jr(jr), .branch(branch), .i_rs(i_rs), .i_rt(i_rt));
    DestMult dMult(.rt(rt), .rd(rd), .dest_rt(dest_rt), .dest_reg(dest_reg), .linkreg(linkreg));
    RegisterFile regFile(.clk(clk), .rs(rs), .rt(rt), .wb_reg(wb_reg), .wb_dest(wb_dest), .wb_data(wb_data), .rsrtequ(rsrtequ), .qa(rqa), .qb(qb), .jump(jump));
    ImmediateExtender immExt(.imm(imm), .imm32(imm32));

    always@(*)begin
        if(jump)begin
            qa = insToDecode;
        end
        else begin
            qa = rqa;
        end 
    end

endmodule

// Combinational - Calculates the control signals for the given instruction
module ControlUnit(
    input rsrtequ,
    input [5:0] op,
    input [5:0] func,

    output reg wr_reg,
    output reg mem_to_reg,
    output reg wr_mem,
    output reg [3:0] alu_op,
    output reg alu_imm,
    output reg dest_rt,
    output reg jump,
    output reg jr,
    output reg linkreg,
    output reg branch,
    output reg i_rs,
    output reg i_rt
);

    always@(*) begin
        jump = 1'b0;
        jr = 1'b0;
        branch = 1'b0;
        linkreg = 1'b0;
        i_rs = 1'b1;
        i_rt = 1'b0;
        case(op)
            6'b000000:
            begin
                i_rt = 1'b1;
                case(func)
                    // add signals
                    6'b100000:
                    begin
                        wr_reg <= 1'b1;
                        mem_to_reg <= 1'b0;
                        wr_mem <= 1'b0;
                        alu_op <= 4'b0010;
                        alu_imm <= 1'b0;
                        dest_rt <= 1'b0;
                    end
                    // sub signals 
                    6'b100010:
                    begin
                        wr_reg <= 1'b1;
                        mem_to_reg <= 1'b0;
                        wr_mem <= 1'b0;
                        alu_op <= 4'b0110;
                        alu_imm <= 1'b0;
                        dest_rt <= 1'b0;
                    end
                    // and signals 
                    6'b100100:
                    begin
                        wr_reg <= 1'b1;
                        mem_to_reg <= 1'b0;
                        wr_mem <= 1'b0;
                        alu_op <= 4'b0000;
                        alu_imm <= 1'b0;
                        dest_rt <= 1'b0;
                    end
                    // or signals 
                    6'b100101:
                    begin
                        wr_reg <= 1'b1;
                        mem_to_reg <= 1'b0;
                        wr_mem <= 1'b0;
                        alu_op <= 4'b0001;
                        alu_imm <= 1'b0;
                        dest_rt <= 1'b0;
                    end
                    // xor signals 
                    6'b100110:
                    begin
                        wr_reg <= 1'b1;
                        mem_to_reg <= 1'b0;
                        wr_mem <= 1'b0;
                        alu_op <= 4'b1100;
                        alu_imm <= 1'b0;
                        dest_rt <= 1'b0;
                    end
                    // sll signals 
                    6'b000000:
                    begin
                        wr_reg <= 1'b1;
                        mem_to_reg <= 1'b0;
                        wr_mem <= 1'b0;
                        alu_op <= 4'b1000;
                        alu_imm <= 1'b0;
                        dest_rt <= 1'b0;
                    end
                    // srl signals 
                    6'b000010:
                    begin
                        wr_reg <= 1'b1;
                        mem_to_reg <= 1'b0;
                        wr_mem <= 1'b0;
                        alu_op <= 4'b1001;
                        alu_imm <= 1'b0;
                        dest_rt <= 1'b0;
                    end
                    // sra signals 
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
            // lw signals
            6'b100011:
            begin
                wr_reg <= 1'b1;
                mem_to_reg <= 1'b1;
                wr_mem <= 1'b0;
                alu_op <= 4'b0010;
                alu_imm <= 1'b1;
                dest_rt <= 1'b1;
            end
            // sw signals
            6'b101011:
            begin
                wr_reg <= 1'b0;
                mem_to_reg <= 1'b0;
                wr_mem <= 1'b1;
                alu_op <= 4'b0010;
                alu_imm <= 1'b1;
                dest_rt <= 1'b0;
                i_rt <= 1'b1;
            end
            // lui signals
            6'b001111:
            begin
                wr_reg <= 1'b1;
                mem_to_reg <= 1'b0;
                wr_mem <= 1'b0;
                alu_op <= 4'b0010;
                alu_imm <= 1'b1;
                dest_rt <= 1'b1;
            end
            // addi signals
            6'b001000:
            begin
                wr_reg <= 1'b1;
                mem_to_reg <= 1'b0;
                wr_mem <= 1'b0;
                alu_op <= 4'b0010;
                alu_imm <= 1'b1;
                dest_rt <= 1'b1;
            end
            // andi signals
            6'b001100:
            begin
                wr_reg <= 1'b1;
                mem_to_reg <= 1'b0;
                wr_mem <= 1'b0;
                alu_op <= 4'b0000;
                alu_imm <= 1'b1;
                dest_rt <= 1'b1;
            end
            // ori signals
            6'b001101:
            begin
                wr_reg <= 1'b1;
                mem_to_reg <= 1'b0;
                wr_mem <= 1'b0;
                alu_op <= 4'b0001;
                alu_imm <= 1'b1;
                dest_rt <= 1'b1;
            end
            // xori signals
            6'b001110:
            begin
                wr_reg <= 1'b1;
                mem_to_reg <= 1'b0;
                wr_mem <= 1'b0;
                alu_op <= 4'b1100;
                alu_imm <= 1'b1;
                dest_rt <= 1'b1;
            end
            // j signals
            6'b000010:
            begin
                wr_reg <= 1'b0;
                mem_to_reg <= 1'bX;
                wr_mem <= 1'b0;
                alu_op <= 4'bXXXX;
                alu_imm <= 1'bX;
                dest_rt <= 1'bX;
                jump <= 1'b1;
                i_rs <= 1'b0;
            end
            // jr signals
            6'b000000:
            begin
                wr_reg <= 1'b0;
                mem_to_reg <= 1'bX;
                wr_mem <= 1'b0;
                alu_op <= 4'bXXXX;
                alu_imm <= 1'bX;
                dest_rt <= 1'bX;
                jr <= 1'b1;
            end
            // jal signals
            6'b000011:
            begin
                wr_reg <= 1'b1;
                mem_to_reg <= 1'b0;
                wr_mem <= 1'b0;
                alu_op <= 4'b0010;
                alu_imm <= 1'b0;
                dest_rt <= 1'b0;
                jump <= 1'b1;
                linkreg <= 1'b1;
                i_rs <= 1'b0;
            end
            // beq signals
            6'b000100:
            begin
                wr_reg <= 1'b0;
                mem_to_reg <= 1'bX;
                wr_mem <= 1'b0;
                alu_op <= 4'bXXXX;
                alu_imm <= 1'bX;
                dest_rt <= 1'bX;
                if(rsrtequ)begin
                    branch <= 1'b1;
                end
                i_rt <= 1'b1;
            end
            // bne signals
            6'b000101:
            begin
                wr_reg <= 1'b0;
                mem_to_reg <= 1'bX;
                wr_mem <= 1'b0;
                alu_op <= 4'bXXXX;
                alu_imm <= 1'bX;
                dest_rt <= 1'bX;
                branch <= 1'b1;
                if(!rsrtequ)begin
                    branch <= 1'b1;
                end
                i_rt <= 1'b1;
            end
        endcase
    end

endmodule

// Combinational - returns the proper destination register based on instruction type
module DestMult(
    input [4:0] rd,
    input [4:0] rt,
    input dest_rt,
    input linkreg,

    output reg [4:0] dest_reg
);

    always@(*)begin
        if(dest_rt)begin
            dest_reg = rt;
        end
        else if(linkreg)begin
            dest_reg = 5'd31;
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
    input jump,
    input [4:0] rs,
    input [4:0] rt,
    input [4:0] wb_dest,
    input [31:0] wb_data,

    output reg rsrtequ,
    output reg [31:0] qa,
    output reg [31:0] qb
);

    reg [31:0] registers [0:31];

    initial begin
        registers[0] <= 32'd0;
        registers[1] <= 32'hA00000AA;
        registers[2] <= 32'h10000011;
        registers[3] <= 32'h20000022;
        registers[4] <= 32'h30000033;
        registers[5] <= 32'h40000044;
        registers[6] <= 32'h50000055;
        registers[7] <= 32'h60000066;
        registers[8] <= 32'h70000077;
        registers[9] <= 32'h80000088;
        registers[10] <= 32'h90000099;
    end

    always@(*)begin
        if(!jump)begin
            qa = registers[rs];
        end
        qb = registers[rt];
        rsrtequ = ~| (qa^qb);
    end
    
    // Write back on negative edge of clock instead of the positive edge to write and read in the same cycle
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



