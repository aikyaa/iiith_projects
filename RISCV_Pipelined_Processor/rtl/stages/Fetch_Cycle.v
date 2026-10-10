
module fetch_cycle(clk, rst, PCSrcE, PCTargetE, StallF, StallD, FlushD, InstrD, PCD, PCPlus4D);

    input clk, rst;
    input StallF, StallD, FlushD; //hazard unit controls (stall PC / IF-ID, flush IF-ID)
    input PCSrcE;
    input [63:0] PCTargetE;
    output [31:0] InstrD;
    output [63:0] PCD, PCPlus4D;

    wire [63:0] PC_F, PCF, PCPlus4F;
    wire [31:0] InstrF;
    reg [31:0] InstrF_reg;
    reg [63:0] PCF_reg, PCPlus4F_reg;


    // Initiation of Modules

    Mux PC_MUX (.a(PCPlus4F),
                .b(PCTargetE),
                .s(PCSrcE),
                .c(PC_F) //selecting PC
                );


    PC_Module Program_Counter (
                .clk(clk),
                .rst(rst),
                .en(~StallF),
                .PC(PCF),
                .PC_Next(PC_F) //updating PC
                );


    Instruction_Memory IMEM (
                .rst(rst),
                .A(PCF),
                .RD(InstrF) //getting 32-bit instruction from instruction memory
                );


    PC_Adder PC_adder (
                .a(PCF),
                .b(64'h00000004),
                .c(PCPlus4F) //PC+4
                );

    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            InstrF_reg <= 32'h00000000;
            PCF_reg <= 64'h00000000;
            PCPlus4F_reg <= 64'h00000000;
        end
        else if(FlushD) begin
            InstrF_reg <= 32'h00000000; //squash wrong-path instruction
            PCF_reg <= 64'h00000000;
            PCPlus4F_reg <= 64'h00000000;
        end
        else if(~StallD) begin
            InstrF_reg <= InstrF;
            PCF_reg <= PCF;
            PCPlus4F_reg <= PCPlus4F;
        end
    end


    //after IF/ID
    assign  InstrD = (rst == 1'b0) ? 32'h00000000 : InstrF_reg;
    assign  PCD = (rst == 1'b0) ? 64'h00000000 : PCF_reg;
    assign  PCPlus4D = (rst == 1'b0) ? 64'h00000000 : PCPlus4F_reg;


endmodule
