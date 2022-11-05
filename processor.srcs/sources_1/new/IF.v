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

module PCAdder(
    input [31:0] PC,
    output reg [31:0] nextPC
);

    localparam WORD_SIZE = 4;
    
    always@(*)begin
        nextPC = PC + 32'(WORD_SIZE);
    end

endmodule