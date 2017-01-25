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


module SISP_top(
	
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
                DataOutReady_o,
                
                WREN_i,
                WREN_o
                
                
);






input clk;
input reset;
input stall;
input ctrl_gateCLK;
input buffer_input_stop_i;
input reset_register_i;
input reset_buffer_i;
input [3:0]  Address_from_DMA_i;
input [5:0] choose_reg_from_DMA_i;
input        WEAN_from_DMA_i;
input [3:0]  MUXA_from_DMA_i;

input seg_enable_i;          
input seg_stall;

input [63:0] DataIn_i;
input DataInReady_i;
input [7:0]ContextRegAddr_i;
output [63:0] DataOut_o;
output DataOutReady_o;
                
input WREN_i;
output WREN_o;



/*************************************************************/
//             In Out stages
/*************************************************************/            

wire [63:0] DataIn_ws;
wire DataInReady_ws;
wire [7:0]ContextRegAddr_ws;
wire [63:0] DataOut_ws;
wire DataOutReady_ws;
reg  [63:0] DataOut_w;
reg  DataOutReady_w;

reg [63:0] DataIn_r;
reg DataInReady_r;
reg [7:0]ContextRegAddr_r;
reg [63:0] DataOut_r;
reg DataOutReady_r;
reg WREN_r;
wire CCL_write_time_w;

assign WREN_o = WREN_r;

/*************************************************************/
//             Context Registers
/*************************************************************/            
reg [5:0] Mode_r;
reg [11:0] box1xmax_r; 
reg [11:0] box2xmax_r; 
reg [11:0] box3xmax_r; 
reg [11:0] box4xmax_r; 
reg [11:0] box5xmax_r; 
reg [11:0] box6xmax_r; 
reg [11:0] box7xmax_r; 
reg [11:0] box8xmax_r; 
reg [11:0] box9xmax_r; 
reg [11:0] box10xmax_r;

reg [11:0] box1ymax_r; 
reg [11:0] box2ymax_r; 
reg [11:0] box3ymax_r; 
reg [11:0] box4ymax_r; 
reg [11:0] box5ymax_r; 
reg [11:0] box6ymax_r; 
reg [11:0] box7ymax_r; 
reg [11:0] box8ymax_r; 
reg [11:0] box9ymax_r; 
reg [11:0] box10ymax_r;

reg [11:0] box1xmin_r; 
reg [11:0] box2xmin_r; 
reg [11:0] box3xmin_r; 
reg [11:0] box4xmin_r; 
reg [11:0] box5xmin_r; 
reg [11:0] box6xmin_r; 
reg [11:0] box7xmin_r; 
reg [11:0] box8xmin_r; 
reg [11:0] box9xmin_r; 
reg [11:0] box10xmin_r;

reg [11:0] box1ymin_r; 
reg [11:0] box2ymin_r; 
reg [11:0] box3ymin_r; 
reg [11:0] box4ymin_r; 
reg [11:0] box5ymin_r; 
reg [11:0] box6ymin_r; 
reg [11:0] box7ymin_r; 
reg [11:0] box8ymin_r; 
reg [11:0] box9ymin_r; 
reg [11:0] box10ymin_r;

reg [7:0] BDthY_default_r;
reg [7:0] BDthY_box1_r; 
reg [7:0] BDthY_box2_r; 
reg [7:0] BDthY_box3_r; 
reg [7:0] BDthY_box4_r; 
reg [7:0] BDthY_box5_r; 
reg [7:0] BDthY_box6_r; 
reg [7:0] BDthY_box7_r; 
reg [7:0] BDthY_box8_r; 
reg [7:0] BDthY_box9_r; 
reg [7:0] BDthY_box10_r;

reg [7:0] BDthU_default_r; 
reg [7:0] BDthU_box1_r; 
reg [7:0] BDthU_box2_r; 
reg [7:0] BDthU_box3_r; 
reg [7:0] BDthU_box4_r; 
reg [7:0] BDthU_box5_r; 
reg [7:0] BDthU_box6_r; 
reg [7:0] BDthU_box7_r; 
reg [7:0] BDthU_box8_r; 
reg [7:0] BDthU_box9_r; 
reg [7:0] BDthU_box10_r;

reg [7:0] BDthV_default_r;        
reg [7:0] BDthV_box1_r;      
reg [7:0] BDthV_box2_r;      
reg [7:0] BDthV_box3_r;      
reg [7:0] BDthV_box4_r;      
reg [7:0] BDthV_box5_r;      
reg [7:0] BDthV_box6_r;      
reg [7:0] BDthV_box7_r;      
reg [7:0] BDthV_box8_r;      
reg [7:0] BDthV_box9_r;      
reg [7:0] BDthV_box10_r;     

reg update_box1_r; 
reg update_box2_r; 
reg update_box3_r; 
reg update_box4_r; 
reg update_box5_r; 
reg update_box6_r; 
reg update_box7_r; 
reg update_box8_r; 
reg update_box9_r; 
reg update_box10_r;

reg [7:0] Bth_default_r;
reg [7:0] Bth_box1_r; 
reg [7:0] Bth_box2_r; 
reg [7:0] Bth_box3_r; 
reg [7:0] Bth_box4_r; 
reg [7:0] Bth_box5_r; 
reg [7:0] Bth_box6_r; 
reg [7:0] Bth_box7_r; 
reg [7:0] Bth_box8_r; 
reg [7:0] Bth_box9_r; 
reg [7:0] Bth_box10_r;

          
reg [7:0] BckGndBuildTH_default_r;
reg [7:0] BckGndBuildTH_box1_r; 
reg [7:0] BckGndBuildTH_box2_r; 
reg [7:0] BckGndBuildTH_box3_r; 
reg [7:0] BckGndBuildTH_box4_r; 
reg [7:0] BckGndBuildTH_box5_r; 
reg [7:0] BckGndBuildTH_box6_r; 
reg [7:0] BckGndBuildTH_box7_r; 
reg [7:0] BckGndBuildTH_box8_r; 
reg [7:0] BckGndBuildTH_box9_r; 
reg [7:0] BckGndBuildTH_box10_r ;

reg       MASK_input_stop_r;
wire      MASK_input_stop_w;


wire [5:0] Mode_ws;
wire [11:0] box1xmax_ws; 
wire [11:0] box2xmax_ws; 
wire [11:0] box3xmax_ws; 
wire [11:0] box4xmax_ws; 
wire [11:0] box5xmax_ws; 
wire [11:0] box6xmax_ws; 
wire [11:0] box7xmax_ws; 
wire [11:0] box8xmax_ws; 
wire [11:0] box9xmax_ws; 
wire [11:0] box10xmax_ws;

wire [11:0] box1ymax_ws; 
wire [11:0] box2ymax_ws; 
wire [11:0] box3ymax_ws; 
wire [11:0] box4ymax_ws; 
wire [11:0] box5ymax_ws; 
wire [11:0] box6ymax_ws; 
wire [11:0] box7ymax_ws; 
wire [11:0] box8ymax_ws; 
wire [11:0] box9ymax_ws; 
wire [11:0] box10ymax_ws;

wire [11:0] box1xmin_ws; 
wire [11:0] box2xmin_ws; 
wire [11:0] box3xmin_ws; 
wire [11:0] box4xmin_ws; 
wire [11:0] box5xmin_ws; 
wire [11:0] box6xmin_ws; 
wire [11:0] box7xmin_ws; 
wire [11:0] box8xmin_ws; 
wire [11:0] box9xmin_ws; 
wire [11:0] box10xmin_ws;

wire [11:0] box1ymin_ws; 
wire [11:0] box2ymin_ws; 
wire [11:0] box3ymin_ws; 
wire [11:0] box4ymin_ws; 
wire [11:0] box5ymin_ws; 
wire [11:0] box6ymin_ws; 
wire [11:0] box7ymin_ws; 
wire [11:0] box8ymin_ws; 
wire [11:0] box9ymin_ws; 
wire [11:0] box10ymin_ws;

wire [7:0] BDthY_default_ws;
wire [7:0] BDthY_box1_ws; 
wire [7:0] BDthY_box2_ws; 
wire [7:0] BDthY_box3_ws; 
wire [7:0] BDthY_box4_ws; 
wire [7:0] BDthY_box5_ws; 
wire [7:0] BDthY_box6_ws; 
wire [7:0] BDthY_box7_ws; 
wire [7:0] BDthY_box8_ws; 
wire [7:0] BDthY_box9_ws; 
wire [7:0] BDthY_box10_ws;

wire [7:0] BDthU_default_ws; 
wire [7:0] BDthU_box1_ws; 
wire [7:0] BDthU_box2_ws; 
wire [7:0] BDthU_box3_ws; 
wire [7:0] BDthU_box4_ws; 
wire [7:0] BDthU_box5_ws; 
wire [7:0] BDthU_box6_ws; 
wire [7:0] BDthU_box7_ws; 
wire [7:0] BDthU_box8_ws; 
wire [7:0] BDthU_box9_ws; 
wire [7:0] BDthU_box10_ws;

wire [7:0] BDthV_default_ws;        
wire [7:0] BDthV_box1_ws;      
wire [7:0] BDthV_box2_ws;      
wire [7:0] BDthV_box3_ws;      
wire [7:0] BDthV_box4_ws;      
wire [7:0] BDthV_box5_ws;      
wire [7:0] BDthV_box6_ws;      
wire [7:0] BDthV_box7_ws;      
wire [7:0] BDthV_box8_ws;      
wire [7:0] BDthV_box9_ws;      
wire [7:0] BDthV_box10_ws;     

wire update_box1_ws; 
wire update_box2_ws; 
wire update_box3_ws; 
wire update_box4_ws; 
wire update_box5_ws; 
wire update_box6_ws; 
wire update_box7_ws; 
wire update_box8_ws; 
wire update_box9_ws; 
wire update_box10_ws;

wire [7:0] Bth_default_ws;
wire [7:0] Bth_box1_ws; 
wire [7:0] Bth_box2_ws; 
wire [7:0] Bth_box3_ws; 
wire [7:0] Bth_box4_ws; 
wire [7:0] Bth_box5_ws; 
wire [7:0] Bth_box6_ws; 
wire [7:0] Bth_box7_ws; 
wire [7:0] Bth_box8_ws; 
wire [7:0] Bth_box9_ws; 
wire [7:0] Bth_box10_ws;

          
wire [7:0] BckGndBuildTH_default_ws;
wire [7:0] BckGndBuildTH_box1_ws; 
wire [7:0] BckGndBuildTH_box2_ws; 
wire [7:0] BckGndBuildTH_box3_ws; 
wire [7:0] BckGndBuildTH_box4_ws; 
wire [7:0] BckGndBuildTH_box5_ws; 
wire [7:0] BckGndBuildTH_box6_ws; 
wire [7:0] BckGndBuildTH_box7_ws; 
wire [7:0] BckGndBuildTH_box8_ws; 
wire [7:0] BckGndBuildTH_box9_ws; 
wire [7:0] BckGndBuildTH_box10_ws ;


wire [63:0] DataIn_Seg;
wire [63:0] DataOut_Seg;
 
wire     [7:0]    color_0_in_w;
wire     [7:0]    color_1_in_w;
wire     [7:0]    color_2_in_w;
wire     [7:0]    color_3_in_w;
wire     [7:0]    color_4_in_w;
wire     [7:0]    color_5_in_w;
wire     [7:0]    color_6_in_w;
wire     [7:0]    color_7_in_w;
wire     [2:0]    write_which_in_w;
wire     [1:0]    compute_bu_in_w;
wire     [9:0]    start_position_x_in_w, width_in_w;
wire     [8:0]    start_position_y_in_w, height_in_w;
wire     [3:0]    accumulate_how_many_in_w;

wire     [7:0]    background_weight_0_in_w; 
wire     [7:0]    background_weight_1_in_w; 
wire     [7:0]    background_weight_2_in_w; 
wire     [7:0]    background_weight_3_in_w; 
wire     [7:0]    background_weight_4_in_w; 
wire     [7:0]    background_weight_5_in_w; 
wire     [7:0]    background_weight_6_in_w; 
wire     [7:0]    background_weight_7_in_w;
wire     [31:0]   diag_w;

wire     [9:0]    centerx_in_w;
wire     [8:0]    centery_in_w;
wire              controller_enable_w;
wire     [2:0]    iteration_times_w;
wire     [19:0]   total_target_histogram_y_w;
wire     [19:0]   total_target_histogram_u_w;
wire     [19:0]   total_target_histogram_v_w;
//wire              buffer_input_stop_w;
wire              use_background_color_or_not_w;
wire     [7:0]    background_weight_threshold_in_w;
wire     [15:0]   background_binvalue_threshold_in_w;
wire              reset_register_w;
wire              reset_buffer_w;
wire              CCA_stop_w; 
wire     [63:0]   CCA_D_in_w, CCA_I_in_w;
wire     [3:0]    Address_from_DMA_w;
wire     [63:0]   Data_from_DMA_w;
wire              WEAN_from_DMA_w;
wire     [47:0]   choose_reg_from_DMA_w;
wire     [3:0]    MUXA_from_DMA_w;

wire     [19:0]   total_candidate_histogram_Y_out_w;
wire     [19:0]   total_target_histogram_Y_out_w   ;
wire     [19:0]   total_candidate_histogram_U_out_w;
wire     [19:0]   total_target_histogram_U_out_w   ;
wire     [19:0]   total_candidate_histogram_V_out_w;
wire     [19:0]   total_target_histogram_V_out_w   ;

wire              mask_on_or_not_w;
wire     [63:0]   mask_in_w;
reg               mask_on_or_not_r;
reg      [63:0]   mask_in_r;
wire     [6:0]    CCA_1_out_w;
wire     [6:0]    CCA_2_out_w;

reg      [7:0]    color_0_in_r;
reg      [7:0]    color_1_in_r;
reg      [7:0]    color_2_in_r;
reg      [7:0]    color_3_in_r;
reg      [7:0]    color_4_in_r;
reg      [7:0]    color_5_in_r;
reg      [7:0]    color_6_in_r;
reg      [7:0]    color_7_in_r;
reg      [2:0]    write_which_in_r;
reg      [1:0]    compute_bu_in_r;
reg      [9:0]    start_position_x_in_r, width_in_r;
reg      [8:0]    start_position_y_in_r, height_in_r;
reg      [3:0]    accumulate_how_many_in_r;

reg      [7:0]    background_weight_0_in_r; 
reg      [7:0]    background_weight_1_in_r; 
reg      [7:0]    background_weight_2_in_r; 
reg      [7:0]    background_weight_3_in_r; 
reg      [7:0]    background_weight_4_in_r; 
reg      [7:0]    background_weight_5_in_r; 
reg      [7:0]    background_weight_6_in_r; 
reg      [7:0]    background_weight_7_in_r;
reg      [31:0]   diag_r;

reg      [9:0]    centerx_in_r;
reg      [8:0]    centery_in_r;
reg               controller_enable_r;
reg      [2:0]    iteration_times_r;
reg      [19:0]   total_target_histogram_y_r;
reg      [19:0]   total_target_histogram_u_r;
reg      [19:0]   total_target_histogram_v_r;
//reg               buffer_input_stop_r;
reg               use_background_color_or_not_r;
reg      [7:0]    background_weight_threshold_in_r;
reg      [15:0]   background_binvalue_threshold_in_r;
reg               reset_register_r;
reg               reset_buffer_r;
reg               CCA_stop_r; 
reg      [63:0]   CCA_D_in_r, CCA_I_in_r;
reg      [3:0]    Address_from_DMA_r;
reg      [63:0]   Data_from_DMA_r;
reg               WEAN_from_DMA_r;
reg      [47:0]   choose_reg_from_DMA_r;
reg      [3:0]    MUXA_from_DMA_r;

reg      [5:0]    choose_reg_from_DMA_i_r;

wire     [63:0]   Data_to_DMA_w;
wire     [63:0]   distanceY_w;
wire     [63:0]   distanceU_w;
wire     [63:0]   distanceV_w;
wire              done_w;    
wire              histogram_accumulation_done_w;


reg      [63:0]   OI_Data_64bit_r;      
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

wire     [63:0]   OI_Data_64bit_w;      
wire     [7:0]    o0_label_w;           
wire     [7:0]    o1_label_w;           
wire     [7:0]    o2_label_w;           
wire     [7:0]    o3_label_w;           
wire     [7:0]    o4_label_w;           
wire     [7:0]    o5_label_w;           
wire     [7:0]    o6_label_w;           
wire     [7:0]    o7_label_w;           
wire     [7:0]    o8_label_w;           
wire     [7:0]    o9_label_w; 

wire     [9:0]    o0_x_min_w;
wire     [9:0]    o0_x_max_w;
wire     [9:0]    o1_x_min_w;
wire     [9:0]    o1_x_max_w;
wire     [9:0]    o2_x_min_w;
wire     [9:0]    o2_x_max_w;
wire     [9:0]    o3_x_min_w;
wire     [9:0]    o3_x_max_w;
wire     [9:0]    o4_x_min_w;
wire     [9:0]    o4_x_max_w;
wire     [9:0]    o5_x_min_w;
wire     [9:0]    o5_x_max_w;
wire     [9:0]    o6_x_min_w;
wire     [9:0]    o6_x_max_w;
wire     [9:0]    o7_x_min_w;
wire     [9:0]    o7_x_max_w;
wire     [9:0]    o8_x_min_w;
wire     [9:0]    o8_x_max_w;
wire     [9:0]    o9_x_min_w;
wire     [9:0]    o9_x_max_w;

wire     [8:0]    o0_y_min_w;
wire     [8:0]    o0_y_max_w;
wire     [8:0]    o1_y_min_w;
wire     [8:0]    o1_y_max_w;
wire     [8:0]    o2_y_min_w;
wire     [8:0]    o2_y_max_w;
wire     [8:0]    o3_y_min_w;
wire     [8:0]    o3_y_max_w;
wire     [8:0]    o4_y_min_w;
wire     [8:0]    o4_y_max_w;
wire     [8:0]    o5_y_min_w;
wire     [8:0]    o5_y_max_w;
wire     [8:0]    o6_y_min_w;
wire     [8:0]    o6_y_max_w;
wire     [8:0]    o7_y_min_w;
wire     [8:0]    o7_y_max_w;
wire     [8:0]    o8_y_min_w;
wire     [8:0]    o8_y_max_w;
wire     [8:0]    o9_y_min_w;
wire     [8:0]    o9_y_max_w;


wire  store_CCL_w;
reg   [6:0] CCL_reg_r   [0:19];
reg   [6:0] CCL_reg_w   [0:19];
reg   [4:0] count_CCL_w;
reg   [4:0] count_CCL_r;
reg         store_CCL_r;

wire  [0:19] mapping_array_1_w, mapping_array_2_w;



//reg      [63:0]   Data_to_DMA_r;
//reg      [63:0]   distanceY_r;
//reg      [63:0]   distanceU_r;
//reg      [63:0]   distanceV_r;
//reg               done_r;    
//reg               histogram_accumulation_done_r;


assign choose_reg_from_DMA_w[00] = (choose_reg_from_DMA_i_r == 6'd00 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[01] = (choose_reg_from_DMA_i_r == 6'd01 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[02] = (choose_reg_from_DMA_i_r == 6'd02 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[03] = (choose_reg_from_DMA_i_r == 6'd03 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[04] = (choose_reg_from_DMA_i_r == 6'd04 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[05] = (choose_reg_from_DMA_i_r == 6'd05 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[06] = (choose_reg_from_DMA_i_r == 6'd06 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[07] = (choose_reg_from_DMA_i_r == 6'd07 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[08] = (choose_reg_from_DMA_i_r == 6'd08 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[09] = (choose_reg_from_DMA_i_r == 6'd09 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[10] = (choose_reg_from_DMA_i_r == 6'd10 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[11] = (choose_reg_from_DMA_i_r == 6'd11 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[12] = (choose_reg_from_DMA_i_r == 6'd12 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[13] = (choose_reg_from_DMA_i_r == 6'd13 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[14] = (choose_reg_from_DMA_i_r == 6'd14 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[15] = (choose_reg_from_DMA_i_r == 6'd15 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[16] = (choose_reg_from_DMA_i_r == 6'd16 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[17] = (choose_reg_from_DMA_i_r == 6'd17 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[18] = (choose_reg_from_DMA_i_r == 6'd18 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[19] = (choose_reg_from_DMA_i_r == 6'd19 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[20] = (choose_reg_from_DMA_i_r == 6'd20 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[21] = (choose_reg_from_DMA_i_r == 6'd21 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[22] = (choose_reg_from_DMA_i_r == 6'd22 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[23] = (choose_reg_from_DMA_i_r == 6'd23 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[24] = (choose_reg_from_DMA_i_r == 6'd24 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[25] = (choose_reg_from_DMA_i_r == 6'd25 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[26] = (choose_reg_from_DMA_i_r == 6'd26 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[27] = (choose_reg_from_DMA_i_r == 6'd27 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[28] = (choose_reg_from_DMA_i_r == 6'd28 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[29] = (choose_reg_from_DMA_i_r == 6'd29 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[30] = (choose_reg_from_DMA_i_r == 6'd30 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[31] = (choose_reg_from_DMA_i_r == 6'd31 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[32] = (choose_reg_from_DMA_i_r == 6'd32 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[33] = (choose_reg_from_DMA_i_r == 6'd33 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[34] = (choose_reg_from_DMA_i_r == 6'd34 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[35] = (choose_reg_from_DMA_i_r == 6'd35 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[36] = (choose_reg_from_DMA_i_r == 6'd36 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[37] = (choose_reg_from_DMA_i_r == 6'd37 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[38] = (choose_reg_from_DMA_i_r == 6'd38 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[39] = (choose_reg_from_DMA_i_r == 6'd39 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[40] = (choose_reg_from_DMA_i_r == 6'd40 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[41] = (choose_reg_from_DMA_i_r == 6'd41 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[42] = (choose_reg_from_DMA_i_r == 6'd42 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[43] = (choose_reg_from_DMA_i_r == 6'd43 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[44] = (choose_reg_from_DMA_i_r == 6'd44 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[45] = (choose_reg_from_DMA_i_r == 6'd45 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[46] = (choose_reg_from_DMA_i_r == 6'd46 ) ? 1'b1 : 1'b0;
assign choose_reg_from_DMA_w[47] = (choose_reg_from_DMA_i_r == 6'd47 ) ? 1'b1 : 1'b0;














































/******************************************************************************************************************************/                                
/**************************************            Input Stage                *************************************************/
/******************************************************************************************************************************/                                
assign DataIn_ws = (stall)? DataIn_r : DataIn_i;
assign DataInReady_ws = (stall)? DataInReady_r : DataInReady_i;

assign ContextRegAddr_ws = (stall)? ContextRegAddr_r : ContextRegAddr_i;

//wire gclk = clk & ctrl_gateCLK;

always@(posedge clk or posedge reset)
begin
      if(reset)
      begin
         DataIn_r <=64'd0;
         DataInReady_r <=1'b0;
         
         ContextRegAddr_r <= 8'd0;
         choose_reg_from_DMA_i_r <= 6'd0;
         
      end
      else if(ctrl_gateCLK)
      begin
         DataIn_r <= DataIn_ws ;
         DataInReady_r <=DataInReady_ws ;
         
         ContextRegAddr_r <=ContextRegAddr_ws ;
         choose_reg_from_DMA_i_r <= choose_reg_from_DMA_i;
      end
end







/******************************************************************************************************************************/                                
/**************************************            Output Stage                *************************************************/
/******************************************************************************************************************************/                                


//assign DataOut_w = (Mode_r == `SEGMENTATION_MODE)? DataOut_Seg:
                                                   //64'd0;

always@(*)
begin
   if(Mode_r == `SEGMENTATION_MODE)
   begin
      DataOut_w = DataOut_Seg;
   end
   else if(Mode_r == `ACCUMULATION_CANDIDATE_HISTOGRAM || Mode_r == `ACCUMULATION_TARGET_HISTOGRAM || Mode_r == `ACCUMULATION_CANDIDATE_BACKGROUND_HISTOGRAM || Mode_r == `ACCUMULATION_TARGET_BACKGROUND_HISTOGRAM)
   begin    
      if(ContextRegAddr_r == 8'd137) DataOut_w = {4'd0, total_candidate_histogram_Y_out_w, total_candidate_histogram_U_out_w, total_candidate_histogram_V_out_w};
      else DataOut_w = {4'd0, total_target_histogram_Y_out_w, total_target_histogram_U_out_w, total_target_histogram_V_out_w};
   end
   else if(Mode_r == `COMPUTE_DISTANCE)
   begin
      if(ContextRegAddr_r == 8'd121)
      begin
         DataOut_w = distanceY_w;
      end
      else if(ContextRegAddr_r == 8'd122)
      begin
         DataOut_w = distanceU_w;
      end
      else if(ContextRegAddr_r == 8'd123)
      begin
         DataOut_w = distanceV_w;
      end
      else
      begin
         DataOut_w = DataOut_r;
      end
   end
   else if(Mode_r == `SAVE_LOAD_FROM_DMA)
   begin
      DataOut_w = Data_to_DMA_w;
   end
   else if(Mode_r == `OBJECT_INFO_RSPE)
   begin
      case(ContextRegAddr_r)
         8'd127:  DataOut_w = {6'd0, o0_x_min_w, 6'd0, o0_x_max_w, 7'd0, o0_y_min_w , 7'd0, o0_y_max_w};
         8'd128:  DataOut_w = {6'd0, o1_x_min_w, 6'd0, o1_x_max_w, 7'd0, o1_y_min_w , 7'd0, o1_y_max_w};
         8'd129:  DataOut_w = {6'd0, o2_x_min_w, 6'd0, o2_x_max_w, 7'd0, o2_y_min_w , 7'd0, o2_y_max_w};
         8'd130:  DataOut_w = {6'd0, o3_x_min_w, 6'd0, o3_x_max_w, 7'd0, o3_y_min_w , 7'd0, o3_y_max_w};
         8'd131:  DataOut_w = {6'd0, o4_x_min_w, 6'd0, o4_x_max_w, 7'd0, o4_y_min_w , 7'd0, o4_y_max_w};
         8'd132:  DataOut_w = {6'd0, o5_x_min_w, 6'd0, o5_x_max_w, 7'd0, o5_y_min_w , 7'd0, o5_y_max_w};
         8'd133:  DataOut_w = {6'd0, o6_x_min_w, 6'd0, o6_x_max_w, 7'd0, o6_y_min_w , 7'd0, o6_y_max_w};
         8'd134:  DataOut_w = {6'd0, o7_x_min_w, 6'd0, o7_x_max_w, 7'd0, o7_y_min_w , 7'd0, o7_y_max_w};
         8'd135:  DataOut_w = {6'd0, o8_x_min_w, 6'd0, o8_x_max_w, 7'd0, o8_y_min_w , 7'd0, o8_y_max_w};
         8'd136:  DataOut_w = {6'd0, o9_x_min_w, 6'd0, o9_x_max_w, 7'd0, o9_y_min_w , 7'd0, o9_y_max_w};
         default: DataOut_w = DataOut_r;
      endcase
   end
   else if(Mode_r == `CONNECT_COMPONENT_ANALYSIS)
   begin
      case(ContextRegAddr_r)
         8'd140:  DataOut_w = {57'd0,CCL_reg_r[00]};
         8'd141:  DataOut_w = {57'd0,CCL_reg_r[01]};
         8'd142:  DataOut_w = {57'd0,CCL_reg_r[02]};
         8'd143:  DataOut_w = {57'd0,CCL_reg_r[03]};
         8'd144:  DataOut_w = {57'd0,CCL_reg_r[04]};
         8'd145:  DataOut_w = {57'd0,CCL_reg_r[05]};
         8'd146:  DataOut_w = {57'd0,CCL_reg_r[06]};
         8'd147:  DataOut_w = {57'd0,CCL_reg_r[07]};
         8'd148:  DataOut_w = {57'd0,CCL_reg_r[08]};
         8'd149:  DataOut_w = {57'd0,CCL_reg_r[09]};
         8'd150:  DataOut_w = {57'd0,CCL_reg_r[10]};
         8'd151:  DataOut_w = {57'd0,CCL_reg_r[11]};
         8'd152:  DataOut_w = {57'd0,CCL_reg_r[12]};
         8'd153:  DataOut_w = {57'd0,CCL_reg_r[13]};
         8'd154:  DataOut_w = {57'd0,CCL_reg_r[14]};
         8'd155:  DataOut_w = {57'd0,CCL_reg_r[15]};
         8'd156:  DataOut_w = {57'd0,CCL_reg_r[16]};
         8'd157:  DataOut_w = {57'd0,CCL_reg_r[17]};
         8'd158:  DataOut_w = {57'd0,CCL_reg_r[18]};
         8'd159:  DataOut_w = {57'd0,CCL_reg_r[19]};
         
         
         default: DataOut_w = DataOut_r;
      endcase
   end
   else
   begin
      DataOut_w = 64'd0;
   end
end


  
//assign DataOutReady_w = (Mode_r == `SEGMENTATION_MODE)? 1'b1:
//                                                   1'b0;

always@(*)
begin
   if(Mode_r == `SEGMENTATION_MODE)
   begin
      DataOutReady_w = 1'b1;
   end
   else if(Mode_r == `COMPUTE_DISTANCE)
   begin
      DataOutReady_w = done_w;
   end
   else if(Mode_r == `ACCUMULATION_CANDIDATE_HISTOGRAM || Mode_r == `ACCUMULATION_TARGET_HISTOGRAM || Mode_r == `ACCUMULATION_CANDIDATE_BACKGROUND_HISTOGRAM || Mode_r == `ACCUMULATION_TARGET_BACKGROUND_HISTOGRAM)
   begin
      DataOutReady_w = histogram_accumulation_done_w;
   end
   else
   begin
      DataOutReady_w = 1'b0;
   end
end


assign DataOut_ws = (stall)? DataOut_r : DataOut_w;
assign DataOutReady_ws = (stall)? DataOutReady_r : DataOutReady_w;

always@(posedge clk or posedge reset)
begin
      if(reset)
      begin
         DataOut_r <=64'd0;
         DataOutReady_r <=1'b0;
         WREN_r <= 1'b0;
      end
      else if(ctrl_gateCLK)
      begin
         DataOut_r <=DataOut_ws ;
         DataOutReady_r <=DataOutReady_ws ;
         WREN_r <= WREN_i;
      end
end


assign DataOut_o = DataOut_r;
assign DataOutReady_o =DataOutReady_r;           

   
   
   
/******************************************************************************************************************************/                                
/**************************************            Context Write              *************************************************/
/******************************************************************************************************************************/                                
always@(posedge clk or posedge reset)
begin
      if(reset)
      begin
         Mode_r                  <= 6'd0;
	      box1xmax_r             <= 12'd0; 
	      box2xmax_r             <= 12'd0; 
	      box3xmax_r             <= 12'd0; 
	      box4xmax_r             <= 12'd0; 
	      box5xmax_r             <= 12'd0; 
	      box6xmax_r             <= 12'd0; 
	      box7xmax_r             <= 12'd0; 
	      box8xmax_r             <= 12'd0; 
	      box9xmax_r             <= 12'd0; 
	      box10xmax_r            <= 12'd0;
	      
	      box1ymax_r             <= 12'd0; 
	      box2ymax_r             <= 12'd0; 
	      box3ymax_r             <= 12'd0; 
	      box4ymax_r             <= 12'd0; 
	      box5ymax_r             <= 12'd0; 
	      box6ymax_r             <= 12'd0; 
	      box7ymax_r             <= 12'd0; 
	      box8ymax_r             <= 12'd0; 
	      box9ymax_r             <= 12'd0; 
	      box10ymax_r            <= 12'd0;
	                             
	      box1xmin_r             <= 12'd0; 
	      box2xmin_r             <= 12'd0; 
	      box3xmin_r             <= 12'd0; 
	      box4xmin_r             <= 12'd0; 
	      box5xmin_r             <= 12'd0; 
	      box6xmin_r             <= 12'd0; 
	      box7xmin_r             <= 12'd0; 
	      box8xmin_r             <= 12'd0; 
	      box9xmin_r             <= 12'd0; 
	      box10xmin_r            <= 12'd0;
	                             
	      box1ymin_r             <= 12'd0; 
	      box2ymin_r             <= 12'd0; 
	      box3ymin_r             <= 12'd0; 
	      box4ymin_r             <= 12'd0; 
	      box5ymin_r             <= 12'd0; 
	      box6ymin_r             <= 12'd0; 
	      box7ymin_r             <= 12'd0; 
	      box8ymin_r             <= 12'd0; 
	      box9ymin_r             <= 12'd0; 
	      box10ymin_r            <= 12'd0;
	                        
	      BDthY_default_r         <= 8'd0;
	      BDthY_box1_r            <= 8'd0; 
	      BDthY_box2_r            <= 8'd0; 
	      BDthY_box3_r            <= 8'd0; 
	      BDthY_box4_r            <= 8'd0; 
	      BDthY_box5_r            <= 8'd0; 
	      BDthY_box6_r            <= 8'd0; 
	      BDthY_box7_r            <= 8'd0; 
	      BDthY_box8_r            <= 8'd0; 
	      BDthY_box9_r            <= 8'd0; 
	      BDthY_box10_r           <= 8'd0;
	      
	      BDthU_default_r         <= 8'd0; 
	      BDthU_box1_r            <= 8'd0; 
	      BDthU_box2_r            <= 8'd0; 
	      BDthU_box3_r            <= 8'd0; 
	      BDthU_box4_r            <= 8'd0; 
	      BDthU_box5_r            <= 8'd0; 
	      BDthU_box6_r            <= 8'd0; 
	      BDthU_box7_r            <= 8'd0; 
	      BDthU_box8_r            <= 8'd0; 
	      BDthU_box9_r            <= 8'd0; 
	      BDthU_box10_r           <= 8'd0;
	      
	      BDthV_default_r         <= 8'd0;        
	      BDthV_box1_r            <= 8'd0;      
	      BDthV_box2_r            <= 8'd0;      
	      BDthV_box3_r            <= 8'd0;      
	      BDthV_box4_r            <= 8'd0;      
	      BDthV_box5_r            <= 8'd0;      
	      BDthV_box6_r            <= 8'd0;      
	      BDthV_box7_r            <= 8'd0;      
	      BDthV_box8_r            <= 8'd0;      
	      BDthV_box9_r            <= 8'd0;      
	      BDthV_box10_r           <= 8'd0;     
	      
	      update_box1_r           <= 1'b0; 
	      update_box2_r           <= 1'b0; 
	      update_box3_r           <= 1'b0; 
	      update_box4_r           <= 1'b0; 
	      update_box5_r           <= 1'b0; 
	      update_box6_r           <= 1'b0; 
	      update_box7_r           <= 1'b0; 
	      update_box8_r           <= 1'b0; 
	      update_box9_r           <= 1'b0; 
	      update_box10_r          <= 1'b0;
	                                         
	      Bth_default_r           <= 8'd0;
	      Bth_box1_r              <= 8'd0; 
	      Bth_box2_r              <= 8'd0; 
	      Bth_box3_r              <= 8'd0; 
	      Bth_box4_r              <= 8'd0; 
	      Bth_box5_r              <= 8'd0; 
	      Bth_box6_r              <= 8'd0; 
	      Bth_box7_r              <= 8'd0; 
	      Bth_box8_r              <= 8'd0; 
	      Bth_box9_r              <= 8'd0; 
	      Bth_box10_r             <= 8'd0;
	      
	                
	      BckGndBuildTH_default_r <= 8'd0;
	      BckGndBuildTH_box1_r    <= 8'd0; 
	      BckGndBuildTH_box2_r    <= 8'd0; 
	      BckGndBuildTH_box3_r    <= 8'd0; 
	      BckGndBuildTH_box4_r    <= 8'd0; 
	      BckGndBuildTH_box5_r    <= 8'd0; 
	      BckGndBuildTH_box6_r    <= 8'd0; 
	      BckGndBuildTH_box7_r    <= 8'd0; 
	      BckGndBuildTH_box8_r    <= 8'd0; 
	      BckGndBuildTH_box9_r    <= 8'd0; 
	      BckGndBuildTH_box10_r   <= 8'd0;
	      
	      color_0_in_r <= 8'd0;                      
	      color_1_in_r <= 8'd0;                      
	      color_2_in_r <= 8'd0;                      
	      color_3_in_r <= 8'd0;                      
	      color_4_in_r <= 8'd0;                      
	      color_5_in_r <= 8'd0;                      
	      color_6_in_r <= 8'd0;                      
	      color_7_in_r <= 8'd0;                      
	      write_which_in_r <= 3'd0;                  
	      compute_bu_in_r <= 2'd0;
	      start_position_x_in_r <= 10'd0;
	      width_in_r <= 10'd0; 
	      start_position_y_in_r <= 9'd0;
	      height_in_r <= 9'd0;
	      accumulate_how_many_in_r <= 4'd0;          
	                                         
	      background_weight_0_in_r <= 8'd0;          
	      background_weight_1_in_r <= 8'd0;          
	      background_weight_2_in_r <= 8'd0;          
	      background_weight_3_in_r <= 8'd0;          
	      background_weight_4_in_r <= 8'd0;          
	      background_weight_5_in_r <= 8'd0;          
	      background_weight_6_in_r <= 8'd0;          
	      background_weight_7_in_r <= 8'd0;          
	      diag_r <= 32'd0;                            
	                                         
	      centerx_in_r <= 10'd0;                      
	      centery_in_r <= 9'd0;                      
	      controller_enable_r <= 1'b0;            
	      iteration_times_r <= 3'd0;                 
	      total_target_histogram_y_r <= 20'd0;        
	      total_target_histogram_u_r <= 20'd0;        
	      total_target_histogram_v_r <= 20'd0;        
	      //buffer_input_stop_r <= 1'b0;               
	      use_background_color_or_not_r <= 1'b0;     
	      background_weight_threshold_in_r <= 8'd0;  
	      background_binvalue_threshold_in_r <= 16'd0;
	      reset_register_r <= 1'b0;                  
	      reset_buffer_r <= 1'b0;                    
	      CCA_stop_r <= 1'b0;                        
	      CCA_D_in_r <= 64'd0;
	      CCA_I_in_r <= 64'd0;            
	      Address_from_DMA_r <= 4'd0;               
	      Data_from_DMA_r <= 64'd0;                   
	      WEAN_from_DMA_r <= 1'b0;                   
	      choose_reg_from_DMA_r <= 48'd0;            
	      MUXA_from_DMA_r <= 4'd0;                   
	      OI_Data_64bit_r <= 64'd0;
	      o0_label_r <= 8'd0;      
	      o1_label_r <= 8'd0;      
	      o2_label_r <= 8'd0;      
	      o3_label_r <= 8'd0;      
	      o4_label_r <= 8'd0;      
	      o5_label_r <= 8'd0;      
	      o6_label_r <= 8'd0;      
	      o7_label_r <= 8'd0;      
	      o8_label_r <= 8'd0;      
	      o9_label_r <= 8'd0;   
	      mask_on_or_not_r <= 1'b0;
	      mask_in_r <= 64'd0;
	      MASK_input_stop_r <= 1'b0;
	 
	 
	 
      end
      else if(ctrl_gateCLK)
      begin
         Mode_r                  <=  Mode_ws            ;    
	      box1xmax_r             <=   box1xmax_ws        ;    
	      box2xmax_r             <=   box2xmax_ws        ;    
	      box3xmax_r             <=   box3xmax_ws        ;    
	      box4xmax_r             <=   box4xmax_ws        ;    
	      box5xmax_r             <=   box5xmax_ws        ;    
	      box6xmax_r             <=   box6xmax_ws        ;    
	      box7xmax_r             <=   box7xmax_ws        ;    
	      box8xmax_r             <=   box8xmax_ws        ;    
	      box9xmax_r             <=   box9xmax_ws        ;    
	      box10xmax_r            <=   box10xmax_ws       ;    
	                                                        
	      box1ymax_r             <=   box1ymax_ws         ;   
	      box2ymax_r             <=   box2ymax_ws         ;   
	      box3ymax_r             <=   box3ymax_ws         ;   
	      box4ymax_r             <=   box4ymax_ws         ;   
	      box5ymax_r             <=   box5ymax_ws         ;   
	      box6ymax_r             <=   box6ymax_ws         ;   
	      box7ymax_r             <=   box7ymax_ws         ;   
	      box8ymax_r             <=   box8ymax_ws         ;   
	      box9ymax_r             <=   box9ymax_ws         ;   
	      box10ymax_r            <=   box10ymax_ws        ;   
	                                                        
	      box1xmin_r             <=   box1xmin_ws          ;  
	      box2xmin_r             <=   box2xmin_ws          ;  
	      box3xmin_r             <=   box3xmin_ws          ;  
	      box4xmin_r             <=   box4xmin_ws          ;  
	      box5xmin_r             <=   box5xmin_ws          ;  
	      box6xmin_r             <=   box6xmin_ws          ;  
	      box7xmin_r             <=   box7xmin_ws          ;  
	      box8xmin_r             <=   box8xmin_ws          ;  
	      box9xmin_r             <=   box9xmin_ws          ;  
	      box10xmin_r            <=   box10xmin_ws         ;  
	                                                        
	      box1ymin_r             <=   box1ymin_ws          ; 
	      box2ymin_r             <=   box2ymin_ws          ; 
	      box3ymin_r             <=   box3ymin_ws          ; 
	      box4ymin_r             <=   box4ymin_ws          ; 
	      box5ymin_r             <=   box5ymin_ws          ; 
	      box6ymin_r             <=   box6ymin_ws          ; 
	      box7ymin_r             <=   box7ymin_ws          ; 
	      box8ymin_r             <=   box8ymin_ws          ; 
	      box9ymin_r             <=   box9ymin_ws          ; 
	      box10ymin_r            <=   box10ymin_ws         ; 
	                                                   
	      BDthY_default_r         <=  BDthY_default_ws     ;   
	      BDthY_box1_r            <=  BDthY_box1_ws        ;   
	      BDthY_box2_r            <=  BDthY_box2_ws        ;   
	      BDthY_box3_r            <=  BDthY_box3_ws        ;   
	      BDthY_box4_r            <=  BDthY_box4_ws        ;   
	      BDthY_box5_r            <=  BDthY_box5_ws        ;   
	      BDthY_box6_r            <=  BDthY_box6_ws        ;   
	      BDthY_box7_r            <=  BDthY_box7_ws        ;   
	      BDthY_box8_r            <=  BDthY_box8_ws        ;   
	      BDthY_box9_r            <=  BDthY_box9_ws        ;   
	      BDthY_box10_r           <=  BDthY_box10_ws       ;   
	                                                         
	      BDthU_default_r         <=  BDthU_default_ws     ;   
	      BDthU_box1_r            <=  BDthU_box1_ws        ;   
	      BDthU_box2_r            <=  BDthU_box2_ws        ;   
	      BDthU_box3_r            <=  BDthU_box3_ws        ;   
	      BDthU_box4_r            <=  BDthU_box4_ws        ;   
	      BDthU_box5_r            <=  BDthU_box5_ws        ;   
	      BDthU_box6_r            <=  BDthU_box6_ws        ;   
	      BDthU_box7_r            <=  BDthU_box7_ws        ;   
	      BDthU_box8_r            <=  BDthU_box8_ws        ;   
	      BDthU_box9_r            <=  BDthU_box9_ws        ;   
	      BDthU_box10_r           <=  BDthU_box10_ws       ;   
	                                                         
	      BDthV_default_r         <=  BDthV_default_ws     ;   
	      BDthV_box1_r            <=  BDthV_box1_ws        ;   
	      BDthV_box2_r            <=  BDthV_box2_ws        ;   
	      BDthV_box3_r            <=  BDthV_box3_ws        ;   
	      BDthV_box4_r            <=  BDthV_box4_ws        ;   
	      BDthV_box5_r            <=  BDthV_box5_ws        ;   
	      BDthV_box6_r            <=  BDthV_box6_ws        ;   
	      BDthV_box7_r            <=  BDthV_box7_ws        ;   
	      BDthV_box8_r            <=  BDthV_box8_ws        ;   
	      BDthV_box9_r            <=  BDthV_box9_ws        ;   
	      BDthV_box10_r           <=  BDthV_box10_ws       ;   
	                                                         
	      update_box1_r           <=  update_box1_ws        ;  
	      update_box2_r           <=  update_box2_ws        ;  
	      update_box3_r           <=  update_box3_ws        ;  
	      update_box4_r           <=  update_box4_ws        ;  
	      update_box5_r           <=  update_box5_ws        ;  
	      update_box6_r           <=  update_box6_ws        ;  
	      update_box7_r           <=  update_box7_ws        ;  
	      update_box8_r           <=  update_box8_ws        ;  
	      update_box9_r           <=  update_box9_ws        ;  
	      update_box10_r          <=  update_box10_ws       ;  
	                                                         
	      Bth_default_r           <=  Bth_default_ws        ; 
	      Bth_box1_r              <=  Bth_box1_ws           ; 
	      Bth_box2_r              <=  Bth_box2_ws           ; 
	      Bth_box3_r              <=  Bth_box3_ws           ; 
	      Bth_box4_r              <=  Bth_box4_ws           ; 
	      Bth_box5_r              <=  Bth_box5_ws           ; 
	      Bth_box6_r              <=  Bth_box6_ws           ; 
	      Bth_box7_r              <=  Bth_box7_ws           ; 
	      Bth_box8_r              <=  Bth_box8_ws           ; 
	      Bth_box9_r              <=  Bth_box9_ws           ; 
	      Bth_box10_r             <=  Bth_box10_ws         ; 
	                                                         
	                                                         
	      BckGndBuildTH_default_r <=  BckGndBuildTH_default_ws;
	      BckGndBuildTH_box1_r    <=  BckGndBuildTH_box1_ws   ;
	      BckGndBuildTH_box2_r    <=  BckGndBuildTH_box2_ws   ;
	      BckGndBuildTH_box3_r    <=  BckGndBuildTH_box3_ws   ;
	      BckGndBuildTH_box4_r    <=  BckGndBuildTH_box4_ws   ;
	      BckGndBuildTH_box5_r    <=  BckGndBuildTH_box5_ws   ;
	      BckGndBuildTH_box6_r    <=  BckGndBuildTH_box6_ws   ;
	      BckGndBuildTH_box7_r    <=  BckGndBuildTH_box7_ws   ;
	      BckGndBuildTH_box8_r    <=  BckGndBuildTH_box8_ws   ;
	      BckGndBuildTH_box9_r    <=  BckGndBuildTH_box9_ws   ;
	      BckGndBuildTH_box10_r   <=  BckGndBuildTH_box10_ws  ;
	      
	      
	      color_0_in_r <= color_0_in_w;                      
	      color_1_in_r <= color_1_in_w;                      
	      color_2_in_r <= color_2_in_w;                      
	      color_3_in_r <= color_3_in_w;                      
	      color_4_in_r <= color_4_in_w;                      
	      color_5_in_r <= color_5_in_w;                      
	      color_6_in_r <= color_6_in_w;                      
	      color_7_in_r <= color_7_in_w;                      
	      write_which_in_r <= write_which_in_w;                  
	      compute_bu_in_r <= compute_bu_in_w;
	      start_position_x_in_r <= start_position_x_in_w;
	      width_in_r <= width_in_w; 
	      start_position_y_in_r <= start_position_y_in_w;
	      height_in_r <= height_in_w;
	      accumulate_how_many_in_r <= accumulate_how_many_in_w;          
	                                                            
	      background_weight_0_in_r <= background_weight_0_in_w;          
	      background_weight_1_in_r <= background_weight_1_in_w;          
	      background_weight_2_in_r <= background_weight_2_in_w;          
	      background_weight_3_in_r <= background_weight_3_in_w;          
	      background_weight_4_in_r <= background_weight_4_in_w;          
	      background_weight_5_in_r <= background_weight_5_in_w;          
	      background_weight_6_in_r <= background_weight_6_in_w;          
	      background_weight_7_in_r <= background_weight_7_in_w;          
	      diag_r <= diag_w;
	                                         
	      centerx_in_r <= centerx_in_w; 
	      centery_in_r <= centery_in_w; 
	      controller_enable_r <= controller_enable_w;
	      iteration_times_r <= iteration_times_w;
	      total_target_histogram_y_r <= total_target_histogram_y_w;        
	      total_target_histogram_u_r <= total_target_histogram_u_w;        
	      total_target_histogram_v_r <= total_target_histogram_v_w;        
	      //buffer_input_stop_r <= buffer_input_stop_w;
	      use_background_color_or_not_r <= use_background_color_or_not_w;
	      background_weight_threshold_in_r <= background_weight_threshold_in_w;
	      background_binvalue_threshold_in_r <= background_binvalue_threshold_in_w;
	      reset_register_r <= reset_register_w;
	      reset_buffer_r <= reset_buffer_w;
	      CCA_stop_r <= CCA_stop_w;
	      CCA_D_in_r <= CCA_D_in_w;
	      CCA_I_in_r <= CCA_I_in_w;
	      Address_from_DMA_r <= Address_from_DMA_w;
	      Data_from_DMA_r <= Data_from_DMA_w;  
	      WEAN_from_DMA_r <= WEAN_from_DMA_w;
	      choose_reg_from_DMA_r <= choose_reg_from_DMA_w;
	      MUXA_from_DMA_r <= MUXA_from_DMA_w;
	      
	      OI_Data_64bit_r <= OI_Data_64bit_w; 
	      o0_label_r <= o0_label_w;      
	      o1_label_r <= o1_label_w;      
	      o2_label_r <= o2_label_w;      
	      o3_label_r <= o3_label_w;      
	      o4_label_r <= o4_label_w;      
	      o5_label_r <= o5_label_w;      
	      o6_label_r <= o6_label_w;      
	      o7_label_r <= o7_label_w;      
	      o8_label_r <= o8_label_w;      
	      o9_label_r <= o9_label_w;      
	      
	      mask_on_or_not_r <= mask_on_or_not_w;
	      mask_in_r <= mask_in_w;
	      MASK_input_stop_r <= MASK_input_stop_w;
                                                           
      end
end





assign Mode_ws     = ((ContextRegAddr_r == 8'd0) && (!stall) )?         DataIn_r[5:0] :                        
       					       			  Mode_r;                
assign box1xmax_ws = ((ContextRegAddr_r == 8'd1) && (!stall) )?         DataIn_r[11:0]:                        
       								  box1xmax_r;            
assign box2xmax_ws = ((ContextRegAddr_r == 8'd2) && (!stall) )?         DataIn_r[11:0]:                        
             		 						  box2xmax_r;            
assign box3xmax_ws = ((ContextRegAddr_r == 8'd3) && (!stall) )?         DataIn_r[11:0]:                        
                                                                            box3xmax_r;         
assign box4xmax_ws = ((ContextRegAddr_r == 8'd4) && (!stall) )?         DataIn_r[11:0]:                        
                                                                             box4xmax_r;         
assign box5xmax_ws = ((ContextRegAddr_r == 8'd5) && (!stall) )?         DataIn_r[11:0]:                        
                                                                            box5xmax_r ;        
assign box6xmax_ws = ((ContextRegAddr_r == 8'd6) && (!stall) )?         DataIn_r[11:0]:                        
                                                                              box6xmax_r ;        
assign box7xmax_ws = ((ContextRegAddr_r == 8'd7) && (!stall) )?         DataIn_r[11:0]:                        
                                                                             box7xmax_r ;        
assign box8xmax_ws = ((ContextRegAddr_r == 8'd8) && (!stall) )?         DataIn_r[11:0]:                        
                                                                              box8xmax_r ;        
assign box9xmax_ws = ((ContextRegAddr_r == 8'd9) && (!stall) )?         DataIn_r[11:0]:                        
                                                                            box9xmax_r ;        
assign box10xmax_ws= ((ContextRegAddr_r == 8'd10)&& (!stall) )?         DataIn_r[11:0]:                        
                                                                             box10xmax_r;        
                     


assign  box1ymax_ws = ((ContextRegAddr_r == 8'd11)&& (!stall) )?         DataIn_r  [11:0]:		             
                   	 	       				                        box1ymax_r; 
assign  box2ymax_ws = ((ContextRegAddr_r == 8'd12)&& (!stall) )?         DataIn_r  [11:0]:                                      
                   	 					                        box2ymax_r; 
assign  box3ymax_ws = ((ContextRegAddr_r == 8'd13)&& (!stall) )?         DataIn_r  [11:0]:                                      
                   	 					     	           box3ymax_r; 
assign  box4ymax_ws = ((ContextRegAddr_r == 8'd14)&& (!stall) )?         DataIn_r  [11:0]:                                      
                                                                                         box4ymax_r; 
assign  box5ymax_ws = ((ContextRegAddr_r == 8'd15)&& (!stall) )?         DataIn_r  [11:0]:                                      
                                                                                         box5ymax_r; 
assign  box6ymax_ws = ((ContextRegAddr_r == 8'd16)&& (!stall) )?         DataIn_r  [11:0]:                                      
                                                                                         box6ymax_r; 
assign  box7ymax_ws = ((ContextRegAddr_r == 8'd17)&& (!stall) )?         DataIn_r  [11:0]:                                      
                                                                                         box7ymax_r; 
assign  box8ymax_ws = ((ContextRegAddr_r == 8'd18)&& (!stall) )?         DataIn_r  [11:0]:                                      
                                                                                         box8ymax_r; 
assign  box9ymax_ws = ((ContextRegAddr_r == 8'd19)&& (!stall) )?         DataIn_r  [11:0]:                                      
                                                                                         box9ymax_r; 
assign  box10ymax_ws= ((ContextRegAddr_r == 8'd20)&& (!stall) )?         DataIn_r  [11:0]:                                      
                                                                                         box10ymax_r;           
                                                   

assign  box1xmin_ws   = ((ContextRegAddr_r == 8'd21)&& (!stall) )?         DataIn_r [11:0]:			      
                     	 	       				                         box1xmin_r; 
assign  box2xmin_ws   = ((ContextRegAddr_r == 8'd22)&& (!stall) )?         DataIn_r [11:0]:                                      
                     	 					                         box2xmin_r; 
assign  box3xmin_ws   = ((ContextRegAddr_r == 8'd23)&& (!stall) )?         DataIn_r [11:0]:                                      
                     	 					     	            box3xmin_r; 
assign  box4xmin_ws   = ((ContextRegAddr_r == 8'd24)&& (!stall) )?         DataIn_r [11:0]:                                      
                                                                                          box4xmin_r; 
assign  box5xmin_ws   = ((ContextRegAddr_r == 8'd25)&& (!stall) )?         DataIn_r [11:0]:                                      
                                                                                          box5xmin_r; 
assign  box6xmin_ws   = ((ContextRegAddr_r == 8'd26)&& (!stall) )?         DataIn_r [11:0]:                                      
                                                                                          box6xmin_r; 
assign  box7xmin_ws   = ((ContextRegAddr_r == 8'd27)&& (!stall) )?         DataIn_r [11:0]:                                      
                                                                                          box7xmin_r; 
assign  box8xmin_ws   = ((ContextRegAddr_r == 8'd28)&& (!stall) )?         DataIn_r [11:0]:                                      
                                                                                          box8xmin_r; 
assign  box9xmin_ws   = ((ContextRegAddr_r == 8'd29)&& (!stall) )?         DataIn_r [11:0]:                                      
                                                                                          box9xmin_r; 
assign  box10xmin_ws  = ((ContextRegAddr_r == 8'd30)&& (!stall) )?         DataIn_r [11:0]:                                      
                                                                                          box10xmin_r;   
                                                                            
                                                                             
                                                                             
                                                                             
                                                                             
                                                                                                     
assign  box1ymin_ws   = ((ContextRegAddr_r == 8'd31)&& (!stall) )?         DataIn_r [11:0]:                                      
                                                     	                            box1ymin_r; 
assign  box2ymin_ws   = ((ContextRegAddr_r == 8'd32)&& (!stall) )?         DataIn_r [11:0]:                                      
                     	 	       				                         box2ymin_r; 
assign  box3ymin_ws   = ((ContextRegAddr_r == 8'd33)&& (!stall) )?         DataIn_r [11:0]:                                      
                     	 					                         box3ymin_r; 
assign  box4ymin_ws   = ((ContextRegAddr_r == 8'd34)&& (!stall) )?         DataIn_r [11:0]:                                      
                     	 				             	            box4ymin_r; 
assign  box5ymin_ws   = ((ContextRegAddr_r == 8'd35)&& (!stall) )?         DataIn_r [11:0]:                                      
                                                                                          box5ymin_r; 
assign  box6ymin_ws   = ((ContextRegAddr_r == 8'd36)&& (!stall) )?         DataIn_r [11:0]:                                      
                                                                                          box6ymin_r; 
assign  box7ymin_ws   = ((ContextRegAddr_r == 8'd37)&& (!stall) )?         DataIn_r [11:0]:                                      
                                                                                          box7ymin_r; 
assign  box8ymin_ws   = ((ContextRegAddr_r == 8'd38)&& (!stall) )?         DataIn_r [11:0]:                                      
                                                                                          box8ymin_r; 
assign  box9ymin_ws   = ((ContextRegAddr_r == 8'd39)&& (!stall) )?         DataIn_r [11:0]:                                      
                                                                                          box9ymin_r; 
assign  box10ymin_ws  = ((ContextRegAddr_r == 8'd40)&& (!stall) )?         DataIn_r [11:0]:                                      
                                                                                          box10ymin_r;          
                                                    
                        
                        








assign BDthY_default_ws   =( (ContextRegAddr_r == 8'd41)&& (!stall) )?         DataIn_r [7:0]: 		          
                         	 	       		 	      	               BDthY_default_r; 
assign BDthY_box1_ws     = ((ContextRegAddr_r == 8'd42 )&& (!stall) )?         DataIn_r [7:0]:                                            
                         	 					                    BDthY_box1_r;    
assign BDthY_box2_ws      =( (ContextRegAddr_r == 8'd43)&& (!stall) )?         DataIn_r [7:0]:                                            
                         	 					     	       BDthY_box2_r;    
assign BDthY_box3_ws      =( (ContextRegAddr_r == 8'd44)&& (!stall) )?         DataIn_r [7:0]:                                            
                                                     	                                 BDthY_box3_r;    
assign BDthY_box4_ws      =( (ContextRegAddr_r == 8'd45)&& (!stall) )?         DataIn_r [7:0]:                                            
                                                                                              BDthY_box4_r;    
assign BDthY_box5_ws      =( (ContextRegAddr_r == 8'd46)&& (!stall) )?         DataIn_r [7:0]:                                            
                                                                                              BDthY_box5_r;    
assign BDthY_box6_ws      =( (ContextRegAddr_r == 8'd47)&& (!stall) )?         DataIn_r [7:0]:                                            
                                                                                              BDthY_box6_r;    
assign BDthY_box7_ws      =( (ContextRegAddr_r == 8'd48)&& (!stall) )?         DataIn_r [7:0]:                                            
                                                                                              BDthY_box7_r;    
assign BDthY_box8_ws      =( (ContextRegAddr_r == 8'd49)&& (!stall) )?         DataIn_r [7:0]:                                            
                                                                                            BDthY_box8_r;    
assign BDthY_box9_ws      =( (ContextRegAddr_r == 8'd50)&& (!stall) )?         DataIn_r [7:0]:                                            
                                                                                            BDthY_box9_r;    
assign BDthY_box10_ws     =( (ContextRegAddr_r == 8'd51)&& (!stall) )?         DataIn_r [7:0]:                                            
                                                                               BDthY_box10_r;   










assign BDthU_default_ws   = ((ContextRegAddr_r == 8'd52)&& (!stall) )?         DataIn_r [7:0] :                          
                         	 	       		 	                    BDthU_default_r; 
assign BDthU_box1_ws      = ((ContextRegAddr_r == 8'd53)&& (!stall) )?         DataIn_r [7:0] :                                           
                         	 			 	                    BDthU_box1_r;    
assign BDthU_box2_ws      = ((ContextRegAddr_r == 8'd54)&& (!stall) )?         DataIn_r [7:0] :                                           
                         	 					     	        BDthU_box2_r;    
assign BDthU_box3_ws      = ((ContextRegAddr_r == 8'd55)&& (!stall) )?         DataIn_r [7:0] :                                           
                                                                                               BDthU_box3_r;    
assign BDthU_box4_ws      = ((ContextRegAddr_r == 8'd56)&& (!stall) )?         DataIn_r [7:0] :                                           
                                                                                               BDthU_box4_r;    
assign BDthU_box5_ws      = ((ContextRegAddr_r == 8'd57)&& (!stall) )?         DataIn_r [7:0] :                                           
                                                                                               BDthU_box5_r;    
assign BDthU_box6_ws      = ((ContextRegAddr_r == 8'd58)&& (!stall) )?         DataIn_r [7:0] :                                           
                                                                                               BDthU_box6_r;    
assign BDthU_box7_ws      = ((ContextRegAddr_r == 8'd59)&& (!stall) )?         DataIn_r [7:0] :                                           
                                                                                               BDthU_box7_r;    
assign BDthU_box8_ws      = ((ContextRegAddr_r == 8'd60)&& (!stall) )?         DataIn_r [7:0] :                                           
                                                                                               BDthU_box8_r;    
assign BDthU_box9_ws      = ((ContextRegAddr_r == 8'd61)&& (!stall) )?         DataIn_r [7:0] :                                           
                                                                                       BDthU_box9_r;    
assign BDthU_box10_ws     = ((ContextRegAddr_r == 8'd62)&& (!stall) )?         DataIn_r [7:0] :                                           
                                                                                BDthU_box10_r;   







                                                                           
assign BDthV_default_ws   = ((ContextRegAddr_r == 8'd63)&& (!stall) )?         DataIn_r [7:0] :                          
                         	 	       		 	      	                BDthV_default_r; 
assign BDthV_box1_ws      = ((ContextRegAddr_r == 8'd64)&& (!stall) )?         DataIn_r [7:0] :                                           
                         	 			 	      	                BDthV_box1_r;    
assign BDthV_box2_ws      = ((ContextRegAddr_r == 8'd65)&& (!stall) )?         DataIn_r [7:0] :                                           
                         	 			 	      		        BDthV_box2_r;    
assign BDthV_box3_ws      = ((ContextRegAddr_r == 8'd66)&& (!stall) )?         DataIn_r [7:0] :                                           
                                                                                               BDthV_box3_r;    
assign BDthV_box4_ws      = ((ContextRegAddr_r == 8'd67)&& (!stall) )?         DataIn_r [7:0] :                                           
                                                                                               BDthV_box4_r;    
assign BDthV_box5_ws      = ((ContextRegAddr_r == 8'd68)&& (!stall) )?         DataIn_r [7:0] :                                           
                                                                                               BDthV_box5_r;    
assign BDthV_box6_ws      = ((ContextRegAddr_r == 8'd69)&& (!stall) )?         DataIn_r [7:0] :                                           
                                                                                               BDthV_box6_r;    
assign BDthV_box7_ws      = ((ContextRegAddr_r == 8'd70)&& (!stall) )?         DataIn_r [7:0] :                                           
                                                                                               BDthV_box7_r;    
assign BDthV_box8_ws      = ((ContextRegAddr_r == 8'd71)&& (!stall) )?         DataIn_r [7:0] :                                           
                                                                                               BDthV_box8_r;    
assign BDthV_box9_ws      = ((ContextRegAddr_r == 8'd72)&& (!stall) )?         DataIn_r [7:0] :                                           
                                                                                             BDthV_box9_r;    
assign BDthV_box10_ws     = ((ContextRegAddr_r == 8'd73)&& (!stall) )?         DataIn_r [7:0] :                                           
                                                                                BDthV_box10_r;   








assign update_box1_ws  = ((ContextRegAddr_r == 8'd74)&& (!stall) )?         DataIn_r[0]: 					       
                      		        			     	                update_box1_r;  
assign update_box2_ws  = ((ContextRegAddr_r == 8'd75)&& (!stall) )?         DataIn_r[0]:                                                         
                      		 				                     update_box2_r;  
assign update_box3_ws  = ((ContextRegAddr_r == 8'd76)&& (!stall) )?         DataIn_r[0]:                                                         
                      		 				       	      update_box3_r;  
assign update_box4_ws  = ((ContextRegAddr_r == 8'd77)&& (!stall) )?         DataIn_r[0]:                                                         
                                                                                     update_box4_r;  
assign update_box5_ws  = ((ContextRegAddr_r == 8'd78)&& (!stall) )?         DataIn_r[0]:                                                         
                                                                                     update_box5_r;  
assign update_box6_ws  = ((ContextRegAddr_r == 8'd79)&& (!stall) )?         DataIn_r[0]:                                                         
                                                                                     update_box6_r;   
assign update_box7_ws  = ((ContextRegAddr_r == 8'd80)&& (!stall) )?         DataIn_r[0]:                                                         
                                                                                     update_box7_r;   
assign update_box8_ws  = ((ContextRegAddr_r == 8'd81)&& (!stall) )?         DataIn_r[0]:                                                         
                                                                                     update_box8_r;   
assign update_box9_ws  = ((ContextRegAddr_r == 8'd82)&& (!stall) )?         DataIn_r[0]:                                                         
                                                                                     update_box9_r;   
assign update_box10_ws = ((ContextRegAddr_r == 8'd83)&& (!stall) )?         DataIn_r[0]:                                                         
                                                                                    update_box10_r; 
                                                     








assign  Bth_default_ws	=  ((ContextRegAddr_r == 8'd84)&& (!stall) )?         DataIn_r [7:0]	:		                 
                        	 	       			       	                 Bth_default_r;   
assign  Bth_box1_ws      = ((ContextRegAddr_r == 8'd85)&& (!stall) )?         DataIn_r [7:0]   :                                                 
                        	 				       	                 Bth_box1_r;      
assign  Bth_box2_ws      = ((ContextRegAddr_r == 8'd86)&& (!stall) )?         DataIn_r [7:0]   :                                                 
                        	 				       		         Bth_box2_r;      
assign  Bth_box3_ws      = ((ContextRegAddr_r == 8'd87)&& (!stall) )?         DataIn_r [7:0]   :                                                 
                                                                                                Bth_box3_r;      
assign  Bth_box4_ws      = ((ContextRegAddr_r == 8'd88)&& (!stall) )?         DataIn_r [7:0]   :                                                 
                                                                                                Bth_box4_r;      
assign  Bth_box5_ws      = ((ContextRegAddr_r == 8'd89)&& (!stall) )?         DataIn_r [7:0]   :                                                 
                                                                                                Bth_box5_r;      
assign  Bth_box6_ws      = ((ContextRegAddr_r == 8'd90)&& (!stall) )?         DataIn_r [7:0]   :                                                 
                                                                                                Bth_box6_r;      
assign  Bth_box7_ws      = ((ContextRegAddr_r == 8'd91)&& (!stall) )?         DataIn_r [7:0]   :                                                 
                                                                                                Bth_box7_r;      
assign  Bth_box8_ws      = ((ContextRegAddr_r == 8'd92)&& (!stall) )?         DataIn_r [7:0]   :                                                 
                                                                                                Bth_box8_r;      
assign  Bth_box9_ws      = ((ContextRegAddr_r == 8'd93)&& (!stall) )?         DataIn_r [7:0]   :                                                 
                                                                                              Bth_box9_r;      
assign  Bth_box10_ws     = ((ContextRegAddr_r == 8'd94)&& (!stall) )?         DataIn_r [7:0]   :                                                 
                                                                                 Bth_box10_r;             
                                                                                                          








assign  BckGndBuildTH_default_ws   = ((ContextRegAddr_r == 8'd95 )&& (!stall) )?         DataIn_r [7:0] :                       
                                  	 	       		   	       	                 BckGndBuildTH_default_r; 
assign  BckGndBuildTH_box1_ws      = ((ContextRegAddr_r == 8'd96 )&& (!stall) )?         DataIn_r [7:0] :                                                
                                  	 			   	       	                 BckGndBuildTH_box1_r;    
assign  BckGndBuildTH_box2_ws      = ((ContextRegAddr_r == 8'd97 )&& (!stall) )?         DataIn_r [7:0] :                                                
                                  	 			   	       		         BckGndBuildTH_box2_r;    
assign  BckGndBuildTH_box3_ws      = ((ContextRegAddr_r == 8'd98 )&& (!stall) )?         DataIn_r [7:0] :                                                
                                                                                                         BckGndBuildTH_box3_r;    
assign  BckGndBuildTH_box4_ws      = ((ContextRegAddr_r == 8'd99 )&& (!stall) )?         DataIn_r [7:0] :                                                
                                                                                                        BckGndBuildTH_box4_r;    
assign  BckGndBuildTH_box5_ws      = ((ContextRegAddr_r == 8'd100)&& (!stall) )?         DataIn_r [7:0] :                                                
                                                                                                        BckGndBuildTH_box5_r;    
assign  BckGndBuildTH_box6_ws      = ((ContextRegAddr_r == 8'd101)&& (!stall) )?         DataIn_r [7:0] :                                                
                                                                                                        BckGndBuildTH_box6_r;    
assign  BckGndBuildTH_box7_ws      = ((ContextRegAddr_r == 8'd102)&& (!stall) )?         DataIn_r [7:0] :                                                
                                                                                                        BckGndBuildTH_box7_r;    
assign  BckGndBuildTH_box8_ws      = ((ContextRegAddr_r == 8'd103)&& (!stall) )?         DataIn_r [7:0] :                                                
                                                                                                        BckGndBuildTH_box8_r;    
assign  BckGndBuildTH_box9_ws      = ((ContextRegAddr_r == 8'd104)&& (!stall) )?         DataIn_r [7:0] :                                                
                                                                                                      BckGndBuildTH_box9_r;    
assign  BckGndBuildTH_box10_ws     = ((ContextRegAddr_r == 8'd105)&& (!stall) )?         DataIn_r [7:0] :                                                
                                                                                         	      BckGndBuildTH_box10_r ;  



assign DataIn_Seg = DataIn_r;


assign color_0_in_w = (ContextRegAddr_r == 8'd106 && !stall)? DataIn_r[07:00]:color_0_in_r;                      
assign color_1_in_w = (ContextRegAddr_r == 8'd106 && !stall)? DataIn_r[15:08]:color_1_in_r;                      
assign color_2_in_w = (ContextRegAddr_r == 8'd106 && !stall)? DataIn_r[23:16]:color_2_in_r;                      
assign color_3_in_w = (ContextRegAddr_r == 8'd106 && !stall)? DataIn_r[31:24]:color_3_in_r;                      
assign color_4_in_w = (ContextRegAddr_r == 8'd106 && !stall)? DataIn_r[39:32]:color_4_in_r;                      
assign color_5_in_w = (ContextRegAddr_r == 8'd106 && !stall)? DataIn_r[47:40]:color_5_in_r;                      
assign color_6_in_w = (ContextRegAddr_r == 8'd106 && !stall)? DataIn_r[55:48]:color_6_in_r;                      
assign color_7_in_w = (ContextRegAddr_r == 8'd106 && !stall)? DataIn_r[63:56]:color_7_in_r;                      
assign write_which_in_w = (ContextRegAddr_r == 8'd107 && !stall)? DataIn_r[2:0] : write_which_in_r;
assign compute_bu_in_w = (ContextRegAddr_r == 8'd107 && !stall)? DataIn_r[4:3] : compute_bu_in_r;
assign start_position_x_in_w =(ContextRegAddr_r == 8'd108 && !stall)? DataIn_r[9:0] : start_position_x_in_r;
assign width_in_w = (ContextRegAddr_r == 8'd108 && !stall)? DataIn_r[19:10] : width_in_r; 
assign start_position_y_in_w = (ContextRegAddr_r == 8'd108 && !stall)? DataIn_r[28:20] : start_position_y_in_r;
assign height_in_w = (ContextRegAddr_r == 8'd108 && !stall)? DataIn_r[37:29] : height_in_r;
assign accumulate_how_many_in_w = (ContextRegAddr_r == 8'd109 && !stall)? DataIn_r[3:0] : accumulate_how_many_in_r;          
                                 
assign background_weight_0_in_w = (ContextRegAddr_r == 8'd110 && !stall)? DataIn_r[07:00]:background_weight_0_in_r;          
assign background_weight_1_in_w = (ContextRegAddr_r == 8'd110 && !stall)? DataIn_r[15:08]:background_weight_1_in_r;          
assign background_weight_2_in_w = (ContextRegAddr_r == 8'd110 && !stall)? DataIn_r[23:16]:background_weight_2_in_r;          
assign background_weight_3_in_w = (ContextRegAddr_r == 8'd110 && !stall)? DataIn_r[31:24]:background_weight_3_in_r;          
assign background_weight_4_in_w = (ContextRegAddr_r == 8'd110 && !stall)? DataIn_r[39:32]:background_weight_4_in_r;          
assign background_weight_5_in_w = (ContextRegAddr_r == 8'd110 && !stall)? DataIn_r[47:40]:background_weight_5_in_r;          
assign background_weight_6_in_w = (ContextRegAddr_r == 8'd110 && !stall)? DataIn_r[55:48]:background_weight_6_in_r;          
assign background_weight_7_in_w = (ContextRegAddr_r == 8'd110 && !stall)? DataIn_r[63:56]:background_weight_7_in_r;          
assign diag_w = (ContextRegAddr_r == 8'd111 && !stall)? DataIn_r[31:00]:diag_r;
                                   
assign centerx_in_w = (ContextRegAddr_r == 8'd112 && !stall)? DataIn_r[9:0]:centerx_in_r;                      
assign centery_in_w = (ContextRegAddr_r == 8'd113 && !stall)? DataIn_r[18:10]:centery_in_r;                      
assign controller_enable_w = ctrl_gateCLK;               
assign iteration_times_w = (ContextRegAddr_r == 8'd114 && !stall)? DataIn_r[2:0]:iteration_times_r;                 
assign total_target_histogram_y_w = (ContextRegAddr_r == 8'd115 && !stall)?DataIn_r[19:00] : total_target_histogram_y_r;        
assign total_target_histogram_u_w = (ContextRegAddr_r == 8'd115 && !stall)?DataIn_r[39:20] : total_target_histogram_u_r;        
assign total_target_histogram_v_w = (ContextRegAddr_r == 8'd115 && !stall)?DataIn_r[59:40] : total_target_histogram_v_r;        
//assign buffer_input_stop_w = buffer_input_stop_i;               
assign use_background_color_or_not_w = (ContextRegAddr_r == 8'd116 && !stall)?DataIn_r[0] : use_background_color_or_not_r;
assign mask_on_or_not_w = (ContextRegAddr_r == 8'd116 && !stall)?DataIn_r[1] : mask_on_or_not_r;

assign background_weight_threshold_in_w = (ContextRegAddr_r == 8'd117 && !stall)?DataIn_r[7:0] : background_weight_threshold_in_r;  
assign background_binvalue_threshold_in_w = (ContextRegAddr_r == 8'd117 && !stall)?DataIn_r[23:8] : background_binvalue_threshold_in_r;  
assign reset_register_w = reset_register_i;
assign reset_buffer_w = reset_buffer_i;
assign CCA_stop_w = buffer_input_stop_i;                        
assign CCA_D_in_w = (ContextRegAddr_r == 8'd118 && !stall)?DataIn_r : CCA_D_in_r;  
assign CCA_I_in_w = (ContextRegAddr_r == 8'd119 && !stall)?DataIn_r : CCA_I_in_r;
assign Address_from_DMA_w = Address_from_DMA_i;//(ContextRegAddr_r == 8'd120 && !stall)? DataIn_r[3:0] : Address_from_DMA_r;               
assign Data_from_DMA_w = (ContextRegAddr_r == 8'd120 && !stall)? DataIn_r : Data_from_DMA_r;                   
assign WEAN_from_DMA_w = WEAN_from_DMA_i;//(ContextRegAddr_r == 8'd122 && !stall)? DataIn_r[0] : WEAN_from_DMA_r;  
assign MUXA_from_DMA_w = MUXA_from_DMA_i;//(ContextRegAddr_r == 8'd123 && !stall)? DataIn_r[4:1] : MUXA_from_DMA_r;                  


assign OI_Data_64bit_w = (ContextRegAddr_r == 8'd124 && !stall)?DataIn_r : OI_Data_64bit_r;
assign o0_label_w = (ContextRegAddr_r == 8'd125 && !stall)?DataIn_r[07:00] : o0_label_r;
assign o1_label_w = (ContextRegAddr_r == 8'd125 && !stall)?DataIn_r[15:08] : o1_label_r;
assign o2_label_w = (ContextRegAddr_r == 8'd125 && !stall)?DataIn_r[23:16] : o2_label_r;
assign o3_label_w = (ContextRegAddr_r == 8'd125 && !stall)?DataIn_r[31:24] : o3_label_r;
assign o4_label_w = (ContextRegAddr_r == 8'd125 && !stall)?DataIn_r[39:32] : o4_label_r;
assign o5_label_w = (ContextRegAddr_r == 8'd125 && !stall)?DataIn_r[47:40] : o5_label_r;
assign o6_label_w = (ContextRegAddr_r == 8'd125 && !stall)?DataIn_r[55:48] : o6_label_r;
assign o7_label_w = (ContextRegAddr_r == 8'd125 && !stall)?DataIn_r[63:56] : o7_label_r;
assign o8_label_w = (ContextRegAddr_r == 8'd126 && !stall)?DataIn_r[07:00] : o8_label_r;
assign o9_label_w = (ContextRegAddr_r == 8'd126 && !stall)?DataIn_r[15:08] : o9_label_r;

assign mask_in_w = (ContextRegAddr_r == 8'd138 && !stall)?DataIn_r : mask_in_r;
assign MASK_input_stop_w = (ContextRegAddr_r == 8'd139 && !stall)?DataIn_r[0] : MASK_input_stop_r;




//*******************************************
//            CCL REGISTER STACK
//*******************************************


assign store_CCL_w = (ContextRegAddr_r == 8'd140 && !stall)?DataIn_r[0] : store_CCL_r;
reg   CCL_write_time_r;

assign mapping_array_1_w[00] = ((CCL_write_time_r == 1'b0) || (CCA_1_out_w == 7'd0) || (CCL_reg_r[00] == CCA_1_out_w && count_CCL_r >= 5'd00)) ? 1'b1 : 1'b0;
assign mapping_array_1_w[01] = ((CCL_write_time_r == 1'b0) || (CCA_1_out_w == 7'd0) || (CCL_reg_r[01] == CCA_1_out_w && count_CCL_r >= 5'd01)) ? 1'b1 : 1'b0;
assign mapping_array_1_w[02] = ((CCL_write_time_r == 1'b0) || (CCA_1_out_w == 7'd0) || (CCL_reg_r[02] == CCA_1_out_w && count_CCL_r >= 5'd02)) ? 1'b1 : 1'b0;
assign mapping_array_1_w[03] = ((CCL_write_time_r == 1'b0) || (CCA_1_out_w == 7'd0) || (CCL_reg_r[03] == CCA_1_out_w && count_CCL_r >= 5'd03)) ? 1'b1 : 1'b0;
assign mapping_array_1_w[04] = ((CCL_write_time_r == 1'b0) || (CCA_1_out_w == 7'd0) || (CCL_reg_r[04] == CCA_1_out_w && count_CCL_r >= 5'd04)) ? 1'b1 : 1'b0;
assign mapping_array_1_w[05] = ((CCL_write_time_r == 1'b0) || (CCA_1_out_w == 7'd0) || (CCL_reg_r[05] == CCA_1_out_w && count_CCL_r >= 5'd05)) ? 1'b1 : 1'b0;
assign mapping_array_1_w[06] = ((CCL_write_time_r == 1'b0) || (CCA_1_out_w == 7'd0) || (CCL_reg_r[06] == CCA_1_out_w && count_CCL_r >= 5'd06)) ? 1'b1 : 1'b0;
assign mapping_array_1_w[07] = ((CCL_write_time_r == 1'b0) || (CCA_1_out_w == 7'd0) || (CCL_reg_r[07] == CCA_1_out_w && count_CCL_r >= 5'd07)) ? 1'b1 : 1'b0;
assign mapping_array_1_w[08] = ((CCL_write_time_r == 1'b0) || (CCA_1_out_w == 7'd0) || (CCL_reg_r[08] == CCA_1_out_w && count_CCL_r >= 5'd08)) ? 1'b1 : 1'b0;
assign mapping_array_1_w[09] = ((CCL_write_time_r == 1'b0) || (CCA_1_out_w == 7'd0) || (CCL_reg_r[09] == CCA_1_out_w && count_CCL_r >= 5'd09)) ? 1'b1 : 1'b0;
assign mapping_array_1_w[10] = ((CCL_write_time_r == 1'b0) || (CCA_1_out_w == 7'd0) || (CCL_reg_r[10] == CCA_1_out_w && count_CCL_r >= 5'd10)) ? 1'b1 : 1'b0;
assign mapping_array_1_w[11] = ((CCL_write_time_r == 1'b0) || (CCA_1_out_w == 7'd0) || (CCL_reg_r[11] == CCA_1_out_w && count_CCL_r >= 5'd11)) ? 1'b1 : 1'b0;
assign mapping_array_1_w[12] = ((CCL_write_time_r == 1'b0) || (CCA_1_out_w == 7'd0) || (CCL_reg_r[12] == CCA_1_out_w && count_CCL_r >= 5'd12)) ? 1'b1 : 1'b0;
assign mapping_array_1_w[13] = ((CCL_write_time_r == 1'b0) || (CCA_1_out_w == 7'd0) || (CCL_reg_r[13] == CCA_1_out_w && count_CCL_r >= 5'd13)) ? 1'b1 : 1'b0;
assign mapping_array_1_w[14] = ((CCL_write_time_r == 1'b0) || (CCA_1_out_w == 7'd0) || (CCL_reg_r[14] == CCA_1_out_w && count_CCL_r >= 5'd14)) ? 1'b1 : 1'b0;
assign mapping_array_1_w[15] = ((CCL_write_time_r == 1'b0) || (CCA_1_out_w == 7'd0) || (CCL_reg_r[15] == CCA_1_out_w && count_CCL_r >= 5'd15)) ? 1'b1 : 1'b0;
assign mapping_array_1_w[16] = ((CCL_write_time_r == 1'b0) || (CCA_1_out_w == 7'd0) || (CCL_reg_r[16] == CCA_1_out_w && count_CCL_r >= 5'd16)) ? 1'b1 : 1'b0;
assign mapping_array_1_w[17] = ((CCL_write_time_r == 1'b0) || (CCA_1_out_w == 7'd0) || (CCL_reg_r[17] == CCA_1_out_w && count_CCL_r >= 5'd17)) ? 1'b1 : 1'b0;
assign mapping_array_1_w[18] = ((CCL_write_time_r == 1'b0) || (CCA_1_out_w == 7'd0) || (CCL_reg_r[18] == CCA_1_out_w && count_CCL_r >= 5'd18)) ? 1'b1 : 1'b0;
assign mapping_array_1_w[19] = ((CCL_write_time_r == 1'b0) || (CCA_1_out_w == 7'd0) || (CCL_reg_r[19] == CCA_1_out_w && count_CCL_r == 5'd19)) ? 1'b1 : 1'b0;

assign mapping_array_2_w[00] = ((CCL_write_time_r == 1'b0) || (CCA_2_out_w == 7'd0) || (CCL_reg_r[00] == CCA_2_out_w && count_CCL_r >= 5'd00)) ? 1'b1 : 1'b0;
assign mapping_array_2_w[01] = ((CCL_write_time_r == 1'b0) || (CCA_2_out_w == 7'd0) || (CCL_reg_r[01] == CCA_2_out_w && count_CCL_r >= 5'd01)) ? 1'b1 : 1'b0;
assign mapping_array_2_w[02] = ((CCL_write_time_r == 1'b0) || (CCA_2_out_w == 7'd0) || (CCL_reg_r[02] == CCA_2_out_w && count_CCL_r >= 5'd02)) ? 1'b1 : 1'b0;
assign mapping_array_2_w[03] = ((CCL_write_time_r == 1'b0) || (CCA_2_out_w == 7'd0) || (CCL_reg_r[03] == CCA_2_out_w && count_CCL_r >= 5'd03)) ? 1'b1 : 1'b0;
assign mapping_array_2_w[04] = ((CCL_write_time_r == 1'b0) || (CCA_2_out_w == 7'd0) || (CCL_reg_r[04] == CCA_2_out_w && count_CCL_r >= 5'd04)) ? 1'b1 : 1'b0;
assign mapping_array_2_w[05] = ((CCL_write_time_r == 1'b0) || (CCA_2_out_w == 7'd0) || (CCL_reg_r[05] == CCA_2_out_w && count_CCL_r >= 5'd05)) ? 1'b1 : 1'b0;
assign mapping_array_2_w[06] = ((CCL_write_time_r == 1'b0) || (CCA_2_out_w == 7'd0) || (CCL_reg_r[06] == CCA_2_out_w && count_CCL_r >= 5'd06)) ? 1'b1 : 1'b0;
assign mapping_array_2_w[07] = ((CCL_write_time_r == 1'b0) || (CCA_2_out_w == 7'd0) || (CCL_reg_r[07] == CCA_2_out_w && count_CCL_r >= 5'd07)) ? 1'b1 : 1'b0;
assign mapping_array_2_w[08] = ((CCL_write_time_r == 1'b0) || (CCA_2_out_w == 7'd0) || (CCL_reg_r[08] == CCA_2_out_w && count_CCL_r >= 5'd08)) ? 1'b1 : 1'b0;
assign mapping_array_2_w[09] = ((CCL_write_time_r == 1'b0) || (CCA_2_out_w == 7'd0) || (CCL_reg_r[09] == CCA_2_out_w && count_CCL_r >= 5'd09)) ? 1'b1 : 1'b0;
assign mapping_array_2_w[10] = ((CCL_write_time_r == 1'b0) || (CCA_2_out_w == 7'd0) || (CCL_reg_r[10] == CCA_2_out_w && count_CCL_r >= 5'd10)) ? 1'b1 : 1'b0;
assign mapping_array_2_w[11] = ((CCL_write_time_r == 1'b0) || (CCA_2_out_w == 7'd0) || (CCL_reg_r[11] == CCA_2_out_w && count_CCL_r >= 5'd11)) ? 1'b1 : 1'b0;
assign mapping_array_2_w[12] = ((CCL_write_time_r == 1'b0) || (CCA_2_out_w == 7'd0) || (CCL_reg_r[12] == CCA_2_out_w && count_CCL_r >= 5'd12)) ? 1'b1 : 1'b0;
assign mapping_array_2_w[13] = ((CCL_write_time_r == 1'b0) || (CCA_2_out_w == 7'd0) || (CCL_reg_r[13] == CCA_2_out_w && count_CCL_r >= 5'd13)) ? 1'b1 : 1'b0;
assign mapping_array_2_w[14] = ((CCL_write_time_r == 1'b0) || (CCA_2_out_w == 7'd0) || (CCL_reg_r[14] == CCA_2_out_w && count_CCL_r >= 5'd14)) ? 1'b1 : 1'b0;
assign mapping_array_2_w[15] = ((CCL_write_time_r == 1'b0) || (CCA_2_out_w == 7'd0) || (CCL_reg_r[15] == CCA_2_out_w && count_CCL_r >= 5'd15)) ? 1'b1 : 1'b0;
assign mapping_array_2_w[16] = ((CCL_write_time_r == 1'b0) || (CCA_2_out_w == 7'd0) || (CCL_reg_r[16] == CCA_2_out_w && count_CCL_r >= 5'd16)) ? 1'b1 : 1'b0;
assign mapping_array_2_w[17] = ((CCL_write_time_r == 1'b0) || (CCA_2_out_w == 7'd0) || (CCL_reg_r[17] == CCA_2_out_w && count_CCL_r >= 5'd17)) ? 1'b1 : 1'b0;
assign mapping_array_2_w[18] = ((CCL_write_time_r == 1'b0) || (CCA_2_out_w == 7'd0) || (CCL_reg_r[18] == CCA_2_out_w && count_CCL_r >= 5'd18)) ? 1'b1 : 1'b0;
assign mapping_array_2_w[19] = ((CCL_write_time_r == 1'b0) || (CCA_2_out_w == 7'd0) || (CCL_reg_r[19] == CCA_2_out_w && count_CCL_r == 5'd19)) ? 1'b1 : 1'b0;

wire [6:0] temp = CCL_reg_r[00];

always@(posedge clk or posedge reset)
begin
   if(reset)
   begin
      CCL_reg_r[00]<= 7'd0;
      CCL_reg_r[01]<= 7'd0;
      CCL_reg_r[02]<= 7'd0;
      CCL_reg_r[03]<= 7'd0;
      CCL_reg_r[04]<= 7'd0;
      CCL_reg_r[05]<= 7'd0;
      CCL_reg_r[06]<= 7'd0;
      CCL_reg_r[07]<= 7'd0;
      CCL_reg_r[08]<= 7'd0;
      CCL_reg_r[09]<= 7'd0;
      CCL_reg_r[10]<= 7'd0;
      CCL_reg_r[11]<= 7'd0;
      CCL_reg_r[12]<= 7'd0;
      CCL_reg_r[13]<= 7'd0;
      CCL_reg_r[14]<= 7'd0;
      CCL_reg_r[15]<= 7'd0;
      CCL_reg_r[16]<= 7'd0;
      CCL_reg_r[17]<= 7'd0;
      CCL_reg_r[18]<= 7'd0;
      CCL_reg_r[19]<= 7'd0;
      count_CCL_r <= 5'd0;
      store_CCL_r <= 1'b0;
      CCL_write_time_r <= 1'b0;
   
   end
   else if(ctrl_gateCLK)
   begin
      CCL_reg_r[00]<= CCL_reg_w[00];
      CCL_reg_r[01]<= CCL_reg_w[01];
      CCL_reg_r[02]<= CCL_reg_w[02];
      CCL_reg_r[03]<= CCL_reg_w[03];
      CCL_reg_r[04]<= CCL_reg_w[04];
      CCL_reg_r[05]<= CCL_reg_w[05];
      CCL_reg_r[06]<= CCL_reg_w[06];
      CCL_reg_r[07]<= CCL_reg_w[07];
      CCL_reg_r[08]<= CCL_reg_w[08];
      CCL_reg_r[09]<= CCL_reg_w[09];
      CCL_reg_r[10]<= CCL_reg_w[10];
      CCL_reg_r[11]<= CCL_reg_w[11];
      CCL_reg_r[12]<= CCL_reg_w[12];
      CCL_reg_r[13]<= CCL_reg_w[13];
      CCL_reg_r[14]<= CCL_reg_w[14];
      CCL_reg_r[15]<= CCL_reg_w[15];
      CCL_reg_r[16]<= CCL_reg_w[16];
      CCL_reg_r[17]<= CCL_reg_w[17];
      CCL_reg_r[18]<= CCL_reg_w[18];
      CCL_reg_r[19]<= CCL_reg_w[19];
      count_CCL_r <= count_CCL_w;
      store_CCL_r <= store_CCL_w;
      CCL_write_time_r <= CCL_write_time_w;
   end
end


always@(*)
begin
   if(store_CCL_r == 1'b1 && mapping_array_1_w == 20'd0)
   begin
      if(mapping_array_2_w == 20'd0 && CCA_1_out_w != CCA_2_out_w)
      begin
         CCL_reg_w[00] = (count_CCL_r == 5'd00) ? CCA_1_out_w : CCL_reg_r[00];       
         CCL_reg_w[01] = (count_CCL_r == 5'd00) ? CCA_2_out_w : ((count_CCL_r == 5'd01) ? CCA_1_out_w : CCL_reg_r[01]);
         CCL_reg_w[02] = (count_CCL_r == 5'd01) ? CCA_2_out_w : ((count_CCL_r == 5'd02) ? CCA_1_out_w : CCL_reg_r[02]);
         CCL_reg_w[03] = (count_CCL_r == 5'd02) ? CCA_2_out_w : ((count_CCL_r == 5'd03) ? CCA_1_out_w : CCL_reg_r[03]);
         CCL_reg_w[04] = (count_CCL_r == 5'd03) ? CCA_2_out_w : ((count_CCL_r == 5'd04) ? CCA_1_out_w : CCL_reg_r[04]);
         CCL_reg_w[05] = (count_CCL_r == 5'd04) ? CCA_2_out_w : ((count_CCL_r == 5'd05) ? CCA_1_out_w : CCL_reg_r[05]);
         CCL_reg_w[06] = (count_CCL_r == 5'd05) ? CCA_2_out_w : ((count_CCL_r == 5'd06) ? CCA_1_out_w : CCL_reg_r[06]);
         CCL_reg_w[07] = (count_CCL_r == 5'd06) ? CCA_2_out_w : ((count_CCL_r == 5'd07) ? CCA_1_out_w : CCL_reg_r[07]);
         CCL_reg_w[08] = (count_CCL_r == 5'd07) ? CCA_2_out_w : ((count_CCL_r == 5'd08) ? CCA_1_out_w : CCL_reg_r[08]);
         CCL_reg_w[09] = (count_CCL_r == 5'd08) ? CCA_2_out_w : ((count_CCL_r == 5'd09) ? CCA_1_out_w : CCL_reg_r[09]);
         CCL_reg_w[10] = (count_CCL_r == 5'd09) ? CCA_2_out_w : ((count_CCL_r == 5'd10) ? CCA_1_out_w : CCL_reg_r[10]);
         CCL_reg_w[11] = (count_CCL_r == 5'd10) ? CCA_2_out_w : ((count_CCL_r == 5'd11) ? CCA_1_out_w : CCL_reg_r[11]);
         CCL_reg_w[12] = (count_CCL_r == 5'd11) ? CCA_2_out_w : ((count_CCL_r == 5'd12) ? CCA_1_out_w : CCL_reg_r[12]);
         CCL_reg_w[13] = (count_CCL_r == 5'd12) ? CCA_2_out_w : ((count_CCL_r == 5'd13) ? CCA_1_out_w : CCL_reg_r[13]);
         CCL_reg_w[14] = (count_CCL_r == 5'd13) ? CCA_2_out_w : ((count_CCL_r == 5'd14) ? CCA_1_out_w : CCL_reg_r[14]);
         CCL_reg_w[15] = (count_CCL_r == 5'd14) ? CCA_2_out_w : ((count_CCL_r == 5'd15) ? CCA_1_out_w : CCL_reg_r[15]);
         CCL_reg_w[16] = (count_CCL_r == 5'd15) ? CCA_2_out_w : ((count_CCL_r == 5'd16) ? CCA_1_out_w : CCL_reg_r[16]);
         CCL_reg_w[17] = (count_CCL_r == 5'd16) ? CCA_2_out_w : ((count_CCL_r == 5'd17) ? CCA_1_out_w : CCL_reg_r[17]);
         CCL_reg_w[18] = (count_CCL_r == 5'd17) ? CCA_2_out_w : ((count_CCL_r == 5'd18) ? CCA_1_out_w : CCL_reg_r[18]);
         CCL_reg_w[19] = (count_CCL_r == 5'd18) ? CCA_2_out_w : ((count_CCL_r == 5'd19) ? CCA_1_out_w : CCL_reg_r[19]);
                                                                                                                  
      
         count_CCL_w = count_CCL_r + 5'd2;
      end
      else
      begin
         CCL_reg_w[00] = (count_CCL_r == 5'd00) ? CCA_1_out_w : CCL_reg_r[00];       
         CCL_reg_w[01] = (count_CCL_r == 5'd01) ? CCA_1_out_w : CCL_reg_r[01];
         CCL_reg_w[02] = (count_CCL_r == 5'd02) ? CCA_1_out_w : CCL_reg_r[02];
         CCL_reg_w[03] = (count_CCL_r == 5'd03) ? CCA_1_out_w : CCL_reg_r[03];
         CCL_reg_w[04] = (count_CCL_r == 5'd04) ? CCA_1_out_w : CCL_reg_r[04];
         CCL_reg_w[05] = (count_CCL_r == 5'd05) ? CCA_1_out_w : CCL_reg_r[05];
         CCL_reg_w[06] = (count_CCL_r == 5'd06) ? CCA_1_out_w : CCL_reg_r[06];
         CCL_reg_w[07] = (count_CCL_r == 5'd07) ? CCA_1_out_w : CCL_reg_r[07];
         CCL_reg_w[08] = (count_CCL_r == 5'd08) ? CCA_1_out_w : CCL_reg_r[08];
         CCL_reg_w[09] = (count_CCL_r == 5'd09) ? CCA_1_out_w : CCL_reg_r[09];
         CCL_reg_w[10] = (count_CCL_r == 5'd10) ? CCA_1_out_w : CCL_reg_r[10];
         CCL_reg_w[11] = (count_CCL_r == 5'd11) ? CCA_1_out_w : CCL_reg_r[11];
         CCL_reg_w[12] = (count_CCL_r == 5'd12) ? CCA_1_out_w : CCL_reg_r[12];
         CCL_reg_w[13] = (count_CCL_r == 5'd13) ? CCA_1_out_w : CCL_reg_r[13];
         CCL_reg_w[14] = (count_CCL_r == 5'd14) ? CCA_1_out_w : CCL_reg_r[14];
         CCL_reg_w[15] = (count_CCL_r == 5'd15) ? CCA_1_out_w : CCL_reg_r[15];
         CCL_reg_w[16] = (count_CCL_r == 5'd16) ? CCA_1_out_w : CCL_reg_r[16];
         CCL_reg_w[17] = (count_CCL_r == 5'd17) ? CCA_1_out_w : CCL_reg_r[17];
         CCL_reg_w[18] = (count_CCL_r == 5'd18) ? CCA_1_out_w : CCL_reg_r[18];
         CCL_reg_w[19] = (count_CCL_r == 5'd19) ? CCA_1_out_w : CCL_reg_r[19];
                                                                                                                  
      
         count_CCL_w = count_CCL_r + 5'd1;
      
      end
      
   end
   else
   begin
      if(mapping_array_2_w == 20'd0)
      begin
         CCL_reg_w[00] = (count_CCL_r == 5'd00) ? CCA_2_out_w : CCL_reg_r[00];       
         CCL_reg_w[01] = (count_CCL_r == 5'd01) ? CCA_2_out_w : CCL_reg_r[01];
         CCL_reg_w[02] = (count_CCL_r == 5'd02) ? CCA_2_out_w : CCL_reg_r[02];
         CCL_reg_w[03] = (count_CCL_r == 5'd03) ? CCA_2_out_w : CCL_reg_r[03];
         CCL_reg_w[04] = (count_CCL_r == 5'd04) ? CCA_2_out_w : CCL_reg_r[04];
         CCL_reg_w[05] = (count_CCL_r == 5'd05) ? CCA_2_out_w : CCL_reg_r[05];
         CCL_reg_w[06] = (count_CCL_r == 5'd06) ? CCA_2_out_w : CCL_reg_r[06];
         CCL_reg_w[07] = (count_CCL_r == 5'd07) ? CCA_2_out_w : CCL_reg_r[07];
         CCL_reg_w[08] = (count_CCL_r == 5'd08) ? CCA_2_out_w : CCL_reg_r[08];
         CCL_reg_w[09] = (count_CCL_r == 5'd09) ? CCA_2_out_w : CCL_reg_r[09];
         CCL_reg_w[10] = (count_CCL_r == 5'd10) ? CCA_2_out_w : CCL_reg_r[10];
         CCL_reg_w[11] = (count_CCL_r == 5'd11) ? CCA_2_out_w : CCL_reg_r[11];
         CCL_reg_w[12] = (count_CCL_r == 5'd12) ? CCA_2_out_w : CCL_reg_r[12];
         CCL_reg_w[13] = (count_CCL_r == 5'd13) ? CCA_2_out_w : CCL_reg_r[13];
         CCL_reg_w[14] = (count_CCL_r == 5'd14) ? CCA_2_out_w : CCL_reg_r[14];
         CCL_reg_w[15] = (count_CCL_r == 5'd15) ? CCA_2_out_w : CCL_reg_r[15];
         CCL_reg_w[16] = (count_CCL_r == 5'd16) ? CCA_2_out_w : CCL_reg_r[16];
         CCL_reg_w[17] = (count_CCL_r == 5'd17) ? CCA_2_out_w : CCL_reg_r[17];
         CCL_reg_w[18] = (count_CCL_r == 5'd18) ? CCA_2_out_w : CCL_reg_r[18];
         CCL_reg_w[19] = (count_CCL_r == 5'd19) ? CCA_2_out_w : CCL_reg_r[19];
                                                                                                                  
      
         count_CCL_w = count_CCL_r + 5'd1;
      end
      else
      begin
         CCL_reg_w[00] = CCL_reg_r[00];       
         CCL_reg_w[01] = CCL_reg_r[01];
         CCL_reg_w[02] = CCL_reg_r[02];
         CCL_reg_w[03] = CCL_reg_r[03];
         CCL_reg_w[04] = CCL_reg_r[04];
         CCL_reg_w[05] = CCL_reg_r[05];
         CCL_reg_w[06] = CCL_reg_r[06];
         CCL_reg_w[07] = CCL_reg_r[07];
         CCL_reg_w[08] = CCL_reg_r[08];
         CCL_reg_w[09] = CCL_reg_r[09];
         CCL_reg_w[10] = CCL_reg_r[10];
         CCL_reg_w[11] = CCL_reg_r[11];
         CCL_reg_w[12] = CCL_reg_r[12];
         CCL_reg_w[13] = CCL_reg_r[13];
         CCL_reg_w[14] = CCL_reg_r[14];
         CCL_reg_w[15] = CCL_reg_r[15];
         CCL_reg_w[16] = CCL_reg_r[16];
         CCL_reg_w[17] = CCL_reg_r[17];
         CCL_reg_w[18] = CCL_reg_r[18];
         CCL_reg_w[19] = CCL_reg_r[19];
                                                                                                                  
      
         count_CCL_w = count_CCL_r;
      
      end
      
      
      
      
      
   end
   
end



//*******************************************

//assign choose_reg_from_DMA_w = (ContextRegAddr_r == 8'd124 && !stall)? DataIn_r[47:0] : choose_weg_from_DMA_r;            
     



SISP sisp00(
                .clk(clk),
                .reset(reset),
                
                .seg_enable_i(seg_enable_i), 
                .seg_stall(seg_stall),                
                .Seg_DataIn_i(DataIn_Seg),
                .Seg_DataInReady_i(),
                .Seg_DataOut_o(DataOut_Seg),
                .Seg_DataOutReady_o(),
                
                //From Arong
                .color_0_in(color_0_in_r), 
                .color_1_in(color_1_in_r), 
                .color_2_in(color_2_in_r), 
                .color_3_in(color_3_in_r), 
                .color_4_in(color_4_in_r), 
                .color_5_in(color_5_in_r), 
                .color_6_in(color_6_in_r), 
                .color_7_in(color_7_in_r), 
                .write_which_in(write_which_in_r),
                .compute_bu_in(compute_bu_in_r),
                .start_position_x_in(start_position_x_in_r), 
                .start_position_y_in(start_position_y_in_r), 
                .width_in(width_in_r), 
                .height_in(height_in_r),
                .accumulate_how_many_in(accumulate_how_many_in_r),
                .centerx_in(centerx_in_r), 
                .centery_in(centery_in_r), 
                .background_weight_0_in(background_weight_0_in_r), 
                .background_weight_1_in(background_weight_1_in_r), 
                .background_weight_2_in(background_weight_2_in_r), 
                .background_weight_3_in(background_weight_3_in_r), 
                .background_weight_4_in(background_weight_4_in_r), 
                .background_weight_5_in(background_weight_5_in_r), 
                .background_weight_6_in(background_weight_6_in_r), 
                .background_weight_7_in(background_weight_7_in_r), 
                .diag(diag_r), 
                .distanceY(distanceY_w), 
                .distanceU(distanceU_w), 
                .distanceV(distanceV_w), 
                .done(done_w),              
                .controller_enable(controller_enable_r),
                .iteration_times(iteration_times_r), 
                .total_target_histogram_y(total_target_histogram_y_r), 
                .total_target_histogram_u(total_target_histogram_u_r), 
                .total_target_histogram_v(total_target_histogram_v_r), 
                //.buffer_input_stop(buffer_input_stop_r), 
                .use_background_color_or_not(use_background_color_or_not_r), 
                .background_weight_threshold_in(background_weight_threshold_in_r), 
                .background_binvalue_threshold_in(background_binvalue_threshold_in_r), 
                .histogram_accumulation_done(histogram_accumulation_done_w),
                .reset_register(reset_register_i), 
                .reset_buffer(reset_buffer_i), 
                .CCA_stop(CCA_stop_r), 
                .CCA_D_in(CCA_D_in_r), 
                .CCA_I_in(CCA_I_in_r), 
                .Address_from_DMA(Address_from_DMA_r), 
                .Data_from_DMA(Data_from_DMA_r), 
                .Data_to_DMA(Data_to_DMA_w), 
                .WEAN_from_DMA(WEAN_from_DMA_r), 
                .choose_reg_from_DMA(choose_reg_from_DMA_r), 
                .MUXA_from_DMA(MUXA_from_DMA_r),
                //From context Register
                .Mode_i(Mode_r),
                .BDthY_default_i(BDthY_default_r), 
                .BDthU_default_i(BDthU_default_r), 
                .BDthV_default_i(BDthV_default_r),  
                .Bth_default_i(Bth_default_r), 
                .BckGndBuildTH_default_i(BckGndBuildTH_default_r),
                .box1xmax_i(box1xmax_r),  
                .box1ymax_i(box1ymax_r),  
                .box1xmin_i(box1xmin_r),  
                .box1ymin_i(box1ymin_r),  
                .BDthY_box1_i(BDthY_box1_r),  
                .BDthU_box1_i(BDthU_box1_r),  
                .BDthV_box1_i(BDthV_box1_r),   
                .update_box1_i(update_box1_r),   
                .Bth_box1_i(Bth_box1_r),  
                .BckGndBuildTH_box1_i(BckGndBuildTH_box1_r),
                
                .box2xmax_i(box2xmax_r),  
                .box2ymax_i(box2ymax_r),  
                .box2xmin_i(box2xmin_r),  
                .box2ymin_i(box2ymin_r),  
                .BDthY_box2_i(BDthY_box2_r),  
                .BDthU_box2_i(BDthU_box2_r),  
                .BDthV_box2_i(BDthV_box2_r),   
                .update_box2_i(update_box2_r),   
                .Bth_box2_i(Bth_box2_r),  
                .BckGndBuildTH_box2_i(BckGndBuildTH_box2_r),
                
                .box3xmax_i(box3xmax_r),  
                .box3ymax_i(box3ymax_r),  
                .box3xmin_i(box3xmin_r),  
                .box3ymin_i(box3ymin_r),  
                .BDthY_box3_i(BDthY_box3_r),  
                .BDthU_box3_i(BDthU_box3_r),  
                .BDthV_box3_i(BDthV_box3_r),   
                .update_box3_i(update_box3_r),   
                .Bth_box3_i(Bth_box3_r),  
                .BckGndBuildTH_box3_i(BckGndBuildTH_box3_r),
                
                .box4xmax_i(box4xmax_r),  
                .box4ymax_i(box4ymax_r),  
                .box4xmin_i(box4xmin_r),  
                .box4ymin_i(box4ymin_r),  
                .BDthY_box4_i(BDthY_box4_r),  
                .BDthU_box4_i(BDthU_box4_r),  
                .BDthV_box4_i(BDthV_box4_r),   
                .update_box4_i(update_box4_r),   
                .Bth_box4_i(Bth_box4_r),  
                .BckGndBuildTH_box4_i(BckGndBuildTH_box4_r),
                
                .box5xmax_i(box5xmax_r),  
                .box5ymax_i(box5ymax_r),  
                .box5xmin_i(box5xmin_r),  
                .box5ymin_i(box5ymin_r),  
                .BDthY_box5_i(BDthY_box5_r),  
                .BDthU_box5_i(BDthU_box5_r),  
                .BDthV_box5_i(BDthV_box5_r),   
                .update_box5_i(update_box5_r),   
                .Bth_box5_i(Bth_box5_r),  
                .BckGndBuildTH_box5_i(BckGndBuildTH_box5_r),
                
                .box6xmax_i(box6xmax_r),  
                .box6ymax_i(box6ymax_r),  
                .box6xmin_i(box6xmin_r),  
                .box6ymin_i(box6ymin_r),  
                .BDthY_box6_i(BDthY_box6_r),  
                .BDthU_box6_i(BDthU_box6_r),  
                .BDthV_box6_i(BDthV_box6_r),   
                .update_box6_i(update_box6_r),   
                .Bth_box6_i(Bth_box6_r),  
                .BckGndBuildTH_box6_i(BckGndBuildTH_box6_r),
                
                .box7xmax_i(box7xmax_r),  
                .box7ymax_i(box7ymax_r),  
                .box7xmin_i(box7xmin_r),  
                .box7ymin_i(box7ymin_r),  
                .BDthY_box7_i(BDthY_box7_r),  
                .BDthU_box7_i(BDthU_box7_r),  
                .BDthV_box7_i(BDthV_box7_r),   
                .update_box7_i(update_box7_r),   
                .Bth_box7_i(Bth_box7_r),  
                .BckGndBuildTH_box7_i(BckGndBuildTH_box7_r),
                
                .box8xmax_i(box8xmax_r),  
                .box8ymax_i(box8ymax_r),  
                .box8xmin_i(box8xmin_r),  
                .box8ymin_i(box8ymin_r),  
                .BDthY_box8_i(BDthY_box8_r),  
                .BDthU_box8_i(BDthU_box8_r),  
                .BDthV_box8_i(BDthV_box8_r),   
                .update_box8_i(update_box8_r),   
                .Bth_box8_i(Bth_box8_r),  
                .BckGndBuildTH_box8_i(BckGndBuildTH_box8_r),
                
                .box9xmax_i(box9xmax_r),  
                .box9ymax_i(box9ymax_r),  
                .box9xmin_i(box9xmin_r),  
                .box9ymin_i(box9ymin_r),  
                .BDthY_box9_i(BDthY_box9_r),  
                .BDthU_box9_i(BDthU_box9_r),  
                .BDthV_box9_i(BDthV_box9_r),   
                .update_box9_i(update_box9_r),   
                .Bth_box9_i(Bth_box9_r),  
                .BckGndBuildTH_box9_i(BckGndBuildTH_box9_r),
                
                .box10xmax_i(box10xmax_r),  
                .box10ymax_i(box10ymax_r),  
                .box10xmin_i(box10xmin_r),  
                .box10ymin_i(box10ymin_r),  
                .BDthY_box10_i(BDthY_box10_r),  
                .BDthU_box10_i(BDthU_box10_r),  
                .BDthV_box10_i(BDthV_box10_r),   
                .update_box10_i(update_box10_r),   
                .Bth_box10_i(Bth_box10_r),  
                .BckGndBuildTH_box10_i(BckGndBuildTH_box10_r),
                
                .OI_Data_64bit(OI_Data_64bit_r),      
                .o0_label(o0_label_r),           
                .o1_label(o1_label_r),           
                .o2_label(o2_label_r),           
                .o3_label(o3_label_r),           
                .o4_label(o4_label_r),           
                .o5_label(o5_label_r),           
                .o6_label(o6_label_r),           
                .o7_label(o7_label_r),           
                .o8_label(o8_label_r),           
                .o9_label(o9_label_r),           
                                   
                .o0_x_min(o0_x_min_w),
                .o0_x_max(o0_x_max_w), 
                .o1_x_min(o1_x_min_w),
                .o1_x_max(o1_x_max_w), 
                .o2_x_min(o2_x_min_w),
                .o2_x_max(o2_x_max_w), 
                .o3_x_min(o3_x_min_w),
                .o3_x_max(o3_x_max_w), 
                .o4_x_min(o4_x_min_w),
                .o4_x_max(o4_x_max_w), 
                .o5_x_min(o5_x_min_w),
                .o5_x_max(o5_x_max_w), 
                .o6_x_min(o6_x_min_w),
                .o6_x_max(o6_x_max_w), 
                .o7_x_min(o7_x_min_w),
                .o7_x_max(o7_x_max_w), 
                .o8_x_min(o8_x_min_w),
                .o8_x_max(o8_x_max_w), 
                .o9_x_min(o9_x_min_w),
                .o9_x_max(o9_x_max_w), 
                                    
                .o0_y_min(o0_y_min_w),
                .o0_y_max(o0_y_max_w), 
                .o1_y_min(o1_y_min_w),
                .o1_y_max(o1_y_max_w), 
                .o2_y_min(o2_y_min_w),
                .o2_y_max(o2_y_max_w), 
                .o3_y_min(o3_y_min_w),
                .o3_y_max(o3_y_max_w), 
                .o4_y_min(o4_y_min_w),
                .o4_y_max(o4_y_max_w), 
                .o5_y_min(o5_y_min_w),
                .o5_y_max(o5_y_max_w), 
                .o6_y_min(o6_y_min_w),
                .o6_y_max(o6_y_max_w), 
                .o7_y_min(o7_y_min_w),
                .o7_y_max(o7_y_max_w), 
                .o8_y_min(o8_y_min_w),
                .o8_y_max(o8_y_max_w), 
                .o9_y_min(o9_y_min_w),
                .o9_y_max(o9_y_max_w),
                
                .total_candidate_histogram_Y_out(total_candidate_histogram_Y_out_w), 
                .total_target_histogram_Y_out   (total_target_histogram_Y_out_w   ),  
                .total_candidate_histogram_U_out(total_candidate_histogram_U_out_w), 
                .total_target_histogram_U_out   (total_target_histogram_U_out_w   ),  
                .total_candidate_histogram_V_out(total_candidate_histogram_V_out_w), 
                .total_target_histogram_V_out   (total_target_histogram_V_out_w   ),
                
                .mask_in(mask_in_r), 
                .mask_on_or_not(mask_on_or_not_r), 
                .MASK_input_stop(MASK_input_stop_r),
                .CCA_1_out(CCA_1_out_w), 
                .CCA_2_out(CCA_2_out_w), 
                .CCL_write_time(CCL_write_time_w)
                
                                
                );
                
                
                
                
                
                
endmodule       
                
                
                
                
                
                
                
                
                
                
                