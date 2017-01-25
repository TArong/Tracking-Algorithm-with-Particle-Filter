module CCA(clk, reset, 
           Imid_0_in, Imid_1_in, //segmentation in
           Dmid_0_in, Dmid_1_in, Dtemp_0_in, //data in (7 bits)
           Dout_0_out, //OUTPUT
           PE_temp_0_out, temp_out_0_in, Dtemp_1_in, //給alu去比大小
           Dout_1_out, //OUTPUT
           PE_temp_1_out, temp_out_1_in, Dout_0_out_w, //給alu去比大小
           CCA_enable);
   input             clk, reset;
   input             CCA_enable;
   input    [15:0]   Dtemp_0_in;
   input             Imid_0_in, Imid_1_in;
   
   //input    [6:0]    PE_temp_0_out;
   input    [15:0]   temp_out_0_in;
   input    [15:0]   Dtemp_1_in;
   input    [6:0]    Dmid_0_in, Dmid_1_in;
   
   //input    [6:0]    PE_temp_1_out;
   input    [15:0]   temp_out_1_in;
   
   output   [6:0]    Dout_0_out_w, Dout_0_out, Dout_1_out;
   output   [6:0]    PE_temp_0_out, PE_temp_1_out;
/*   input             Iup, Ileft, Imid;
   input    [6:0]    Dup, Dleft, Dmid;
   input    [15:0]   Dtemp_in, temp_out_in;
   output   [6:0]    Dout;
   output   [6:0]    PE_temp_out;
*/   
   
   wire     [15:0]   Dtemp_0_w;
   wire     [6:0]    PE_temp_0_w;
   wire     [6:0]    PE_Count_0_w;
   wire     [15:0]   temp_out_0_w;
   wire     [6:0]    Dout_0_w;
   wire     [15:0]   Dtemp_1_w;
   wire     [6:0]    PE_temp_1_w;
   wire     [15:0]   temp_out_1_w;
   wire     [6:0]    Dout_1_w;
   wire     [6:0]    PE_Count_1_w;
   
   //reg               Iup_r, Ileft_r, Imid_r;
   //reg      [6:0]    Dup_r, Dleft_r, Dmid_r;
   reg      [6:0]    Dout_0_r, Dout_1_r;
   reg      [6:0]    PE_Count_0_r, PE_Count_1_r;
   
   
   
   
   assign Dout_0_out = Dout_0_r;
   assign Dout_1_out = Dout_1_r;
   assign PE_Count_0_w = (Dtemp_0_w[7] == 1'b0 && Imid_0_in == 1'b1 && Dmid_0_in == 7'd0) ? PE_Count_0_r - 7'd2 : PE_Count_0_r;
   assign PE_Count_1_w = (Dtemp_1_w[7] == 1'b0 && Imid_1_in == 1'b1 && Dmid_1_in == 7'd0) ? PE_Count_1_r - 7'd2 : PE_Count_1_r;
   assign PE_temp_0_w = (Dtemp_0_w[7] == 1'b1) ? Dtemp_0_w[6:0] : PE_Count_0_r;
   assign Dout_0_w = (Imid_0_in == 1'b1)? temp_out_0_w[6:0] : 6'd0;
   assign temp_out_0_w = temp_out_0_in;
   assign Dtemp_0_w = Dtemp_0_in;
   assign PE_temp_0_out = PE_temp_0_w;
   assign PE_temp_1_out = PE_temp_1_w;
   
   assign PE_temp_1_w = (Dtemp_1_w[7] == 1'b1) ? Dtemp_1_w[6:0] : PE_Count_1_r;
   assign Dout_1_w = (Imid_1_in == 1'b1)? temp_out_1_w[6:0] : 6'd0;
   assign temp_out_1_w = temp_out_1_in;
   assign Dtemp_1_w = Dtemp_1_in;
   assign Dout_0_out_w = Dout_0_w;
   
/*    //ALU的接法示意
   ALU a0(.clk(clk), 
          .reset(reset), 
          .data_1_in({Iup_r, Dup_r}), 
          .data_2_in({Ileft_r, Dleft_r}), 
          .input_select(1'b0), 
          .selector(4'd9), 
          .data_out(Dtemp_w), 
          .ALU_enable(CCA_enable)
          );
          
   ALU a1(.clk(clk), 
          .reset(reset), 
          .data_1_in({1'b0, Dmid_r}), 
          .data_2_in({1'b0, PE_temp_w}), 
          .input_select(1'b0), 
          .selector(4'd9), 
          .data_out(temp_out_w), 
          .ALU_enable(CCA_enable)
          );       
*/   
//   wire gclk = clk & CCA_enable;
   always@(posedge clk or posedge reset)
   begin
      if(reset)
      begin
         Dout_0_r <= 7'd0;
         Dout_1_r <= 7'd0;
         PE_Count_0_r <= 7'd127;
         PE_Count_1_r <= 7'd126;
      end
      else if(CCA_enable)
      begin
         Dout_0_r <= Dout_0_w;
         Dout_1_r <= Dout_1_w;
         PE_Count_0_r <= PE_Count_0_w;
         PE_Count_1_r <= PE_Count_1_w;
      end
   
   end




endmodule