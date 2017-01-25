module ReconfigurableRegisterRSPE(clk, reset, data_in, data_out, Register_enable);
   input           clk, reset;
   input    [63:0] data_in;
   input           Register_enable;
   output   [87:0] data_out;
   reg      [87:0] data_out;
   
   always@(posedge clk or posedge reset)
   begin
      if(reset)
         data_out <= 88'd0;
      else if(Register_enable)
      begin
         data_out[87:64] <= data_out[23:0];
         data_out[63:0]  <= data_in[63:0];
      
      end
   
   end
   


endmodule