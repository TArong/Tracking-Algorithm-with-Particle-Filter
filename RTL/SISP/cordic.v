module cordic(clk, reset, 
              x, y, z, //input  Z是角度
              xn, yn, zn, //output  小數點在第16~17bit中間  ([16]~[15]間)
              choose, //0:rotation mode(把角度轉到0)  1:vector mode(把y轉到0)
              cordic_enable
              /*, loop*/);  //固定做五個loop
   //input-> x -> x1 -> x2 -> x3 -> x4 -> x5 -> xn -> output  切pipeline
   input             clk, reset;
   input    [31:0]   x, y, z;
   input             choose;
   input             cordic_enable;
   //input             loop;
   //input    [5:0]    bitpoint;
   output   [31:0]   xn, yn, zn;
   
   reg              d_0_w, d_0_r;
   reg              d_1_w, d_1_r;
   reg              d_2_w, d_2_r;
   reg              d_3_w, d_3_r;
   reg              d_4_w, d_4_r;
   
   //reg              loop_r;
   
   reg      [31:0]   xn, yn, zn, an;
   reg      [31:0]   x_r, y_r, z_r;
   
   reg      [31:0]   x1_w, y1_w, z1_w;
   reg      [31:0]   x1_r, y1_r, z1_r;
   reg      [31:0]   x2_w, y2_w, z2_w;
   reg      [31:0]   x2_r, y2_r, z2_r;
   reg      [31:0]   x3_w, y3_w, z3_w;
   reg      [31:0]   x3_r, y3_r, z3_r;
   reg      [31:0]   x4_r, y4_r, z4_r;
   reg      [31:0]   x4_w, y4_w, z4_w;
   reg      [31:0]   x5_w, y5_w, z5_w;
   reg      [31:0]   x5_r, y5_r, z5_r;
   reg      [31:0]   xn_w, yn_w, zn_w;
   
   reg      [31:0]   xn_r, yn_r;//, zn_r;
   reg      [47:0]   xn_temp_w, yn_temp_w, zn_temp_w;
   wire      [47:0]   xn_temp2_w, yn_temp2_w;
   wire      [31:0]   xn_temp3_w, yn_temp3_w;
   reg               choose_r;
   wire      [32:0]   x1_temp_w, y1_temp_w;
   reg       [32:0]   x1_temp_r, y1_temp_r;
   wire      [33:0]   x2_temp_w, y2_temp_w;
   reg      [33:0]   x2_temp_r, y2_temp_r;
   wire      [34:0]   x3_temp_w, y3_temp_w;
   reg       [34:0]   x3_temp_r, y3_temp_r;
   reg       [35:0]   x4_temp_r, y4_temp_r;
   wire      [35:0]   x4_temp_w, y4_temp_w;
   wire      [36:0]   x5_temp_w, y5_temp_w;
   reg       [36:0]   x5_temp_r, y5_temp_r;
/*   wire      [37:0]   x6_temp_w, y6_temp_w;
   wire      [38:0]   x7_temp_w, y7_temp_w;
   wire      [39:0]   x8_temp_w, y8_temp_w;
   reg       [40:0]   x9_temp_r, y9_temp_r;
   wire      [40:0]   x9_temp_w, y9_temp_w;
  */ 
   
   assign x1_temp_w = {x1_w[31],x1_w};
   assign y1_temp_w = {y1_w[31],y1_w};
   assign x2_temp_w = {{2{x2_w[31]}},x2_w};
   assign y2_temp_w = {{2{y2_w[31]}},y2_w};
   assign x3_temp_w = {{3{x3_w[31]}},x3_w};
   assign y3_temp_w = {{3{y3_w[31]}},y3_w};      
   assign x4_temp_w = {{4{x4_w[31]}},x4_w};
   assign y4_temp_w = {{4{y4_w[31]}},y4_w};      
   assign x5_temp_w = {{5{x_r[31]}},x_r};
   assign y5_temp_w = {{5{y_r[31]}},y_r};
/*   assign x6_temp_w = {{6{x1_w[31]}},x1_w};
   assign y6_temp_w = {{6{y1_w[31]}},y1_w};
   assign x7_temp_w = {{7{x2_w[31]}},x2_w};
   assign y7_temp_w = {{7{y2_w[31]}},y2_w};
   assign x8_temp_w = {{8{x3_w[31]}},x3_w};
   assign y8_temp_w = {{8{y3_w[31]}},y3_w};
   assign x9_temp_w = {{9{x4_w[31]}},x4_w};
   assign y9_temp_w = {{9{y4_w[31]}},y4_w};    
 */  
   
   assign xn_temp3_w = (xn_r[31] == 1'b0)?xn_r:(~xn_r+32'd1);                 
   assign yn_temp3_w = (yn_r[31] == 1'b0)?yn_r:(~yn_r+32'd1);     
   assign xn_temp2_w = (xn_r[31] == 1'b0)?xn_temp_w:(~xn_temp_w + 48'd1);
   assign yn_temp2_w = (yn_r[31] == 1'b0)?yn_temp_w:(~yn_temp_w + 48'd1);
   
   always@(*)
   begin

      
         xn_temp_w = xn_temp3_w * 16'h9B8F;
         yn_temp_w = yn_temp3_w * 16'h9B8F;
      
      

      
   end


//這個部份是改變原本的cordic運算  在vector mode時 角度為-pi/2~pi/2
//這裡加上x, y input正負的資訊  使他變成 -pi~pi   才可以給SIFT用
   always@(*)
   begin
      xn_w = x5_r;
      yn_w = y5_r;
      if(choose == 1'b0 || x_r[31] == 1'b0)
         zn_w = z5_r;
      else
         if(y_r[31] == 1'b0)
         begin
            zn_w = 32'h3243F - z5_r;
            
         end
         else
         begin
            zn_w = 0 - 32'h3243F - z5_r;
         end
      
      
   end
   
   
   always@(*)
   begin
      if(choose == 1'b0)
      begin
		   d_0_w = z_r [31];//(z_r  >= 0)?1'b0:(1'b1);
		   d_1_w = z1_r[31];//(z1_w >= 0)?1'b0:(1'b1);
		   d_2_w = z2_r[31];//(z2_w >= 0)?1'b0:(1'b1);
		   d_3_w = z3_r[31];//(z3_w >= 0)?1'b0:(1'b1);
		   d_4_w = z4_r[31];//(z4_w >= 0)?1'b0:(1'b1);
		end
		   
	   else
	   begin
		   d_0_w = !y_r[31];
		   d_1_w = !y1_r[31];//(y1_w < 0)?1'b0:(1'b1);
		   d_2_w = !y2_r[31];//(y2_w < 0)?1'b0:(1'b1);
		   d_3_w = !y3_r[31];//(y3_w < 0)?1'b0:(1'b1);
		   d_4_w = !y4_r[31];//(y4_w < 0)?1'b0:(1'b1);
		end
   end
   always@(*)begin
      
         if(d_0_w == 1'b0)
         begin
            x1_w = (choose == 1'b1 && x_r[31] == 1'b0) ? (x_r - y_r) : (32'd0 - x_r - y_r);
            y1_w = (choose == 1'b1 && x_r[31] == 1'b0) ? (y_r + x_r) : (y_r - x_r);
            z1_w = z_r - 32'hCA1D;
         end
         else
         begin
            x1_w = (choose == 1'b1 && x_r[31] == 1'b0) ? (y_r + x_r) : (y_r - x_r);
            y1_w = (choose == 1'b1 && x_r[31] == 1'b0) ? (y_r - x_r) : (y_r + x_r);
            z1_w = z_r + 32'hCA1D;
         end
      
   end
      
   always@(*)begin
      
         if(d_1_w == 1'b0)
         begin
            x2_w = x1_r - y1_temp_r[32:1];//(y1_w>>1);
            y2_w = y1_r + x1_temp_r[32:1];//(x1_w>>1);
            z2_w = z1_r - 32'h76B1;
         end
         else
         begin
            x2_w = x1_r + y1_temp_r[32:1];//(y1_w>>1);
            y2_w = y1_r - x1_temp_r[32:1];//(x1_w>>1);
            z2_w = z1_r + 32'h76B1;
         end
     
      
   end
   
   always@(*)begin
      
         if(d_2_w == 1'b0)
         begin
            x3_w = x2_r - y2_temp_r[33:2];//(y2_w>>2);
            y3_w = y2_r + x2_temp_r[33:2];//(x2_w>>2);
            z3_w = z2_r - 32'h3EB6;
         end
         else
         begin
            x3_w = x2_r + y2_temp_r[33:2];//(y2_w>>2);
            y3_w = y2_r - x2_temp_r[33:2];//(x2_w>>2);
            z3_w = z2_r + 32'h3EB6;
         end
      
   end
   
   
   
   always@(*)begin
      
         
         if(d_3_w == 1'b0)
         begin
            x4_w = x3_r - y3_temp_r[34:3];//(y3_w>>3);
            y4_w = y3_r + x3_temp_r[34:3];//(x3_w>>3);
            z4_w = z3_r - 32'h1FD5;
         end
         else
         begin
            x4_w = x3_r + y3_temp_r[34:3];//(y3_w>>3);
            y4_w = y3_r - x3_temp_r[34:3];//(x3_w>>3);
            z4_w = z3_r + 32'h1FD5;
         end
      
   end
   
   always@(*)begin
      
         
         if(d_4_w == 1'b0)
         begin
            x5_w = x4_r - y4_temp_r[35:4];//(y4_w>>4);
            y5_w = y4_r + x4_temp_r[35:4];//(x4_w>>4);
            z5_w = z4_r - 32'hFFB;
         end
         else
         begin
            x5_w = x4_r + y4_temp_r[35:4];//(y4_w>>4);
            y5_w = y4_r - x4_temp_r[35:4];//(x4_w>>4);
            z5_w = z4_r + 32'hFFB;
         end
      
   end
      
      
      
//   wire gclk = clk & cordic_enable;
  
   
   always@(posedge clk or posedge reset)
   begin
      
      if(reset)
      begin
         x_r <= 32'd0;
         y_r <= 32'd0;
         z_r <= 32'd0;
         choose_r <= 1'd0;
         d_0_r <= 1'b0;
         d_1_r <= 1'b0;
         d_2_r <= 1'b0;
         d_3_r <= 1'b0;
         d_4_r <= 1'b0;
         
         xn <= 32'd0;
         yn <= 32'd0;
         zn <= 32'd0;
         xn_r <= 32'd0;
         yn_r <= 32'd0;
         //zn_r <= 31'd0;
         
         x4_r <= 32'd0;
         y4_r <= 32'd0;
         z4_r <= 32'd0;
         x4_temp_r <= 36'd0;
         y4_temp_r <= 36'd0;
         x2_r <= 32'd0;
         y2_r <= 32'd0;
         z2_r <= 32'd0;
         x2_temp_r <= 34'd0;
         y2_temp_r <= 34'd0;
         x3_r <= 32'd0;
         y3_r <= 32'd0;
         z3_r <= 32'd0;
         x3_temp_r <= 35'd0;
         y3_temp_r <= 35'd0;
         x1_r <= 32'd0;
         y1_r <= 32'd0;
         z1_r <= 32'd0;
         x1_temp_r <= 33'd0;
         y1_temp_r <= 33'd0;
         x5_r <= 32'd0;
         y5_r <= 32'd0;
         z5_r <= 32'd0;
         x5_temp_r <= 37'd0;
         y5_temp_r <= 37'd0;
   
         
      end
      else
      begin
         if(cordic_enable)
         begin
            x_r <= x;
            y_r <= y;
            z_r <= z;
            xn_r <= xn_w;
            yn_r <= yn_w;
            //zn_r <= z5_w;
            choose_r <= choose;
            d_0_r <= d_0_w;
            d_1_r <= d_1_w;
            d_2_r <= d_2_w;
            d_3_r <= d_3_w;
            d_4_r <= d_4_w;
            xn <= xn_temp2_w[47:16];
            yn <= yn_temp2_w[47:16];
            
            zn <= zn_w;
            
            x4_r <= x4_w;
            y4_r <= y4_w;
            z4_r <= z4_w;
            x4_temp_r <= x4_temp_w;
            y4_temp_r <= y4_temp_w;
            x2_r <= x2_w;
            y2_r <= y2_w;
            z2_r <= z2_w;
            x2_temp_r <= x2_temp_w;
            y2_temp_r <= y2_temp_w;
            
            x3_r <= x3_w;
            y3_r <= y3_w;
            z3_r <= z3_w;
            x3_temp_r <= x3_temp_w;
            y3_temp_r <= y3_temp_w;
            
            x1_r <= x1_w;
            y1_r <= y1_w;
            z1_r <= z1_w;
            x1_temp_r <= x1_temp_w;
            y1_temp_r <= y1_temp_w;
            
            x5_r <= x5_w;
            y5_r <= y5_w;
            z5_r <= z5_w;
            x5_temp_r <= x5_temp_w;
            y5_temp_r <= y5_temp_w;
            
         end
      end
      
   end
   




endmodule