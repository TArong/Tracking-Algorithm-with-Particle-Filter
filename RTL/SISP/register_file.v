//2 Ports Regsiter element
//WEAN, WEBM: 0: write in, 1: none
//CSA, CSB: 0: turn off, 1: turn on
//OEA, OEB: 1: read out, 0: none
//MUXA, MUXB: 4-bit 選擇要寫哪16-bit的資料 eg. 1100 就是寫前32-bit 

module register_file(clk, reset, A, B, DIA, DIB, DOA, DOB, WEAN, WEBN, CSA, CSB, OEA, OEB, MUXA, MUXB);
   input             clk, reset;
   input    [3:0]    A, B;
   input    [63:0]   DIA, DIB;
   input             WEAN, WEBN, CSA, CSB, OEA, OEB;
   input    [3:0]    MUXA, MUXB;
   output   [63:0]   DOA, DOB;
   
   
   reg      [15:0]   memory_0_r   [0:9];
   reg      [15:0]   memory_1_r   [0:9];
   reg      [15:0]   memory_2_r   [0:9];
   reg      [15:0]   memory_3_r   [0:9];
   
   wire     [15:0]   memory_0_w   [0:9];
   wire     [15:0]   memory_1_w   [0:9];
   wire     [15:0]   memory_2_w   [0:9];
   wire     [15:0]   memory_3_w   [0:9];
   
   wire     [63:0]   temp = {memory_3_r[2],memory_2_r[2],memory_1_r[2],memory_0_r[2]};
   wire     [63:0]   temp2 = {memory_3_w[2],memory_2_w[2],memory_1_w[2],memory_0_w[2]};
   
   assign DOA = /*(OEA == 1'b1 && CSA == 1'b1) ? */{memory_3_r[A],memory_2_r[A],memory_1_r[A],memory_0_r[A]}/* : 63'd0*/;
   assign DOB = /*(OEB == 1'b1 && CSB == 1'b1) ? */{memory_3_r[B],memory_2_r[B],memory_1_r[B],memory_0_r[B]}/* : 63'd0*/;
   
   assign memory_0_w[0] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd0 && MUXA[0] == 1'b1) ? DIA[15:0] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd0 && MUXB[0] == 1'b1) ? DIB[15:0] : memory_0_r[0]);
   assign memory_0_w[1] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd1 && MUXA[0] == 1'b1) ? DIA[15:0] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd1 && MUXB[0] == 1'b1) ? DIB[15:0] : memory_0_r[1]);
   assign memory_0_w[2] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd2 && MUXA[0] == 1'b1) ? DIA[15:0] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd2 && MUXB[0] == 1'b1) ? DIB[15:0] : memory_0_r[2]);
   assign memory_0_w[3] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd3 && MUXA[0] == 1'b1) ? DIA[15:0] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd3 && MUXB[0] == 1'b1) ? DIB[15:0] : memory_0_r[3]);
   assign memory_0_w[4] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd4 && MUXA[0] == 1'b1) ? DIA[15:0] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd4 && MUXB[0] == 1'b1) ? DIB[15:0] : memory_0_r[4]);
   assign memory_0_w[5] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd5 && MUXA[0] == 1'b1) ? DIA[15:0] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd5 && MUXB[0] == 1'b1) ? DIB[15:0] : memory_0_r[5]);
   assign memory_0_w[6] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd6 && MUXA[0] == 1'b1) ? DIA[15:0] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd6 && MUXB[0] == 1'b1) ? DIB[15:0] : memory_0_r[6]);
   assign memory_0_w[7] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd7 && MUXA[0] == 1'b1) ? DIA[15:0] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd7 && MUXB[0] == 1'b1) ? DIB[15:0] : memory_0_r[7]);
   assign memory_0_w[8] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd8 && MUXA[0] == 1'b1) ? DIA[15:0] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd8 && MUXB[0] == 1'b1) ? DIB[15:0] : memory_0_r[8]);
   assign memory_0_w[9] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd9 && MUXA[0] == 1'b1) ? DIA[15:0] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd9 && MUXB[0] == 1'b1) ? DIB[15:0] : memory_0_r[9]);
   
   assign memory_1_w[0] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd0 && MUXA[1] == 1'b1) ? DIA[31:16] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd0 && MUXB[1] == 1'b1) ? DIB[31:16] : memory_1_r[0]);
   assign memory_1_w[1] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd1 && MUXA[1] == 1'b1) ? DIA[31:16] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd1 && MUXB[1] == 1'b1) ? DIB[31:16] : memory_1_r[1]);
   assign memory_1_w[2] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd2 && MUXA[1] == 1'b1) ? DIA[31:16] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd2 && MUXB[1] == 1'b1) ? DIB[31:16] : memory_1_r[2]);
   assign memory_1_w[3] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd3 && MUXA[1] == 1'b1) ? DIA[31:16] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd3 && MUXB[1] == 1'b1) ? DIB[31:16] : memory_1_r[3]);
   assign memory_1_w[4] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd4 && MUXA[1] == 1'b1) ? DIA[31:16] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd4 && MUXB[1] == 1'b1) ? DIB[31:16] : memory_1_r[4]);
   assign memory_1_w[5] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd5 && MUXA[1] == 1'b1) ? DIA[31:16] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd5 && MUXB[1] == 1'b1) ? DIB[31:16] : memory_1_r[5]);
   assign memory_1_w[6] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd6 && MUXA[1] == 1'b1) ? DIA[31:16] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd6 && MUXB[1] == 1'b1) ? DIB[31:16] : memory_1_r[6]);
   assign memory_1_w[7] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd7 && MUXA[1] == 1'b1) ? DIA[31:16] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd7 && MUXB[1] == 1'b1) ? DIB[31:16] : memory_1_r[7]);
   assign memory_1_w[8] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd8 && MUXA[1] == 1'b1) ? DIA[31:16] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd8 && MUXB[1] == 1'b1) ? DIB[31:16] : memory_1_r[8]);
   assign memory_1_w[9] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd9 && MUXA[1] == 1'b1) ? DIA[31:16] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd9 && MUXB[1] == 1'b1) ? DIB[31:16] : memory_1_r[9]);
                                                                                                                                                                                           
   assign memory_2_w[0] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd0 && MUXA[2] == 1'b1) ? DIA[47:32] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd0 && MUXB[2] == 1'b1) ? DIB[47:32] : memory_2_r[0]);
   assign memory_2_w[1] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd1 && MUXA[2] == 1'b1) ? DIA[47:32] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd1 && MUXB[2] == 1'b1) ? DIB[47:32] : memory_2_r[1]);
   assign memory_2_w[2] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd2 && MUXA[2] == 1'b1) ? DIA[47:32] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd2 && MUXB[2] == 1'b1) ? DIB[47:32] : memory_2_r[2]);
   assign memory_2_w[3] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd3 && MUXA[2] == 1'b1) ? DIA[47:32] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd3 && MUXB[2] == 1'b1) ? DIB[47:32] : memory_2_r[3]);
   assign memory_2_w[4] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd4 && MUXA[2] == 1'b1) ? DIA[47:32] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd4 && MUXB[2] == 1'b1) ? DIB[47:32] : memory_2_r[4]);
   assign memory_2_w[5] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd5 && MUXA[2] == 1'b1) ? DIA[47:32] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd5 && MUXB[2] == 1'b1) ? DIB[47:32] : memory_2_r[5]);
   assign memory_2_w[6] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd6 && MUXA[2] == 1'b1) ? DIA[47:32] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd6 && MUXB[2] == 1'b1) ? DIB[47:32] : memory_2_r[6]);
   assign memory_2_w[7] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd7 && MUXA[2] == 1'b1) ? DIA[47:32] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd7 && MUXB[2] == 1'b1) ? DIB[47:32] : memory_2_r[7]);
   assign memory_2_w[8] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd8 && MUXA[2] == 1'b1) ? DIA[47:32] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd8 && MUXB[2] == 1'b1) ? DIB[47:32] : memory_2_r[8]);
   assign memory_2_w[9] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd9 && MUXA[2] == 1'b1) ? DIA[47:32] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd9 && MUXB[2] == 1'b1) ? DIB[47:32] : memory_2_r[9]);
                                                                                                                                                                                           
   assign memory_3_w[0] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd0 && MUXA[3] == 1'b1) ? DIA[63:48] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd0 && MUXB[3] == 1'b1) ? DIB[63:48] : memory_3_r[0]);
   assign memory_3_w[1] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd1 && MUXA[3] == 1'b1) ? DIA[63:48] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd1 && MUXB[3] == 1'b1) ? DIB[63:48] : memory_3_r[1]);
   assign memory_3_w[2] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd2 && MUXA[3] == 1'b1) ? DIA[63:48] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd2 && MUXB[3] == 1'b1) ? DIB[63:48] : memory_3_r[2]);
   assign memory_3_w[3] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd3 && MUXA[3] == 1'b1) ? DIA[63:48] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd3 && MUXB[3] == 1'b1) ? DIB[63:48] : memory_3_r[3]);
   assign memory_3_w[4] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd4 && MUXA[3] == 1'b1) ? DIA[63:48] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd4 && MUXB[3] == 1'b1) ? DIB[63:48] : memory_3_r[4]);
   assign memory_3_w[5] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd5 && MUXA[3] == 1'b1) ? DIA[63:48] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd5 && MUXB[3] == 1'b1) ? DIB[63:48] : memory_3_r[5]);
   assign memory_3_w[6] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd6 && MUXA[3] == 1'b1) ? DIA[63:48] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd6 && MUXB[3] == 1'b1) ? DIB[63:48] : memory_3_r[6]);
   assign memory_3_w[7] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd7 && MUXA[3] == 1'b1) ? DIA[63:48] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd7 && MUXB[3] == 1'b1) ? DIB[63:48] : memory_3_r[7]);
   assign memory_3_w[8] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd8 && MUXA[3] == 1'b1) ? DIA[63:48] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd8 && MUXB[3] == 1'b1) ? DIB[63:48] : memory_3_r[8]);
   assign memory_3_w[9] = (CSA == 1'b1 && WEAN == 1'b0 && A == 4'd9 && MUXA[3] == 1'b1) ? DIA[63:48] : ((CSB == 1'b1 && WEBN == 1'b0 && B == 4'd9 && MUXB[3] == 1'b1) ? DIB[63:48] : memory_3_r[9]);
   
   
   
   
   
   //wire gclk = clk & (CSA || CSB);
   
   
   
   always@(posedge clk or posedge reset)
   begin
      if(reset)
      begin
         memory_0_r[0] <= 16'd0;
         memory_0_r[1] <= 16'd0;
         memory_0_r[2] <= 16'd0;
         memory_0_r[3] <= 16'd0;
         memory_0_r[4] <= 16'd0;
         memory_0_r[5] <= 16'd0;
         memory_0_r[6] <= 16'd0;
         memory_0_r[7] <= 16'd0;
         memory_0_r[8] <= 16'd0;
         memory_0_r[9] <= 16'd0;
         
         memory_1_r[0] <= 16'd0;
         memory_1_r[1] <= 16'd0;
         memory_1_r[2] <= 16'd0;
         memory_1_r[3] <= 16'd0;
         memory_1_r[4] <= 16'd0;
         memory_1_r[5] <= 16'd0;
         memory_1_r[6] <= 16'd0;
         memory_1_r[7] <= 16'd0;
         memory_1_r[8] <= 16'd0;
         memory_1_r[9] <= 16'd0;
         
         memory_2_r[0] <= 16'd0;
         memory_2_r[1] <= 16'd0;
         memory_2_r[2] <= 16'd0;
         memory_2_r[3] <= 16'd0;
         memory_2_r[4] <= 16'd0;
         memory_2_r[5] <= 16'd0;
         memory_2_r[6] <= 16'd0;
         memory_2_r[7] <= 16'd0;
         memory_2_r[8] <= 16'd0;
         memory_2_r[9] <= 16'd0;
         
         memory_3_r[0] <= 16'd0;
         memory_3_r[1] <= 16'd0;
         memory_3_r[2] <= 16'd0;
         memory_3_r[3] <= 16'd0;
         memory_3_r[4] <= 16'd0;
         memory_3_r[5] <= 16'd0;
         memory_3_r[6] <= 16'd0;
         memory_3_r[7] <= 16'd0;
         memory_3_r[8] <= 16'd0;
         memory_3_r[9] <= 16'd0;
      end
      else if(CSA || CSB)
      begin
         memory_0_r[0] <= memory_0_w[0];
         memory_0_r[1] <= memory_0_w[1];
         memory_0_r[2] <= memory_0_w[2];
         memory_0_r[3] <= memory_0_w[3];
         memory_0_r[4] <= memory_0_w[4];
         memory_0_r[5] <= memory_0_w[5];
         memory_0_r[6] <= memory_0_w[6];
         memory_0_r[7] <= memory_0_w[7];
         memory_0_r[8] <= memory_0_w[8];
         memory_0_r[9] <= memory_0_w[9];
                                  
         memory_1_r[0] <= memory_1_w[0];
         memory_1_r[1] <= memory_1_w[1];
         memory_1_r[2] <= memory_1_w[2];
         memory_1_r[3] <= memory_1_w[3];
         memory_1_r[4] <= memory_1_w[4];
         memory_1_r[5] <= memory_1_w[5];
         memory_1_r[6] <= memory_1_w[6];
         memory_1_r[7] <= memory_1_w[7];
         memory_1_r[8] <= memory_1_w[8];
         memory_1_r[9] <= memory_1_w[9];
                                  
         memory_2_r[0] <= memory_2_w[0];
         memory_2_r[1] <= memory_2_w[1];
         memory_2_r[2] <= memory_2_w[2];
         memory_2_r[3] <= memory_2_w[3];
         memory_2_r[4] <= memory_2_w[4];
         memory_2_r[5] <= memory_2_w[5];
         memory_2_r[6] <= memory_2_w[6];
         memory_2_r[7] <= memory_2_w[7];
         memory_2_r[8] <= memory_2_w[8];
         memory_2_r[9] <= memory_2_w[9];
                                  
         memory_3_r[0] <= memory_3_w[0];
         memory_3_r[1] <= memory_3_w[1];
         memory_3_r[2] <= memory_3_w[2];
         memory_3_r[3] <= memory_3_w[3];
         memory_3_r[4] <= memory_3_w[4];
         memory_3_r[5] <= memory_3_w[5];
         memory_3_r[6] <= memory_3_w[6];
         memory_3_r[7] <= memory_3_w[7];
         memory_3_r[8] <= memory_3_w[8];
         memory_3_r[9] <= memory_3_w[9];
      end
   
   end
   
   
   
   

endmodule