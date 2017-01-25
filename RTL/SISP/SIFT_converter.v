module SIFT_converter(clk, reset, positionx, positiony, magnitude, angle, output_bin, output_value, SIFT_convert_enable);
   input             clk, reset, SIFT_convert_enable;
   input    [3:0]    positionx, positiony;  //在16*16哪一個位置
   input    [9:0]    magnitude; //可以將magnitude在這裡normalize之類  目前沒有用到
   input    [19:0]   angle;        //input 角度  (rad) 小數點位置跟cordic一樣 在第16~17bit中間  ([16]~[15]間)
   output   [7:0]    output_bin;   //將bin index輸出
   output   [7:0]    output_value; //將normalize後的magnitude輸出
   
   
   wire     [7:0]    output_bin_w;
   wire     [7:0]    output_value_w;
   wire     [19:0]   abs_angle_w;
   
   
   
   
   reg      [3:0]    positionx_r, positiony_r;
   reg      [9:0]    magnitude_r;
   reg      [19:0]   angle_r;
   reg      [7:0]    output_bin_r;
   reg      [7:0]    output_value_r;
   reg      [2:0]    temp_output_bin_w;
   
   
   
   
   assign output_bin = output_bin_r;
   assign output_value = output_value_r;
   assign abs_angle_w = (angle_r[19] == 1'b1) ? (angle_r + 20'd411775) : ( angle_r > 20'd411775 ? angle_r - 20'd411775 : angle_r); //把角度normalize到0~2pi
   assign output_bin_w[2:0] = temp_output_bin_w[2:0];
   assign output_bin_w[7:3] = {1'b0,positiony[3:2], positionx[3:2]};
   assign output_value_w = magnitude_r[9:2];
   
   
   always@(*)
   begin
      if(abs_angle_w < 20'd205887)
      begin
         if(abs_angle_w < 20'd128680)
         begin
            if(abs_angle_w < 20'd25736)
            begin
               temp_output_bin_w = 3'd0;
            end
            else if(abs_angle_w < 20'd77208)
            begin
               temp_output_bin_w = 3'd1;
            end
            else
            begin
               temp_output_bin_w = 3'd2;
            end
         end
         else
         begin
            if(abs_angle_w < 20'd180151)
            begin
               temp_output_bin_w = 3'd3;
            end
            else
            begin
               temp_output_bin_w = 3'd4;
            end
         end
      
      end
      else
      begin
         if(abs_angle_w < 20'd334567)
         begin
            if(abs_angle_w < 20'd231623)
            begin
               temp_output_bin_w = 3'd4;
            end
            else if(abs_angle_w < 20'd283095)
            begin
               temp_output_bin_w = 3'd5;
            end
            else
            begin
               temp_output_bin_w = 3'd6;
            end
         end
         else
         begin
            if(abs_angle_w < 20'd386039)
            begin
               temp_output_bin_w = 3'd7;
            end
            else
            begin
               temp_output_bin_w = 3'd0;
            end
         end
      end
      
   
   end
   
//   wire gclk = clk & SIFT_convert_enable;
   always@(posedge clk or posedge reset)
   begin
      if(reset)
      begin
         positionx_r <= 4'd0;
         positiony_r <= 4'd0;
         magnitude_r <= 10'd0;
         angle_r <= 20'd0;
         output_bin_r <= 8'd0;
         output_value_r <= 10'd0;
      
      end
      else if(SIFT_convert_enable)
      begin
         positionx_r <= positionx;
         positiony_r <= positiony;
         magnitude_r <= magnitude;
         angle_r <= angle;
         output_bin_r <= output_bin_w;
         output_value_r <= output_value_w;
      
      end
      
      
      
   end
   
   
   
   
   



endmodule