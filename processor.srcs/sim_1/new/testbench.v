`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2022 05:24:09 PM
// Design Name: 
// Module Name: testbench
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

// Basic Testbench that just provides a clock
module testbench();

    reg clk;
    
    wire [31:0] out_insToDecode;
    wire out_wr_reg;
    wire out_mem_to_reg;
    wire out_wr_mem;
    wire [3:0] out_alu_op;
    wire [4:0] out_dest_reg;
    wire [31:0] out_qa;
    wire [31:0] out_qb;
    wire [31:0] out_imm32;
    
    initial begin
        clk = 1'b0;
    end
    
    always begin
        #1;
        clk = ~clk;
    end
    
    Processor proccessor(
        .clk(clk), 
        .out_insToDecode(out_insToDecode),
        .out_wr_reg(out_wr_reg),
        .out_mem_to_reg(out_mem_to_reg),
        .out_wr_mem(out_wr_mem),
        .out_alu_op(out_alu_op),
        .out_dest_reg(out_dest_reg),
        .out_qa(out_qa),
        .out_qb(out_qb),
        .out_imm32(out_imm32)
    );

endmodule
