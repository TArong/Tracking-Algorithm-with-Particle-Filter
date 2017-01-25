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

//DISTANCE Y == 1F_217D
//DISTANCE U == 0
//DISTANCE V == 0
//DataOut_o = 1F_217D When ContextRegAddr_i == 121
//SUM of histogram = 3D68

module test_SISP();
   parameter TIMEOUT = 100000;//50*2*(256+128+64+32+16+8)*2 + 1000;// Provide a value
   parameter DELAY = 100;
   parameter HALF_CYCLE = 50;

   
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
      $dumpfile("SISP.vcd");						
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
      
      
      ContextRegAddr_i = 0;
      DataIn_i = 0;
      #DELAY
      ContextRegAddr_i = 106;
      DataIn_i = 9;
      #DELAY
      ContextRegAddr_i = 138;
      DataIn_i = 64'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1110_1111;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 1;
      #DELAY
      ContextRegAddr_i = 108;
      DataIn_i = {25'd0,9'd1,9'd0,10'd80,10'd25};
      #DELAY
      ContextRegAddr_i = 109;
      DataIn_i = 8;
      #DELAY
      ContextRegAddr_i = 111;
      DataIn_i = 250000;
      #DELAY
      ContextRegAddr_i = 112;
      DataIn_i = 0;
      #DELAY
      ContextRegAddr_i = 113;
      DataIn_i = 0;
      #DELAY
      ContextRegAddr_i = 114;
      DataIn_i = 5;
      #DELAY
      ContextRegAddr_i = 116;
      DataIn_i = 0;
      #DELAY
      ContextRegAddr_i = 0;
      DataIn_i = 1;
      
      while(DataOutReady_o == 0)
      begin
         #(DELAY)    ContextRegAddr_i = 0;
         DataIn_i = 1; 
      end
    
//***********************SEG************************     
      #DELAY
      
      ContextRegAddr_i = 107;
      DataIn_i = 12;
//等一個cycle才選擇是算還是換顏色      
      
        
      
      
      #DELAY
      #DELAY
      #DELAY
      
      
      ContextRegAddr_i = 138;
      DataIn_i = 64'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111;
      
      
      
      //#DELAY
      //#DELAY
      #DELAY
      
      ContextRegAddr_i = 107;
      DataIn_i = 9;
      #DELAY
      #DELAY
      ContextRegAddr_i = 139;
      DataIn_i = 1;
      //#DELAY
      
      
      
      
//寫第一筆      
/*      
      
      
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 12;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 12;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 12;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 12;
      
      #DELAY
      #DELAY
      #DELAY
      
      
      //ContextRegAddr_i = 107;
      //DataIn_i = 12;
//等10個cycle開始寫第一筆     
      
*/       
      
      
      



//**************************************************    
     
      
      #DELAY
      
      ContextRegAddr_i = 107;
      DataIn_i = 9;
//等一個cycle才選擇是算還是換顏色      
      
      //#DELAY
//TEST GATE-CLOCK      
      /*ctrl_gateCLK = 1'b0;
      #DELAY
      #DELAY
      #DELAY
      #DELAY
      ctrl_gateCLK = 1'b1;
      */
      
      #DELAY
//寫第一筆資料      
      //ContextRegAddr_i = 107;
      //DataIn_i = 9;
      ContextRegAddr_i = 106;
      DataIn_i = 10;
      
      #DELAY
      //ContextRegAddr_i = 107;
      //DataIn_i = 9;
      ContextRegAddr_i = 106;
      DataIn_i = 11;
      
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 9;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 9;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 9;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 9;
      
      #DELAY
      #DELAY
      #DELAY
//等10個cycle開始將第一筆顏色寫進buffer裡
      ContextRegAddr_i = 106;
      DataIn_i = 10;
      #DELAY
      ContextRegAddr_i = 106;
      DataIn_i = 11;
/*         
      while(DataOutReady_o == 0)
      begin
         #(DELAY)    ContextRegAddr_i = 107;
         DataIn_i = 9; 
      end 
*/

      while(DataOutReady_o == 0)
      begin
         #(DELAY)    ContextRegAddr_i = 107;
         DataIn_i = 17; 
      end
      
      
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 17;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 17;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 17;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 17;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 17;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 17;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 17;
      //ContextRegAddr_i = 106;
      //DataIn_i = 10;
      
      while(DataOutReady_o == 0)
      begin
         #(DELAY)    ContextRegAddr_i = 0;
         DataIn_i = 1; 
      end
/***********/
// TARGET  
/***********/    
      #DELAY
       
         ContextRegAddr_i = 0;
         DataIn_i = 0; 
      
      #DELAY
      #DELAY
      #DELAY reset_buffer_i = 1;
      #DELAY reset_buffer_i = 0;
      ctrl_gateCLK = 1'b1;
      
      
      ContextRegAddr_i = 0;
      DataIn_i = 0;
      #DELAY
      ContextRegAddr_i = 106;
      DataIn_i = 8;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 1;
      #DELAY
      ContextRegAddr_i = 108;
      DataIn_i = {25'd0,9'd1,9'd0,10'd80,10'd25};
      #DELAY
      ContextRegAddr_i = 109;
      DataIn_i = 8;
      #DELAY
      ContextRegAddr_i = 111;
      DataIn_i = 250000;
      #DELAY
      ContextRegAddr_i = 112;
      DataIn_i = 0;
      #DELAY
      ContextRegAddr_i = 113;
      DataIn_i = 0;
      #DELAY
      ContextRegAddr_i = 114;
      DataIn_i = 5;
      #DELAY
      ContextRegAddr_i = 116;
      DataIn_i = 0;
      #DELAY
      ContextRegAddr_i = 0;
      DataIn_i = 2;
      
      while(DataOutReady_o == 0)
      begin
         #(DELAY)    ContextRegAddr_i = 0;
         DataIn_i = 2; 
      end
      
      
      #DELAY
      
      ContextRegAddr_i = 107;
      DataIn_i = 9;
//等一個cycle才選擇是算還是換顏色      
      
      //#DELAY
//TEST GATE-CLOCK      
      ctrl_gateCLK = 1'b0;
      #DELAY
      #DELAY
      #DELAY
      #DELAY
      ctrl_gateCLK = 1'b1;
      
      
      #DELAY
//寫第一筆      
      ContextRegAddr_i = 107;
      DataIn_i = 9;
      ContextRegAddr_i = 106;
      DataIn_i = 10;
      
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 9;
      ContextRegAddr_i = 106;
      DataIn_i = 11;
      
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 9;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 9;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 9;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 9;
      
      #DELAY
      #DELAY
      #DELAY
//等10個cycle開始寫第一筆      
      ContextRegAddr_i = 106;
      DataIn_i = 10;
      #DELAY
      ContextRegAddr_i = 106;
      DataIn_i = 11;
      
      while(DataOutReady_o == 0)
      begin
         #(DELAY)    ContextRegAddr_i = 107;
         DataIn_i = 17; 
      end
      
      
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 17;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 17;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 17;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 17;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 17;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 17;
      #DELAY
      ContextRegAddr_i = 107;
      DataIn_i = 17;
      //ContextRegAddr_i = 106;
      //DataIn_i = 10;
      
      while(DataOutReady_o == 0)
      begin
         #(DELAY)    ContextRegAddr_i = 0;
         DataIn_i = 2; 
      end
      
/************************/
//   COMPUTE DISTANCE      
/************************/
      
      ContextRegAddr_i = 0;
      DataIn_i = 3;
      #DELAY
      
      while(DataOutReady_o == 0)
      begin
         #(DELAY)    ContextRegAddr_i = 0;
         DataIn_i = 3; 
      end
   
      ContextRegAddr_i = 121;
      
      
      
      
      
   end
      
   initial #TIMEOUT $finish;
      
      


endmodule