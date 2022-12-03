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
    
    //wire [31:0] out_insToDecode;
    /*
    wire out_ewr_reg;
    wire out_emem_to_reg;
    wire out_ewr_mem;
    wire [3:0] out_ealu_op;
    wire [4:0] out_edest_reg;
    wire [31:0] out_eqa;
    wire [31:0] out_eqb;
    wire [31:0] out_eimm32;
    //
    wire out_mwr_reg;
    wire out_mmem_to_reg;
    wire out_mwr_mem;
    wire [4:0] out_mdest_reg;
    wire [31:0] out_mqb;
    wire [31:0] out_malu_out;
 
    wire out_wb_reg;
    wire [4:0] out_wb_dest;
    */
    wire [31:0] out_wb_data;
    
    initial begin
        clk = 1'b0;
    end
    
    always begin
        #1;
        clk = ~clk;
    end
    
    Processor proccessor(
        .clk(clk), 
        //.out_insToDecode(out_insToDecode),
        /*
        .out_ewr_reg(out_ewr_reg),
        .out_emem_to_reg(out_emem_to_reg),
        .out_ewr_mem(out_ewr_mem),
        .out_ealu_op(out_ealu_op),
        .out_edest_reg(out_edest_reg),
        .out_eqa(out_eqa),
        .out_eqb(out_eqb),
        .out_eimm32(out_eimm32),
        //
        .out_mwr_reg(out_mwr_reg),
        .out_mmem_to_reg(out_mmem_to_reg),
        .out_mwr_mem(out_mwr_mem),
        .out_mdest_reg(out_mdest_reg),
        .out_mqb(out_mqb),
        .out_malu_out(out_malu_out),
     
        .out_wb_reg(out_wb_reg),
        .out_wb_dest(out_wb_dest),
        */
        .out_wb_data(out_wb_data)
    );

endmodule
