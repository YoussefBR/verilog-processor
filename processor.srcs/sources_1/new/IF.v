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


module IF(
    
);
endmodule

// Sequential - Updates the pc at the start of every new cycle
module ProgramCounter(
    input [31:0] nextPC,
    input clk,
    output reg [31:0] pc
);

    always@(posedge clk)begin
        pc <= nextPC;
    end

endmodule

// Combinatial - Calculates the address of the next instruction 
module PCAdder(
    input [31:0] PC,
    output reg [31:0] nextPC
);

    wire [31:0] WORD_SIZE = 32'd4;
    
    always@(*)begin
        nextPC = PC + WORD_SIZE;
    end

endmodule

// Combinational - Gets the instruction at the location of the PC
module InstructionMemory(
    input [31:0] pc,
    output reg [31:0] nextIns
);

    reg [31:0] memory [0:63];
    
    initial begin
        memory[25] = {6'b000000, 5'b00000, 5'b00000, 5'b00000, 5'b00000, 6'b000000};
        memory[26] = {6'b000000, 5'b00000, 5'b00000, 5'b00000, 5'b00000, 6'b000000};
    end
    
    always@(*)begin
        nextIns = memory[pc[31:2]];
    end

endmodule