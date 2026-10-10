module Sign_Extend (In,ImmSrc,Imm_Ext);
    input [31:0] In;
    input [1:0] ImmSrc;
    output [63:0] Imm_Ext;

    assign Imm_Ext = (ImmSrc == 2'b00) ? {{52{In[31]}}, In[31:20]} :  // I-Type
                     (ImmSrc == 2'b01) ? {{52{In[31]}}, In[31:25], In[11:7]} :  // S-Type
                     (ImmSrc == 2'b10) ? {{52{In[31]}}, In[31], In[7], In[30:25], In[11:8]} :  // B-Type (imm[12:1], shifted left by 1 later)
                     64'h0000000000000000;  // Default case
endmodule
