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
    input [31:0] pc,
    output [31:0] nextPc,
    output [31:0] nextIns
);

    PCAdder pcAdd(.pc(pc), .nextPc(nextPc));
    InstructionMemory insMem(.pc(pc), .nextIns(nextIns));

endmodule

// Combinational - Calculates the address of the next instruction 
module PCAdder(
    input [31:0] pc,
    output reg [31:0] nextPc
);

    wire [31:0] WORD_SIZE = 32'd4;
    initial begin
        // Initial pc is set to 100 as it is byte addressed and we want the 25th word
        #1 nextPc = 32'd100;
    end
    always@(*)begin
        nextPc = pc + WORD_SIZE;
    end

endmodule

// Combinational - Gets the instruction at the location of the PC
module InstructionMemory(
    input [31:0] pc,
    output reg [31:0] nextIns
);

    reg [31:0] ins_memory [0:63];
    
    initial begin
        // lw $v0 0[$at]
        ins_memory[25] = {6'b100011, 5'b00001, 5'b00010, 5'b00000, 5'b00000, 6'b000000};
        // lw $v1 4[$at]
        ins_memory[26] = {6'b100011, 5'b00001, 5'b00011, 5'b00000, 5'b00000, 6'b000100};
        // lw $a0 8[$at]
        ins_memory[27] = {6'b100011, 5'b00001, 5'b00100, 5'b00000, 5'b00000, 6'b001000};
        // lw $a1 12[$at]
        ins_memory[28] = {6'b100011, 5'b00001, 5'b00101, 5'b00000, 5'b00000, 6'b001100};
        // add $6 $2 $10
        ins_memory[29] = {6'b000000, 5'b00010, 5'b01010, 5'b00110, 5'b00000, 6'b100000};
    end
    
    always@(*)begin
        // Chop off the last two bits of pc because pc is byte addressed and instruction memory is word addressed
        nextIns = ins_memory[pc[31:2]];
    end

endmodule