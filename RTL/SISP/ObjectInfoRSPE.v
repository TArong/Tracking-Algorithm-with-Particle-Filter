//一次處理十個物件 
module ObjectInfoRSPE(clk, reset, start, Data_64bit, o0_label, o0_x_min, o0_x_max, o0_y_min, o0_y_max,
                                                     o1_label, o1_x_min, o1_x_max, o1_y_min, o1_y_max,
                                                     o2_label, o2_x_min, o2_x_max, o2_y_min, o2_y_max,
                                                     o3_label, o3_x_min, o3_x_max, o3_y_min, o3_y_max,
                                                     o4_label, o4_x_min, o4_x_max, o4_y_min, o4_y_max,
                                                     o5_label, o5_x_min, o5_x_max, o5_y_min, o5_y_max,
                                                     o6_label, o6_x_min, o6_x_max, o6_y_min, o6_y_max,
                                                     o7_label, o7_x_min, o7_x_max, o7_y_min, o7_y_max,
                                                     o8_label, o8_x_min, o8_x_max, o8_y_min, o8_y_max,
                                                     o9_label, o9_x_min, o9_x_max, o9_y_min, o9_y_max, 
                                                     ObjectInfoRSPE_en);
                                                     
   parameter WIDTH = 640/8;
   parameter HEIGHT = 480;
   input             clk, reset, start;  //start: 開始做
   input             ObjectInfoRSPE_en;
   input    [63:0]   Data_64bit;         //一次進來8筆8-bit資料
   input    [7:0]    o0_label;
   input    [7:0]    o1_label;
   input    [7:0]    o2_label;
   input    [7:0]    o3_label;
   input    [7:0]    o4_label;
   input    [7:0]    o5_label;
   input    [7:0]    o6_label;
   input    [7:0]    o7_label;
   input    [7:0]    o8_label;
   input    [7:0]    o9_label;
   
   output   [9:0]    o0_x_min, o0_x_max;
   output   [9:0]    o1_x_min, o1_x_max;
   output   [9:0]    o2_x_min, o2_x_max;
   output   [9:0]    o3_x_min, o3_x_max;
   output   [9:0]    o4_x_min, o4_x_max;
   output   [9:0]    o5_x_min, o5_x_max;
   output   [9:0]    o6_x_min, o6_x_max;
   output   [9:0]    o7_x_min, o7_x_max;
   output   [9:0]    o8_x_min, o8_x_max;
   output   [9:0]    o9_x_min, o9_x_max;
   
   output   [8:0]    o0_y_min, o0_y_max;
   output   [8:0]    o1_y_min, o1_y_max;
   output   [8:0]    o2_y_min, o2_y_max;
   output   [8:0]    o3_y_min, o3_y_max;
   output   [8:0]    o4_y_min, o4_y_max;
   output   [8:0]    o5_y_min, o5_y_max;
   output   [8:0]    o6_y_min, o6_y_max;
   output   [8:0]    o7_y_min, o7_y_max;
   output   [8:0]    o8_y_min, o8_y_max;
   output   [8:0]    o9_y_min, o9_y_max;
   
   reg      [9:0]    o0_x_min, o0_x_max;
   reg      [9:0]    o1_x_min, o1_x_max;
   reg      [9:0]    o2_x_min, o2_x_max;
   reg      [9:0]    o3_x_min, o3_x_max;
   reg      [9:0]    o4_x_min, o4_x_max;
   reg      [9:0]    o5_x_min, o5_x_max;
   reg      [9:0]    o6_x_min, o6_x_max;
   reg      [9:0]    o7_x_min, o7_x_max;
   reg      [9:0]    o8_x_min, o8_x_max;
   reg      [9:0]    o9_x_min, o9_x_max;
   
   reg      [8:0]    o0_y_min, o0_y_max;
   reg      [8:0]    o1_y_min, o1_y_max;
   reg      [8:0]    o2_y_min, o2_y_max;
   reg      [8:0]    o3_y_min, o3_y_max;
   reg      [8:0]    o4_y_min, o4_y_max;
   reg      [8:0]    o5_y_min, o5_y_max;
   reg      [8:0]    o6_y_min, o6_y_max;
   reg      [8:0]    o7_y_min, o7_y_max;
   reg      [8:0]    o8_y_min, o8_y_max;
   reg      [8:0]    o9_y_min, o9_y_max;
   
   
   
   
   
   reg      [6:0]    count_i_r;
   reg      [8:0]    count_j_r;
   
 
   
   reg               start_r;
   
   reg      [7:0]    o0_label_r;
   reg      [7:0]    o1_label_r;
   reg      [7:0]    o2_label_r;
   reg      [7:0]    o3_label_r;
   reg      [7:0]    o4_label_r;
   reg      [7:0]    o5_label_r;
   reg      [7:0]    o6_label_r;
   reg      [7:0]    o7_label_r;
   reg      [7:0]    o8_label_r;
   reg      [7:0]    o9_label_r;
   
   reg      [7:0]    data_r [0:7];
   //reg      [7:0]    data_1_r;
   //reg      [7:0]    data_2_r;
   //reg      [7:0]    data_3_r;
   //reg      [7:0]    data_4_r;
   //reg      [7:0]    data_5_r;
   //reg      [7:0]    data_6_r;
   //reg      [7:0]    data_7_r;
   
   reg      [6:0]    count_i_w; 
   reg      [8:0]    count_j_w; 
   
   wire     [2:0]    index_min_0_w;
   wire     [2:0]    index_min_1_w;
   wire     [2:0]    index_min_2_w;
   wire     [2:0]    index_min_3_w;
   wire     [2:0]    index_min_4_w;
   wire     [2:0]    index_min_5_w;
   wire     [2:0]    index_min_6_w;
   wire     [2:0]    index_min_7_w;
   wire     [2:0]    index_min_8_w;
   wire     [2:0]    index_min_9_w;
   
   wire     [2:0]    index_max_0_w;
   wire     [2:0]    index_max_1_w;
   wire     [2:0]    index_max_2_w;
   wire     [2:0]    index_max_3_w;
   wire     [2:0]    index_max_4_w;
   wire     [2:0]    index_max_5_w;
   wire     [2:0]    index_max_6_w;
   wire     [2:0]    index_max_7_w;
   wire     [2:0]    index_max_8_w;
   wire     [2:0]    index_max_9_w;
   
   

                               
   wire     [9:0]    i_0_w;    
   wire     [9:0]    i_1_w;
   wire     [9:0]    i_2_w;
   wire     [9:0]    i_3_w;
   wire     [9:0]    i_4_w;
   wire     [9:0]    i_5_w;
   wire     [9:0]    i_6_w;
   wire     [9:0]    i_7_w;
   
   wire     [8:0]    j_w;
   
   wire     [8:0]    o0_y_min_w, o0_y_max_w;
   wire     [8:0]    o1_y_min_w, o1_y_max_w;
   wire     [8:0]    o2_y_min_w, o2_y_max_w;
   wire     [8:0]    o3_y_min_w, o3_y_max_w;
   wire     [8:0]    o4_y_min_w, o4_y_max_w;
   wire     [8:0]    o5_y_min_w, o5_y_max_w;
   wire     [8:0]    o6_y_min_w, o6_y_max_w;
   wire     [8:0]    o7_y_min_w, o7_y_max_w;
   wire     [8:0]    o8_y_min_w, o8_y_max_w;
   wire     [8:0]    o9_y_min_w, o9_y_max_w;
   
   wire     [9:0]    o0_x_min_w, o0_x_max_w;
   wire     [9:0]    o1_x_min_w, o1_x_max_w;
   wire     [9:0]    o2_x_min_w, o2_x_max_w;
   wire     [9:0]    o3_x_min_w, o3_x_max_w;
   wire     [9:0]    o4_x_min_w, o4_x_max_w;
   wire     [9:0]    o5_x_min_w, o5_x_max_w;
   wire     [9:0]    o6_x_min_w, o6_x_max_w;
   wire     [9:0]    o7_x_min_w, o7_x_max_w;
   wire     [9:0]    o8_x_min_w, o8_x_max_w;
   wire     [9:0]    o9_x_min_w, o9_x_max_w;
   
   
   wire     [7:0]    flag_min_0_w;
   wire     [7:0]    flag_min_1_w;
   wire     [7:0]    flag_min_2_w;
   wire     [7:0]    flag_min_3_w;
   wire     [7:0]    flag_min_4_w;
   wire     [7:0]    flag_min_5_w;
   wire     [7:0]    flag_min_6_w;
   wire     [7:0]    flag_min_7_w;
   wire     [7:0]    flag_min_8_w;
   wire     [7:0]    flag_min_9_w;
   
   wire     [7:0]    flag_max_0_w;
   wire     [7:0]    flag_max_1_w;
   wire     [7:0]    flag_max_2_w;
   wire     [7:0]    flag_max_3_w;
   wire     [7:0]    flag_max_4_w;
   wire     [7:0]    flag_max_5_w;
   wire     [7:0]    flag_max_6_w;
   wire     [7:0]    flag_max_7_w;
   wire     [7:0]    flag_max_8_w;
   wire     [7:0]    flag_max_9_w;
   
   
   
//========================================================================================================   
   assign i_0_w = {count_i_r, 3'd0};
   assign i_1_w = {count_i_r, 3'd1};
   assign i_2_w = {count_i_r, 3'd2};
   assign i_3_w = {count_i_r, 3'd3};
   assign i_4_w = {count_i_r, 3'd4};
   assign i_5_w = {count_i_r, 3'd5};
   assign i_6_w = {count_i_r, 3'd6};
   assign i_7_w = {count_i_r, 3'd7};
   
   assign j_w = count_j_r;
   
   assign o0_y_min_w = (o0_y_min >= j_w && (data_r[0] == o0_label_r || data_r[1] == o0_label_r || data_r[2] == o0_label_r || data_r[3] == o0_label_r || data_r[4] == o0_label_r || data_r[5] == o0_label_r || data_r[6] == o0_label_r || data_r[7] == o0_label_r) ) ? j_w : o0_y_min;
   assign o1_y_min_w = (o1_y_min >= j_w && (data_r[0] == o1_label_r || data_r[1] == o1_label_r || data_r[2] == o1_label_r || data_r[3] == o1_label_r || data_r[4] == o1_label_r || data_r[5] == o1_label_r || data_r[6] == o1_label_r || data_r[7] == o1_label_r) ) ? j_w : o1_y_min;
   assign o2_y_min_w = (o2_y_min >= j_w && (data_r[0] == o2_label_r || data_r[1] == o2_label_r || data_r[2] == o2_label_r || data_r[3] == o2_label_r || data_r[4] == o2_label_r || data_r[5] == o2_label_r || data_r[6] == o2_label_r || data_r[7] == o2_label_r) ) ? j_w : o2_y_min;
   assign o3_y_min_w = (o3_y_min >= j_w && (data_r[0] == o3_label_r || data_r[1] == o3_label_r || data_r[2] == o3_label_r || data_r[3] == o3_label_r || data_r[4] == o3_label_r || data_r[5] == o3_label_r || data_r[6] == o3_label_r || data_r[7] == o3_label_r) ) ? j_w : o3_y_min;
   assign o4_y_min_w = (o4_y_min >= j_w && (data_r[0] == o4_label_r || data_r[1] == o4_label_r || data_r[2] == o4_label_r || data_r[3] == o4_label_r || data_r[4] == o4_label_r || data_r[5] == o4_label_r || data_r[6] == o4_label_r || data_r[7] == o4_label_r) ) ? j_w : o4_y_min;
   assign o5_y_min_w = (o5_y_min >= j_w && (data_r[0] == o5_label_r || data_r[1] == o5_label_r || data_r[2] == o5_label_r || data_r[3] == o5_label_r || data_r[4] == o5_label_r || data_r[5] == o5_label_r || data_r[6] == o5_label_r || data_r[7] == o5_label_r) ) ? j_w : o5_y_min;
   assign o6_y_min_w = (o6_y_min >= j_w && (data_r[0] == o6_label_r || data_r[1] == o6_label_r || data_r[2] == o6_label_r || data_r[3] == o6_label_r || data_r[4] == o6_label_r || data_r[5] == o6_label_r || data_r[6] == o6_label_r || data_r[7] == o6_label_r) ) ? j_w : o6_y_min;
   assign o7_y_min_w = (o7_y_min >= j_w && (data_r[0] == o7_label_r || data_r[1] == o7_label_r || data_r[2] == o7_label_r || data_r[3] == o7_label_r || data_r[4] == o7_label_r || data_r[5] == o7_label_r || data_r[6] == o7_label_r || data_r[7] == o7_label_r) ) ? j_w : o7_y_min;
   assign o8_y_min_w = (o8_y_min >= j_w && (data_r[0] == o8_label_r || data_r[1] == o8_label_r || data_r[2] == o8_label_r || data_r[3] == o8_label_r || data_r[4] == o8_label_r || data_r[5] == o8_label_r || data_r[6] == o8_label_r || data_r[7] == o8_label_r) ) ? j_w : o8_y_min;
   assign o9_y_min_w = (o9_y_min >= j_w && (data_r[0] == o9_label_r || data_r[1] == o9_label_r || data_r[2] == o9_label_r || data_r[3] == o9_label_r || data_r[4] == o9_label_r || data_r[5] == o9_label_r || data_r[6] == o9_label_r || data_r[7] == o9_label_r) ) ? j_w : o9_y_min;
   
   assign o0_y_max_w = (o0_y_max <= j_w && (data_r[0] == o0_label_r || data_r[1] == o0_label_r || data_r[2] == o0_label_r || data_r[3] == o0_label_r || data_r[4] == o0_label_r || data_r[5] == o0_label_r || data_r[6] == o0_label_r || data_r[7] == o0_label_r) ) ? j_w : o0_y_max;
   assign o1_y_max_w = (o1_y_max <= j_w && (data_r[0] == o1_label_r || data_r[1] == o1_label_r || data_r[2] == o1_label_r || data_r[3] == o1_label_r || data_r[4] == o1_label_r || data_r[5] == o1_label_r || data_r[6] == o1_label_r || data_r[7] == o1_label_r) ) ? j_w : o1_y_max;
   assign o2_y_max_w = (o2_y_max <= j_w && (data_r[0] == o2_label_r || data_r[1] == o2_label_r || data_r[2] == o2_label_r || data_r[3] == o2_label_r || data_r[4] == o2_label_r || data_r[5] == o2_label_r || data_r[6] == o2_label_r || data_r[7] == o2_label_r) ) ? j_w : o2_y_max;
   assign o3_y_max_w = (o3_y_max <= j_w && (data_r[0] == o3_label_r || data_r[1] == o3_label_r || data_r[2] == o3_label_r || data_r[3] == o3_label_r || data_r[4] == o3_label_r || data_r[5] == o3_label_r || data_r[6] == o3_label_r || data_r[7] == o3_label_r) ) ? j_w : o3_y_max;
   assign o4_y_max_w = (o4_y_max <= j_w && (data_r[0] == o4_label_r || data_r[1] == o4_label_r || data_r[2] == o4_label_r || data_r[3] == o4_label_r || data_r[4] == o4_label_r || data_r[5] == o4_label_r || data_r[6] == o4_label_r || data_r[7] == o4_label_r) ) ? j_w : o4_y_max;
   assign o5_y_max_w = (o5_y_max <= j_w && (data_r[0] == o5_label_r || data_r[1] == o5_label_r || data_r[2] == o5_label_r || data_r[3] == o5_label_r || data_r[4] == o5_label_r || data_r[5] == o5_label_r || data_r[6] == o5_label_r || data_r[7] == o5_label_r) ) ? j_w : o5_y_max;
   assign o6_y_max_w = (o6_y_max <= j_w && (data_r[0] == o6_label_r || data_r[1] == o6_label_r || data_r[2] == o6_label_r || data_r[3] == o6_label_r || data_r[4] == o6_label_r || data_r[5] == o6_label_r || data_r[6] == o6_label_r || data_r[7] == o6_label_r) ) ? j_w : o6_y_max;
   assign o7_y_max_w = (o7_y_max <= j_w && (data_r[0] == o7_label_r || data_r[1] == o7_label_r || data_r[2] == o7_label_r || data_r[3] == o7_label_r || data_r[4] == o7_label_r || data_r[5] == o7_label_r || data_r[6] == o7_label_r || data_r[7] == o7_label_r) ) ? j_w : o7_y_max;
   assign o8_y_max_w = (o8_y_max <= j_w && (data_r[0] == o8_label_r || data_r[1] == o8_label_r || data_r[2] == o8_label_r || data_r[3] == o8_label_r || data_r[4] == o8_label_r || data_r[5] == o8_label_r || data_r[6] == o8_label_r || data_r[7] == o8_label_r) ) ? j_w : o8_y_max;
   assign o9_y_max_w = (o9_y_max <= j_w && (data_r[0] == o9_label_r || data_r[1] == o9_label_r || data_r[2] == o9_label_r || data_r[3] == o9_label_r || data_r[4] == o9_label_r || data_r[5] == o9_label_r || data_r[6] == o9_label_r || data_r[7] == o9_label_r) ) ? j_w : o9_y_max;
   
   assign flag_min_0_w[0] = (o0_x_min >= i_0_w && data_r[0] == o0_label_r);
   assign flag_min_0_w[1] = (o0_x_min >= i_1_w && data_r[1] == o0_label_r);
   assign flag_min_0_w[2] = (o0_x_min >= i_2_w && data_r[2] == o0_label_r);
   assign flag_min_0_w[3] = (o0_x_min >= i_3_w && data_r[3] == o0_label_r);
   assign flag_min_0_w[4] = (o0_x_min >= i_4_w && data_r[4] == o0_label_r);
   assign flag_min_0_w[5] = (o0_x_min >= i_5_w && data_r[5] == o0_label_r);
   assign flag_min_0_w[6] = (o0_x_min >= i_6_w && data_r[6] == o0_label_r);
   assign flag_min_0_w[7] = (o0_x_min >= i_7_w && data_r[7] == o0_label_r);
   
   assign flag_min_1_w[0] = (o1_x_min >= i_0_w && data_r[0] == o1_label_r);
   assign flag_min_1_w[1] = (o1_x_min >= i_1_w && data_r[1] == o1_label_r);
   assign flag_min_1_w[2] = (o1_x_min >= i_2_w && data_r[2] == o1_label_r);
   assign flag_min_1_w[3] = (o1_x_min >= i_3_w && data_r[3] == o1_label_r);
   assign flag_min_1_w[4] = (o1_x_min >= i_4_w && data_r[4] == o1_label_r);
   assign flag_min_1_w[5] = (o1_x_min >= i_5_w && data_r[5] == o1_label_r);
   assign flag_min_1_w[6] = (o1_x_min >= i_6_w && data_r[6] == o1_label_r);
   assign flag_min_1_w[7] = (o1_x_min >= i_7_w && data_r[7] == o1_label_r);
   
   assign flag_min_2_w[0] = (o2_x_min >= i_0_w && data_r[0] == o2_label_r);
   assign flag_min_2_w[1] = (o2_x_min >= i_1_w && data_r[1] == o2_label_r);
   assign flag_min_2_w[2] = (o2_x_min >= i_2_w && data_r[2] == o2_label_r);
   assign flag_min_2_w[3] = (o2_x_min >= i_3_w && data_r[3] == o2_label_r);
   assign flag_min_2_w[4] = (o2_x_min >= i_4_w && data_r[4] == o2_label_r);
   assign flag_min_2_w[5] = (o2_x_min >= i_5_w && data_r[5] == o2_label_r);
   assign flag_min_2_w[6] = (o2_x_min >= i_6_w && data_r[6] == o2_label_r);
   assign flag_min_2_w[7] = (o2_x_min >= i_7_w && data_r[7] == o2_label_r);
   
   assign flag_min_3_w[0] = (o3_x_min >= i_0_w && data_r[0] == o3_label_r);
   assign flag_min_3_w[1] = (o3_x_min >= i_1_w && data_r[1] == o3_label_r);
   assign flag_min_3_w[2] = (o3_x_min >= i_2_w && data_r[2] == o3_label_r);
   assign flag_min_3_w[3] = (o3_x_min >= i_3_w && data_r[3] == o3_label_r);
   assign flag_min_3_w[4] = (o3_x_min >= i_4_w && data_r[4] == o3_label_r);
   assign flag_min_3_w[5] = (o3_x_min >= i_5_w && data_r[5] == o3_label_r);
   assign flag_min_3_w[6] = (o3_x_min >= i_6_w && data_r[6] == o3_label_r);
   assign flag_min_3_w[7] = (o3_x_min >= i_7_w && data_r[7] == o3_label_r);
   
   assign flag_min_4_w[0] = (o4_x_min >= i_0_w && data_r[0] == o4_label_r);
   assign flag_min_4_w[1] = (o4_x_min >= i_1_w && data_r[1] == o4_label_r);
   assign flag_min_4_w[2] = (o4_x_min >= i_2_w && data_r[2] == o4_label_r);
   assign flag_min_4_w[3] = (o4_x_min >= i_3_w && data_r[3] == o4_label_r);
   assign flag_min_4_w[4] = (o4_x_min >= i_4_w && data_r[4] == o4_label_r);
   assign flag_min_4_w[5] = (o4_x_min >= i_5_w && data_r[5] == o4_label_r);
   assign flag_min_4_w[6] = (o4_x_min >= i_6_w && data_r[6] == o4_label_r);
   assign flag_min_4_w[7] = (o4_x_min >= i_7_w && data_r[7] == o4_label_r);
   
   assign flag_min_5_w[0] = (o5_x_min >= i_0_w && data_r[0] == o5_label_r);
   assign flag_min_5_w[1] = (o5_x_min >= i_1_w && data_r[1] == o5_label_r);
   assign flag_min_5_w[2] = (o5_x_min >= i_2_w && data_r[2] == o5_label_r);
   assign flag_min_5_w[3] = (o5_x_min >= i_3_w && data_r[3] == o5_label_r);
   assign flag_min_5_w[4] = (o5_x_min >= i_4_w && data_r[4] == o5_label_r);
   assign flag_min_5_w[5] = (o5_x_min >= i_5_w && data_r[5] == o5_label_r);
   assign flag_min_5_w[6] = (o5_x_min >= i_6_w && data_r[6] == o5_label_r);
   assign flag_min_5_w[7] = (o5_x_min >= i_7_w && data_r[7] == o5_label_r);
   
   assign flag_min_6_w[0] = (o6_x_min >= i_0_w && data_r[0] == o6_label_r);
   assign flag_min_6_w[1] = (o6_x_min >= i_1_w && data_r[1] == o6_label_r);
   assign flag_min_6_w[2] = (o6_x_min >= i_2_w && data_r[2] == o6_label_r);
   assign flag_min_6_w[3] = (o6_x_min >= i_3_w && data_r[3] == o6_label_r);
   assign flag_min_6_w[4] = (o6_x_min >= i_4_w && data_r[4] == o6_label_r);
   assign flag_min_6_w[5] = (o6_x_min >= i_5_w && data_r[5] == o6_label_r);
   assign flag_min_6_w[6] = (o6_x_min >= i_6_w && data_r[6] == o6_label_r);
   assign flag_min_6_w[7] = (o6_x_min >= i_7_w && data_r[7] == o6_label_r);
   
   assign flag_min_7_w[0] = (o7_x_min >= i_0_w && data_r[0] == o7_label_r);
   assign flag_min_7_w[1] = (o7_x_min >= i_1_w && data_r[1] == o7_label_r);
   assign flag_min_7_w[2] = (o7_x_min >= i_2_w && data_r[2] == o7_label_r);
   assign flag_min_7_w[3] = (o7_x_min >= i_3_w && data_r[3] == o7_label_r);
   assign flag_min_7_w[4] = (o7_x_min >= i_4_w && data_r[4] == o7_label_r);
   assign flag_min_7_w[5] = (o7_x_min >= i_5_w && data_r[5] == o7_label_r);
   assign flag_min_7_w[6] = (o7_x_min >= i_6_w && data_r[6] == o7_label_r);
   assign flag_min_7_w[7] = (o7_x_min >= i_7_w && data_r[7] == o7_label_r);
   
   assign flag_min_8_w[0] = (o8_x_min >= i_0_w && data_r[0] == o8_label_r);
   assign flag_min_8_w[1] = (o8_x_min >= i_1_w && data_r[1] == o8_label_r);
   assign flag_min_8_w[2] = (o8_x_min >= i_2_w && data_r[2] == o8_label_r);
   assign flag_min_8_w[3] = (o8_x_min >= i_3_w && data_r[3] == o8_label_r);
   assign flag_min_8_w[4] = (o8_x_min >= i_4_w && data_r[4] == o8_label_r);
   assign flag_min_8_w[5] = (o8_x_min >= i_5_w && data_r[5] == o8_label_r);
   assign flag_min_8_w[6] = (o8_x_min >= i_6_w && data_r[6] == o8_label_r);
   assign flag_min_8_w[7] = (o8_x_min >= i_7_w && data_r[7] == o8_label_r);
   
   assign flag_min_9_w[0] = (o9_x_min >= i_0_w && data_r[0] == o9_label_r);
   assign flag_min_9_w[1] = (o9_x_min >= i_1_w && data_r[1] == o9_label_r);
   assign flag_min_9_w[2] = (o9_x_min >= i_2_w && data_r[2] == o9_label_r);
   assign flag_min_9_w[3] = (o9_x_min >= i_3_w && data_r[3] == o9_label_r);
   assign flag_min_9_w[4] = (o9_x_min >= i_4_w && data_r[4] == o9_label_r);
   assign flag_min_9_w[5] = (o9_x_min >= i_5_w && data_r[5] == o9_label_r);
   assign flag_min_9_w[6] = (o9_x_min >= i_6_w && data_r[6] == o9_label_r);
   assign flag_min_9_w[7] = (o9_x_min >= i_7_w && data_r[7] == o9_label_r);
   
   
   assign flag_max_0_w[0] = (o0_x_max <= i_0_w && data_r[0] == o0_label_r);
   assign flag_max_0_w[1] = (o0_x_max <= i_1_w && data_r[1] == o0_label_r);
   assign flag_max_0_w[2] = (o0_x_max <= i_2_w && data_r[2] == o0_label_r);
   assign flag_max_0_w[3] = (o0_x_max <= i_3_w && data_r[3] == o0_label_r);
   assign flag_max_0_w[4] = (o0_x_max <= i_4_w && data_r[4] == o0_label_r);
   assign flag_max_0_w[5] = (o0_x_max <= i_5_w && data_r[5] == o0_label_r);
   assign flag_max_0_w[6] = (o0_x_max <= i_6_w && data_r[6] == o0_label_r);
   assign flag_max_0_w[7] = (o0_x_max <= i_7_w && data_r[7] == o0_label_r);
                         
   assign flag_max_1_w[0] = (o1_x_max <= i_0_w && data_r[0] == o1_label_r);
   assign flag_max_1_w[1] = (o1_x_max <= i_1_w && data_r[1] == o1_label_r);
   assign flag_max_1_w[2] = (o1_x_max <= i_2_w && data_r[2] == o1_label_r);
   assign flag_max_1_w[3] = (o1_x_max <= i_3_w && data_r[3] == o1_label_r);
   assign flag_max_1_w[4] = (o1_x_max <= i_4_w && data_r[4] == o1_label_r);
   assign flag_max_1_w[5] = (o1_x_max <= i_5_w && data_r[5] == o1_label_r);
   assign flag_max_1_w[6] = (o1_x_max <= i_6_w && data_r[6] == o1_label_r);
   assign flag_max_1_w[7] = (o1_x_max <= i_7_w && data_r[7] == o1_label_r);
                         
   assign flag_max_2_w[0] = (o2_x_max <= i_0_w && data_r[0] == o2_label_r);
   assign flag_max_2_w[1] = (o2_x_max <= i_1_w && data_r[1] == o2_label_r);
   assign flag_max_2_w[2] = (o2_x_max <= i_2_w && data_r[2] == o2_label_r);
   assign flag_max_2_w[3] = (o2_x_max <= i_3_w && data_r[3] == o2_label_r);
   assign flag_max_2_w[4] = (o2_x_max <= i_4_w && data_r[4] == o2_label_r);
   assign flag_max_2_w[5] = (o2_x_max <= i_5_w && data_r[5] == o2_label_r);
   assign flag_max_2_w[6] = (o2_x_max <= i_6_w && data_r[6] == o2_label_r);
   assign flag_max_2_w[7] = (o2_x_max <= i_7_w && data_r[7] == o2_label_r);
                         
   assign flag_max_3_w[0] = (o3_x_max <= i_0_w && data_r[0] == o3_label_r);
   assign flag_max_3_w[1] = (o3_x_max <= i_1_w && data_r[1] == o3_label_r);
   assign flag_max_3_w[2] = (o3_x_max <= i_2_w && data_r[2] == o3_label_r);
   assign flag_max_3_w[3] = (o3_x_max <= i_3_w && data_r[3] == o3_label_r);
   assign flag_max_3_w[4] = (o3_x_max <= i_4_w && data_r[4] == o3_label_r);
   assign flag_max_3_w[5] = (o3_x_max <= i_5_w && data_r[5] == o3_label_r);
   assign flag_max_3_w[6] = (o3_x_max <= i_6_w && data_r[6] == o3_label_r);
   assign flag_max_3_w[7] = (o3_x_max <= i_7_w && data_r[7] == o3_label_r);
                         
   assign flag_max_4_w[0] = (o4_x_max <= i_0_w && data_r[0] == o4_label_r);
   assign flag_max_4_w[1] = (o4_x_max <= i_1_w && data_r[1] == o4_label_r);
   assign flag_max_4_w[2] = (o4_x_max <= i_2_w && data_r[2] == o4_label_r);
   assign flag_max_4_w[3] = (o4_x_max <= i_3_w && data_r[3] == o4_label_r);
   assign flag_max_4_w[4] = (o4_x_max <= i_4_w && data_r[4] == o4_label_r);
   assign flag_max_4_w[5] = (o4_x_max <= i_5_w && data_r[5] == o4_label_r);
   assign flag_max_4_w[6] = (o4_x_max <= i_6_w && data_r[6] == o4_label_r);
   assign flag_max_4_w[7] = (o4_x_max <= i_7_w && data_r[7] == o4_label_r);
                         
   assign flag_max_5_w[0] = (o5_x_max <= i_0_w && data_r[0] == o5_label_r);
   assign flag_max_5_w[1] = (o5_x_max <= i_1_w && data_r[1] == o5_label_r);
   assign flag_max_5_w[2] = (o5_x_max <= i_2_w && data_r[2] == o5_label_r);
   assign flag_max_5_w[3] = (o5_x_max <= i_3_w && data_r[3] == o5_label_r);
   assign flag_max_5_w[4] = (o5_x_max <= i_4_w && data_r[4] == o5_label_r);
   assign flag_max_5_w[5] = (o5_x_max <= i_5_w && data_r[5] == o5_label_r);
   assign flag_max_5_w[6] = (o5_x_max <= i_6_w && data_r[6] == o5_label_r);
   assign flag_max_5_w[7] = (o5_x_max <= i_7_w && data_r[7] == o5_label_r);
                         
   assign flag_max_6_w[0] = (o6_x_max <= i_0_w && data_r[0] == o6_label_r);
   assign flag_max_6_w[1] = (o6_x_max <= i_1_w && data_r[1] == o6_label_r);
   assign flag_max_6_w[2] = (o6_x_max <= i_2_w && data_r[2] == o6_label_r);
   assign flag_max_6_w[3] = (o6_x_max <= i_3_w && data_r[3] == o6_label_r);
   assign flag_max_6_w[4] = (o6_x_max <= i_4_w && data_r[4] == o6_label_r);
   assign flag_max_6_w[5] = (o6_x_max <= i_5_w && data_r[5] == o6_label_r);
   assign flag_max_6_w[6] = (o6_x_max <= i_6_w && data_r[6] == o6_label_r);
   assign flag_max_6_w[7] = (o6_x_max <= i_7_w && data_r[7] == o6_label_r);
                         
   assign flag_max_7_w[0] = (o7_x_max <= i_0_w && data_r[0] == o7_label_r);
   assign flag_max_7_w[1] = (o7_x_max <= i_1_w && data_r[1] == o7_label_r);
   assign flag_max_7_w[2] = (o7_x_max <= i_2_w && data_r[2] == o7_label_r);
   assign flag_max_7_w[3] = (o7_x_max <= i_3_w && data_r[3] == o7_label_r);
   assign flag_max_7_w[4] = (o7_x_max <= i_4_w && data_r[4] == o7_label_r);
   assign flag_max_7_w[5] = (o7_x_max <= i_5_w && data_r[5] == o7_label_r);
   assign flag_max_7_w[6] = (o7_x_max <= i_6_w && data_r[6] == o7_label_r);
   assign flag_max_7_w[7] = (o7_x_max <= i_7_w && data_r[7] == o7_label_r);
                         
   assign flag_max_8_w[0] = (o8_x_max <= i_0_w && data_r[0] == o8_label_r);
   assign flag_max_8_w[1] = (o8_x_max <= i_1_w && data_r[1] == o8_label_r);
   assign flag_max_8_w[2] = (o8_x_max <= i_2_w && data_r[2] == o8_label_r);
   assign flag_max_8_w[3] = (o8_x_max <= i_3_w && data_r[3] == o8_label_r);
   assign flag_max_8_w[4] = (o8_x_max <= i_4_w && data_r[4] == o8_label_r);
   assign flag_max_8_w[5] = (o8_x_max <= i_5_w && data_r[5] == o8_label_r);
   assign flag_max_8_w[6] = (o8_x_max <= i_6_w && data_r[6] == o8_label_r);
   assign flag_max_8_w[7] = (o8_x_max <= i_7_w && data_r[7] == o8_label_r);
                         
   assign flag_max_9_w[0] = (o9_x_max <= i_0_w && data_r[0] == o9_label_r);
   assign flag_max_9_w[1] = (o9_x_max <= i_1_w && data_r[1] == o9_label_r);
   assign flag_max_9_w[2] = (o9_x_max <= i_2_w && data_r[2] == o9_label_r);
   assign flag_max_9_w[3] = (o9_x_max <= i_3_w && data_r[3] == o9_label_r);
   assign flag_max_9_w[4] = (o9_x_max <= i_4_w && data_r[4] == o9_label_r);
   assign flag_max_9_w[5] = (o9_x_max <= i_5_w && data_r[5] == o9_label_r);
   assign flag_max_9_w[6] = (o9_x_max <= i_6_w && data_r[6] == o9_label_r);
   assign flag_max_9_w[7] = (o9_x_max <= i_7_w && data_r[7] == o9_label_r);
   
   
   
   assign index_min_0_w[2] = !(flag_min_0_w[0] || flag_min_0_w[1] || flag_min_0_w[2] || flag_min_0_w[3]);
   assign index_min_1_w[2] = !(flag_min_1_w[0] || flag_min_1_w[1] || flag_min_1_w[2] || flag_min_1_w[3]);
   assign index_min_2_w[2] = !(flag_min_2_w[0] || flag_min_2_w[1] || flag_min_2_w[2] || flag_min_2_w[3]);
   assign index_min_3_w[2] = !(flag_min_3_w[0] || flag_min_3_w[1] || flag_min_3_w[2] || flag_min_3_w[3]);
   assign index_min_4_w[2] = !(flag_min_4_w[0] || flag_min_4_w[1] || flag_min_4_w[2] || flag_min_4_w[3]);
   assign index_min_5_w[2] = !(flag_min_5_w[0] || flag_min_5_w[1] || flag_min_5_w[2] || flag_min_5_w[3]);
   assign index_min_6_w[2] = !(flag_min_6_w[0] || flag_min_6_w[1] || flag_min_6_w[2] || flag_min_6_w[3]);
   assign index_min_7_w[2] = !(flag_min_7_w[0] || flag_min_7_w[1] || flag_min_7_w[2] || flag_min_7_w[3]);
   assign index_min_8_w[2] = !(flag_min_8_w[0] || flag_min_8_w[1] || flag_min_8_w[2] || flag_min_8_w[3]);
   assign index_min_9_w[2] = !(flag_min_9_w[0] || flag_min_9_w[1] || flag_min_9_w[2] || flag_min_9_w[3]);
   
   assign index_min_0_w[1] = !((index_min_0_w[2])?(flag_min_0_w[4] || flag_min_0_w[5]):(flag_min_0_w[0] || flag_min_0_w[1]));
   assign index_min_1_w[1] = !((index_min_1_w[2])?(flag_min_1_w[4] || flag_min_1_w[5]):(flag_min_1_w[0] || flag_min_1_w[1]));
   assign index_min_2_w[1] = !((index_min_2_w[2])?(flag_min_2_w[4] || flag_min_2_w[5]):(flag_min_2_w[0] || flag_min_2_w[1]));
   assign index_min_3_w[1] = !((index_min_3_w[2])?(flag_min_3_w[4] || flag_min_3_w[5]):(flag_min_3_w[0] || flag_min_3_w[1]));
   assign index_min_4_w[1] = !((index_min_4_w[2])?(flag_min_4_w[4] || flag_min_4_w[5]):(flag_min_4_w[0] || flag_min_4_w[1]));
   assign index_min_5_w[1] = !((index_min_5_w[2])?(flag_min_5_w[4] || flag_min_5_w[5]):(flag_min_5_w[0] || flag_min_5_w[1]));
   assign index_min_6_w[1] = !((index_min_6_w[2])?(flag_min_6_w[4] || flag_min_6_w[5]):(flag_min_6_w[0] || flag_min_6_w[1]));
   assign index_min_7_w[1] = !((index_min_7_w[2])?(flag_min_7_w[4] || flag_min_7_w[5]):(flag_min_7_w[0] || flag_min_7_w[1]));
   assign index_min_8_w[1] = !((index_min_8_w[2])?(flag_min_8_w[4] || flag_min_8_w[5]):(flag_min_8_w[0] || flag_min_8_w[1]));
   assign index_min_9_w[1] = !((index_min_9_w[2])?(flag_min_9_w[4] || flag_min_9_w[5]):(flag_min_9_w[0] || flag_min_9_w[1]));
   
   assign index_min_0_w[0] = !((index_min_0_w[2])? ( (index_min_0_w[1])? flag_min_0_w[6] : flag_min_0_w[4] ) : ( (index_min_0_w[1])? flag_min_0_w[2] : flag_min_0_w[0] )  );
   assign index_min_1_w[0] = !((index_min_1_w[2])? ( (index_min_1_w[1])? flag_min_1_w[6] : flag_min_1_w[4] ) : ( (index_min_1_w[1])? flag_min_1_w[2] : flag_min_1_w[0] )  );
   assign index_min_2_w[0] = !((index_min_2_w[2])? ( (index_min_2_w[1])? flag_min_2_w[6] : flag_min_2_w[4] ) : ( (index_min_2_w[1])? flag_min_2_w[2] : flag_min_2_w[0] )  );
   assign index_min_3_w[0] = !((index_min_3_w[2])? ( (index_min_3_w[1])? flag_min_3_w[6] : flag_min_3_w[4] ) : ( (index_min_3_w[1])? flag_min_3_w[2] : flag_min_3_w[0] )  );
   assign index_min_4_w[0] = !((index_min_4_w[2])? ( (index_min_4_w[1])? flag_min_4_w[6] : flag_min_4_w[4] ) : ( (index_min_4_w[1])? flag_min_4_w[2] : flag_min_4_w[0] )  );
   assign index_min_5_w[0] = !((index_min_5_w[2])? ( (index_min_5_w[1])? flag_min_5_w[6] : flag_min_5_w[4] ) : ( (index_min_5_w[1])? flag_min_5_w[2] : flag_min_5_w[0] )  );
   assign index_min_6_w[0] = !((index_min_6_w[2])? ( (index_min_6_w[1])? flag_min_6_w[6] : flag_min_6_w[4] ) : ( (index_min_6_w[1])? flag_min_6_w[2] : flag_min_6_w[0] )  );
   assign index_min_7_w[0] = !((index_min_7_w[2])? ( (index_min_7_w[1])? flag_min_7_w[6] : flag_min_7_w[4] ) : ( (index_min_7_w[1])? flag_min_7_w[2] : flag_min_7_w[0] )  );
   assign index_min_8_w[0] = !((index_min_8_w[2])? ( (index_min_8_w[1])? flag_min_8_w[6] : flag_min_8_w[4] ) : ( (index_min_8_w[1])? flag_min_8_w[2] : flag_min_8_w[0] )  );
   assign index_min_9_w[0] = !((index_min_9_w[2])? ( (index_min_9_w[1])? flag_min_9_w[6] : flag_min_9_w[4] ) : ( (index_min_9_w[1])? flag_min_9_w[2] : flag_min_9_w[0] )  );
   
   
   assign index_max_0_w[2] = (flag_max_0_w[4] || flag_max_0_w[5] || flag_max_0_w[6] || flag_max_0_w[7]);
   assign index_max_1_w[2] = (flag_max_1_w[4] || flag_max_1_w[5] || flag_max_1_w[6] || flag_max_1_w[7]);
   assign index_max_2_w[2] = (flag_max_2_w[4] || flag_max_2_w[5] || flag_max_2_w[6] || flag_max_2_w[7]);
   assign index_max_3_w[2] = (flag_max_3_w[4] || flag_max_3_w[5] || flag_max_3_w[6] || flag_max_3_w[7]);
   assign index_max_4_w[2] = (flag_max_4_w[4] || flag_max_4_w[5] || flag_max_4_w[6] || flag_max_4_w[7]);
   assign index_max_5_w[2] = (flag_max_5_w[4] || flag_max_5_w[5] || flag_max_5_w[6] || flag_max_5_w[7]);
   assign index_max_6_w[2] = (flag_max_6_w[4] || flag_max_6_w[5] || flag_max_6_w[6] || flag_max_6_w[7]);
   assign index_max_7_w[2] = (flag_max_7_w[4] || flag_max_7_w[5] || flag_max_7_w[6] || flag_max_7_w[7]);
   assign index_max_8_w[2] = (flag_max_8_w[4] || flag_max_8_w[5] || flag_max_8_w[6] || flag_max_8_w[7]);
   assign index_max_9_w[2] = (flag_max_9_w[4] || flag_max_9_w[5] || flag_max_9_w[6] || flag_max_9_w[7]);
   
   assign index_max_0_w[1] = ((index_max_0_w[2])?(flag_max_0_w[6] || flag_max_0_w[7]):(flag_max_0_w[2] || flag_max_0_w[3]));
   assign index_max_1_w[1] = ((index_max_1_w[2])?(flag_max_1_w[6] || flag_max_1_w[7]):(flag_max_1_w[2] || flag_max_1_w[3]));
   assign index_max_2_w[1] = ((index_max_2_w[2])?(flag_max_2_w[6] || flag_max_2_w[7]):(flag_max_2_w[2] || flag_max_2_w[3]));
   assign index_max_3_w[1] = ((index_max_3_w[2])?(flag_max_3_w[6] || flag_max_3_w[7]):(flag_max_3_w[2] || flag_max_3_w[3]));
   assign index_max_4_w[1] = ((index_max_4_w[2])?(flag_max_4_w[6] || flag_max_4_w[7]):(flag_max_4_w[2] || flag_max_4_w[3]));
   assign index_max_5_w[1] = ((index_max_5_w[2])?(flag_max_5_w[6] || flag_max_5_w[7]):(flag_max_5_w[2] || flag_max_5_w[3]));
   assign index_max_6_w[1] = ((index_max_6_w[2])?(flag_max_6_w[6] || flag_max_6_w[7]):(flag_max_6_w[2] || flag_max_6_w[3]));
   assign index_max_7_w[1] = ((index_max_7_w[2])?(flag_max_7_w[6] || flag_max_7_w[7]):(flag_max_7_w[2] || flag_max_7_w[3]));
   assign index_max_8_w[1] = ((index_max_8_w[2])?(flag_max_8_w[6] || flag_max_8_w[7]):(flag_max_8_w[2] || flag_max_8_w[3]));
   assign index_max_9_w[1] = ((index_max_9_w[2])?(flag_max_9_w[6] || flag_max_9_w[7]):(flag_max_9_w[2] || flag_max_9_w[3]));
   
   assign index_max_0_w[0] = ((index_max_0_w[2])? ( (index_max_0_w[1])? flag_max_0_w[7] : flag_max_0_w[5] ) : ( (index_max_0_w[1])? flag_max_0_w[3] : flag_max_0_w[1] )  );
   assign index_max_1_w[0] = ((index_max_1_w[2])? ( (index_max_1_w[1])? flag_max_1_w[7] : flag_max_1_w[5] ) : ( (index_max_1_w[1])? flag_max_1_w[3] : flag_max_1_w[1] )  );
   assign index_max_2_w[0] = ((index_max_2_w[2])? ( (index_max_2_w[1])? flag_max_2_w[7] : flag_max_2_w[5] ) : ( (index_max_2_w[1])? flag_max_2_w[3] : flag_max_2_w[1] )  );
   assign index_max_3_w[0] = ((index_max_3_w[2])? ( (index_max_3_w[1])? flag_max_3_w[7] : flag_max_3_w[5] ) : ( (index_max_3_w[1])? flag_max_3_w[3] : flag_max_3_w[1] )  );
   assign index_max_4_w[0] = ((index_max_4_w[2])? ( (index_max_4_w[1])? flag_max_4_w[7] : flag_max_4_w[5] ) : ( (index_max_4_w[1])? flag_max_4_w[3] : flag_max_4_w[1] )  );
   assign index_max_5_w[0] = ((index_max_5_w[2])? ( (index_max_5_w[1])? flag_max_5_w[7] : flag_max_5_w[5] ) : ( (index_max_5_w[1])? flag_max_5_w[3] : flag_max_5_w[1] )  );
   assign index_max_6_w[0] = ((index_max_6_w[2])? ( (index_max_6_w[1])? flag_max_6_w[7] : flag_max_6_w[5] ) : ( (index_max_6_w[1])? flag_max_6_w[3] : flag_max_6_w[1] )  );
   assign index_max_7_w[0] = ((index_max_7_w[2])? ( (index_max_7_w[1])? flag_max_7_w[7] : flag_max_7_w[5] ) : ( (index_max_7_w[1])? flag_max_7_w[3] : flag_max_7_w[1] )  );
   assign index_max_8_w[0] = ((index_max_8_w[2])? ( (index_max_8_w[1])? flag_max_8_w[7] : flag_max_8_w[5] ) : ( (index_max_8_w[1])? flag_max_8_w[3] : flag_max_8_w[1] )  );
   assign index_max_9_w[0] = ((index_max_9_w[2])? ( (index_max_9_w[1])? flag_max_9_w[7] : flag_max_9_w[5] ) : ( (index_max_9_w[1])? flag_max_9_w[3] : flag_max_9_w[1] )  );
   
   assign o0_x_min_w = (|flag_min_0_w)?{count_i_r, index_min_0_w}:o0_x_min;
   assign o1_x_min_w = (|flag_min_1_w)?{count_i_r, index_min_1_w}:o1_x_min;
   assign o2_x_min_w = (|flag_min_2_w)?{count_i_r, index_min_2_w}:o2_x_min;
   assign o3_x_min_w = (|flag_min_3_w)?{count_i_r, index_min_3_w}:o3_x_min;
   assign o4_x_min_w = (|flag_min_4_w)?{count_i_r, index_min_4_w}:o4_x_min;
   assign o5_x_min_w = (|flag_min_5_w)?{count_i_r, index_min_5_w}:o5_x_min;
   assign o6_x_min_w = (|flag_min_6_w)?{count_i_r, index_min_6_w}:o6_x_min;
   assign o7_x_min_w = (|flag_min_7_w)?{count_i_r, index_min_7_w}:o7_x_min;
   assign o8_x_min_w = (|flag_min_8_w)?{count_i_r, index_min_8_w}:o8_x_min;
   assign o9_x_min_w = (|flag_min_9_w)?{count_i_r, index_min_9_w}:o9_x_min;
   
   
   assign o0_x_max_w = (|flag_max_0_w)?{count_i_r, index_max_0_w}:o0_x_max;
   assign o1_x_max_w = (|flag_max_1_w)?{count_i_r, index_max_1_w}:o1_x_max;
   assign o2_x_max_w = (|flag_max_2_w)?{count_i_r, index_max_2_w}:o2_x_max;
   assign o3_x_max_w = (|flag_max_3_w)?{count_i_r, index_max_3_w}:o3_x_max;
   assign o4_x_max_w = (|flag_max_4_w)?{count_i_r, index_max_4_w}:o4_x_max;
   assign o5_x_max_w = (|flag_max_5_w)?{count_i_r, index_max_5_w}:o5_x_max;
   assign o6_x_max_w = (|flag_max_6_w)?{count_i_r, index_max_6_w}:o6_x_max;
   assign o7_x_max_w = (|flag_max_7_w)?{count_i_r, index_max_7_w}:o7_x_max;
   assign o8_x_max_w = (|flag_max_8_w)?{count_i_r, index_max_8_w}:o8_x_max;
   assign o9_x_max_w = (|flag_max_9_w)?{count_i_r, index_max_9_w}:o9_x_max;


   
   
//========================================================================================================     
   always@(*)
   begin
      if(start_r == 1'b1)
      begin
         if(count_i_r == WIDTH-1)
         begin
            count_i_w = 7'd0;
            if(count_j_r != HEIGHT-1)
               count_j_w = count_j_r + 9'd1;
            else
               count_j_w = 9'd0;
         end
         else
         begin
            count_i_w = count_i_r + 7'd1;
            count_j_w = count_j_r;
            
         end
      
      end
      else
      begin
         count_i_w = 7'd0;
         count_j_w = 9'd0;
      end
   
   end
   
  
   
   
   
  
   
   
   
   
   
   
   
   
   
   
   
   
   
//   wire gclk = clk & ObjectInfoRSPE_en;
   
   always@(posedge clk or posedge reset)                             
   begin
      
      if(reset)
      begin
         o0_x_min <= 10'd1023;
         o1_x_min <= 10'd1023;
         o2_x_min <= 10'd1023;
         o3_x_min <= 10'd1023;
         o4_x_min <= 10'd1023;
         o5_x_min <= 10'd1023;
         o6_x_min <= 10'd1023;
         o7_x_min <= 10'd1023;
         o8_x_min <= 10'd1023;
         o9_x_min <= 10'd1023;
         o0_x_max <= 10'd0;
         o1_x_max <= 10'd0;
         o2_x_max <= 10'd0;
         o3_x_max <= 10'd0;
         o4_x_max <= 10'd0;
         o5_x_max <= 10'd0;
         o6_x_max <= 10'd0;
         o7_x_max <= 10'd0;
         o8_x_max <= 10'd0;
         o9_x_max <= 10'd0;
         o0_y_min <= 9'd511;
         o1_y_min <= 9'd511;
         o2_y_min <= 9'd511;
         o3_y_min <= 9'd511;
         o4_y_min <= 9'd511;
         o5_y_min <= 9'd511;
         o6_y_min <= 9'd511;
         o7_y_min <= 9'd511;
         o8_y_min <= 9'd511;
         o9_y_min <= 9'd511;
         o0_y_max <= 9'd0;
         o1_y_max <= 9'd0;
         o2_y_max <= 9'd0;
         o3_y_max <= 9'd0;
         o4_y_max <= 9'd0;
         o5_y_max <= 9'd0;
         o6_y_max <= 9'd0;
         o7_y_max <= 9'd0;
         o8_y_max <= 9'd0;         
         o9_y_max <= 9'd0;
         
         count_i_r <= 7'd0;
         count_j_r <= 9'd0;
         
         start_r <= 1'b0;
         
         o0_label_r <= 8'd255;
         o1_label_r <= 8'd255;
         o2_label_r <= 8'd255;
         o3_label_r <= 8'd255;
         o4_label_r <= 8'd255;
         o5_label_r <= 8'd255;
         o6_label_r <= 8'd255;
         o7_label_r <= 8'd255;
         o8_label_r <= 8'd255;
         o9_label_r <= 8'd255;
         
         data_r[0] <= 8'd0;
         data_r[1] <= 8'd0;
         data_r[2] <= 8'd0;
         data_r[3] <= 8'd0;
         data_r[4] <= 8'd0;
         data_r[5] <= 8'd0;
         data_r[6] <= 8'd0;
         data_r[7] <= 8'd0;
         
            
            
            
      end
      else
      begin
         if(ObjectInfoRSPE_en)
         begin
            o0_x_min <= o0_x_min_w;
            o1_x_min <= o1_x_min_w;
            o2_x_min <= o2_x_min_w;
            o3_x_min <= o3_x_min_w;
            o4_x_min <= o4_x_min_w;
            o5_x_min <= o5_x_min_w;
            o6_x_min <= o6_x_min_w;
            o7_x_min <= o7_x_min_w;
            o8_x_min <= o8_x_min_w;
            o9_x_min <= o9_x_min_w;
            o0_x_max <= o0_x_max_w;
            o1_x_max <= o1_x_max_w;
            o2_x_max <= o2_x_max_w;
            o3_x_max <= o3_x_max_w;
            o4_x_max <= o4_x_max_w;
            o5_x_max <= o5_x_max_w;
            o6_x_max <= o6_x_max_w;
            o7_x_max <= o7_x_max_w;
            o8_x_max <= o8_x_max_w;
            o9_x_max <= o9_x_max_w;
            o0_y_min <= o0_y_min_w;
            o1_y_min <= o1_y_min_w;
            o2_y_min <= o2_y_min_w;
            o3_y_min <= o3_y_min_w;
            o4_y_min <= o4_y_min_w;
            o5_y_min <= o5_y_min_w;
            o6_y_min <= o6_y_min_w;
            o7_y_min <= o7_y_min_w;
            o8_y_min <= o8_y_min_w;
            o9_y_min <= o9_y_min_w;
            o0_y_max <= o0_y_max_w;
            o1_y_max <= o1_y_max_w;
            o2_y_max <= o2_y_max_w;
            o3_y_max <= o3_y_max_w;
            o4_y_max <= o4_y_max_w;
            o5_y_max <= o5_y_max_w;
            o6_y_max <= o6_y_max_w;
            o7_y_max <= o7_y_max_w;
            o8_y_max <= o8_y_max_w;
            o9_y_max <= o9_y_max_w;
            
            count_i_r <= count_i_w;
            count_j_r <= count_j_w;
            
            start_r <= start;
            
            o0_label_r <= o0_label;
            o1_label_r <= o1_label;
            o2_label_r <= o2_label;
            o3_label_r <= o3_label;
            o4_label_r <= o4_label;
            o5_label_r <= o5_label;
            o6_label_r <= o6_label;
            o7_label_r <= o7_label;
            o8_label_r <= o8_label;
            o9_label_r <= o9_label;
            
            data_r[0] <= Data_64bit[07:00];
            data_r[1] <= Data_64bit[15:08];
            data_r[2] <= Data_64bit[23:16];
            data_r[3] <= Data_64bit[31:24];
            data_r[4] <= Data_64bit[39:32];
            data_r[5] <= Data_64bit[47:40];
            data_r[6] <= Data_64bit[55:48];
            data_r[7] <= Data_64bit[63:56];
            
            
            
            
            
         end
            
            
            
            
      end   
            
   end      
            
            

                      
                      

endmodule