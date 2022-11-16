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
    input clk,
    
    output [31:0] out_insToDecode,
    output out_wr_reg,
    output out_mem_to_reg,
    output out_wr_mem,
    output [3:0] out_alu_op,
    output [4:0] out_dest_reg,
    output [31:0] out_qa,
    output [31:0] out_qb,
    output [31:0] out_imm32
);

    // PC init
    wire [31:0] nextPc;
    wire [31:0] pc;
    Program_Counter programCount(
        // Inputs
        .nextPc ( nextPc ),
        .clk    ( clk    ),
        // Outputs
        .pc     ( pc     )
    );
    
    // IF init
    wire [31:0] IF_pc = pc;
    wire [31:0] IF_nextPc;
    assign nextPc = IF_nextPc;
    wire [31:0] nextIns;

    IF insFetch(
        // Inputs
        .pc         ( IF_pc     ),
        // Outputs
        .nextPc     ( IF_nextPc ),
        .nextIns    ( nextIns   )
    );
    
    // IFIDPipeReg init
    wire [31:0] insToDecode;

    IF_ID_PipeReg IF_ID_Pipe(
        // Inputs
        .nextIns        ( nextIns     ),
        .clk            ( clk         ),
        // Outputs
        .insToDecode    ( insToDecode )
    );
    
    // ID init
    wire wr_reg;
    wire mem_to_reg;
    wire wr_mem;
    wire alu_imm;
    wire [3:0] alu_op;
    wire [4:0] dest_reg;
    wire [31:0] qa;
    wire [31:0] qb;
    wire [31:0] imm32;
   
    wire wb_reg;
    wire [4:0] wb_dest;
    wire [31:0] wb_result;

    ID insDecode(
        // Inputs
        .insToDecode    ( insToDecode   ),
        .wb_reg         ( wb_reg        ),
        .wb_dest        ( wb_dest       ),
        .wb_result      ( wb_result     ),
        // Outputs
        .wr_reg         ( wr_reg        ),
        .mem_to_reg     ( mem_to_reg    ),
        .wr_mem         ( wr_mem        ),
        .alu_op         ( alu_op        ),
        .alu_imm        ( alu_imm       ),
        .dest_reg       ( dest_reg      ),
        .qa             ( qa            ),
        .qb             ( qb            ),
        .imm32          ( imm32         )
    );
    
    // IDEXEPipeReg init
    wire ewr_reg;
    wire emem_to_reg;
    wire ewr_mem;
    wire ealu_imm;
    wire [3:0] ealu_op;
    wire [4:0] edest_reg;
    wire [31:0] eqa;
    wire [31:0] eqb;
    wire [31:0] eimm32;

    ID_EXE_PipeReg ID_EXE_Pipe(
        // Inputs
        .clk            ( clk         ),
        .wr_reg         ( wr_reg      ),
        .mem_to_reg     ( mem_to_reg  ),
        .wr_mem         ( wr_mem      ),
        .alu_op         ( alu_op      ),
        .alu_imm        ( alu_imm     ),
        .dest_reg       ( dest_reg    ),
        .qa             ( qa          ),
        .qb             ( qb          ),
        .imm32          ( imm32       ),
        // Outputs
        .ewr_reg        ( ewr_reg     ),
        .emem_to_reg    ( emem_to_reg ),
        .ewr_mem        ( ewr_mem     ),
        .ealu_op        ( ealu_op     ),
        .ealu_imm       ( ealu_imm    ),
        .edest_reg      ( edest_reg   ),
        .eqa            ( eqa         ),
        .eqb            ( eqb         ),
        .eimm32         ( eimm32      )
    );

    // Makeshift WB until implemented, should be the memory versions of these vars not the exe versions.
    reg [31:0] result;
    always@(*)begin
        if(mem_to_reg)begin
            // We chop off the last two bits bc data memory is word addressed and aluResult is byte addressed
            result = data_memory[aluResult[31:2]];
        end
        else begin
            result = aluResult;
        end
    end

    MEM_WB_PipeReg MEM_WB_Pipe(
        // Inputs
        .clk        ( clk       ),
        .wr_reg     ( ewr_reg   ),
        .dest_reg   ( edest_reg ),
        .result     ( result    ),
        // Outputss
        .wb_reg     ( wb_reg    ),
        .wb_dest    ( wb_dest   ),
        .wb_result  ( wb_result )
    );
    
    assign out_insToDecode = insToDecode;
    assign out_wr_reg = ewr_reg;
    assign out_mem_to_reg = emem_to_reg;
    assign out_wr_mem = ewr_mem;
    assign out_alu_op = ealu_op;
    assign out_dest_reg = edest_reg;
    assign out_qa = eqa;
    assign out_qb = eqb;
    assign out_imm32 = eimm32;

endmodule

// Sequential - Updates the pc at the start of every new cycle
module Program_Counter(
    input [31:0] nextPc,
    input clk,
    output reg [31:0] pc
);

    always@(posedge clk)begin
        pc <= nextPc;
    end

endmodule

// Sequential - Stores and passes necessary values from IF to ID at the start of each cycle
module IF_ID_PipeReg(
    input [31:0] nextIns,
    input clk,

    output reg [31:0] insToDecode
);

    always@(posedge clk)begin
        insToDecode <= nextIns;
    end

endmodule

// Sequential - Stores and passes necessary values from ID to EXE at the start of each cycle
module ID_EXE_PipeReg(
    input clk,
    input wr_reg,
    input mem_to_reg,
    input wr_mem,
    input alu_imm,
    input [3:0] alu_op,
    input [4:0] dest_reg,
    input [31:0] qa,
    input [31:0] qb,
    input [31:0] imm32,

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

// Sequential - Stores and passes necessary values from MEM to WB and updates at the start of each cycle (unfinished & makeshift)
module MEM_WB_PipeReg(
    input clk,
    input wr_reg,
    input [4:0] dest_reg,
    input [31:0] result,

    output reg wb_reg,
    output reg [4:0] wb_dest,
    output reg [31:0] wb_result
);
    // Temporarily set to when result changes even though this should be on clk just to give mem enough time to finish.
    always@(*)begin
        if(wr_reg)begin
            wb_reg <= wr_reg;
            wb_dest <= dest_reg;
            wb_result <= result;
        end
    end

endmodule