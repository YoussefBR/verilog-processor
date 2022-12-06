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

    reg    [31:0] ram [0:31];              // ram cells: 32 words * 32 bits 
    integer i; 
    initial begin                          // ram initialization 
        for (i = 0; i < 32; i = i + 1) 
            ram[i] = 0; 
        // ram[word_addr] = data           // (byte_addr) item in data array 
        ram[5'h14] = 32'h000000a3;         // (50) data[0]   0 +  a3 =  a3 
        ram[5'h15] = 32'h00000027;         // (54) data[1]  a3 +  27 =  ca 
        ram[5'h16] = 32'h00000079;         // (58) data[2]  ca +  79 = 143 
        ram[5'h17] = 32'h00000115;         // (5c) data[3] 143 + 115 = 258 
        // ram[5'h18] should be 0x00000258, the sum stored by sw instruction 
    end

    always@(*)begin
        mem_out = ram[mem_loc[6:2]]; // 5 bits used to address
    end
    always@(posedge clk)begin
        if(wr_mem)begin
            ram[mem_loc[6:2]] = qb; // 5 bits used to address
        end                                                                                                                                                                                                             
    end

endmodule