`timescale 1ns/1ps

module cla_tb;

    // Inputs
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    reg clk;

    // Outputs
    wire [3:0] PS;
    wire PCout;
    wire [3:0] S;
    wire Cout;

    // Instantiate the CLA module
    cla uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .clk(clk),
        .PS(PS),
        .PCout(PCout),
        .S(S),
        .Cout(Cout)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test sequence
    initial begin
        // Monitor the outputs
        $monitor("Time: %0dns | A: %b | B: %b | Cin: %b | S: %b | Cout: %b",
                 $time, A, B, Cin, S, Cout);

        // Initialize inputs
        A = 4'b0000;
        B = 4'b0000;
        Cin = 1'b0;

        // Apply test cases
        #10 A = 4'b0001; B = 4'b0010; Cin = 1'b0; // Test case 1
        #10 A = 4'b1111; B = 4'b0001; Cin = 1'b0; // Test case 2
        #10 A = 4'b1010; B = 4'b0101; Cin = 1'b1; // Test case 3
        #10 A = 4'b0110; B = 4'b1001; Cin = 1'b0; // Test case 4
        #10 A = 4'b1100; B = 4'b0011; Cin = 1'b1; // Test case 5

        // End simulation
        #20 $finish;
    end

endmodule
