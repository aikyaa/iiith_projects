`timescale 1ns/1ps

module cla (
    input [3:0] A,
    input [3:0] B,
    input wire Cin,clk,
    output [3:0] PS,
    output PCout,
    output reg [3:0] S,
    output reg Cout
);

    wire [3:0] G;
    wire [3:0] P;
    wire [3:0] AxB;
    wire [3:0] Sb;
    reg [3:0] An;
    reg [3:0] Bn;
    reg Cn;

    
    wire C0, C0not, C1, C2, C3, C4, Gout, c1b, c2b, c3b, c4b;
    wire c1bnot, c2midnor, c2midand, c3midnor, c3midand, midnor, midand,midor;
    wire c2midnand, c3midnand, midnand,c2midor, c3midor,Pout;

    always @(posedge clk) begin
            An <= A;
            Bn<= B;
            Cn<= Cin;
    end

    nand (G[3], An[3], Bn[3]);
    nand (G[2], An[2], Bn[2]);
    nand (G[1], An[1], Bn[1]);
    nand (G[0], An[0], Bn[0]);

    nor (P[3], An[3], Bn[3]);
    nor (P[2], An[2], Bn[2]);
    nor (P[1], An[1], Bn[1]);
    nor (P[0], An[0], Bn[0]);

    xor (AxB[3], An[3], Bn[3]);
    xor (AxB[2], An[2], Bn[2]);
    xor (AxB[1], An[1], Bn[1]);
    xor (AxB[0], An[0], Bn[0]);


    assign C0 = Cn;
    
    not (C0not, C0);               
    or (c1b, P[0], C0not);               
    nand (C1, G[0], c1b); 

    or (c2b, P[1], G[0]);                 
    nand (c2midnand, G[1], c2b);        
    nor (c2midnor, P[0], P[1]);             
    and (c2midand, C0, c2midnor);     
    or (C2, c2midnand, c2midand); 

    nor (c3midnor, P[2], P[1]);           
    or (c3midor, P[2], G[1]);             
    nand (c3midnand, G[2], c3midor);    
    and (c3midand, C1, c3midnor);            
    or (C3, c3midnand, c3midand);  

    nor (midnor, P[3], P[2]);
    or (midor, P[3], G[2]);
    nand (midnand, G[3], midor);
    and ( midand, c2midnand, midnor);
    or (Gout, midnand, midand);
    nand (Pout, c2midnor, midnor);

    nor (c4b,Pout, C0not);
    or (C4, Gout, c4b);  

    xor (Sb[3], AxB[3], C3);          
    xor (Sb[2], AxB[2], C2);             
    xor (Sb[1], AxB[1], C1);              
    xor (Sb[0], AxB[0], C0);     
    
    always @(posedge clk) begin
            S <= Sb;
            Cout <= C4;
    end

    assign PS = S;
    assign PCout = Cout;

endmodule
