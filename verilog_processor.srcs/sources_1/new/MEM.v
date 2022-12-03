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


module MEM(
        input clk,
        input wr_mem,
        input [31:0] alu_out,
        input [31:0] qb,

        output [31:0] mem_out
    );

    DataMemory dataMem(.clk(clk), .wr_mem(wr_mem), .mem_loc(alu_out), .qb(qb), .mem_out(mem_out));

endmodule

module DataMemory(
    input wr_mem,
    input [31:0] mem_loc,
    input [31:0] qb,
    input clk,

    output reg [31:0] mem_out
);

    reg [31:0] data_memory [0:9];
    initial begin
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

    always@(*)begin
        mem_out = data_memory[mem_loc[31:2]];
    end
    always@(negedge clk)begin
        if(wr_mem)begin
            data_memory[mem_loc[31:2]] = qb;
        end
    end

endmodule