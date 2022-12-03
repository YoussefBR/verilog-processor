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
    
    //output [31:0] out_insToDecode,
    /*
    output out_ewr_reg,
    output out_emem_to_reg,
    output out_ewr_mem,
    output [3:0] out_ealu_op,
    output [4:0] out_edest_reg,
    output [31:0] out_eqa,
    output [31:0] out_eqb,
    output [31:0] out_eimm32,
    //
    output out_mwr_reg,
    output out_mmem_to_reg,
    output out_mwr_mem,
    output [4:0] out_mdest_reg,
    output [31:0] out_mqb,
    output [31:0] out_malu_out,
    
    output out_wb_reg,
    output [4:0] out_wb_dest,
    */
    output [31:0] out_wb_data
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
    wire [31:0] wb_data;

    ID insDecode(
        // Inputs
        .clk            ( clk           ),
        .insToDecode    ( insToDecode   ),
        .wb_reg         ( wb_reg        ),
        .wb_dest        ( wb_dest       ),
        .wb_data        ( wb_data       ),
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

    // EXE init
    wire [31:0] alu_out;

    EXE execute(
        // Inputs
        .alu_imm(ealu_imm),
        .alu_op(ealu_op),
        .qa(eqa),
        .qb(eqb),
        .imm32(eimm32),

        // Outputs
        .alu_out(alu_out)
    );

    // Init EXE_MEM_Pipe
    wire mwr_reg;
    wire mmem_to_reg;
    wire mwr_mem;
    wire [4:0] mdest_reg;
    wire [31:0] mqb;
    wire [31:0] malu_out;

    EXE_MEM_PipeReg EXE_MEM_Pipe(
        // Inputs
        .clk(clk),
        .ewr_reg(ewr_reg),
        .emem_to_reg(emem_to_reg),
        .ewr_mem(ewr_mem),
        .edest_reg(edest_reg),
        .eqb(eqb),
        .alu_out(alu_out),

        // Outputs
        .mwr_reg(mwr_reg),
        .mmem_to_reg(mmem_to_reg),
        .mwr_mem(mwr_mem),
        .mdest_reg(mdest_reg),
        .mqb(mqb),
        .malu_out(malu_out)
    );

    // Init MEM
    wire [31:0] mem_out;

    MEM memory(
        // Inputs
        .clk(clk),
        .wr_mem(mwr_mem),
        .alu_out(malu_out),
        .qb(mqb),

        // Outputs
        .mem_out(mem_out)
    );

    // Init MEM_WB_Pipe
    wire wb_mem_to_reg;
    wire [31:0] wb_alu_out;
    wire [31:0] wb_mem_out;

    MEM_WB_PipeReg MEM_WB_Pipe(
        // Inputs
        .clk        ( clk         ),
        .wr_reg     ( mwr_reg     ),
        .mem_to_reg ( mmem_to_reg ),
        .dest_reg   ( mdest_reg   ),
        .alu_out    ( malu_out    ),
        .mem_out    ( mem_out     ),

        // Outputs
        .wb_reg     ( wb_reg    ),
        .wb_mem_to_reg ( wb_mem_to_reg ),
        .wb_dest    ( wb_dest   ),
        .wb_alu_out  ( wb_alu_out ),
        .wb_mem_out (wb_mem_out)
    );

    // Init WB


    WB writeBack(
        // Inputs
        .mem_to_reg(wb_mem_to_reg),
        .alu_out(wb_alu_out),
        .mem_out(wb_mem_out),

        // Outputs 
        .wb_data(wb_data)
    );
    
    /* IF_ID
    assign out_insToDecode = insToDecode;
    // ID_EXE
    assign out_ewr_reg = ewr_reg;
    assign out_emem_to_reg = emem_to_reg;
    assign out_ewr_mem = ewr_mem;
    assign out_ealu_op = ealu_op;
    assign out_edest_reg = edest_reg;
    assign out_eqa = eqa;
    assign out_eqb = eqb;
    assign out_eimm32 = eimm32;
    // EXE_MEM
    assign out_mwr_reg = mwr_reg;
    assign out_mmem_to_reg = mmem_to_reg;
    assign out_mwr_mem = mwr_mem;
    assign out_mdest_reg = mdest_reg;
    assign out_mqb = mqb;
    assign out_malu_out = malu_out;
    // MEM_WB
    assign out_wb_reg = wb_reg;
    assign out_wb_dest = wb_dest;
    */
    assign out_wb_data = wb_data;

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

// Sequential - Stores and passes necessary values from EXE to MEM and updates at the start of each cycle
module EXE_MEM_PipeReg(
    input clk,
    input ewr_reg,
    input emem_to_reg,
    input ewr_mem,
    input [4:0] edest_reg,
    input [31:0] alu_out,
    input [31:0] eqb,

    output reg mwr_reg,
    output reg mmem_to_reg,
    output reg mwr_mem,
    output reg [4:0] mdest_reg,
    output reg [31:0] malu_out,
    output reg [31:0] mqb
);

    always@(posedge clk)begin
        mwr_reg <= ewr_reg;
        mmem_to_reg <= emem_to_reg;
        mwr_mem <= ewr_mem;
        mdest_reg <= edest_reg;
        malu_out <= alu_out;
        mqb <= eqb;
    end

endmodule

// Sequential - Stores and passes necessary values from MEM to WB and updates at the start of each cycle
module MEM_WB_PipeReg(
    input clk,
    input wr_reg,
    input mem_to_reg,
    input [4:0] dest_reg,
    input [31:0] alu_out,
    input [31:0] mem_out,

    output reg wb_reg,
    output reg wb_mem_to_reg,
    output reg [4:0] wb_dest,
    output reg [31:0] wb_alu_out,
    output reg [31:0] wb_mem_out
);
    always@(posedge clk)begin
        wb_reg <= wr_reg;
        wb_mem_to_reg <= mem_to_reg;
        wb_dest <= dest_reg;
        wb_alu_out <= alu_out;
        wb_mem_out <= mem_out;
    end

endmodule