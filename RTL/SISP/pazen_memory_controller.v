//做pin mapping
//從memory讀進DOA00_w ~ DOA06_w 然後 利用A_in決定哪一個才是想要的，從DOA輸出 (只輸出16 bits)  B也是一樣
//當要寫資料進memory時，由於這裡的DIA是16-bit，而memory要輸入的是64-bit，所以做一個轉換，成為64-bit，由DIA_T_w輸出
module pazen_memory_controller(clk, reset, A_in, B_in, DIA, DIB, DOA, DOB, A_w, B_w, CSA, CSB,
                               DOA00_w, DOB00_w, DOA01_w, DOB01_w, DOA02_w, DOB02_w, DOA03_w, DOB03_w, DOA04_w, DOB04_w, DOA05_w, DOB05_w, DOA06_w, DOB06_w,
                               DIA_T_w, DIB_T_w,
                               choose_reg_A_w, choose_reg_B_w, MUXA, MUXB

);
   input             clk, reset;
   input    [7:0]    A_in, B_in;
   input    [15:0]   DIA, DIB;
   input             CSA, CSB;
   
   output   [15:0]   DOA, DOB;
   output   [3:0]    A_w, B_w;
   input    [63:0]   DOA00_w, DOB00_w;
   input    [63:0]   DOA01_w, DOB01_w;
   input    [63:0]   DOA02_w, DOB02_w;
   input    [63:0]   DOA03_w, DOB03_w;
   input    [63:0]   DOA04_w, DOB04_w;
   input    [63:0]   DOA05_w, DOB05_w;
   input    [63:0]   DOA06_w, DOB06_w;
   output   [6:0]   choose_reg_A_w, choose_reg_B_w;
   output   [3:0]    MUXA, MUXB;
   output   [63:0]   DIA_T_w, DIB_T_w;
   
   
   
   
   
   
   //reg      [31:0]   DOA, DOB;
   
   wire     [3:0]    A_w, B_w;
   wire     [5:0]    tempA_w, tempB_w;
   //wire     [3:0]    MUX;
   
   wire     [63:0]   DIA_T_w, DIB_T_w;
  
   
   
   
   
   reg      [6:0]    choose_reg_A_w;
   reg      [6:0]    choose_reg_B_w;
   
   reg      [5:0]    number_A_w, number_B_w;
   
   
   wire     [63:0]   DOA00_w, DOB00_w;
   wire     [63:0]   DOA01_w, DOB01_w;
   wire     [63:0]   DOA02_w, DOB02_w;
   wire     [63:0]   DOA03_w, DOB03_w;
   wire     [63:0]   DOA04_w, DOB04_w;
   wire     [63:0]   DOA05_w, DOB05_w;
   wire     [63:0]   DOA06_w, DOB06_w;
   reg      [63:0]   DOA_T_w, DOB_T_w;
   
   assign A_w = tempA_w[3:0];
   assign B_w = tempB_w[3:0];
   assign tempA_w = A_in[7:2] - number_A_w;
   assign tempB_w = B_in[7:2] - number_B_w;
   
   
   
   
   //register_file e00(~clk, reset, A_w, B_w, DIA_T_w, DIB_T_w, DOA00_w, DOB00_w, WEAN, WEBN, choose_reg_A_w[00], choose_reg_B_w[00], OEA, OEB, MUX);
   //register_file e01(~clk, reset, A_w, B_w, DIA_T_w, DIB_T_w, DOA01_w, DOB01_w, WEAN, WEBN, choose_reg_A_w[01], choose_reg_B_w[01], OEA, OEB, MUX);
   //register_file e02(~clk, reset, A_w, B_w, DIA_T_w, DIB_T_w, DOA02_w, DOB02_w, WEAN, WEBN, choose_reg_A_w[02], choose_reg_B_w[02], OEA, OEB, MUX);
   //register_file e03(~clk, reset, A_w, B_w, DIA_T_w, DIB_T_w, DOA03_w, DOB03_w, WEAN, WEBN, choose_reg_A_w[03], choose_reg_B_w[03], OEA, OEB, MUX);
   //register_file e04(~clk, reset, A_w, B_w, DIA_T_w, DIB_T_w, DOA04_w, DOB04_w, WEAN, WEBN, choose_reg_A_w[04], choose_reg_B_w[04], OEA, OEB, MUX);
   //register_file e05(~clk, reset, A_w, B_w, DIA_T_w, DIB_T_w, DOA05_w, DOB05_w, WEAN, WEBN, choose_reg_A_w[05], choose_reg_B_w[05], OEA, OEB, MUX);
   //register_file e06(~clk, reset, A_w, B_w, DIA_T_w, DIB_T_w, DOA06_w, DOB06_w, WEAN, WEBN, choose_reg_A_w[06], choose_reg_B_w[06], OEA, OEB, MUX);
   
   
   
   assign MUXA[0] = (!A_in[0] && !A_in[1]) ? 1'b1 : 1'b0;
   assign MUXA[1] = ( A_in[0] && !A_in[1]) ? 1'b1 : 1'b0;
   assign MUXA[2] = (!A_in[0] &&  A_in[1]) ? 1'b1 : 1'b0;
   assign MUXA[3] = ( A_in[0] &&  A_in[1]) ? 1'b1 : 1'b0;
   
   assign MUXB[0] = (!B_in[0] && !B_in[1]) ? 1'b1 : 1'b0;
   assign MUXB[1] = ( B_in[0] && !B_in[1]) ? 1'b1 : 1'b0;
   assign MUXB[2] = (!B_in[0] &&  B_in[1]) ? 1'b1 : 1'b0;
   assign MUXB[3] = ( B_in[0] &&  B_in[1]) ? 1'b1 : 1'b0;
   
   assign DOA = MUXA == 4'b0001 ? DOA_T_w[15:0] : (
                MUXA == 4'b0010 ? DOA_T_w[31:16]: (
                MUXA == 4'b0100 ? DOA_T_w[47:32]: (DOA_T_w[63:48])));
   //assign DOB = (B_in[1] == 1'b0) ? DOB_T_w[63:32] : DOB_T_w[31:0];
   assign DOB = MUXB == 4'b0001 ? DOB_T_w[15:0] : (
                MUXB == 4'b0010 ? DOB_T_w[31:16]: (
                MUXB == 4'b0100 ? DOB_T_w[47:32]: (DOB_T_w[63:48])));   
                
   assign DIA_T_w = MUXA == 4'b0001 ? {48'd0, DIA}: (
                    MUXA == 4'b0010 ? {32'd0, DIA, 16'd0}: (
                    MUXA == 4'b0100 ? {16'd0, DIA, 32'd0}: ({DIA, 48'd0})));
                    
   
   assign DIB_T_w = MUXB == 4'b0001 ? {48'd0, DIB}: (
                    MUXB == 4'b0010 ? {32'd0, DIB, 16'd0}: (
                    MUXB == 4'b0100 ? {16'd0, DIB, 32'd0}: ({DIB, 48'd0})));
                                                                                                                                                 
   always@(*)                                                                                                                                    
   begin
      if(CSA == 1'b1)                                                                                                                                         
      begin
         if(A_in >= 8'd0 && A_in < 8'd120)                                                                                                       
         begin                                                                                                                                   
            if(A_in >= 8'd0 && A_in < 8'd40)                                                                                                    
            begin                                                                                                                                
               choose_reg_A_w = 7'b0000001; number_A_w = 6'd00; DOA_T_w = DOA00_w;
            end                                                                                                                            
            else if(A_in >= 8'd40 && A_in < 8'd80)
            begin                                                                                                                          
               choose_reg_A_w = 7'b0000010; number_A_w = 6'd10; DOA_T_w = DOA01_w;                                         
            end                                                                                   
            else
            begin
               choose_reg_A_w = 7'b0000100; number_A_w = 6'd20; DOA_T_w = DOA02_w;
            end                                         
         end                                                                                                                               
         else                                                                                                                              
         begin                                                                                                                             
            if(A_in >= 8'd120 && A_in < 8'd200)                                                                                            
            begin                                                                                                                          
               if(A_in >= 8'd120 && A_in < 8'd160)
               begin
                  choose_reg_A_w = 7'b0001000; number_A_w = 6'd30; DOA_T_w = DOA03_w;
               end
               else
               begin
                  choose_reg_A_w = 7'b0010000; number_A_w = 6'd40; DOA_T_w = DOA04_w;
               end
            end                                                                                                                            
            else
            begin                                                                                                                          
               if(A_in >= 8'd200 && A_in < 8'd240)
               begin
                  choose_reg_A_w = 7'b0100000; number_A_w = 6'd50; DOA_T_w = DOA05_w;
               end
               else
               begin
                  choose_reg_A_w = 7'b1000000; number_A_w = 6'd60; DOA_T_w = DOA06_w;
               end
            end                                                                                                                            
         end
      end
      else
      begin
         choose_reg_A_w = 7'd0;
         number_A_w = 6'd0;
         DOA_T_w = 64'd0;
      end                                                                                                                               
      
                                                 
                                      
   end
   
     
  always@(*)                                                                                                                                    
   begin                                                                                                                                         
      if(CSB == 1'b1)
      begin
         if(B_in >= 8'd0 && B_in < 8'd120)                                                                                                       
         begin                                                                                                                                   
            if(B_in >= 8'd0 && B_in < 8'd40)                                                                                                    
            begin                                                                                                                                
               choose_reg_B_w = 7'b0000001; number_B_w = 6'd00; DOB_T_w = DOB00_w;
            end                                                                                                                            
            else if(B_in >= 8'd40 && B_in < 8'd80)
            begin                                                                                                                          
               choose_reg_B_w = 7'b0000010; number_B_w = 6'd10; DOB_T_w = DOB01_w;                                         
            end                                                                                   
            else
            begin
               choose_reg_B_w = 7'b0000100; number_B_w = 6'd20; DOB_T_w = DOB02_w;
            end                                         
         end                                                                                                                               
         else                                                                                                                              
         begin                                                                                                                             
            if(B_in >= 8'd120 && B_in < 8'd200)                                                                                            
            begin                                                                                                                          
               if(B_in >= 8'd120 && B_in < 8'd160)
               begin
                  choose_reg_B_w = 7'b0001000; number_B_w = 6'd30; DOB_T_w = DOB03_w;
               end
               else
               begin
                  choose_reg_B_w = 7'b0010000; number_B_w = 6'd40; DOB_T_w = DOB04_w;
               end
            end                                                                                                                            
            else
            begin                                                                                                                          
               if(B_in >= 8'd200 && B_in < 8'd240)
               begin
                  choose_reg_B_w = 7'b0100000; number_B_w = 6'd50; DOB_T_w = DOB05_w;
               end
               else
               begin
                  choose_reg_B_w = 7'b1000000; number_B_w = 6'd60; DOB_T_w = DOB06_w;
               end
            end                                                                                                                            
         end                                                                                                                               
      end
      else
      begin
         choose_reg_B_w = 7'd0;
         number_B_w = 6'd0;
         DOB_T_w = 64'd0;
      end
      
      
                                                 
                                      
   end
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
                      
                      
                      
                      
                      
                      
                      
endmodule             