module compare(A, B, min, max);
   input    [13:0]    A, B;
   output   [13:0]    min, max;
   reg      [13:0]    min, max;
   
   
   
   //assign min = (A[8:0] > B[8:0]) ? B : A;
   //assign max = (A[8:0] > B[8:0]) ? A : B;
   
   
   always@(*)
   begin
      if(A[8] == 1'b1)
      begin
         if(B[8] == 1'b0)
         begin
            min = A;
            max = B;
         end
         else
         begin
            if(A[8:0] > B[8:0])
            begin
               min = B;
               max = A;
            end
            else
            begin
               min = A;
               max = B;
            end
         end
      end
      else
      begin
         if(B[8] == 1'b0)
         begin
            if(A[8:0] > B[8:0])
            begin
               min = B;
               max = A;
            end
            else
            begin
               min = A;
               max = B;
            end
         end
         else
         begin
            min = B;
            max = A;
         end
         
      end
   
   end
endmodule

module compare_min(A, B, min);
   input    [13:0]   A, B;
   output   [13:0]   min;
   reg      [13:0]   min;
   
   //assign min = (A[7:0] > B[7:0]) ? B : A;
   always@(*)
   begin
      if(A[8] == 1'b1)
      begin
         if(B[8] == 1'b0)
         begin
            min = A;
            
         end
         else
         begin
            if(A[8:0] > B[8:0])
            begin
               min = B;
               
            end
            else
            begin
               min = A;
               
            end
         end
      end
      else
      begin
         if(B[8] == 1'b0)
         begin
            if(A[8:0] > B[8:0])
            begin
               min = B;
         
            end
            else
            begin
               min = A;
         
            end
         end
         else
         begin
            min = B;
         
         end
         
      end
   
   end
endmodule

module compare_max(A, B, max);
   input    [13:0]   A, B;
   output   [13:0]   max;
   reg      [13:0]   max;
   
   //assign max = (A[8:0] > B[8:0]) ? A : B;
   
   always@(*)
   begin
      if(A[8] == 1'b1)
      begin
         if(B[8] == 1'b0)
         begin
            
            max = B;
         end
         else
         begin
            if(A[8:0] > B[8:0])
            begin
               
               max = A;
            end
            else
            begin
               
               max = B;
            end
         end
      end
      else
      begin
         if(B[8] == 1'b0)
         begin
            if(A[8:0] > B[8:0])
            begin
         
               max = A;
            end
            else
            begin
         
               max = B;
            end
         end
         else
         begin
         
            max = A;
         end
         
      end
   
   end
endmodule