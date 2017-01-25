//做pin mapping
//從memory讀進DOA00_w ~ DOA06_w 然後 利用A_in決定哪一個才是想要的，從DOA輸出 (只輸出16 bits)  B也是一樣
module distance_memory_controller(clk, reset, A_in, B_in, DOA, DOB, A_w, B_w, CSA, CSB,
                               DOA00_w, DOB00_w, DOA01_w, DOB01_w, DOA02_w, DOB02_w, DOA03_w, DOB03_w, DOA04_w, DOB04_w, DOA05_w, DOB05_w, DOA06_w, DOB06_w, choose_reg_A_w, choose_reg_B_w);
                               
   input             clk, reset;
   input    [5:0]    A_in, B_in;
   
   input             CSA, CSB;
   
   output   [63:0]   DOA, DOB;
   output   [3:0]    A_w, B_w;
   input    [63:0]   DOA00_w, DOB00_w;
   input    [63:0]   DOA01_w, DOB01_w;
   input    [63:0]   DOA02_w, DOB02_w;
   input    [63:0]   DOA03_w, DOB03_w;
   input    [63:0]   DOA04_w, DOB04_w;
   input    [63:0]   DOA05_w, DOB05_w;
   input    [63:0]   DOA06_w, DOB06_w;
   output   [6:0]   choose_reg_A_w, choose_reg_B_w;
   
   
   
   wire     [3:0]    A_w, B_w;
   wire     [5:0]    tempA_w, tempB_w;
   wire     [3:0]    MUX;
   
   
  
   
   
   
   
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
   assign tempA_w = A_in[5:0] - number_A_w;
   assign tempB_w = B_in[5:0] - number_B_w;
   
   

   
   assign DOA = DOA_T_w;
   //assign DOB = (B_in[1] == 1'b0) ? DOB_T_w[63:32] : DOB_T_w[31:0];
   assign DOB = DOB_T_w;   
                
   
                    
   
   
                                                                                                                                                 
   always@(*)                                                                                                                                    
   begin
      if(CSA == 1'b1)                                                                                                                                         
      begin
         if(A_in >= 8'd0 && A_in < 8'd30)                                                                                                       
         begin                                                                                                                                   
            if(A_in >= 8'd0 && A_in < 8'd10)                                                                                                    
            begin                                                                                                                                
               choose_reg_A_w = 7'b0000001; number_A_w = 6'd00; DOA_T_w = DOA00_w;
            end                                                                                                                            
            else if(A_in >= 8'd10 && A_in < 8'd20)
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
            if(A_in >= 8'd30 && A_in < 8'd50)                                                                                            
            begin                                                                                                                          
               if(A_in >= 8'd30 && A_in < 8'd40)
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
               if(A_in >= 8'd50 && A_in < 8'd60)
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
         if(B_in >= 8'd0 && B_in < 8'd30)                                                                                                       
         begin                                                                                                                                   
            if(B_in >= 8'd0 && B_in < 8'd10)                                                                                                    
            begin                                                                                                                                
               choose_reg_B_w = 7'b0000001; number_B_w = 6'd00; DOB_T_w = DOB00_w;
            end                                                                                                                            
            else if(B_in >= 8'd10 && B_in < 8'd20)
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
            if(B_in >= 8'd30 && B_in < 8'd50)                                                                                            
            begin                                                                                                                          
               if(B_in >= 8'd30 && B_in < 8'd40)
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
               if(B_in >= 8'd50 && B_in < 8'd60)
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