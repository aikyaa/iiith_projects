module Instruction_Memory(rst,A,RD);

  input rst;
  input [63:0]A;
  output [31:0]RD;

  reg [31:0] mem [0:1023]; //32-bit instructions
  reg [8*64:1] memfile;
  
  assign RD = (rst == 1'b0) ? {32{1'b0}} : mem[A[11:2]]; //word aligned

  integer i;
  initial begin
    for (i = 0; i < 1024; i = i + 1) begin
        mem[i] = 32'h00000000; //unused locations are NOPs (not X)
    end
    if (!$value$plusargs("MEM=%s", memfile))
        memfile = "mem/memfile.hex"; //memfile2,3,4 also attached (select with +MEM=mem/memfile2.hex)
    $readmemh(memfile,mem);
    //instruction is fetched based on pc value
  end

endmodule
