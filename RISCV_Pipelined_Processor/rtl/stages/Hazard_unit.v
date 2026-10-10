module hazard_unit(rst, RegWriteM, RegWriteW, RD_M, RD_W, Rs1_E, Rs2_E, ForwardAE, ForwardBE, ResultSrcE, RD_E, Rs1_D, Rs2_D, PCSrcE, StallF, StallD, FlushD, FlushE);

    // Declaration of I/Os
    input rst, RegWriteM, RegWriteW;
    input [4:0] RD_M, RD_W, Rs1_E, Rs2_E;
    output [1:0] ForwardAE, ForwardBE;
    input ResultSrcE, PCSrcE;
    input [4:0] RD_E, Rs1_D, Rs2_D;
    output StallF, StallD, FlushD, FlushE;

    wire lwStall;
    
    assign ForwardAE = (rst == 1'b0) ? 2'b00 : 
                       ((RegWriteM == 1'b1) & (RD_M != 5'h00) & (RD_M == Rs1_E)) ? 2'b10 :
                       ((RegWriteW == 1'b1) & (RD_W != 5'h00) & (RD_W == Rs1_E)) ? 2'b01 : 2'b00;
                       
    assign ForwardBE = (rst == 1'b0) ? 2'b00 : 
                       ((RegWriteM == 1'b1) & (RD_M != 5'h00) & (RD_M == Rs2_E)) ? 2'b10 :
                       ((RegWriteW == 1'b1) & (RD_W != 5'h00) & (RD_W == Rs2_E)) ? 2'b01 : 2'b00;

                       //00:No forwarding
                       //01:forward from writeback to execute
                       //10:forward from memory to execute

    // Load-use hazard: load in execute, its result needed by the instruction in decode
    assign lwStall = (rst == 1'b1) & (ResultSrcE == 1'b1) & (RD_E != 5'h00) & ((RD_E == Rs1_D) | (RD_E == Rs2_D));

    assign StallF = lwStall; //hold PC
    assign StallD = lwStall; //hold IF/ID
    assign FlushD = PCSrcE;  //branch taken: squash instruction in fetch
    assign FlushE = lwStall | PCSrcE; //insert bubble (load-use) / squash instruction in decode (branch taken)

endmodule
