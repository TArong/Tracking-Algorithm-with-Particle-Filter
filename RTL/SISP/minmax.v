module minmax(clk, reset,
              data_00_in,
              data_01_in,
              data_02_in,
              data_03_in,
              data_04_in,
              data_05_in,
              data_06_in,
              data_07_in,
              data_08_in,
              data_09_in,
              data_10_in,
              data_11_in,
              data_12_in,
              data_13_in,
              data_14_in,
              data_15_in,
              data_16_in,
              data_17_in,
              data_18_in,
              data_19_in,
              data_20_in,
              data_21_in,
              data_22_in,
              data_23_in,
              data_24_in,
              data_25_in,
              data_26_in, //27舱9bit data (MSBsign bit)
              min_out, max_out, //程程
              which_min_out, which_max_out, //琌程or程 0~26
              minmax_enable);
   input       [8:0]    data_00_in;
   input       [8:0]    data_01_in;
   input       [8:0]    data_02_in;
   input       [8:0]    data_03_in;
   input       [8:0]    data_04_in;
   input       [8:0]    data_05_in;
   input       [8:0]    data_06_in;
   input       [8:0]    data_07_in;
   input       [8:0]    data_08_in;
   input       [8:0]    data_09_in;
   input       [8:0]    data_10_in;
   input       [8:0]    data_11_in;
   input       [8:0]    data_12_in;
   input       [8:0]    data_13_in;
   input       [8:0]    data_14_in;
   input       [8:0]    data_15_in;
   input       [8:0]    data_16_in;
   input       [8:0]    data_17_in;
   input       [8:0]    data_18_in;
   input       [8:0]    data_19_in;
   input       [8:0]    data_20_in;
   input       [8:0]    data_21_in;
   input       [8:0]    data_22_in;
   input       [8:0]    data_23_in;
   input       [8:0]    data_24_in;
   input       [8:0]    data_25_in;
   input       [8:0]    data_26_in;
   input                clk, reset, minmax_enable;
   output      [8:0]    min_out, max_out;
   output      [4:0]    which_min_out, which_max_out;
                        
                        
                        
   wire        [8:0]    min_out_w, max_out_w;
   wire        [4:0]    which_min_out_w, which_max_out_w;
   wire        [13:0]   data_ID_00_in_w;
   wire        [13:0]   data_ID_01_in_w;
   wire        [13:0]   data_ID_02_in_w;
   wire        [13:0]   data_ID_03_in_w;
   wire        [13:0]   data_ID_04_in_w;
   wire        [13:0]   data_ID_05_in_w;
   wire        [13:0]   data_ID_06_in_w;
   wire        [13:0]   data_ID_07_in_w;
   wire        [13:0]   data_ID_08_in_w;
   wire        [13:0]   data_ID_09_in_w;
   wire        [13:0]   data_ID_10_in_w;
   wire        [13:0]   data_ID_11_in_w;
   wire        [13:0]   data_ID_12_in_w;
   wire        [13:0]   data_ID_13_in_w;
   wire        [13:0]   data_ID_14_in_w;
   wire        [13:0]   data_ID_15_in_w;
   wire        [13:0]   data_ID_16_in_w;
   wire        [13:0]   data_ID_17_in_w;
   wire        [13:0]   data_ID_18_in_w;
   wire        [13:0]   data_ID_19_in_w;
   wire        [13:0]   data_ID_20_in_w;
   wire        [13:0]   data_ID_21_in_w;
   wire        [13:0]   data_ID_22_in_w;
   wire        [13:0]   data_ID_23_in_w;
   wire        [13:0]   data_ID_24_in_w;
   wire        [13:0]   data_ID_25_in_w;
   wire        [13:0]   data_ID_26_in_w;
   
   wire        [13:0]   min_00_01_w, max_00_01_w;
   wire        [13:0]   min_02_03_w, max_02_03_w;
   wire        [13:0]   min_04_05_w, max_04_05_w;
   wire        [13:0]   min_06_07_w, max_06_07_w;
   wire        [13:0]   min_08_09_w, max_08_09_w;
   wire        [13:0]   min_10_11_w, max_10_11_w;
   wire        [13:0]   min_12_13_w, max_12_13_w;
   wire        [13:0]   min_14_15_w, max_14_15_w;
   wire        [13:0]   min_16_17_w, max_16_17_w;
   wire        [13:0]   min_18_19_w, max_18_19_w;
   wire        [13:0]   min_20_21_w, max_20_21_w;
   wire        [13:0]   min_22_23_w, max_22_23_w;
   wire        [13:0]   min_24_25_w, max_24_25_w;
   
   wire        [13:0]   min_00_03_w, max_00_03_w;
   wire        [13:0]   min_04_07_w, max_04_07_w;
   wire        [13:0]   min_08_11_w, max_08_11_w;
   wire        [13:0]   min_12_15_w, max_12_15_w;
   wire        [13:0]   min_16_19_w, max_16_19_w;
   wire        [13:0]   min_20_23_w, max_20_23_w;
   wire        [13:0]   min_24_26_w, max_24_26_w;
                               
   wire        [13:0]   min_00_07_w, max_00_07_w;                            
   wire        [13:0]   min_08_15_w, max_08_15_w;
   wire        [13:0]   min_16_23_w, max_16_23_w;
   
   
   wire        [13:0]   min_00_15_w, max_00_15_w;
   wire        [13:0]   min_16_26_w, max_16_26_w;
   
   
   
                               
                               
   reg         [8:0]    min_out_r, max_out_r;
   reg         [4:0]    which_min_out_r, which_max_out_r;
   reg         [8:0]    data_00_in_r;
   reg         [8:0]    data_01_in_r;
   reg         [8:0]    data_02_in_r;
   reg         [8:0]    data_03_in_r;
   reg         [8:0]    data_04_in_r;
   reg         [8:0]    data_05_in_r;
   reg         [8:0]    data_06_in_r;
   reg         [8:0]    data_07_in_r;
   reg         [8:0]    data_08_in_r;
   reg         [8:0]    data_09_in_r;
   reg         [8:0]    data_10_in_r;
   reg         [8:0]    data_11_in_r;
   reg         [8:0]    data_12_in_r;
   reg         [8:0]    data_13_in_r;
   reg         [8:0]    data_14_in_r;
   reg         [8:0]    data_15_in_r;
   reg         [8:0]    data_16_in_r;
   reg         [8:0]    data_17_in_r;
   reg         [8:0]    data_18_in_r;
   reg         [8:0]    data_19_in_r;
   reg         [8:0]    data_20_in_r;
   reg         [8:0]    data_21_in_r;
   reg         [8:0]    data_22_in_r;
   reg         [8:0]    data_23_in_r;
   reg         [8:0]    data_24_in_r;
   reg         [8:0]    data_25_in_r;
   reg         [8:0]    data_26_in_r;
                               
                               
   assign min_out = min_out_r; 
   assign max_out = max_out_r; 
   assign which_min_out = which_min_out_r;
   assign which_max_out = which_max_out_r;
                               
   assign data_ID_00_in_w = {5'd00, data_00_in_r};
   assign data_ID_01_in_w = {5'd01, data_01_in_r};
   assign data_ID_02_in_w = {5'd02, data_02_in_r};
   assign data_ID_03_in_w = {5'd03, data_03_in_r};
   assign data_ID_04_in_w = {5'd04, data_04_in_r};
   assign data_ID_05_in_w = {5'd05, data_05_in_r};
   assign data_ID_06_in_w = {5'd06, data_06_in_r};
   assign data_ID_07_in_w = {5'd07, data_07_in_r};
   assign data_ID_08_in_w = {5'd08, data_08_in_r};
   assign data_ID_09_in_w = {5'd09, data_09_in_r};
   assign data_ID_10_in_w = {5'd10, data_10_in_r};
   assign data_ID_11_in_w = {5'd11, data_11_in_r};
   assign data_ID_12_in_w = {5'd12, data_12_in_r};
   assign data_ID_13_in_w = {5'd13, data_13_in_r};
   assign data_ID_14_in_w = {5'd14, data_14_in_r};
   assign data_ID_15_in_w = {5'd15, data_15_in_r};
   assign data_ID_16_in_w = {5'd16, data_16_in_r};
   assign data_ID_17_in_w = {5'd17, data_17_in_r};
   assign data_ID_18_in_w = {5'd18, data_18_in_r};
   assign data_ID_19_in_w = {5'd19, data_19_in_r};
   assign data_ID_20_in_w = {5'd20, data_20_in_r};
   assign data_ID_21_in_w = {5'd21, data_21_in_r};
   assign data_ID_22_in_w = {5'd22, data_22_in_r};
   assign data_ID_23_in_w = {5'd23, data_23_in_r};
   assign data_ID_24_in_w = {5'd24, data_24_in_r};
   assign data_ID_25_in_w = {5'd25, data_25_in_r};
   assign data_ID_26_in_w = {5'd26, data_26_in_r};
                               
   compare c00 (.A(data_ID_00_in_w), .B(data_ID_01_in_w), .max(max_00_01_w), .min(min_00_01_w));
   compare c01 (.A(data_ID_02_in_w), .B(data_ID_03_in_w), .max(max_02_03_w), .min(min_02_03_w));
   compare c02 (.A(data_ID_04_in_w), .B(data_ID_05_in_w), .max(max_04_05_w), .min(min_04_05_w));
   compare c03 (.A(data_ID_06_in_w), .B(data_ID_07_in_w), .max(max_06_07_w), .min(min_06_07_w));
   compare c04 (.A(data_ID_08_in_w), .B(data_ID_09_in_w), .max(max_08_09_w), .min(min_08_09_w));
   compare c05 (.A(data_ID_10_in_w), .B(data_ID_11_in_w), .max(max_10_11_w), .min(min_10_11_w));
   compare c06 (.A(data_ID_12_in_w), .B(data_ID_13_in_w), .max(max_12_13_w), .min(min_12_13_w));
   compare c07 (.A(data_ID_14_in_w), .B(data_ID_15_in_w), .max(max_14_15_w), .min(min_14_15_w));
   compare c08 (.A(data_ID_16_in_w), .B(data_ID_17_in_w), .max(max_16_17_w), .min(min_16_17_w));
   compare c09 (.A(data_ID_18_in_w), .B(data_ID_19_in_w), .max(max_18_19_w), .min(min_18_19_w));
   compare c10 (.A(data_ID_20_in_w), .B(data_ID_21_in_w), .max(max_20_21_w), .min(min_20_21_w));
   compare c11 (.A(data_ID_22_in_w), .B(data_ID_23_in_w), .max(max_22_23_w), .min(min_22_23_w));
   compare c12 (.A(data_ID_24_in_w), .B(data_ID_25_in_w), .max(max_24_25_w), .min(min_24_25_w));
   
   compare_min m00 (.A(min_00_01_w), .B(min_02_03_w), .min(min_00_03_w));
   compare_min m01 (.A(min_04_05_w), .B(min_06_07_w), .min(min_04_07_w));
   compare_min m02 (.A(min_08_09_w), .B(min_10_11_w), .min(min_08_11_w));
   compare_min m03 (.A(min_12_13_w), .B(min_14_15_w), .min(min_12_15_w));
   compare_min m04 (.A(min_16_17_w), .B(min_18_19_w), .min(min_16_19_w));
   compare_min m05 (.A(min_20_21_w), .B(min_22_23_w), .min(min_20_23_w));
   compare_min m06 (.A(min_24_25_w), .B(data_ID_26_in_w), .min(min_24_26_w));
   
   compare_max x00 (.A(max_00_01_w), .B(max_02_03_w), .max(max_00_03_w));
   compare_max x01 (.A(max_04_05_w), .B(max_06_07_w), .max(max_04_07_w));
   compare_max x02 (.A(max_08_09_w), .B(max_10_11_w), .max(max_08_11_w));
   compare_max x03 (.A(max_12_13_w), .B(max_14_15_w), .max(max_12_15_w));
   compare_max x04 (.A(max_16_17_w), .B(max_18_19_w), .max(max_16_19_w));
   compare_max x05 (.A(max_20_21_w), .B(max_22_23_w), .max(max_20_23_w));
   compare_max x06 (.A(max_24_25_w), .B(data_ID_26_in_w), .max(max_24_26_w));
   
   compare_min m07 (.A(min_00_03_w), .B(min_04_07_w), .min(min_00_07_w));
   compare_min m08 (.A(min_08_11_w), .B(min_12_15_w), .min(min_08_15_w));
   compare_min m09 (.A(min_16_19_w), .B(min_20_23_w), .min(min_16_23_w));
   
   compare_max x07 (.A(max_00_03_w), .B(max_04_07_w), .max(max_00_07_w));
   compare_max x08 (.A(max_08_11_w), .B(max_12_15_w), .max(max_08_15_w));
   compare_max x09 (.A(max_16_19_w), .B(max_20_23_w), .max(max_16_23_w));
   
   compare_min m10 (.A(min_00_07_w), .B(min_08_15_w), .min(min_00_15_w));
   compare_min m11 (.A(min_16_23_w), .B(min_24_26_w), .min(min_16_26_w));
   
   compare_max x10 (.A(max_00_07_w), .B(max_08_15_w), .max(max_00_15_w));
   compare_max x11 (.A(max_16_23_w), .B(max_24_26_w), .max(max_16_26_w));
   
   compare_min m12 (.A(min_00_15_w), .B(min_16_26_w), .min({which_min_out_w, min_out_w}));
   
   compare_max x12 (.A(max_00_15_w), .B(max_16_26_w), .max({which_max_out_w, max_out_w}));

//   wire gclk = clk & minmax_enable;                               
   always@(posedge clk or posedge reset)
   begin                       
      if(reset)                
      begin                    
         min_out_r <= 9'd0;    
         max_out_r <= 9'd0;    
         which_min_out_r <= 5'd0;
         which_max_out_r <= 5'd0; 
         data_00_in_r <= 9'd0;
         data_01_in_r <= 9'd0;
         data_02_in_r <= 9'd0;
         data_03_in_r <= 9'd0;
         data_04_in_r <= 9'd0;
         data_05_in_r <= 9'd0;
         data_06_in_r <= 9'd0;
         data_07_in_r <= 9'd0;
         data_08_in_r <= 9'd0;
         data_09_in_r <= 9'd0;
         data_10_in_r <= 9'd0;
         data_11_in_r <= 9'd0;
         data_12_in_r <= 9'd0;
         data_13_in_r <= 9'd0;
         data_14_in_r <= 9'd0;
         data_15_in_r <= 9'd0;
         data_16_in_r <= 9'd0;
         data_17_in_r <= 9'd0;
         data_18_in_r <= 9'd0;
         data_19_in_r <= 9'd0;
         data_20_in_r <= 9'd0;
         data_21_in_r <= 9'd0;
         data_22_in_r <= 9'd0;
         data_23_in_r <= 9'd0;
         data_24_in_r <= 9'd0;
         data_25_in_r <= 9'd0;
         data_26_in_r <= 9'd0;
         
      end                      
      else if(minmax_enable)   
      begin                    
         min_out_r <= min_out_w;
         max_out_r <= max_out_w;
         which_min_out_r <= which_min_out_w;
         which_max_out_r <= which_max_out_w;
         data_00_in_r <= data_00_in;
         data_01_in_r <= data_01_in;
         data_02_in_r <= data_02_in;
         data_03_in_r <= data_03_in;
         data_04_in_r <= data_04_in;
         data_05_in_r <= data_05_in;
         data_06_in_r <= data_06_in;
         data_07_in_r <= data_07_in;
         data_08_in_r <= data_08_in;
         data_09_in_r <= data_09_in;
         data_10_in_r <= data_10_in;
         data_11_in_r <= data_11_in;
         data_12_in_r <= data_12_in;
         data_13_in_r <= data_13_in;
         data_14_in_r <= data_14_in;
         data_15_in_r <= data_15_in;
         data_16_in_r <= data_16_in;
         data_17_in_r <= data_17_in;
         data_18_in_r <= data_18_in;
         data_19_in_r <= data_19_in;
         data_20_in_r <= data_20_in;
         data_21_in_r <= data_21_in;
         data_22_in_r <= data_22_in;
         data_23_in_r <= data_23_in;
         data_24_in_r <= data_24_in;
         data_25_in_r <= data_25_in;
         data_26_in_r <= data_26_in;
         
         
         
         
         
         
         
         
         
                               
      end                      
                               
                               
   end                         
                               
                               
                               
endmodule                      