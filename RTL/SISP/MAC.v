module MAC(clk, reset, data_1_1_in, data_2_1_in, data_3_1_in, data_4_1_in, data_5_1_in, data_6_1_in, data_7_1_in, 
           data_1_2_in, data_2_2_in, data_3_2_in, data_4_2_in, data_5_2_in, data_6_2_in, data_7_2_in,
           data_out, op, MAC_enable);
   input          clk, reset;
   input    [8:0] data_1_1_in, data_1_2_in;
   input    [8:0] data_2_1_in, data_2_2_in;
   input    [8:0] data_3_1_in, data_3_2_in;
   input    [8:0] data_4_1_in, data_4_2_in;
   input    [8:0] data_5_1_in, data_5_2_in;
   input    [8:0] data_6_1_in, data_6_2_in;
   input    [8:0] data_7_1_in, data_7_2_in;
   
   
   input          MAC_enable;
   input          op;//0:ABS SUB, 1: Mul
   
   output   [20:0]data_out;
   
   reg            op_r;
   reg      [20:0]data_out_r;
   
   reg      [8:0] data_1_1_in_r, data_1_2_in_r;
   reg      [8:0] data_2_1_in_r, data_2_2_in_r;
   reg      [8:0] data_3_1_in_r, data_3_2_in_r;
   reg      [8:0] data_4_1_in_r, data_4_2_in_r;
   reg      [8:0] data_5_1_in_r, data_5_2_in_r;
   reg      [8:0] data_6_1_in_r, data_6_2_in_r;
   reg      [8:0] data_7_1_in_r, data_7_2_in_r;
   
   reg      [17:0]fu_1_w, fu_2_w, fu_3_w, fu_4_w, fu_5_w, fu_6_w, fu_7_w;
   
   
   wire     [17:0]temp_fu_1_w, temp_fu_2_w, temp_fu_3_w, temp_fu_4_w, temp_fu_5_w, temp_fu_6_w, temp_fu_7_w;
   wire     [9:0] abs_fu_1_w, abs_fu_2_w, abs_fu_3_w, abs_fu_4_w, abs_fu_5_w, abs_fu_6_w, abs_fu_7_w;
   wire     [9:0] temp_abs_fu_1_w, temp_abs_fu_2_w, temp_abs_fu_3_w, temp_abs_fu_4_w, temp_abs_fu_5_w, temp_abs_fu_6_w, temp_abs_fu_7_w;
   
   wire     [8:0] abs_data_1_1_in_w, abs_data_1_2_in_w;
   wire     [8:0] abs_data_2_1_in_w, abs_data_2_2_in_w;
   wire     [8:0] abs_data_3_1_in_w, abs_data_3_2_in_w;
   wire     [8:0] abs_data_4_1_in_w, abs_data_4_2_in_w;
   wire     [8:0] abs_data_5_1_in_w, abs_data_5_2_in_w;
   wire     [8:0] abs_data_6_1_in_w, abs_data_6_2_in_w;
   wire     [8:0] abs_data_7_1_in_w, abs_data_7_2_in_w;
   
   
   
   
   
   wire     [20:0]data_out_w;
   
   
   assign abs_data_1_1_in_w = (data_1_1_in_r[8] == 1'b1) ? (~data_1_1_in_r + 9'd1) : data_1_1_in_r ;
   assign abs_data_2_1_in_w = (data_2_1_in_r[8] == 1'b1) ? (~data_2_1_in_r + 9'd1) : data_2_1_in_r ;
   assign abs_data_3_1_in_w = (data_3_1_in_r[8] == 1'b1) ? (~data_3_1_in_r + 9'd1) : data_3_1_in_r ;
   assign abs_data_4_1_in_w = (data_4_1_in_r[8] == 1'b1) ? (~data_4_1_in_r + 9'd1) : data_4_1_in_r ;
   assign abs_data_5_1_in_w = (data_5_1_in_r[8] == 1'b1) ? (~data_5_1_in_r + 9'd1) : data_5_1_in_r ;
   assign abs_data_6_1_in_w = (data_6_1_in_r[8] == 1'b1) ? (~data_6_1_in_r + 9'd1) : data_6_1_in_r ;
   assign abs_data_7_1_in_w = (data_7_1_in_r[8] == 1'b1) ? (~data_7_1_in_r + 9'd1) : data_7_1_in_r ; 
   
   assign abs_data_1_2_in_w = (data_1_2_in_r[8] == 1'b1) ? (~data_1_2_in_r + 9'd1) : data_1_2_in_r ;
   assign abs_data_2_2_in_w = (data_2_2_in_r[8] == 1'b1) ? (~data_2_2_in_r + 9'd1) : data_2_2_in_r ;
   assign abs_data_3_2_in_w = (data_3_2_in_r[8] == 1'b1) ? (~data_3_2_in_r + 9'd1) : data_3_2_in_r ;
   assign abs_data_4_2_in_w = (data_4_2_in_r[8] == 1'b1) ? (~data_4_2_in_r + 9'd1) : data_4_2_in_r ;
   assign abs_data_5_2_in_w = (data_5_2_in_r[8] == 1'b1) ? (~data_5_2_in_r + 9'd1) : data_5_2_in_r ;
   assign abs_data_6_2_in_w = (data_6_2_in_r[8] == 1'b1) ? (~data_6_2_in_r + 9'd1) : data_6_2_in_r ;
   assign abs_data_7_2_in_w = (data_7_2_in_r[8] == 1'b1) ? (~data_7_2_in_r + 9'd1) : data_7_2_in_r ; 
   
   
   
      
   
   assign data_out = data_out_r;
   assign temp_fu_1_w = abs_data_1_1_in_w * abs_data_1_2_in_w;
   assign temp_fu_2_w = abs_data_2_1_in_w * abs_data_2_2_in_w;
   assign temp_fu_3_w = abs_data_3_1_in_w * abs_data_3_2_in_w;
   assign temp_fu_4_w = abs_data_4_1_in_w * abs_data_4_2_in_w;
   assign temp_fu_5_w = abs_data_5_1_in_w * abs_data_5_2_in_w;
   assign temp_fu_6_w = abs_data_6_1_in_w * abs_data_6_2_in_w;
   assign temp_fu_7_w = abs_data_7_1_in_w * abs_data_7_2_in_w;
   
   
   assign temp_abs_fu_1_w = {data_1_1_in_r[8], data_1_1_in_r} - {data_1_2_in_r[8], data_1_2_in_r};
   assign temp_abs_fu_2_w = {data_2_1_in_r[8], data_2_1_in_r} - {data_2_2_in_r[8], data_2_2_in_r};
   assign temp_abs_fu_3_w = {data_3_1_in_r[8], data_3_1_in_r} - {data_3_2_in_r[8], data_3_2_in_r};
   assign temp_abs_fu_4_w = {data_4_1_in_r[8], data_4_1_in_r} - {data_4_2_in_r[8], data_4_2_in_r};
   assign temp_abs_fu_5_w = {data_5_1_in_r[8], data_5_1_in_r} - {data_5_2_in_r[8], data_5_2_in_r};
   assign temp_abs_fu_6_w = {data_6_1_in_r[8], data_6_1_in_r} - {data_6_2_in_r[8], data_6_2_in_r};
   assign temp_abs_fu_7_w = {data_7_1_in_r[8], data_7_1_in_r} - {data_7_2_in_r[8], data_7_2_in_r};
   
   assign abs_fu_1_w = temp_abs_fu_1_w[9] == 1'b0 ? temp_abs_fu_1_w : ~temp_abs_fu_1_w + 10'd1;
   assign abs_fu_2_w = temp_abs_fu_2_w[9] == 1'b0 ? temp_abs_fu_2_w : ~temp_abs_fu_2_w + 10'd1;
   assign abs_fu_3_w = temp_abs_fu_3_w[9] == 1'b0 ? temp_abs_fu_3_w : ~temp_abs_fu_3_w + 10'd1;
   assign abs_fu_4_w = temp_abs_fu_4_w[9] == 1'b0 ? temp_abs_fu_4_w : ~temp_abs_fu_4_w + 10'd1;
   assign abs_fu_5_w = temp_abs_fu_5_w[9] == 1'b0 ? temp_abs_fu_5_w : ~temp_abs_fu_5_w + 10'd1;
   assign abs_fu_6_w = temp_abs_fu_6_w[9] == 1'b0 ? temp_abs_fu_6_w : ~temp_abs_fu_6_w + 10'd1;
   assign abs_fu_7_w = temp_abs_fu_7_w[9] == 1'b0 ? temp_abs_fu_7_w : ~temp_abs_fu_7_w + 10'd1;
   
   assign data_out_w = ( {{3{fu_1_w[17]}}, fu_1_w} + {{3{fu_2_w[17]}}, fu_2_w}) + ( {{3{fu_3_w[17]}}, fu_3_w} + {{3{fu_4_w[17]}}, fu_4_w}) + ( {{3{fu_5_w[17]}}, fu_5_w} + {{3{fu_6_w[17]}}, fu_6_w} + {{3{fu_7_w[17]}}, fu_7_w});
   
   
   
   
   always@(*)
   begin
      if(op_r == 1'b0)
      begin
         fu_1_w = {{8{abs_fu_1_w[9]}}, abs_fu_1_w};
         fu_2_w = {{8{abs_fu_2_w[9]}}, abs_fu_2_w};
         fu_3_w = {{8{abs_fu_3_w[9]}}, abs_fu_3_w};
         fu_4_w = {{8{abs_fu_4_w[9]}}, abs_fu_4_w};
         fu_5_w = {{8{abs_fu_5_w[9]}}, abs_fu_5_w};
         fu_6_w = {{8{abs_fu_6_w[9]}}, abs_fu_6_w};
         fu_7_w = {{8{abs_fu_7_w[9]}}, abs_fu_7_w};
      
      end
      else
      begin
         if(data_1_1_in_r[8] ^ data_1_2_in_r[8] == 1'b1)fu_1_w = (~temp_fu_1_w + 1'b1);  else fu_1_w = temp_fu_1_w;
         if(data_2_1_in_r[8] ^ data_2_2_in_r[8] == 1'b1)fu_2_w = (~temp_fu_2_w + 1'b1);  else fu_2_w = temp_fu_2_w;
         if(data_3_1_in_r[8] ^ data_3_2_in_r[8] == 1'b1)fu_3_w = (~temp_fu_3_w + 1'b1);  else fu_3_w = temp_fu_3_w;
         if(data_4_1_in_r[8] ^ data_4_2_in_r[8] == 1'b1)fu_4_w = (~temp_fu_4_w + 1'b1);  else fu_4_w = temp_fu_4_w;
         if(data_5_1_in_r[8] ^ data_5_2_in_r[8] == 1'b1)fu_5_w = (~temp_fu_5_w + 1'b1);  else fu_5_w = temp_fu_5_w;
         if(data_6_1_in_r[8] ^ data_6_2_in_r[8] == 1'b1)fu_6_w = (~temp_fu_6_w + 1'b1);  else fu_6_w = temp_fu_6_w;
         if(data_7_1_in_r[8] ^ data_7_2_in_r[8] == 1'b1)fu_7_w = (~temp_fu_7_w + 1'b1);  else fu_7_w = temp_fu_7_w;
         
      end
   
   end
   
   
   
   
   always@(posedge clk or posedge reset)
   begin
      if(reset)
      begin
         data_out_r <= 21'd0;
         data_1_1_in_r <= 9'd0;
         data_2_1_in_r <= 9'd0;
         data_3_1_in_r <= 9'd0;
         data_4_1_in_r <= 9'd0;
         data_5_1_in_r <= 9'd0;
         data_6_1_in_r <= 9'd0;
         data_7_1_in_r <= 9'd0;
         data_1_2_in_r <= 9'd0;
         data_2_2_in_r <= 9'd0;
         data_3_2_in_r <= 9'd0;
         data_4_2_in_r <= 9'd0;
         data_5_2_in_r <= 9'd0;
         data_6_2_in_r <= 9'd0;
         data_7_2_in_r <= 9'd0;
         
         
         
         op_r <= 1'b0;
         
      end
      else if(MAC_enable)
      begin
         data_out_r <= data_out_w;
         data_1_1_in_r <= data_1_1_in;
         data_2_1_in_r <= data_2_1_in;
         data_3_1_in_r <= data_3_1_in;
         data_4_1_in_r <= data_4_1_in;
         data_5_1_in_r <= data_5_1_in;
         data_6_1_in_r <= data_6_1_in;
         data_7_1_in_r <= data_7_2_in;
         data_1_2_in_r <= data_1_2_in;
         data_2_2_in_r <= data_2_2_in;
         data_3_2_in_r <= data_3_2_in;
         data_4_2_in_r <= data_4_2_in;
         data_5_2_in_r <= data_5_2_in;
         data_6_2_in_r <= data_6_2_in;
         data_7_2_in_r <= data_7_2_in;
         
         
         op_r <= op;
      
      end
   
   end


endmodule