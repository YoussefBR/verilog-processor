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


module WB(
    input mem_to_reg,
    input [31:0] alu_out,
    input [31:0] mem_out,
    
    output reg [31:0] wb_data
);

    always@(*)begin
        if(mem_to_reg)begin
            wb_data <= mem_out;
        end
        else begin
            wb_data <= alu_out;
        end
    end
endmodule