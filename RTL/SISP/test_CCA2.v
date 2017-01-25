`timescale 1ns/1ps

//FRAME Size
`define FRAME_WIDTH 12'd640
`define FRAME_HEIGHT 12'd480


//Address Number in # Memory Elements
`define ADDRNUMin1ELEMENT 7'd10
`define ADDRNUMin2ELEMENT 7'd20
`define ADDRNUMin3ELEMENT 7'd30
`define ADDRNUMin4ELEMENT 7'd40
`define ADDRNUMin5ELEMENT 7'd50
`define ADDRNUMin6ELEMENT 7'd60
`define ADDRNUMin7ELEMENT 7'd70
`define ADDRNUMin8ELEMENT 7'd80



//modes
`define IDLE                                          6'd0
`define ACCUMULATION_CANDIDATE_HISTOGRAM              6'd1
`define ACCUMULATION_TARGET_HISTOGRAM                 6'd2
`define COMPUTE_DISTANCE                              6'd3
`define SAVE_LOAD_FROM_DMA                            6'd4
`define ACCUMULATION_CANDIDATE_BACKGROUND_HISTOGRAM   6'd5
`define ACCUMULATION_TARGET_BACKGROUND_HISTOGRAM      6'd6
`define CONNECT_COMPONENT_ANALYSIS                    6'd7
`define SEGMENTATION_MODE                             6'd8
`define OBJECT_INFO_RSPE                              6'd9

//CCA出來放在context register裡應該只有7F 跟 7C兩筆
module test_SISP();
   parameter TIMEOUT = (50*2*(256+128+64+32+16+8) + 1000)*2;
   parameter DELAY = 100;
   parameter HALF_CYCLE = 50;
   parameter LONG_DELAY = 100*640;

   
   reg clk;
   reg reset;
   reg stall;
   reg ctrl_gateCLK;
   reg buffer_input_stop_i;
   reg reset_register_i;
   reg reset_buffer_i;
   reg [3:0]  Address_from_DMA_i;
   reg [5:0] choose_reg_from_DMA_i;
   reg        WEAN_from_DMA_i;
   reg [3:0]  MUXA_from_DMA_i;
   
   reg seg_enable_i;          
   reg seg_stall;
   
   reg [63:0] DataIn_i;
   reg DataInReady_i;
   reg [7:0]ContextRegAddr_i;
   
   wire [63:0] DataOut_o;
   wire DataOutReady_o;
   
   
   
  SISP_top S0(
	
		          clk,
                reset,
                stall,
                ctrl_gateCLK,
                buffer_input_stop_i,
                reset_register_i, 
                reset_buffer_i,
                
                Address_from_DMA_i,
                choose_reg_from_DMA_i,
                WEAN_from_DMA_i,
                MUXA_from_DMA_i,
                
                DataIn_i,
                DataInReady_i,
                ContextRegAddr_i,
                
                seg_enable_i,
                seg_stall, 
                
                
                DataOut_o,
                DataOutReady_o
                
                
);

   always #(HALF_CYCLE) clk = ~clk;
   
   
//7 cycles stop 3 cycles   
   
   
   initial
   begin
      //$sdf_annotate("SISP_syn_v10.sdf",S0);
      $dumpfile("CCA.vcd");						
	   $dumpvars;
	   Address_from_DMA_i = 0;
      choose_reg_from_DMA_i = 0;
      WEAN_from_DMA_i = 0;
      MUXA_from_DMA_i = 0;
      clk = 1'b0;
      reset = 0;
      stall = 0;
      buffer_input_stop_i = 0;
      reset_register_i = 0;
      reset_buffer_i = 0;
      ctrl_gateCLK = 1'b0;
      seg_enable_i = 0;
      seg_stall = 0;
      DataInReady_i = 1;
      
      
      #DELAY reset = 1;
      reset_register_i = 1;
      reset_buffer_i = 1;
      #DELAY reset = 0;
      reset_register_i = 0;
      reset_buffer_i = 0;
      ctrl_gateCLK = 1'b1;
      
      ContextRegAddr_i = 140;
      DataIn_i = 1;
      #DELAY
      ContextRegAddr_i = 0;
      DataIn_i = 7;
      #DELAY
      ContextRegAddr_i = 119;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 119;
      DataIn_i = 64'hEFFFFFFFFFFFFFFF;
      #DELAY
      ContextRegAddr_i = 119;
      DataIn_i = 64'hFFFFFFFFFFFFFFFF;
      #DELAY
      ContextRegAddr_i = 119;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 119;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 119;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 119;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 119;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 119;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 119;
      DataIn_i = 64'h0;
      
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'hF;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      #DELAY
      ContextRegAddr_i = 118;
      DataIn_i = 64'h0;
      
      
      #LONG_DELAY
      ContextRegAddr_i = 140;
      #DELAY
      ContextRegAddr_i = 141;
      #DELAY
      ContextRegAddr_i = 142;
      #DELAY
      ContextRegAddr_i = 143;
      #DELAY
      ContextRegAddr_i = 144;
      #DELAY
      ContextRegAddr_i = 145;
      #DELAY
      ContextRegAddr_i = 146;
      #DELAY
      ContextRegAddr_i = 147;
      #DELAY
      ContextRegAddr_i = 148;
      #DELAY
      ContextRegAddr_i = 149;
      #DELAY
      ContextRegAddr_i = 150;
      #DELAY
      ContextRegAddr_i = 151;
      #DELAY
      ContextRegAddr_i = 152;
      #DELAY
      ContextRegAddr_i = 153;
      #DELAY
      ContextRegAddr_i = 154;
      #DELAY
      ContextRegAddr_i = 155;
      #DELAY
      ContextRegAddr_i = 156;
      #DELAY
      ContextRegAddr_i = 157;
      #DELAY
      ContextRegAddr_i = 158;
      #DELAY
      ContextRegAddr_i = 159;
      
      
      
      
      
      
   end
      
   initial #TIMEOUT $finish;
      
      


endmodule