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

module Processor(
    input clk;
);

    // PC init
    reg [31:0] nextPc;
    reg [31:0] pc;
    ProgramCounter programCount(.nextPc(nextPc), .clk(clk), .pc(pc));
    // IF init
    reg [31:0] nextIns
    IF insFetch(.pc(pc), .nextPc(nextPc), .nextIns(nextIns));
    // IFIDPipeReg init
    reg [31:0] insToDecode;
    IF_ID_PipeReg IF_ID_Pipe(.nextIns(nextIns), .clk(clk), .insToDecode(insToDecode));
    // ID init
    reg wr_reg;
    reg mem_to_reg;
    reg wr_mem;
    reg alu_op;
    reg alu_imm;
    reg [4:0] dest_reg;
    reg [31:0] qa;
    reg [31:0] qb;
    reg [31:0] imm32;
    ID insDecode(.insToDecode(insToDecode), .wb_reg(wb_reg), .wb_dest(wb_dest), .wb_result(wb_result), .wr_reg(wr_reg), .mem_to_reg(mem_to_reg), .wr_mem(wr_mem), .alu_op(alu_op), .alu_imm(alu_imm), .dest_reg(dest_reg), .qa(qa), .qb(qb), .imm32(imm32));
    // IDEXEPipeReg init
    reg ewr_reg;
    reg emem_to_reg;
    reg ewr_mem;
    reg ealu_op;
    reg ealu_imm;
    reg [4:0] edest_reg;
    reg [31:0] eqa;
    reg [31:0] eqb;
    reg [31:0] eimm32;
    ID_EXE_PipeReg ID_EXE_Pipe(.clk(clk), .wr_reg(wr_reg), .mem_to_reg(mem_to_reg), .wr_mem(wr_mem), .alu_op(alu_op), .alu_imm(alu_imm), .dest_reg(dest_reg), .qa(qa), .qb(qb), .imm32(imm32), .ewr_reg(ewr_reg), .emem_to_reg(emem_to_reg), .ewr_mem(ewr_mem), .ealu_op(ealu_op), .ealu_imm(ealu_imm), .edest_reg(edest_reg), .eqa(eqa), .eqb(eqb), .eimm32(eimm32));

    // Makeshift ALU until implemented
    reg [31:0] aluResult;
    always@(*)begin
        if(ealu_op == 4'b0010)begin
            if(ealu_imm == 1'b1)begin
                aluResult = eqa + eimm32;
            end
            else begin
                aluResult = eqa + eqb;
            end
        end
    end
    // Makeshift DataMem until implemented
    reg [31:0] data_memory [0:9];
    inital begin
        data_memory[0] <= 32'hA00000AA;
        data_memory[1] <= 32'h10000011;
        data_memory[2] <= 32'h20000022;
        data_memory[3] <= 32'h30000033;
        data_memory[4] <= 32'h40000044;
        data_memory[5] <= 32'h50000055;
        data_memory[6] <= 32'h60000066;
        data_memory[7] <= 32'h70000077;
        data_memory[8] <= 32'h80000088;
        data_memory[9] <= 32'h90000099;
    end
    reg [31:0] result;
    always@(*)begin
        if(mem_to_reg)begin
            result = data_memory[aluResult];
        end
        else begin
            result = aluResult;
        end
    end
    // Makeshift WB until implemented, should be the memory versions of these vars not the exe versions.
    reg wb_reg;
    reg [4:0] wb_dest;
    reg [31:0] wb_result;
    MEM_WB_PipeReg MEM_WB_Pipe(.clk(clk), .wr_reg(ewr_reg), .dest_reg(edest_reg), .result(result), .wb_reg(wb_reg), .wb_dest(wb_dest), .wb_result(wb_dest));

endmodule

// Sequential - Updates the pc at the start of every new cycle
module Program_Counter(
    input [31:0] nextPc,
    input clk,
    output reg [31:0] pc
);

    always@(posedge clk)begin
        pc <= nextPc;
    end

endmodule

// Sequential - Stores values needed when transitioning an instruction from IF to ID and updates at the start of each cycle
module IF_ID_PipeReg(
    input [31:0] nextIns,
    input clk,

    output reg [31:0] insToDecode
);

    always@(posedge clk)begin
        insToDecode <= nextIns;
    end

endmodule

module ID_EXE_PipeReg(
    input clk,
    input wr_reg,
    input mem_to_reg,
    input wr_mem, 
    input alu_imm, 
    input [3:0] alu_op,
    input [4:0] dest_reg,
    input [31:0] qa,
    input [31:0] qb,
    input [31:0] imm32,

    output reg ewr_reg,
    output reg emem_to_reg,
    output reg ewr_mem, 
    output reg ealu_imm,
    output reg [3:0] ealu_op,
    output reg [4:0] edest_reg,
    output reg [31:0] eqa,
    output reg [31:0] eqb,
    output reg [31:0] eimm32
);

    always@(posedge clk)begin
        ewr_reg <= wr_reg;
        emem_to_reg <= mem_to_reg;
        ewr_mem <= wr_mem;
        ealu_imm <= alu_imm;
        ealu_op <= alu_op;
        edest_reg <= dest_reg;
        eqa <= qa;
        eqb <= qb;
        eimm32 <= imm32;
    end

endmodule

module MEM_WB_PipeReg(
    input clk,
    input wr_reg,
    input [4:0] dest_reg,
    input [31:0] result,

    output reg wb_reg,
    output reg [4:0] wb_dest,
    output reg [31:0] wb_result
);
    // Temporarily set to when result changes even though this should be on clk just to give mem enough time to finish.
    always@(result)begin
        if(wr_reg)begin
            wb_reg <= wb_reg;
            wb_dest <= dest_reg;
            wb_result <= result;
        end
    end

endmodule