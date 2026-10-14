`timescale 1ns/1ps

module cla_tb;

    reg [3:0] A, B;
    reg Cin, clk, reset;

    wire [3:0] S;
    wire Cout;

    cla uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .clk(clk),
        .reset(reset),
        .S(S),
        .Cout(Cout)
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0; 
        reset = 1;
        A = 4'b0;
        B = 4'b0;
        Cin = 1'b0;

        #20;
        reset = 0; 

        #20;
        A = 4'b0001;
        B = 4'b0011;

        #20;
        A = 4'b0000;
        B = 4'b0000;
        #20;
        A = 4'b1100;
        B = 4'b0011;

        #50;
        $finish;
    end

    initial begin
        $monitor("Time: %0t | A: %b | B: %b | Cin: %b | S: %b | Cout: %b",
                 $time, A, B, Cin, S, Cout);
    end

    initial begin
        $dumpfile("cla_tb.vcd");
        $dumpvars(0, cla_tb);   
    end

endmodule
