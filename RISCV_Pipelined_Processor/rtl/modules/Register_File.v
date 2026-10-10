module Register_File(clk,rst,WE3,WD3,A1,A2,A3,RD1,RD2);

    input clk,rst,WE3;
    input [4:0]A1,A2,A3;
    input [63:0]WD3;
    output [63:0]RD1,RD2;

    reg [63:0] Register [31:0];

    always @ (posedge clk)
    begin
        if(WE3 & (A3 != 5'h00))
            Register[A3] <= WD3;
    end

    assign RD1 = (rst==1'b0) ? 64'd0 : (WE3 & (A3 != 5'h00) & (A3 == A1)) ? WD3 : Register[A1];
    assign RD2 = (rst==1'b0) ? 64'd0 : (WE3 & (A3 != 5'h00) & (A3 == A2)) ? WD3 : Register[A2];

    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            Register[i] = 64'h00000000; //initializing to zero
        end
    end

endmodule
