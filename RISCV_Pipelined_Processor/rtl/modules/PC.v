module PC_Module(clk,rst,en,PC,PC_Next);
    input clk,rst,en;
    input [63:0]PC_Next;
    output [63:0]PC;
    reg [63:0]PC;

    always @(posedge clk or negedge rst)
    begin
        if(rst == 1'b0)
            PC <= {64{1'b0}};
        else if(en)
            PC <= PC_Next;
    end
endmodule
