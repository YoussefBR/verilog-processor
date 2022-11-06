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

);

endmodule

// Sequential - Updates the pc at the start of every new cycle
module ProgramCounter(
    input [31:0] nextPc,
    input clk,
    output reg [31:0] pc
);

    always@(posedge clk)begin
        pc <= nextPc;
    end

endmodule

// Sequential - Stores values needed when transitioning an instruction from IF to ID and updates at the start of each cycle
module IFIDPipeReg(
    input [31:0] nextIns,
    input clk,

    output reg [31:0] insToDecode
);

    always@(posedge clk)begin
        insToDecode <= nextIns;
    end

endmodule

module IDEXEPipeReg(
    input wr_reg,
    input mem_to_reg,
    input wr_mem, 
    input alu_imm, 
    input [3:0] alu_op,
    input [4:0] dest_reg,
    input [31:0] qa,
    input [31:0] qb,
    input [31:0] imm32,
    input clk,

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