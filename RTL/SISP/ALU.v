`define And_op       4'd0
`define Or_op        4'd1
`define Add_op       4'd2
`define Div_Sub_op   4'd3  //相減除2       
`define Abs_Sub_op   4'd4  //相減取絕對值  
`define Sub_op       4'd5  //直接相減      
`define Mul_op       4'd6  //相乘
`define Div_Mul_op   4'd7  //相乘再去最後8 bits
`define Min_op       4'd8
`define Max_op       4'd9




module ALU(clk, reset, data_1_in, data_2_in, input_select, selector, content_in, data_out, ALU_enable);
   input             clk, reset;
   input    [7:0]    data_1_in, data_2_in;
   input             input_select;
   input             ALU_enable;
   input    [3:0]    selector;
   input    [7:0]    content_in;
   
   output   [15:0]   data_out;
   //output   [7:0]    content_select;
   
   
   wire     [7:0]    input_A, input_B;
   wire     [7:0]    AND_w;
   wire     [7:0]    OR_w;
   wire     [8:0]    Adder_w;
   wire     [8:0]    Subtractor_w;
   wire     [7:0]    Abs_Subtractor_w;
   wire     [7:0]    Div_Subtractor_w;
   wire     [15:0]   Mul_w;
   wire     [15:0]   temp_Mul_w;
   wire     [7:0]    Div_Mul_w;
   wire     [7:0]    Min_w;
   wire     [7:0]    Max_w;
   
   
   
   
   reg      [15:0]   data_out_r;
   reg      [15:0]   data_out_w;
   reg      [7:0]    data_1_in_r, data_2_in_r;
   reg               input_select_r;
   //reg               ALU_enable_r;
   reg      [3:0]    selector_r;
   reg      [7:0]    content_in_r;
   

   assign input_A = data_1_in_r;
   assign input_B = (input_select_r == 1'b1) ? content_in_r : data_2_in_r;
   assign AND_w = input_A & input_B;
   assign OR_w = input_A | input_B;
   assign Adder_w = {1'b0, input_A} + {1'b0, input_B};
   assign Subtractor_w = {1'b0,input_A} - {1'b0,input_B};
   assign Abs_Subtractor_w = (input_A > input_B) ? (input_A - input_B) : (input_B - input_A);
   assign Div_Subtractor_w = Subtractor_w[8:1];
   assign Mul_w = input_A * input_B;
   assign temp_Mul_w = Mul_w + 16'h80;
   assign Div_Mul_w = temp_Mul_w[15:8];
   assign Min_w = (input_A > input_B) ? input_B : input_A;
   assign Max_w = (input_A > input_B) ? input_A : input_B;
   assign data_out = data_out_r;
   
   always@(*)
   begin
      case(selector_r)
         `And_op:       data_out_w = {8'd0, AND_w};
         `Or_op:        data_out_w = {8'd0, OR_w};
         `Add_op:       data_out_w = {{7'd0}, Adder_w};
         `Div_Sub_op:   data_out_w = {{8{Div_Subtractor_w[7]}}, Div_Subtractor_w};
         `Abs_Sub_op:   data_out_w = {8'd0, Abs_Subtractor_w};
         `Sub_op:       data_out_w = {{7{Subtractor_w[8]}}, Subtractor_w};
         `Mul_op:       data_out_w = Mul_w;
         `Div_Mul_op:   data_out_w = {{8{Div_Mul_w[7]}}, Div_Mul_w};
         `Min_op:       data_out_w = {8'd0, Min_w};
         `Max_op:       data_out_w = {8'd0, Max_w};
         default:       data_out_w = 16'd0;
      endcase
   
   end
   
   



   always@(posedge clk or posedge reset)
   begin
      if(reset)
      begin
         data_out_r <= 16'd0;
         data_1_in_r <= 8'd0;
         data_2_in_r <= 8'd0;
         input_select_r <= 1'b0;          
         //ALU_enable_r <= 1'b0;            
         selector_r <= 4'd0;              
         content_in_r <= 8'd0;            
         
      end
      else if(ALU_enable)
      begin
         data_out_r <= data_out_w;
         data_1_in_r <= data_1_in;
         data_2_in_r <= data_2_in;
         input_select_r <= input_select;          
         //ALU_enable_r <= 1'b0;            
         selector_r <= selector;              
         content_in_r <= content_in;
      end
   end


endmodule