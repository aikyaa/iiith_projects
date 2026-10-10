module Data_Memory(clk,rst,WE,WD,A,RD);

    input clk,rst,WE;
    input [63:0]A,WD;//memory address, write data
    output [63:0]RD;//data read from mem

    reg [63:0] mem [1023:0]; //1024 x 64-bit doublewords (8KB)

    //writeback
    always @ (posedge clk)
    begin
        if(WE)
            mem[A[12:3]] <= WD; 
    end

    assign RD = (~rst) ? 64'd0 : mem[A[12:3]];

    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            mem[i] = 64'd0; //initializing to zero
        end
    end


endmodule
