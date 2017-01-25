module distance_compute(clk, reset, 
                        data_read_C_A, data_read_C_B, //read candidate in
                        data_write_C_B, //write for next iteration
                        A_C_out, B_C_out, //Address out  A:read B:write for next iteration
                        CSA_C, CSB_C, 
                        data_read_T_A, data_read_T_B, //read target histogram
                        CSA_T, CSB_T, 
                        distance, distance_compute_enable, 
                        iteration_times, //iteration in
                        total_histogram_C, //sum of histogram in
                        total_histogram_T, //sum of target in
                        done, MUX
                        );
   input             clk, reset;
   input             distance_compute_enable;
   input    [2:0]    iteration_times;
   input    [63:0]   data_read_C_A, data_read_C_B;
   //input    [255:0]  flag;
   output   [3:0]    MUX;
   
   
   
   input    [63:0]   data_read_T_A, data_read_T_B;
   //input    [2:0]    size_C;//8 kinds of size: 64, 128, 256, 512, 1024, 2048, 4096, 8192
   //input    [2:0]    size_T;//8 kinds of size: 64, 128, 256, 512, 1024, 2048, 4096, 8192
   input    [19:0]   total_histogram_C, total_histogram_T;
   output   [63:0]   data_write_C_B;
   
   output   [5:0]    A_C_out, B_C_out;
   //output   [7:0]    A_T_out, B_T_out;
   output            CSA_C, CSB_C;
   output            CSA_T, CSB_T;
   
   output   [63:0]   distance;
   output            done;
   
   reg               CSA_C_w, CSA_T_w, CSB_T_w, CSB_C_w;
   reg               CSA_C_r, CSA_T_r, CSB_T_r, CSB_C_r;
   reg               done_r;
   
   wire              done_w;
   wire     [3:0]    MUX_w;
   reg      [3:0]    MUX_r;
   
   wire     [63:0]   data_write_C_B_w;
   reg      [63:0]   data_write_C_B_r;
   
   reg      [1:0]    state_r, state_w;
   reg      [1:0]    state_d_r, state_d_d_r, state_d_d_d_r, state_d_d_d_d_r, state_d_d_d_d_d_r;
   reg      [1:0]    state_d_d_d_d_d_d_r, state_d_d_d_d_d_d_d_r, state_d_d_d_d_d_d_d_d_r;
   
   reg      [6:0]    A_out_C_r;
   reg      [6:0]    A_out_C_d_r;
   wire     [6:0]    A_out_C_w;
   
   reg      [6:0]    B_out_C_r;
   wire     [6:0]    B_out_C_w;
   reg      [6:0]    B_out_C_d_r;
   reg      [6:0]    B_out_C_d_d_r;
   reg      [6:0]    B_out_C_d_d_d_r;
   reg      [6:0]    B_out_C_d_d_d_d_r;
   reg      [6:0]    B_out_C_d_d_d_d_d_r;
   reg      [6:0]    B_out_C_d_d_d_d_d_d_r;
   reg      [6:0]    B_out_C_d_d_d_d_d_d_d_r;
   reg      [6:0]    B_out_C_d_d_d_d_d_d_d_d_r;
   reg      [6:0]    B_out_C_d_d_d_d_d_d_d_d_d_r;
   reg      [6:0]    B_out_C_d_d_d_d_d_d_d_d_d_d_r;
   
   reg      [7:0]    A_out_T_r;
   wire     [7:0]    A_out_T_w;
   
   reg      [5:0]    B_out_T_r;
   wire     [5:0]    B_out_T_w;
   
   reg      [6:0]    index_w;
   reg      [6:0]    index_r;
   reg      [2:0]    iter_count_r;
   reg      [2:0]    iter_count_d_r;
   reg      [2:0]    iter_count_d_d_r;
   wire     [2:0]    iter_count_w;
   
   wire     [31:0]   normalize_C_E_w;
   wire     [31:0]   normalize_T_E_w;
   
   
   wire     [35:0]   temp_normalize_C_E_w;
   wire     [35:0]   temp_normalize_T_E_w;
   
   reg      [35:0]   temp_normalize_C_E_r;
   reg      [35:0]   temp_normalize_T_E_r;
   
   
   //wire     [2:0]    size_C_w, size_T_w;
   //reg      [2:0]    size_C_r, size_T_r;
   reg      [31:0]   exe_A2_r, exe_A1_r;
   reg      [28:0]   exe_A3_r, exe_A4_r;
   reg      [28:0]   exe_G3_r, exe_G4_r;//, exe_G1_r, exe_G2_r;
   reg      [31:0]   exe_H2_r;
   reg      [28:0]   exe_H4_r, exe_H3_r;//, exe_H1_r;
   reg      [31:0]   exe_E2_r, exe_E1_r;
   reg      [28:0]   exe_E3_r, exe_E4_r;
   reg      [31:0]   exe_F2_r, exe_F1_r;
   reg      [28:0]   exe_F3_r, exe_F4_r;
   reg      [28:0]   exe_I4_r;//, exe_I1_r, exe_I3_r, exe_I2_r;
   
   wire     [31:0]   exe_C1_w, exe_C2_w;
   wire     [28:0]   exe_C3_w, exe_C4_w;
   reg      [31:0]   exe_C1_r, exe_C2_r;
   reg      [28:0]   exe_C3_r, exe_C4_r;
   
   reg      [47:0]   temp_exe_C1_w, temp_exe_C2_w;
   reg      [44:0]   temp_exe_C3_w, temp_exe_C4_w;
   reg      [47:0]   temp_exe_C1_r, temp_exe_C2_r;
   reg      [44:0]   temp_exe_C3_r, temp_exe_C4_r;
   wire     [47:0]   temp_temp_exe_C1_w, temp_temp_exe_C2_w;
   wire     [44:0]   temp_temp_exe_C3_w, temp_temp_exe_C4_w;
   
   wire     [31:0]   difference_of_nC_nT_E;
   reg      [31:0]   difference_of_nC_nT_E_r;
   reg               Sign_difference_of_nC_nT_E_d_r;
   wire     [31:0]   abs_difference_of_nC_nT_E;
   reg      [31:0]   abs_difference_of_nC_nT_E_r;
   wire              normalize;
   reg               normalize_r, normalize_d_r;
   wire     [31:0]   add_A1_B2_D2_w;
   reg      [31:0]   add_A1_B2_D2_r;
   wire     [31:0]   down_sample_w;
   reg      [31:0]   down_sample_r;
   wire     [31:0]   abs_add_down_sample_w;
   reg      [31:0]   abs_add_down_sample_r;
   
   reg      [31:0]   add_A1_B2_D2_d_r;
   reg      [31:0]   add_A2_C2_D1_d_r;                                        
   //wire     [63:0]   abs_B2_w;
   
   wire     [31:0]   normalize_C_O_w;
   wire     [31:0]   normalize_T_O_w;
   wire     [35:0]   temp_normalize_C_O_w;
   wire     [35:0]   temp_normalize_T_O_w;
   reg      [35:0]   temp_normalize_C_O_r;
   reg      [35:0]   temp_normalize_T_O_r;
   
   
   reg      [31:0]   exe_B1_r, exe_B2_r;
   reg      [28:0]   exe_B3_r, exe_B4_r;
   wire     [31:0]   exe_D1_w, exe_D2_w;
   wire     [28:0]   exe_D3_w, exe_D4_w;
   reg      [31:0]   exe_D1_r, exe_D2_r;
   reg      [28:0]   exe_D3_r, exe_D4_r;
   reg      [47:0]   temp_exe_D1_w, temp_exe_D2_w;
   reg      [44:0]   temp_exe_D3_w, temp_exe_D4_w;
   reg      [47:0]   temp_exe_D1_r, temp_exe_D2_r;
   reg      [44:0]   temp_exe_D3_r, temp_exe_D4_r;
   wire     [47:0]   temp_temp_exe_D1_w, temp_temp_exe_D2_w;
   wire     [44:0]   temp_temp_exe_D3_w, temp_temp_exe_D4_w;
   
   wire     [31:0]   t_exe_A2_w, t_exe_H2_w, t_exe_E2_w, t_exe_F2_w, t_exe_F1_w, t_exe_E1_w;
   wire     [28:0]   t_exe_H3_w, t_exe_G3_w, t_exe_B3_w, t_exe_C4_w, t_exe_A3_w, t_exe_B4_w, t_exe_G4_w;
   
   wire     [31:0]   difference_of_nC_nT_O;
   reg      [31:0]   difference_of_nC_nT_O_r;
   reg               Sign_difference_of_nC_nT_O_d_r;
   wire     [31:0]   abs_difference_of_nC_nT_O;
   reg      [31:0]   abs_difference_of_nC_nT_O_r;
   wire     [31:0]   add_A2_C2_D1_w;
   reg      [31:0]   add_A2_C2_D1_r;
   wire     [31:0]   data_out_temp_w;
   wire              normalize_w;
   wire     [3:0]    temp_MUX;
   
   reg      [63:0]   data_read_C_A_r, data_read_T_A_r;
   reg      [63:0]   data_read_C_A_d_r;
   
   //reg      [63:0]   add_A2_B1_C2_r;
   
   
   //wire     [63:0]   abs_B2_w;
   
   reg      [63:0]   distance_r;
   reg      [63:0]   distance_w;
   
   //assign WEAN_T = 1'b1;
   //assign WEAN_C = 1'b1;
   //assign WEBN_T = 1'b1;
   //assign WEBN_C = 1'b0;  
   //assign OEA_C = 1'b1;
   //assign OEA_T = 1'b1;
   //assign OEB_C = 1'b0;
   //assign OEB_T = 1'b0;
   assign CSA_C = CSA_C_r;
   assign CSA_T = CSA_T_r;
   assign CSB_T = CSB_T_r;
   assign CSB_C = CSB_C_r;
   
   assign temp_MUX = (B_out_C_d_d_d_d_d_d_d_d_d_r[0] == 1'b0) ? 4'b0011 : 4'b1100;
   assign MUX_w = temp_MUX;
   assign MUX = MUX_r;

//做normalize   
   assign normalize_C_E_w = (normalize == 1'b1)? ({1'b0,temp_normalize_C_E_r[35:5]}) : data_read_C_A_d_r[31:0];                //No negative in first read (without normalize)
   assign normalize_C_O_w = (normalize == 1'b1)? ({1'b0,temp_normalize_C_O_r[35:5]}) : data_read_C_A_d_r[63:32];
   assign normalize_T_E_w = (normalize == 1'b1)? ({1'b0,temp_normalize_T_E_r[35:5]}) : data_read_T_A_r[31:0];
   assign normalize_T_O_w = (normalize == 1'b1)? ({1'b0,temp_normalize_T_O_r[35:5]}) : data_read_T_A_r[63:32];
   assign temp_normalize_C_E_w = (A_out_C_d_r[0] == 1'b0) ? (data_read_C_A_r[15:0] * total_histogram_T ): (data_read_C_A_r[47:32] * total_histogram_T);   //candidate * total target
   assign temp_normalize_C_O_w = (A_out_C_d_r[0] == 1'b0) ? (data_read_C_A_r[31:16] * total_histogram_T) :( data_read_C_A_r[63:48] * total_histogram_T);
   assign temp_normalize_T_E_w = (A_out_C_d_r[0] == 1'b0) ? (data_read_T_A_r[15:0] * total_histogram_C ): (data_read_T_A_r[47:32] * total_histogram_C);   //target * total candidate
   assign temp_normalize_T_O_w = (A_out_C_d_r[0] == 1'b0) ? (data_read_T_A_r[31:16] * total_histogram_C) :( data_read_T_A_r[63:48] * total_histogram_C);
   
   
   assign normalize = normalize_r;
   assign normalize_w = (iter_count_r == 3'd1) ? 1'd1 : 1'd0;
   assign distance = distance_r;
   assign done = done_r;
   assign abs_difference_of_nC_nT_E = (difference_of_nC_nT_E[31] == 1'b0) ? difference_of_nC_nT_E : (~difference_of_nC_nT_E + 32'd1);
   assign difference_of_nC_nT_E = (iter_count_r == 3'd1) ? normalize_C_E_w - normalize_T_E_w : normalize_C_E_w;

//第一排shift register   
   assign exe_C1_w = (state_d_d_d_d_r == 2'd2)?32'd0:temp_temp_exe_C1_w[47:16];    
   assign exe_C2_w = (state_d_d_d_d_r == 2'd2)?32'd0:temp_temp_exe_C2_w[47:16];    
   assign exe_C3_w = (state_d_d_d_d_r == 2'd2)?29'd0:temp_temp_exe_C3_w[44:16];    
   assign exe_C4_w = (state_d_d_d_d_r == 2'd2)?29'd0:temp_temp_exe_C4_w[44:16];  
   assign temp_temp_exe_C1_w = ((Sign_difference_of_nC_nT_E_d_r == 1'b0) ? temp_exe_C1_r + 48'h8000 : (~(temp_exe_C1_r-48'd1)+48'h8000));// + 16'h8000;
   assign temp_temp_exe_C2_w = ((Sign_difference_of_nC_nT_E_d_r == 1'b0) ? temp_exe_C2_r + 48'h8000 : (~(temp_exe_C2_r-48'd1)+48'h8000));// + 16'h8000;
   assign temp_temp_exe_C3_w = ((Sign_difference_of_nC_nT_E_d_r == 1'b0) ? temp_exe_C3_r + 45'h8000 : (~(temp_exe_C3_r-45'd1)+45'h8000 ));// + 16'h8000;
   assign temp_temp_exe_C4_w = ((Sign_difference_of_nC_nT_E_d_r == 1'b0) ? temp_exe_C4_r + 45'h8000 : (~(temp_exe_C4_r-45'd1)+45'h8000 ));// + 16'h8000;
   
   assign abs_difference_of_nC_nT_O = (difference_of_nC_nT_O[31] == 1'b0) ? difference_of_nC_nT_O : (~difference_of_nC_nT_O + 32'd1);
   assign difference_of_nC_nT_O = (iter_count_r == 3'd1) ? normalize_C_O_w - normalize_T_O_w : normalize_C_O_w;
   assign exe_D1_w = (state_d_d_d_d_r == 2'd2)?32'd0:temp_temp_exe_D1_w[47:16];    
   assign exe_D2_w = (state_d_d_d_d_r == 2'd2)?32'd0:temp_temp_exe_D2_w[47:16];    
   assign exe_D3_w = (state_d_d_d_d_r == 2'd2)?29'd0:temp_temp_exe_D3_w[44:16];    
   assign exe_D4_w = (state_d_d_d_d_r == 2'd2)?29'd0:temp_temp_exe_D4_w[44:16];    
   assign temp_temp_exe_D1_w = ((Sign_difference_of_nC_nT_O_d_r == 1'b0) ? temp_exe_D1_r  + 48'h8000: (~(temp_exe_D1_r-48'd1)+48'h8000));// + 16'h8000;
   assign temp_temp_exe_D2_w = ((Sign_difference_of_nC_nT_O_d_r == 1'b0) ? temp_exe_D2_r  + 48'h8000: (~(temp_exe_D2_r-48'd1)+48'h8000));// + 16'h8000;
   assign temp_temp_exe_D3_w = ((Sign_difference_of_nC_nT_O_d_r == 1'b0) ? temp_exe_D3_r  + 45'h8000:(~(temp_exe_D3_r-45'd1)+45'h8000 ));// + 16'h8000;
   assign temp_temp_exe_D4_w = ((Sign_difference_of_nC_nT_O_d_r == 1'b0) ? temp_exe_D4_r  + 45'h8000:(~(temp_exe_D4_r-45'd1)+45'h8000 ));// + 16'h8000;
   
   assign A_out_C_w = (state_r == 2'b1) ? (iter_count_r == 3'd1 ? (A_out_C_r + 7'd1) : (A_out_C_r + 7'd2)) : 7'd0;    
   assign B_out_C_w = (state_r == 2'b1) ? (B_out_C_r + 7'd1) : 7'd0;    
       
   assign A_C_out = A_out_C_r[6:1];
   assign B_C_out = B_out_C_d_d_d_d_d_d_d_d_d_d_r[6:1];//delay register
           
   //assign size_C_w = (state_r == 2'b0) ? size_C : ((state_r == 2'd2) ? 3'd0 : size_C_r);
   //assign size_T_w = (state_r == 2'b0) ? size_T : ((state_r == 2'd2) ? 3'd0 : size_T_r);
   
//Shift Register的運算
//這裡為了handle在切換iteration的時候  上一個iteration最後幾個address與現在iteration不要互相影響   
   assign t_exe_C4_w = (B_out_C_d_d_d_d_d_r < B_out_C_d_d_d_d_d_d_d_r   && iter_count_r != 3'd1)? 29'd0 : exe_C4_r;
   assign t_exe_A2_w = (B_out_C_d_d_d_d_d_d_r < B_out_C_d_d_d_d_d_d_d_r && iter_count_r != 3'd1)? 32'd0 : exe_A2_r;
   assign t_exe_A3_w = (B_out_C_d_d_d_d_d_d_r < B_out_C_d_d_d_d_d_d_d_r && iter_count_r != 3'd1)? 29'd0 : exe_A3_r;
   assign t_exe_E2_w = exe_E2_r;
   assign t_exe_E1_w = exe_E1_r;
   assign t_exe_G3_w = exe_G3_r;
   assign t_exe_G4_w = exe_G4_r;
   
   assign t_exe_B3_w = (B_out_C_d_d_d_d_d_d_r < B_out_C_d_d_d_d_d_d_d_r && iter_count_r != 3'd1)? 29'd0 : exe_B3_r;
   assign t_exe_B4_w = (B_out_C_d_d_d_d_d_d_r < B_out_C_d_d_d_d_d_d_d_r && iter_count_r != 3'd1)? 29'd0 : exe_B4_r;
   assign t_exe_F2_w = exe_F2_r;                          
   assign t_exe_F1_w = exe_F1_r;
   assign t_exe_H2_w = exe_H2_r;
   assign t_exe_H3_w = exe_H3_r;
   
   
   assign add_A1_B2_D2_w = (state_d_d_d_d_d_d_d_r == 2'd1 || (iter_count_d_d_r == 3'd1 && state_r == 2'd1) ) ? ({{2{t_exe_E1_w[31]}}, t_exe_E1_w} + {{2{t_exe_H2_w[31]}}, t_exe_H2_w} + {{2{t_exe_F2_w[31]}}, t_exe_F2_w} + {{3{t_exe_G3_w[28]}}, t_exe_G3_w} + {{3{t_exe_A3_w[28]}}, t_exe_A3_w} + {{3{t_exe_B4_w[28]}}, t_exe_B4_w} + {{3{  exe_I4_r[28]}},   exe_I4_r}) : 32'd0;
   assign add_A2_C2_D1_w = (state_d_d_d_d_d_d_d_r == 2'd1 || (iter_count_d_d_r == 3'd1 && state_r == 2'd1)) ?  ({{2{t_exe_F1_w[31]}}, t_exe_F1_w} + {{2{t_exe_E2_w[31]}}, t_exe_E2_w} + {{2{t_exe_A2_w[31]}}, t_exe_A2_w} + {{3{t_exe_B3_w[28]}}, t_exe_B3_w} + {{3{t_exe_H3_w[28]}}, t_exe_H3_w} + {{3{t_exe_C4_w[28]}}, t_exe_C4_w} + {{3{t_exe_G4_w[28]}}, t_exe_G4_w}) : 32'd0;
   assign down_sample_w =  (add_A1_B2_D2_r + add_A2_C2_D1_r);
   
   assign data_out_temp_w = {{1{down_sample_r[31]}}, down_sample_r[31:1]};
   assign abs_add_down_sample_w = (data_out_temp_w[31] == 1'b0) ? down_sample_r: (~down_sample_r + 32'd1);
   assign data_write_C_B_w = (temp_MUX == 4'b0011)?({32'd0, data_out_temp_w}) : ({data_out_temp_w, 32'd0});
   assign data_write_C_B = data_write_C_B_r;
   
   //assign data_write_C_B = {{1{down_sample_w[63]}}, down_sample_w[63:1]};
   //assign abs_add_down_sample_w = (data_write_C_B[63] == 1'b0) ? data_write_C_B : (~data_write_C_B + 64'd1);
   //assign abs_B2_w = (exe_B2_r[63] == 1'b0) ? exe_B2_r : (~exe_B2_r + 64'd1);
   //assign abs_B2_w = (exe_B2_r[63] == 1'b0) ? exe_B2_r : (~exe_B2_r + 64'd1);
   
   assign done_w = (state_d_d_d_d_d_d_d_d_r == 2'd3) ? 1'b1 : 1'b0;
   assign iter_count_w = (state_r == 2'b0) ? 3'd1 : ( (state_r == 2'd2) ? iter_count_r + 3'd1 : iter_count_r );

//每次iteration要跑的次數不同   
   always@(*)
   begin
      case(iter_count_w)
         3'd1: index_w = 7'd127;
         3'd2: index_w = 7'd126;
         3'd3: index_w = 7'd62;
         3'd4: index_w = 7'd30;
         3'd5: index_w = 7'd14;
         
         default:index_w = 7'd127;
      endcase
   
   end
   
   always@(*)
   begin
      case(state_r)
         2'd0:
         begin
            CSA_C_w = 1'b1;
            CSA_T_w = 1'b1;
         end       
         2'd1:     
         begin     
            CSA_C_w = 1'b1;
            CSA_T_w = 1'b1;
         end       
         2'd2:     
         begin     
            CSA_C_w = 1'b1;
            CSA_T_w = 1'b1;
         end       
         2'd3:     
         begin     
            CSA_C_w = 1'b0;
            CSA_T_w = 1'b0;
         end
         default:
         begin
            CSA_C_w = 1'b0;
            CSA_T_w = 1'b0;
         end
      endcase   
   
   end
   
   always@(*)
   begin
      case(state_d_r)
         2'd0:
         begin
            CSB_C_w = 1'b0;
            CSB_T_w = 1'b0;
         end
         2'd1:
         begin
            CSB_C_w = 1'b1;
            CSB_T_w = 1'b1;
         end
         2'd2:
         begin
            CSB_C_w = 1'b1;
            CSB_T_w = 1'b1;
         end
         default:
         begin
            CSB_C_w = 1'b0;
            CSB_T_w = 1'b0;
         end
      endcase   
   
   end
   
//計算distance，只有第一次iteration要加還沒進shift register的部分  也就是normalize後直接相減取絕對值   
   always@(*)
      case(state_d_d_d_d_d_d_r)
         2'd0:
            if(iter_count_d_d_r == 3'd1 && state_r == 2'd1)distance_w = distance_r + {32'd0,abs_add_down_sample_r} + {32'd0,abs_difference_of_nC_nT_E_r} + {32'd0,abs_difference_of_nC_nT_O_r};
            else distance_w = 64'd0;
         2'd1:
            
               if(iter_count_d_d_r == 3'd1)distance_w = distance_r + {32'd0,abs_add_down_sample_r} + {32'd0,abs_difference_of_nC_nT_E_r} + {32'd0,abs_difference_of_nC_nT_O_r};
               else distance_w = distance_r + {32'd0, abs_add_down_sample_r};
            //else distance_w = distance_r;
         2'd2:
            if(iter_count_d_d_r == 3'd1)distance_w = distance_r + {32'd0, abs_add_down_sample_r} + {32'd0, abs_difference_of_nC_nT_E_r} + {32'd0, abs_difference_of_nC_nT_O_r};
            else distance_w = distance_r + {32'd0, abs_add_down_sample_r};
         2'd3:
            distance_w = distance_r;
         default:
            distance_w = distance_r;
      endcase
/*   
   always@(*)
   begin
      if(normalize)
      begin
         case(size_C_r)
            3'd0: normalize_C_E_w = {{6{data_read_C_A_E[63]}},data_read_C_A_E[63:6]};
            3'd1: normalize_C_E_w = {{7{data_read_C_A_E[63]}},data_read_C_A_E[63:7]};
            3'd2: normalize_C_E_w = {{8{data_read_C_A_E[63]}},data_read_C_A_E[63:8]};
            3'd3: normalize_C_E_w = {{9{data_read_C_A_E[63]}},data_read_C_A_E[63:9]};
            3'd4: normalize_C_E_w = {{10{data_read_C_A_E[63]}},data_read_C_A_E[63:10]};
            3'd5: normalize_C_E_w = {{11{data_read_C_A_E[63]}},data_read_C_A_E[63:11]};
            3'd6: normalize_C_E_w = {{12{data_read_C_A_E[63]}},data_read_C_A_E[63:12]};
            3'd7: normalize_C_E_w = {{13{data_read_C_A_E[63]}},data_read_C_A_E[63:13]};
         endcase
      end
      else
         normalize_C_E_w = data_read_C_A_E;
   
   end
   
   always@(*)
   begin
      if(normalize)
      begin
         case(size_C_r)
            3'd0: normalize_C_O_w = {{6{data_read_C_A_O[63]}},data_read_C_A_O[63:6]};
            3'd1: normalize_C_O_w = {{7{data_read_C_A_O[63]}},data_read_C_A_O[63:7]};
            3'd2: normalize_C_O_w = {{8{data_read_C_A_O[63]}},data_read_C_A_O[63:8]};
            3'd3: normalize_C_O_w = {{9{data_read_C_A_O[63]}},data_read_C_A_O[63:9]};
            3'd4: normalize_C_O_w = {{10{data_read_C_A_O[63]}},data_read_C_A_O[63:10]};
            3'd5: normalize_C_O_w = {{11{data_read_C_A_O[63]}},data_read_C_A_O[63:11]};
            3'd6: normalize_C_O_w = {{12{data_read_C_A_O[63]}},data_read_C_A_O[63:12]};
            3'd7: normalize_C_O_w = {{13{data_read_C_A_O[63]}},data_read_C_A_O[63:13]};
         endcase
      end
      else
         normalize_C_O_w = data_read_C_A_O;
   
   end
  
   always@(*)
   begin
      if(normalize)
      begin
         case(size_T_r)
            3'd0: normalize_T_E_w = {{6{data_read_T_A_E[63]}},data_read_T_A_E[63:6]};
            3'd1: normalize_T_E_w = {{7{data_read_T_A_E[63]}},data_read_T_A_E[63:7]};
            3'd2: normalize_T_E_w = {{8{data_read_T_A_E[63]}},data_read_T_A_E[63:8]};
            3'd3: normalize_T_E_w = {{9{data_read_T_A_E[63]}},data_read_T_A_E[63:9]};
            3'd4: normalize_T_E_w = {{10{data_read_T_A_E[63]}},data_read_T_A_E[63:10]};
            3'd5: normalize_T_E_w = {{11{data_read_T_A_E[63]}},data_read_T_A_E[63:11]};
            3'd6: normalize_T_E_w = {{12{data_read_T_A_E[63]}},data_read_T_A_E[63:12]};
            3'd7: normalize_T_E_w = {{13{data_read_T_A_E[63]}},data_read_T_A_E[63:13]};
         endcase
      end
      else
         normalize_T_E_w = data_read_T_A_E;
   
   end
   
   always@(*)
   begin
      if(normalize)
      begin
         case(size_T_r)
            3'd0: normalize_T_O_w = {{6{data_read_T_A_O[63]}},data_read_T_A_O[63:6]};
            3'd1: normalize_T_O_w = {{7{data_read_T_A_O[63]}},data_read_T_A_O[63:7]};
            3'd2: normalize_T_O_w = {{8{data_read_T_A_O[63]}},data_read_T_A_O[63:8]};
            3'd3: normalize_T_O_w = {{9{data_read_T_A_O[63]}},data_read_T_A_O[63:9]};
            3'd4: normalize_T_O_w = {{10{data_read_T_A_O[63]}},data_read_T_A_O[63:10]};
            3'd5: normalize_T_O_w = {{11{data_read_T_A_O[63]}},data_read_T_A_O[63:11]};
            3'd6: normalize_T_O_w = {{12{data_read_T_A_O[63]}},data_read_T_A_O[63:12]};
            3'd7: normalize_T_O_w = {{13{data_read_T_A_O[63]}},data_read_T_A_O[63:13]};
         endcase
      end
      else
         normalize_T_O_w = data_read_T_A_O;
   
   end
  */
  
   //用來算係數  我試了很多版本，這個版本是最好的
  
   always@(*)
   begin
      temp_exe_C1_w = abs_difference_of_nC_nT_E_r * 16'h91e6;
      temp_exe_C2_w = abs_difference_of_nC_nT_E_r * 16'h3497;
      temp_exe_C3_w = abs_difference_of_nC_nT_E_r * 13'h276;
		temp_exe_C4_w = abs_difference_of_nC_nT_E_r * 13'h4;
   /*
      case(iter_count_d_d_r)
         3'd0:
         begin
            temp_exe_C1_w = abs_difference_of_nC_nT_E_r * 14'h3311;
            temp_exe_C2_w = abs_difference_of_nC_nT_E_r * 14'h2d10;
            temp_exe_C3_w = abs_difference_of_nC_nT_E_r * 13'h1ef9;
            temp_exe_C4_w = abs_difference_of_nC_nT_E_r * 13'h1094;
         end
         3'd1:
         begin
            temp_exe_C1_w = abs_difference_of_nC_nT_E_r * 14'h3311;
            temp_exe_C2_w = abs_difference_of_nC_nT_E_r * 14'h2d10;
            temp_exe_C3_w = abs_difference_of_nC_nT_E_r * 13'h1ef9;
            temp_exe_C4_w = abs_difference_of_nC_nT_E_r * 13'h1094;
         end
         3'd2:
         begin
            temp_exe_C1_w = abs_difference_of_nC_nT_E_r * 14'h220b;
            temp_exe_C2_w = abs_difference_of_nC_nT_E_r * 14'h2034;
            temp_exe_C3_w = abs_difference_of_nC_nT_E_r * 13'h1b42;
            temp_exe_C4_w = abs_difference_of_nC_nT_E_r * 13'h14a6;
         end
         3'd3:
         begin
            temp_exe_C1_w = abs_difference_of_nC_nT_E_r * 14'h1988;
            temp_exe_C2_w = abs_difference_of_nC_nT_E_r * 14'h18bf;
            temp_exe_C3_w = abs_difference_of_nC_nT_E_r * 13'h1688;
            temp_exe_C4_w = abs_difference_of_nC_nT_E_r * 13'h1346;
         end
         3'd4:
         begin
            temp_exe_C1_w = abs_difference_of_nC_nT_E_r * 14'h146d;
            temp_exe_C2_w = abs_difference_of_nC_nT_E_r * 14'h1405;
            temp_exe_C3_w = abs_difference_of_nC_nT_E_r * 13'h12db;
            temp_exe_C4_w = abs_difference_of_nC_nT_E_r * 13'h110f;
         end
         default:
         begin
            temp_exe_C1_w = abs_difference_of_nC_nT_E_r * 14'h3311;
            temp_exe_C2_w = abs_difference_of_nC_nT_E_r * 14'h2d10;
            temp_exe_C3_w = abs_difference_of_nC_nT_E_r * 13'h1ef9;
            temp_exe_C4_w = abs_difference_of_nC_nT_E_r * 13'h1094;
         end         
         
      endcase
      */
   end
   
   
   always@(*)
   begin
      temp_exe_D1_w = abs_difference_of_nC_nT_O_r * 16'h91e6;
      temp_exe_D2_w = abs_difference_of_nC_nT_O_r * 16'h3497;
      temp_exe_D3_w = abs_difference_of_nC_nT_O_r * 13'h276;
		temp_exe_D4_w = abs_difference_of_nC_nT_O_r * 13'h4;
   
   /*
      case(iter_count_d_d_r)
         3'd0:
         begin
            temp_exe_D1_w = abs_difference_of_nC_nT_O_r * 14'h3311;
            temp_exe_D2_w = abs_difference_of_nC_nT_O_r * 14'h2d10;
            temp_exe_D3_w = abs_difference_of_nC_nT_O_r * 13'h1ef9;
            temp_exe_D4_w = abs_difference_of_nC_nT_O_r * 13'h1094;
         end                                                      
         3'd1:                                                    
         begin                                                    
            temp_exe_D1_w = abs_difference_of_nC_nT_O_r * 14'h3311;
            temp_exe_D2_w = abs_difference_of_nC_nT_O_r * 14'h2d10;
            temp_exe_D3_w = abs_difference_of_nC_nT_O_r * 13'h1ef9;
            temp_exe_D4_w = abs_difference_of_nC_nT_O_r * 13'h1094;
         end                                                      
         3'd2:                                                    
         begin                                                    
            temp_exe_D1_w = abs_difference_of_nC_nT_O_r * 14'h220b;
            temp_exe_D2_w = abs_difference_of_nC_nT_O_r * 14'h2034;
            temp_exe_D3_w = abs_difference_of_nC_nT_O_r * 13'h1b42;
            temp_exe_D4_w = abs_difference_of_nC_nT_O_r * 13'h14a6;
         end                                                      
         3'd3:                                                    
         begin                                                    
            temp_exe_D1_w = abs_difference_of_nC_nT_O_r * 14'h1988;
            temp_exe_D2_w = abs_difference_of_nC_nT_O_r * 14'h18bf;
            temp_exe_D3_w = abs_difference_of_nC_nT_O_r * 13'h1688;
            temp_exe_D4_w = abs_difference_of_nC_nT_O_r * 13'h1346;
         end                                                      
         3'd4:                                                    
         begin                                                    
            temp_exe_D1_w = abs_difference_of_nC_nT_O_r * 14'h146d;
            temp_exe_D2_w = abs_difference_of_nC_nT_O_r * 14'h1405;
            temp_exe_D3_w = abs_difference_of_nC_nT_O_r * 13'h12db;
            temp_exe_D4_w = abs_difference_of_nC_nT_O_r * 13'h110f;
         end                                                      
         default:                                                 
         begin                                                    
            temp_exe_D1_w = abs_difference_of_nC_nT_O_r * 14'h3311;
            temp_exe_D2_w = abs_difference_of_nC_nT_O_r * 14'h2d10;
            temp_exe_D3_w = abs_difference_of_nC_nT_O_r * 13'h1ef9;
            temp_exe_D4_w = abs_difference_of_nC_nT_O_r * 13'h1094;
         end         
      endcase
      
      */
   end
   
   always@(*)
   begin
      case(state_r)
         2'd0:
            if(distance_compute_enable) state_w = 2'd1;
            else state_w = 2'd0;
         2'd1:
            if(A_out_C_r[6:0] < index_r) state_w = 2'd1;
            else state_w = 2'd2;
         2'd2:
            if(iter_count_d_r < iteration_times) state_w = 2'd1;
            else state_w = 2'd3;
         2'd3:
            state_w = 2'd3;
         default:
            state_w = 2'd0;
      endcase
   end
   
//   wire gclk = clk & distance_compute_enable;
   always@(posedge clk or posedge reset)
   begin
      if(reset)
      begin
         A_out_C_r <= 7'd0;
         A_out_C_d_r <= 7'd0;
         B_out_C_r <= 7'd0;
         B_out_C_d_r <= 7'd0;
         B_out_C_d_d_r <= 7'd0;
         B_out_C_d_d_d_r <= 7'd0;
         B_out_C_d_d_d_d_r <= 7'd0;
         B_out_C_d_d_d_d_d_r <= 7'd0;
         B_out_C_d_d_d_d_d_d_r <= 7'd0;
         B_out_C_d_d_d_d_d_d_d_r <= 7'd0;
         B_out_C_d_d_d_d_d_d_d_d_r <= 7'd0;
         B_out_C_d_d_d_d_d_d_d_d_d_r <= 7'd0;
         B_out_C_d_d_d_d_d_d_d_d_d_d_r <= 7'd0;
         state_r <= 2'd0;
         index_r <= 7'd127;
         iter_count_r <= 3'd1;
         iter_count_d_r <= 3'd1;
         iter_count_d_d_r <= 3'd1;
         //size_C_r <= 3'd0;
         //size_T_r <= 3'd0;
         exe_A2_r <= 32'd0;
         exe_B2_r <= 32'd0;
         exe_B3_r <= 29'd0;
         exe_B1_r <= 32'd0;
         exe_A3_r <= 29'd0;
         exe_A1_r <= 32'd0;
         
         exe_B4_r <= 29'd0;
         exe_A4_r <= 29'd0;
         exe_F4_r <= 29'd0;
         exe_E4_r <= 29'd0;
         //exe_G1_r <= 32'd0;
         //exe_G2_r <= 32'd0;
         exe_G3_r <= 29'd0;
         exe_G4_r <= 29'd0;
         //exe_H1_r <= 32'd0;
         exe_H2_r <= 32'd0;
         exe_H3_r <= 29'd0;
         exe_H4_r <= 29'd0;
         //exe_I1_r <= 32'd0;
         //exe_I2_r <= 32'd0;
         //exe_I3_r <= 32'd0;
         exe_I4_r <= 29'd0;
         
         exe_F1_r <= 32'd0;
         exe_F2_r <= 32'd0;
         exe_F3_r <= 29'd0;
         exe_E1_r <= 32'd0;
         exe_E2_r <= 32'd0;
         exe_E3_r <= 29'd0;
         
         //add_A2_B1_C2_r <= 64'd0;
         done_r <= 1'b0;
         distance_r <= 64'd0;
         state_d_r <= 2'd0;
         state_d_d_r <= 2'd0;
         state_d_d_d_r <= 2'd0;
         state_d_d_d_d_r <= 2'd0;
         state_d_d_d_d_d_r <= 2'd0;
         state_d_d_d_d_d_d_r <= 2'd0;
         state_d_d_d_d_d_d_d_r <= 2'd0;
         state_d_d_d_d_d_d_d_d_r <= 2'd0;
         normalize_r <= 1'b0;
         normalize_d_r <= 1'b0;
         data_read_C_A_r <= 64'd0;
         data_read_C_A_d_r <= 64'd0;
         data_read_T_A_r <= 64'd0;
         temp_normalize_C_O_r <= 36'd0;
         temp_normalize_C_E_r <= 36'd0;
         temp_normalize_T_O_r <= 36'd0;
         temp_normalize_T_E_r <= 36'd0;
         add_A1_B2_D2_r <= 32'd0;
         add_A2_C2_D1_r <= 32'd0;
         add_A1_B2_D2_d_r <= 32'd0;
         add_A2_C2_D1_d_r <= 32'd0;
         exe_C4_r <= 29'd0;
         exe_C3_r <= 29'd0;
         exe_C2_r <= 32'd0; 
         exe_C1_r <= 32'd0;
         exe_D4_r <= 29'd0;
         exe_D3_r <= 29'd0;
         exe_D2_r <= 32'd0; 
         exe_D1_r <= 32'd0;
         temp_exe_C1_r <= 46'd0;
         temp_exe_C2_r <= 46'd0;
         temp_exe_C3_r <= 45'd0;
         temp_exe_C4_r <= 45'd0;
         temp_exe_D1_r <= 46'd0;
         temp_exe_D2_r <= 46'd0;
         temp_exe_D3_r <= 45'd0;
         temp_exe_D4_r <= 45'd0;
         difference_of_nC_nT_O_r <= 32'd0;
         difference_of_nC_nT_E_r <= 32'd0;
         abs_difference_of_nC_nT_E_r <= 32'd0;
         abs_difference_of_nC_nT_O_r <= 32'd0;
         down_sample_r <= 32'd0;
         Sign_difference_of_nC_nT_O_d_r <= 1'b0;
         Sign_difference_of_nC_nT_E_d_r <= 1'b0;
         CSA_C_r <= 1'd0;
         CSA_T_r <= 1'd0;
         CSB_T_r <= 1'd0;
         CSB_C_r <= 1'd0;
         data_write_C_B_r <= 64'd0;
         MUX_r <= 4'd0;
         abs_add_down_sample_r <= 32'd0;
      end
      else if(distance_compute_enable)
      begin
         A_out_C_r <= A_out_C_w;
         A_out_C_d_r <= A_out_C_r;
         B_out_C_r <= B_out_C_w;
         B_out_C_d_r <= B_out_C_r;
         B_out_C_d_d_r <= B_out_C_d_r;
         B_out_C_d_d_d_r <= B_out_C_d_d_r;
         B_out_C_d_d_d_d_r <= B_out_C_d_d_d_r;
         B_out_C_d_d_d_d_d_r <= B_out_C_d_d_d_d_r;
         B_out_C_d_d_d_d_d_d_r <= B_out_C_d_d_d_d_d_r;
         B_out_C_d_d_d_d_d_d_d_r <= B_out_C_d_d_d_d_d_d_r;
         B_out_C_d_d_d_d_d_d_d_d_r <= B_out_C_d_d_d_d_d_d_d_r;
         B_out_C_d_d_d_d_d_d_d_d_d_r <= B_out_C_d_d_d_d_d_d_d_d_r;
         B_out_C_d_d_d_d_d_d_d_d_d_d_r <= B_out_C_d_d_d_d_d_d_d_d_d_r;
         state_r <= state_w;
         index_r <= index_w;
         iter_count_r <= iter_count_w;
         iter_count_d_r <= iter_count_r;
         iter_count_d_d_r <= iter_count_d_r;
         //size_C_r <= size_C_w;
         //size_T_r <= size_T_w;
         exe_E3_r <= exe_A3_r;
         exe_E2_r <= exe_A2_r;
         exe_E1_r <= exe_A1_r;
         exe_A3_r <= exe_C3_r;
         exe_A2_r <= exe_C2_r;
         exe_A1_r <= exe_C1_r;
         exe_B3_r <= exe_D3_r;
         exe_B2_r <= exe_D2_r;
         exe_B1_r <= exe_D1_r;
         exe_F1_r <= exe_B1_r;
         exe_F2_r <= exe_B2_r;
         exe_F3_r <= exe_B3_r;
         
         exe_B4_r <= exe_D4_r;
         exe_A4_r <= exe_C4_r;
         exe_F4_r <= exe_B4_r;
         exe_E4_r <= exe_A4_r;
         //exe_G1_r <= exe_E1_r;
         //exe_G2_r <= exe_E2_r;
         exe_G3_r <= exe_E3_r;
         exe_G4_r <= exe_E4_r;
         //exe_H1_r <= exe_F1_r;
         exe_H2_r <= exe_F2_r;
         exe_H3_r <= exe_F3_r;
         exe_H4_r <= exe_F4_r;
         //exe_I1_r <= exe_H1_r;
         //exe_I2_r <= exe_H2_r;
         //exe_I3_r <= exe_H3_r;
         exe_I4_r <= exe_H4_r;
         
         exe_C4_r <= exe_C4_w;
         exe_C3_r <= exe_C3_w;
         exe_C2_r <= exe_C2_w; 
         exe_C1_r <= exe_C1_w;
         exe_D4_r <= exe_D4_w;
         exe_D3_r <= exe_D3_w;
         exe_D2_r <= exe_D2_w; 
         exe_D1_r <= exe_D1_w;
         
         
         
         //add_A2_B1_C2_r <= add_A2_B1_C2_w;
         done_r <= done_w;
         distance_r <= distance_w;
         state_d_r <= state_r;
         state_d_d_r <= state_d_r;
         state_d_d_d_r <= state_d_d_r;
         state_d_d_d_d_r <= state_d_d_d_r;
         state_d_d_d_d_d_r <= state_d_d_d_d_r;
         state_d_d_d_d_d_d_r <= state_d_d_d_d_d_r;
         state_d_d_d_d_d_d_d_r <= state_d_d_d_d_d_d_r;
         state_d_d_d_d_d_d_d_d_r <= state_d_d_d_d_d_d_d_r;
         normalize_r <= normalize_w;
         normalize_d_r <= normalize_r;
         data_read_C_A_r <= data_read_C_A;
         data_read_C_A_d_r <= data_read_C_A_r;
         data_read_T_A_r <= data_read_T_A;
         temp_normalize_C_O_r <= temp_normalize_C_O_w;
         temp_normalize_C_E_r <= temp_normalize_C_E_w;
         temp_normalize_T_O_r <= temp_normalize_T_O_w;
         temp_normalize_T_E_r <= temp_normalize_T_E_w;
         add_A1_B2_D2_r <= add_A1_B2_D2_w;
         add_A2_C2_D1_r <= add_A2_C2_D1_w;
         add_A1_B2_D2_d_r <= add_A1_B2_D2_r;
         add_A2_C2_D1_d_r <= add_A2_C2_D1_r;
         temp_exe_C1_r <= temp_exe_C1_w;
         temp_exe_C2_r <= temp_exe_C2_w;
         temp_exe_C3_r <= temp_exe_C3_w;
         temp_exe_D1_r <= temp_exe_D1_w;
         temp_exe_D2_r <= temp_exe_D2_w;
         temp_exe_D3_r <= temp_exe_D3_w;
         
         temp_exe_C4_r <= temp_exe_C4_w;
         temp_exe_D4_r <= temp_exe_D4_w;
         
         difference_of_nC_nT_O_r <= difference_of_nC_nT_O;
         difference_of_nC_nT_E_r <= difference_of_nC_nT_E;
         abs_difference_of_nC_nT_E_r <= abs_difference_of_nC_nT_E;
         abs_difference_of_nC_nT_O_r <= abs_difference_of_nC_nT_O;
         down_sample_r <= down_sample_w;
         Sign_difference_of_nC_nT_O_d_r <= difference_of_nC_nT_O_r[31];
         Sign_difference_of_nC_nT_E_d_r <= difference_of_nC_nT_E_r[31];
         CSA_C_r <= CSA_C_w;
         CSA_T_r <= CSA_T_w;
         CSB_T_r <= CSB_T_w;
         CSB_C_r <= CSB_C_w;
         data_write_C_B_r <= data_write_C_B_w;
         MUX_r <= MUX_w;
         abs_add_down_sample_r <= abs_add_down_sample_w; 
         
      end
         
   end   
   

endmodule