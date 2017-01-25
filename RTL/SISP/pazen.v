module pazen(clk, reset, 
         y1_in, y2_in, u1_in, u2_in, v1_in, v2_in,// positionx1_in, positionx2_in, positiony1_in, positiony2_in, centerx_in, centery_in, 
         pazen_enable,
         data_read_A_Y, data_read_B_Y, data_read_A_U, data_read_B_U, data_read_A_V, data_read_B_V, //從memory拿資料
         data_write_A_Y, data_write_B_Y, data_write_A_U, data_write_B_U, data_write_A_V, data_write_B_V,  //寫資料出去
         wea_Y, web_Y, wea_U, web_U, wea_V, web_V, csa_Y, csb_Y, csa_U, csb_U, csa_V, csb_V, oea_Y, oeb_Y, oea_U, oeb_U, oea_V, oeb_V, //MEMORY 控制
         total_histogram_y, total_histogram_u, total_histogram_v, //output sum of histogram
         diag, 
         y1_out, y2_out, u1_out, u2_out, v1_out, v2_out, //output 顏色  histogram裡找bin data, 也就是去找對應的顏色資料
         //differencex1_out, differencex2_out, differencey1_out, differencey2_out, 
         distance_from_cordic_1_in, distance_from_cordic_2_in, //cordic的資料
         background_weight_1_in, background_weight_2_in, //如果是累積background histogram  要考慮weight
         background_weight_threshold_in,  //大於這個threshold才累積
         background_binvalue_threshold_in,  //若histogram值大於這個  不累積  for background color removal
         acc_background_color_or_not, //是累積background histogram還是不是 1:累積background color histogram
         bg_y1_binvalue_in, bg_y2_binvalue_in, bg_u1_binvalue_in, bg_u2_binvalue_in, bg_v1_binvalue_in, bg_v2_binvalue_in, //背景的histogram bin value  for background color removal
         use_background_color_or_not, //1 使用background color removal
         mask_on_or_not, //1 使用background color removal
         MASK_1_in,
         MASK_2_in  //mask input
         
         
         //,
         //flag_Y, flag_U, flag_V
         );
   parameter INIT_ST = 0;
   parameter DIST_ST = 1;
   parameter BU_ST = 2;
   
   
   input             clk;
   input             reset;
   input    [7:0]    y1_in, y2_in;
   input    [7:0]    u1_in, u2_in;
   input    [7:0]    v1_in, v2_in;
   
   input             pazen_enable;
   input    [31:0]   diag;
   
   input             acc_background_color_or_not, use_background_color_or_not;  //1: true   0: false
   input    [7:0]    background_weight_threshold_in, background_weight_1_in, background_weight_2_in;
   input    [15:0]   background_binvalue_threshold_in;
   input             mask_on_or_not;
   input             MASK_1_in;
   input             MASK_2_in;
   
   //input    [9:0]    positionx1_in, positionx2_in, centerx_in;
   //input    [8:0]    positiony1_in, positiony2_in, centery_in;
   
   input    [15:0]   data_read_A_Y, data_read_B_Y, data_read_A_U, data_read_B_U, data_read_A_V, data_read_B_V;
   
   input    [15:0]    bg_y1_binvalue_in, bg_y2_binvalue_in;
   input    [15:0]    bg_u1_binvalue_in, bg_u2_binvalue_in;
   input    [15:0]    bg_v1_binvalue_in, bg_v2_binvalue_in;
   
   output   [15:0]   data_write_A_Y, data_write_B_Y, data_write_A_U, data_write_B_U, data_write_A_V, data_write_B_V;
   output            wea_Y, web_Y, wea_U, web_U, wea_V, web_V, csa_Y, csb_Y, csa_U, csb_U, csa_V, csb_V, oea_Y, oeb_Y, oea_U, oeb_U, oea_V, oeb_V;
   output   [19:0]   total_histogram_y, total_histogram_u, total_histogram_v;
   output   [7:0]    y1_out, y2_out, u1_out, u2_out, v1_out, v2_out;
   
   //FOR CORDIC   
   //output   [9:0]    differencex1_out, differencex2_out;
   //output   [8:0]    differencey1_out, differencey2_out;
   input    [7:0]   distance_from_cordic_1_in, distance_from_cordic_2_in;
   
   
   
   
   
   
   
   
   
   //output   [255:0]  flag_Y, flag_U, flag_V;
   
   reg      [7:0]    background_weight_threshold_in_r, background_weight_1_in_r, background_weight_2_in_r;
   reg      [15:0]   background_binvalue_threshold_in_r;
   
   wire     [19:0]   total_histogram_y_w;
   reg      [19:0]   total_histogram_y_r;
   wire     [19:0]   total_histogram_u_w;
   reg      [19:0]   total_histogram_u_r;
   wire     [19:0]   total_histogram_v_w;
   reg      [19:0]   total_histogram_v_r;
   reg               use_background_color_or_not_r;
   reg               acc_background_color_or_not_r;
   reg      [7:0]    distance_from_cordic_1_in_r;
   reg      [7:0]    distance_from_cordic_2_in_r;
   //wire     [31:0]   temp_distance1_w, temp_distance2_w;
   
   wire     [7:0]    normal_distance1_w, normal_distance2_w;
   wire     [7:0]    distance1_y_in_w, distance2_y_in_w;
   wire     [7:0]    distance1_u_in_w, distance2_u_in_w;
   wire     [7:0]    distance1_v_in_w, distance2_v_in_w;
   wire     [1:0]    count_for_total_histogram_w ;
   
   reg      [7:0]   distance1_y_in_r, distance2_y_in_r;
   reg      [7:0]   distance1_u_in_r, distance2_u_in_r;
   reg      [7:0]   distance1_v_in_r, distance2_v_in_r;
   //reg      [31:0]   diag_1d_r, diag_2d_r, diag_3d_r, diag_4d_r, diag_5d_r;
   
   reg      [7:0]    y1_in_1d_r, y2_in_1d_r, y1_in_2d_r, y2_in_2d_r, y1_in_3d_r, y2_in_3d_r, y1_in_4d_r, y2_in_4d_r;//, y1_in_5d_r, y2_in_5d_r;
   reg      [7:0]    u1_in_1d_r, u2_in_1d_r, u1_in_2d_r, u2_in_2d_r, u1_in_3d_r, u2_in_3d_r, u1_in_4d_r, u2_in_4d_r;//, u1_in_5d_r, u2_in_5d_r;
   reg      [7:0]    v1_in_1d_r, v2_in_1d_r, v1_in_2d_r, v2_in_2d_r, v1_in_3d_r, v2_in_3d_r, v1_in_4d_r, v2_in_4d_r;//, v1_in_5d_r, v2_in_5d_r;
  
   reg      [7:0]    y1_in_r, y2_in_r;
   reg      [7:0]    u1_in_r, u2_in_r;
   reg      [7:0]    v1_in_r, v2_in_r;
   
   reg      [15:0]   bg_y1_binvalue_in_r, bg_y2_binvalue_in_r;
   reg      [15:0]   bg_u1_binvalue_in_r, bg_u2_binvalue_in_r;
   reg      [15:0]   bg_v1_binvalue_in_r, bg_v2_binvalue_in_r;
   reg               BU_enable_r;
   
   reg      [1:0]    count_for_total_histogram_r;
   
   wire     [9:0]    differencex1_w, differencex2_w;
   wire     [8:0]    differencey1_w, differencey2_w;
   wire              BU_enable_w;
   
   //reg      [1:0]    state_w, state_r;
   //reg      [2:0]    count_dist_r;
   //wire     [2:0]    count_dist_w;
   
   //reg      [1:0]    count_BU_r;
   //wire     [1:0]    count_BU_w;
   
   //reg      [2:0]    count_enable_r;
   //wire     [2:0]    count_enable_w;
   
   assign y1_out = y1_in_3d_r;
   assign y2_out = y2_in_3d_r;
   assign u1_out = u1_in_3d_r;
   assign u2_out = u2_in_3d_r;
   assign v1_out = v1_in_3d_r;
   assign v2_out = v2_in_3d_r;
   
   assign total_histogram_y = total_histogram_y_r;
   assign total_histogram_u = total_histogram_u_r;
   assign total_histogram_v = total_histogram_v_r;
   
   //assign differencex1_w = (positionx1_in > centerx_in) ? (positionx1_in - centerx_in) : (centerx_in - positionx1_in);
   //assign differencex2_w = (positionx2_in > centerx_in) ? (positionx2_in - centerx_in) : (centerx_in - positionx2_in);
   //assign differencey1_w = (positiony1_in > centery_in) ? (positiony1_in - centery_in) : (centery_in - positiony1_in);
   //assign differencey2_w = (positiony2_in > centery_in) ? (positiony2_in - centery_in) : (centery_in - positiony2_in);
   //assign count_dist_w = (state_r == DIST_ST) ? count_dist_r + 3'b1 : 3'b0;
   //assign count_BU_w = (state_r == BU_ST) ? count_BU_r + 2'b1 : 2'b0;
   
   //assign normal_distance1_w =  diag_5d_r - temp_distance1_w + 32'd1;
   //assign normal_distance2_w =  diag_5d_r - temp_distance2_w + 32'd1;
   
   
   assign distance1_y_in_w = (mask_on_or_not)?(MASK_1_in?distance_from_cordic_1_in_r:8'd0):((acc_background_color_or_not_r == 1'b1)? ((background_weight_1_in_r > background_weight_threshold_in_r) ? distance_from_cordic_1_in_r : 8'd0) :((use_background_color_or_not_r == 1'b1 && bg_y1_binvalue_in_r > background_binvalue_threshold_in_r)? 8'd0 : distance_from_cordic_1_in_r));
   assign distance2_y_in_w = (mask_on_or_not)?(MASK_2_in?distance_from_cordic_2_in_r:8'd0):((acc_background_color_or_not_r == 1'b1)? ((background_weight_2_in_r > background_weight_threshold_in_r) ? distance_from_cordic_2_in_r : 8'd0) :((use_background_color_or_not_r == 1'b1 && bg_y2_binvalue_in_r > background_binvalue_threshold_in_r)? 8'd0 : distance_from_cordic_2_in_r));
   assign distance1_u_in_w = (mask_on_or_not)?(MASK_1_in?distance_from_cordic_1_in_r:8'd0):((acc_background_color_or_not_r == 1'b1)? ((background_weight_1_in_r > background_weight_threshold_in_r) ? distance_from_cordic_1_in_r : 8'd0) :((use_background_color_or_not_r == 1'b1 && bg_u1_binvalue_in_r > background_binvalue_threshold_in_r)? 8'd0 : distance_from_cordic_1_in_r));
   assign distance2_u_in_w = (mask_on_or_not)?(MASK_2_in?distance_from_cordic_2_in_r:8'd0):((acc_background_color_or_not_r == 1'b1)? ((background_weight_2_in_r > background_weight_threshold_in_r) ? distance_from_cordic_2_in_r : 8'd0) :((use_background_color_or_not_r == 1'b1 && bg_u2_binvalue_in_r > background_binvalue_threshold_in_r)? 8'd0 : distance_from_cordic_2_in_r));
   assign distance1_v_in_w = (mask_on_or_not)?(MASK_1_in?distance_from_cordic_1_in_r:8'd0):((acc_background_color_or_not_r == 1'b1)? ((background_weight_1_in_r > background_weight_threshold_in_r) ? distance_from_cordic_1_in_r : 8'd0) :((use_background_color_or_not_r == 1'b1 && bg_v1_binvalue_in_r > background_binvalue_threshold_in_r)? 8'd0 : distance_from_cordic_1_in_r));
   assign distance2_v_in_w = (mask_on_or_not)?(MASK_2_in?distance_from_cordic_2_in_r:8'd0):((acc_background_color_or_not_r == 1'b1)? ((background_weight_2_in_r > background_weight_threshold_in_r) ? distance_from_cordic_2_in_r : 8'd0) :((use_background_color_or_not_r == 1'b1 && bg_v2_binvalue_in_r > background_binvalue_threshold_in_r)? 8'd0 : distance_from_cordic_2_in_r));
   
   
   //assign cordic_enable_w = (state_r == DIST_ST) ? (1'b1) : 1'b0;
   //assign BU_enable_w = (state_r == BU_ST) ? (1'b1) : 1'b0;
   //assign count_enable_w = (count_enable_r >= 3'd4 || !pazen_enable) ? 3'd0 : count_enable_r + 3'd1;
   
   assign BU_enable_w = pazen_enable;
   assign count_for_total_histogram_w = (pazen_enable) ? count_for_total_histogram_r + 2'd1 : 2'd0;
                                                                                                       
   assign total_histogram_y_w = (pazen_enable && count_for_total_histogram_r == 2'd2) ? total_histogram_y_r + {12'd0,distance1_y_in_r} + {12'd0,distance2_y_in_r} : total_histogram_y_r;
   assign total_histogram_u_w = (pazen_enable && count_for_total_histogram_r == 2'd2) ? total_histogram_u_r + {12'd0,distance1_u_in_r} + {12'd0,distance2_u_in_r} : total_histogram_u_r;
   assign total_histogram_v_w = (pazen_enable && count_for_total_histogram_r == 2'd2) ? total_histogram_v_r + {12'd0,distance1_v_in_r} + {12'd0,distance2_v_in_r} : total_histogram_v_r;
   
   //FOR CORDIC   
//   assign differencex1_out = differencex1_w;
   //assign differencex2_out = differencex2_w;
   //assign differencey1_out = differencey1_w;
   //assign differencey2_out = differencey2_w;
   //assign temp_distance1_w = distance_from_cordic_1_in;
   //assign temp_distance2_w = distance_from_cordic_2_in;
   
   
   
   
/*   
   cordic_shell d0(.clk(clk), 
                   .reset(reset), 
                   .x({6'd0, differencex1_w, 16'd0}), 
                   .y({7'd0, differencey1_w, 16'd0}), 
                   .z(32'd0), 
                   .xn(temp_distance1_w), 
                   .yn(), 
                   .zn(), 
                   .choose(1'b1), 
                   .cordic_enable(cordic_enable_w), 
                   //.loop(1'b0), 
                   .done(cordic_done1_w));
   cordic_shell d1(.clk(clk), 
                   .reset(reset), 
                   .x({6'd0, differencex2_w, 16'd0}), 
                   .y({7'd0, differencey2_w, 16'd0}), 
                   .z(32'd0), 
                   .xn(temp_distance2_w), 
                   .yn(), 
                   .zn(), 
                   .choose(1'b1), 
                   .cordic_enable(cordic_enable_w), 
                   //.loop(1'b0), 
                   .done(cordic_done2_w));                
*/   
   wire BU_enable_t = BU_enable_r && pazen_enable;
   BU m1(.clk(clk), 
         .reset(reset), 
         .y1_in(y1_in_2d_r), 
         .y2_in(y2_in_2d_r), 
         .u1_in(u1_in_2d_r), 
         .u2_in(u2_in_2d_r), 
         .v1_in(v1_in_2d_r), 
         .v2_in(v2_in_2d_r), 
         .distance1_y_in(distance1_y_in_w), 
         .distance2_y_in(distance2_y_in_w), 
         .distance1_u_in(distance1_u_in_w), 
         .distance2_u_in(distance2_u_in_w), 
         .distance1_v_in(distance1_v_in_w), 
         .distance2_v_in(distance2_v_in_w), 
         .BU_enable(BU_enable_t),
         .data_read_A_Y(data_read_A_Y), 
         .data_read_B_Y(data_read_B_Y), 
         .data_read_A_U(data_read_A_U), 
         .data_read_B_U(data_read_B_U), 
         .data_read_A_V(data_read_A_V), 
         .data_read_B_V(data_read_B_V), 
         .data_write_A_Y(data_write_A_Y), 
         .data_write_B_Y(data_write_B_Y), 
         .data_write_A_U(data_write_A_U), 
         .data_write_B_U(data_write_B_U), 
         .data_write_A_V(data_write_A_V), 
         .data_write_B_V(data_write_B_V), 
         .wea_Y(wea_Y), 
         .web_Y(web_Y), 
         .wea_U(wea_U), 
         .web_U(web_U), 
         .wea_V(wea_V), 
         .web_V(web_V), 
         .csa_Y(csa_Y), 
         .csb_Y(csb_Y), 
         .csa_U(csa_U), 
         .csb_U(csb_U), 
         .csa_V(csa_V), 
         .csb_V(csb_V), 
         .oea_Y(oea_Y), 
         .oeb_Y(oeb_Y), 
         .oea_U(oea_U), 
         .oeb_U(oeb_U), 
         .oea_V(oea_V), 
         .oeb_V(oeb_V)
         
         //,
         //.flag_Y_r(flag_Y), 
         //.flag_U_r(flag_U), 
         //.flag_V_r(flag_V)
         );
/*         
   always@(*)
   begin
      case(state_r)
         INIT_ST:
         begin
            if(pazen_enable)
               state_w = DIST_ST;
            else
               state_w = INIT_ST;
         end
         DIST_ST:
         begin
            if(count_dist_r == 3'd4)
               state_w = BU_ST;
            else
               state_w = DIST_ST;
         end
         BU_ST:
         begin
            if(count_BU_r == 2'd2)
               state_w = INIT_ST;
            else
               state_w = BU_ST;
         end
      endcase
   end
*/   
   
   
//   wire gclk = clk & pazen_enable;
   
   always@(posedge clk or posedge reset)
   begin
      if(reset)
      begin
         distance1_y_in_r <= 8'd0;
         distance2_y_in_r <= 8'd0;
         distance1_u_in_r <= 8'd0;
         distance2_u_in_r <= 8'd0;
         distance1_v_in_r <= 8'd0;
         distance2_v_in_r <= 8'd0;
         //state_r <= 2'd0;
         //count_dist_r <= 3'b0;
         //count_BU_r <= 2'd0;
         distance_from_cordic_1_in_r <= 8'd0;
         distance_from_cordic_2_in_r <= 8'd0;
         total_histogram_y_r <= 20'd0;
         total_histogram_u_r <= 20'd0;
         total_histogram_v_r <= 20'd0;
         //count_enable_r <= 3'd0;
         y1_in_r <= 8'd0;
         u1_in_r <= 8'd0;
         v1_in_r <= 8'd0;
         y2_in_r <= 8'd0;
         u2_in_r <= 8'd0;
         v2_in_r <= 8'd0;
         
         /*diag_1d_r <= 32'd0;
         diag_2d_r <= 32'd0;
         diag_3d_r <= 32'd0;
         diag_4d_r <= 32'd0;
         diag_5d_r <= 32'd0;
         */
         y1_in_1d_r <= 8'd0;
         y2_in_1d_r <= 8'd0;
         y1_in_2d_r <= 8'd0;
         y2_in_2d_r <= 8'd0;
         y1_in_3d_r <= 8'd0;
         y2_in_3d_r <= 8'd0;
         y1_in_4d_r <= 8'd0;
         y2_in_4d_r <= 8'd0;
         //y1_in_5d_r <= 8'd0;
         //y2_in_5d_r <= 8'd0;
         u1_in_1d_r <= 8'd0;
         u2_in_1d_r <= 8'd0;
         u1_in_2d_r <= 8'd0;
         u2_in_2d_r <= 8'd0;
         u1_in_3d_r <= 8'd0;
         u2_in_3d_r <= 8'd0;
         u1_in_4d_r <= 8'd0;
         u2_in_4d_r <= 8'd0;
         //u1_in_5d_r <= 8'd0;
         //u2_in_5d_r <= 8'd0;
         v1_in_1d_r <= 8'd0;
         v2_in_1d_r <= 8'd0;
         v1_in_2d_r <= 8'd0;
         v2_in_2d_r <= 8'd0;
         v1_in_3d_r <= 8'd0;
         v2_in_3d_r <= 8'd0;
         v1_in_4d_r <= 8'd0;
         v2_in_4d_r <= 8'd0;
         //v1_in_5d_r <= 8'd0;
         //v2_in_5d_r <= 8'd0;
         
         bg_y1_binvalue_in_r <= 16'd0;
         bg_y2_binvalue_in_r <= 16'd0;
         bg_u1_binvalue_in_r <= 16'd0;
         bg_u2_binvalue_in_r <= 16'd0;
         bg_v1_binvalue_in_r <= 16'd0;
         bg_v2_binvalue_in_r <= 16'd0;
         use_background_color_or_not_r <= 1'd0;
         acc_background_color_or_not_r <= 1'b0;
         background_weight_threshold_in_r <= 8'd0;
         background_weight_1_in_r <= 8'd0;
         background_weight_2_in_r <= 8'd0;
         background_binvalue_threshold_in_r <= 16'd0;
         BU_enable_r <= 1'd0;  
         count_for_total_histogram_r <= 2'd0;     
          
         
         
         

      end
      else if(pazen_enable)
      begin
         distance1_y_in_r <= distance1_y_in_w;
         distance2_y_in_r <= distance2_y_in_w;
         distance1_u_in_r <= distance1_u_in_w;
         distance2_u_in_r <= distance2_u_in_w;
         distance1_v_in_r <= distance1_v_in_w;
         distance2_v_in_r <= distance2_v_in_w;
         distance_from_cordic_1_in_r <= distance_from_cordic_1_in;
         distance_from_cordic_2_in_r <= distance_from_cordic_2_in;
         //state_r <= state_w;
         //count_dist_r <= count_dist_w;
         //count_BU_r <= count_BU_w;
         total_histogram_y_r <= total_histogram_y_w;
         total_histogram_u_r <= total_histogram_u_w;
         total_histogram_v_r <= total_histogram_v_w;
         //count_enable_r <= count_enable_w;
          /*
         diag_1d_r <= diag;
         diag_2d_r <= diag_1d_r;
         diag_3d_r <= diag_2d_r;
         diag_4d_r <= diag_3d_r;
         diag_5d_r <= diag_4d_r;
        */
         y1_in_1d_r <= y1_in;
         y2_in_1d_r <= y2_in;
         y1_in_2d_r <= y1_in_1d_r;
         y2_in_2d_r <= y2_in_1d_r;
         y1_in_3d_r <= y1_in_2d_r;
         y2_in_3d_r <= y2_in_2d_r;
         y1_in_4d_r <= y1_in_3d_r;
         y2_in_4d_r <= y2_in_3d_r;
         //y1_in_5d_r <= y1_in_4d_r;
         //y2_in_5d_r <= y2_in_4d_r;
         u1_in_1d_r <= u1_in;
         u2_in_1d_r <= u2_in;
         u1_in_2d_r <= u1_in_1d_r;
         u2_in_2d_r <= u2_in_1d_r;
         u1_in_3d_r <= u1_in_2d_r;
         u2_in_3d_r <= u2_in_2d_r;
         u1_in_4d_r <= u1_in_3d_r;
         u2_in_4d_r <= u2_in_3d_r;
         //u1_in_5d_r <= u1_in_4d_r;
         //u2_in_5d_r <= u2_in_4d_r;
         v1_in_1d_r <= v1_in;
         v2_in_1d_r <= v2_in;
         v1_in_2d_r <= v1_in_1d_r;
         v2_in_2d_r <= v2_in_1d_r;
         v1_in_3d_r <= v1_in_2d_r;
         v2_in_3d_r <= v2_in_2d_r;
         v1_in_4d_r <= v1_in_3d_r;
         v2_in_4d_r <= v2_in_3d_r;
         //v1_in_5d_r <= v1_in_4d_r;
         //v2_in_5d_r <= v2_in_4d_r;
         
         y1_in_r <= y1_in;
         u1_in_r <= u1_in;
         v1_in_r <= v1_in;
         y2_in_r <= y2_in;
         u2_in_r <= u2_in;
         v2_in_r <= v2_in;
         bg_y1_binvalue_in_r <= bg_y1_binvalue_in;
         bg_y2_binvalue_in_r <= bg_y2_binvalue_in;
         bg_u1_binvalue_in_r <= bg_u1_binvalue_in;
         bg_u2_binvalue_in_r <= bg_u2_binvalue_in;
         bg_v1_binvalue_in_r <= bg_v1_binvalue_in;
         bg_v2_binvalue_in_r <= bg_v2_binvalue_in;
         use_background_color_or_not_r <= use_background_color_or_not;
         acc_background_color_or_not_r <= acc_background_color_or_not;
         background_weight_threshold_in_r <= background_weight_threshold_in;
         background_weight_1_in_r <= background_weight_1_in;
         background_weight_2_in_r <= background_weight_2_in;
         background_binvalue_threshold_in_r <= background_binvalue_threshold_in;
         BU_enable_r <= BU_enable_w;
         count_for_total_histogram_r <= count_for_total_histogram_w;
          
         
         
      end
   
   end
   

endmodule