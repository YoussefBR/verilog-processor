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


module EXE(

    );
endmodule

module ALU_In_Mux(
    input               ealu_imm,
    input       [31:0]  eqb,
    input       [31:0]  eimm32,
    
    output reg  [31:0]  b
);

    always@(*)begin
        if(ealu_imm)begin
            b = eimm32;
        end
        else begin
            b = eqb;
        end
    end

endmodule
