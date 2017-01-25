module RSPE_Segmentation(
				clk,
                		reset,
                		ctrl_gateCLK, 
                		stall,
				
				which_min_i,
				lineidx_i, pixelidx_i, 
				BDthY_default_i, BDthU_default_i, BDthV_default_i,  Bth_default_i, BckGndBuildTH_default_i,
				box1xmax_i,  box1ymax_i,  box1xmin_i,  box1ymin_i,  BDthY_box1_i,  BDthU_box1_i,  BDthV_box1_i,   update_box1_i,   Bth_box1_i,  BckGndBuildTH_box1_i,
				box2xmax_i,  box2ymax_i,  box2xmin_i,  box2ymin_i,  BDthY_box2_i,  BDthU_box2_i,  BDthV_box2_i,   update_box2_i,   Bth_box2_i,  BckGndBuildTH_box2_i,
				box3xmax_i,  box3ymax_i,  box3xmin_i,  box3ymin_i,  BDthY_box3_i,  BDthU_box3_i,  BDthV_box3_i,   update_box3_i,   Bth_box3_i,  BckGndBuildTH_box3_i,
				box4xmax_i,  box4ymax_i,  box4xmin_i,  box4ymin_i,  BDthY_box4_i,  BDthU_box4_i,  BDthV_box4_i,   update_box4_i,   Bth_box4_i,  BckGndBuildTH_box4_i,
				box5xmax_i,  box5ymax_i,  box5xmin_i,  box5ymin_i,  BDthY_box5_i,  BDthU_box5_i,  BDthV_box5_i,   update_box5_i,   Bth_box5_i,  BckGndBuildTH_box5_i,
				box6xmax_i,  box6ymax_i,  box6xmin_i,  box6ymin_i,  BDthY_box6_i,  BDthU_box6_i,  BDthV_box6_i,   update_box6_i,   Bth_box6_i,  BckGndBuildTH_box6_i,
				box7xmax_i,  box7ymax_i,  box7xmin_i,  box7ymin_i,  BDthY_box7_i,  BDthU_box7_i,  BDthV_box7_i,   update_box7_i,   Bth_box7_i,  BckGndBuildTH_box7_i,
				box8xmax_i,  box8ymax_i,  box8xmin_i,  box8ymin_i,  BDthY_box8_i,  BDthU_box8_i,  BDthV_box8_i,   update_box8_i,   Bth_box8_i,  BckGndBuildTH_box8_i,
				box9xmax_i,  box9ymax_i,  box9xmin_i,  box9ymin_i,  BDthY_box9_i,  BDthU_box9_i,  BDthV_box9_i,   update_box9_i,   Bth_box9_i,  BckGndBuildTH_box9_i,
				box10xmax_i, box10ymax_i, box10xmin_i, box10ymin_i, BDthY_box10_i, BDthU_box10_i, BDthV_box10_i,  update_box10_i,  Bth_box10_i, BckGndBuildTH_box10_i,
				
				curpixelY_i, 
                		curpixelU_i, 
                		curpixelV_i, 
                		bckgndlayerY_i, 
               			bckgndlayerU_i,  
                		bckgndlayerV_i,  
                		bckgndlayerW_i,
                		updatedbckgndlayerY_o,
                		updatedbckgndlayerU_o,
                		updatedbckgndlayerV_o,
                		updatedbckgndlayerW_o,
                		mask_o
				);
input clk;                     
input reset;                                    
input ctrl_gateCLK;            
input stall; 

input [4:0] which_min_i;
input [11:0] lineidx_i;                                                                
input [11:0] pixelidx_i;                                                               
                                                          
input [11:0] box1xmax_i; 
input [11:0] box2xmax_i; 
input [11:0] box3xmax_i; 
input [11:0] box4xmax_i; 
input [11:0] box5xmax_i; 
input [11:0] box6xmax_i; 
input [11:0] box7xmax_i; 
input [11:0] box8xmax_i; 
input [11:0] box9xmax_i; 
input [11:0] box10xmax_i;

input [11:0] box1ymax_i; 
input [11:0] box2ymax_i; 
input [11:0] box3ymax_i; 
input [11:0] box4ymax_i; 
input [11:0] box5ymax_i; 
input [11:0] box6ymax_i; 
input [11:0] box7ymax_i; 
input [11:0] box8ymax_i; 
input [11:0] box9ymax_i; 
input [11:0] box10ymax_i;

input [11:0] box1xmin_i; 
input [11:0] box2xmin_i; 
input [11:0] box3xmin_i; 
input [11:0] box4xmin_i; 
input [11:0] box5xmin_i; 
input [11:0] box6xmin_i; 
input [11:0] box7xmin_i; 
input [11:0] box8xmin_i; 
input [11:0] box9xmin_i; 
input [11:0] box10xmin_i;

input [11:0] box1ymin_i; 
input [11:0] box2ymin_i; 
input [11:0] box3ymin_i; 
input [11:0] box4ymin_i; 
input [11:0] box5ymin_i; 
input [11:0] box6ymin_i; 
input [11:0] box7ymin_i; 
input [11:0] box8ymin_i; 
input [11:0] box9ymin_i; 
input [11:0] box10ymin_i;

input [7:0] BDthY_default_i;
input [7:0] BDthY_box1_i; 
input [7:0] BDthY_box2_i; 
input [7:0] BDthY_box3_i; 
input [7:0] BDthY_box4_i; 
input [7:0] BDthY_box5_i; 
input [7:0] BDthY_box6_i; 
input [7:0] BDthY_box7_i; 
input [7:0] BDthY_box8_i; 
input [7:0] BDthY_box9_i; 
input [7:0] BDthY_box10_i;

input [7:0] BDthU_default_i; 
input [7:0] BDthU_box1_i; 
input [7:0] BDthU_box2_i; 
input [7:0] BDthU_box3_i; 
input [7:0] BDthU_box4_i; 
input [7:0] BDthU_box5_i; 
input [7:0] BDthU_box6_i; 
input [7:0] BDthU_box7_i; 
input [7:0] BDthU_box8_i; 
input [7:0] BDthU_box9_i; 
input [7:0] BDthU_box10_i;

input [7:0] BDthV_default_i;        
input [7:0] BDthV_box1_i;      
input [7:0] BDthV_box2_i;      
input [7:0] BDthV_box3_i;      
input [7:0] BDthV_box4_i;      
input [7:0] BDthV_box5_i;      
input [7:0] BDthV_box6_i;      
input [7:0] BDthV_box7_i;      
input [7:0] BDthV_box8_i;      
input [7:0] BDthV_box9_i;      
input [7:0] BDthV_box10_i;     

input update_box1_i; 
input update_box2_i; 
input update_box3_i; 
input update_box4_i; 
input update_box5_i; 
input update_box6_i; 
input update_box7_i; 
input update_box8_i; 
input update_box9_i; 
input update_box10_i;

input [7:0] Bth_default_i;
input [7:0] Bth_box1_i; 
input [7:0] Bth_box2_i; 
input [7:0] Bth_box3_i; 
input [7:0] Bth_box4_i; 
input [7:0] Bth_box5_i; 
input [7:0] Bth_box6_i; 
input [7:0] Bth_box7_i; 
input [7:0] Bth_box8_i; 
input [7:0] Bth_box9_i; 
input [7:0] Bth_box10_i;

          
input [7:0] BckGndBuildTH_default_i;
input [7:0] BckGndBuildTH_box1_i; 
input [7:0] BckGndBuildTH_box2_i; 
input [7:0] BckGndBuildTH_box3_i; 
input [7:0] BckGndBuildTH_box4_i; 
input [7:0] BckGndBuildTH_box5_i; 
input [7:0] BckGndBuildTH_box6_i; 
input [7:0] BckGndBuildTH_box7_i; 
input [7:0] BckGndBuildTH_box8_i; 
input [7:0] BckGndBuildTH_box9_i; 
input [7:0] BckGndBuildTH_box10_i ;


input [7:0] curpixelY_i;               
input [7:0] curpixelU_i;               
input [7:0] curpixelV_i;               
input [31:0] bckgndlayerY_i;     //4 background layer are used in this version       
input [31:0] bckgndlayerU_i;            
input [31:0] bckgndlayerV_i;  
input [31:0] bckgndlayerW_i; 
output [31:0] updatedbckgndlayerY_o;     //4 background layer are used in this version       
output [31:0] updatedbckgndlayerU_o;            
output [31:0] updatedbckgndlayerV_o;         
output [31:0] updatedbckgndlayerW_o;            
output mask_o;           


//wire and reg
reg [4:0] which_min_r; 
wire [4:0] which_min_ws; 
reg [11:0] lineidx_r    ;
reg [11:0] pixelidx_r   ;
reg [7:0] curpixelY_r       ;
reg [7:0] curpixelU_r       ;
reg [7:0] curpixelV_r       ;
reg [31:0] bckgndlayerY_r   ;
reg [31:0] bckgndlayerU_r   ;
reg [31:0] bckgndlayerV_r   ;
reg [31:0] bckgndlayerW_r   ;
reg mask_r;
wire [11:0] lineidx_ws    ;
wire [11:0] pixelidx_ws   ;
wire [7:0] curpixelY_ws       ;
wire [7:0] curpixelU_ws       ;
wire [7:0] curpixelV_ws       ;
wire [31:0] bckgndlayerY_ws   ;
wire [31:0] bckgndlayerU_ws   ;
wire [31:0] bckgndlayerV_ws   ;
wire [31:0] bckgndlayerW_ws   ;
wire mask_ws;
wire mask_w;

wire [31:0] updatedbckgndlayerY_w;
wire [31:0] updatedbckgndlayerU_w;
wire [31:0] updatedbckgndlayerV_w;
wire [31:0] updatedbckgndlayerW_w;

reg [31:0] updatedbckgndlayerY_r;
reg [31:0] updatedbckgndlayerU_r;
reg [31:0] updatedbckgndlayerV_r;
reg [31:0] updatedbckgndlayerW_r;
wire [31:0] updatedbckgndlayerY_ws;
wire [31:0] updatedbckgndlayerU_ws;
wire [31:0] updatedbckgndlayerV_ws;
wire [31:0] updatedbckgndlayerW_ws;

wire [7:0] decided_BDthY;        
wire [7:0] decided_BDthU;        
wire [7:0] decided_BDthV;        
wire [7:0] decided_Bth;          
wire       decided_update;       
wire [7:0] decided_BckGndBuildTH;
wire [31:0] ordered_bckgndlayerY;
wire [31:0] ordered_bckgndlayerU;
wire [31:0] ordered_bckgndlayerV;
wire [31:0] ordered_bckgndlayerW;					/**Input Stage**/
		//input threshods from control registers has no input registers in this module
					
assign which_min_ws	 =	 (stall)?	which_min_r	 : which_min_i; 	
assign lineidx_ws        =       (stall)?     lineidx_r        : lineidx_i;                 
assign pixelidx_ws       =       (stall)?     pixelidx_r       : pixelidx_i;                           
assign curpixelY_ws      =       (stall)?     curpixelY_r      : curpixelY_i;               
assign curpixelU_ws      =       (stall)?     curpixelU_r      : curpixelU_i;               
assign curpixelV_ws      =       (stall)?     curpixelV_r      : curpixelV_i;               
assign bckgndlayerY_ws   =       (stall)?     bckgndlayerY_r   : bckgndlayerY_i;     
assign bckgndlayerU_ws   =       (stall)?     bckgndlayerU_r   : bckgndlayerU_i;            
assign bckgndlayerV_ws   =       (stall)?     bckgndlayerV_r   : bckgndlayerV_i;  
assign bckgndlayerW_ws   =       (stall)?     bckgndlayerW_r   : bckgndlayerW_i;
//wire gclk = clk & ctrl_gateCLK;
always@(posedge clk or posedge reset)
begin                
   if(reset)         
   begin
   	which_min_r	<=5'd0;
        lineidx_r       <=12'd0 ;
        pixelidx_r      <=12'd0 ;
        curpixelY_r     <=8'd0  ;
        curpixelU_r     <=8'd0  ;
        curpixelV_r     <=8'd0  ;
        bckgndlayerY_r  <=32'd0 ;
        bckgndlayerU_r  <=32'd0 ;
        bckgndlayerV_r  <=32'd0 ;
        bckgndlayerW_r  <=32'd0 ;
                       
   end               
   else if (ctrl_gateCLK)
   begin 
        which_min_r     <=	which_min_ws	;      
        lineidx_r       <=      lineidx_ws       ;
        pixelidx_r      <=      pixelidx_ws      ;
        curpixelY_r     <=      curpixelY_ws     ;
        curpixelU_r     <=      curpixelU_ws     ;
        curpixelV_r     <=      curpixelV_ws     ;
        bckgndlayerY_r  <=      bckgndlayerY_ws  ;
        bckgndlayerU_r  <=      bckgndlayerU_ws  ;
        bckgndlayerV_r  <=      bckgndlayerV_ws  ;
        bckgndlayerW_r  <=      bckgndlayerW_ws  ;
        
              
   end                 
end        

						/**Switch**/
						
assign ordered_bckgndlayerY = 	(which_min_r == 5'd3)? 	{bckgndlayerY_r[7:0], bckgndlayerY_r[23:8], bckgndlayerY_r[31:24] }  :
				(which_min_r == 5'd2)?	{bckgndlayerY_r[31:24], bckgndlayerY_r[7:0], bckgndlayerY_r[15:8], bckgndlayerY_r[23:16] } :
				(which_min_r == 5'd1)?	{bckgndlayerY_r[31:16], bckgndlayerY_r[7:0], bckgndlayerY_r[15:8]} :
							{bckgndlayerY_r};
							
assign ordered_bckgndlayerU = 	(which_min_r == 5'd3)? 	{bckgndlayerU_r[7:0], bckgndlayerU_r[23:8], bckgndlayerU_r[31:24] }  :
				(which_min_r == 5'd2)?	{bckgndlayerU_r[31:24], bckgndlayerU_r[7:0], bckgndlayerU_r[15:8], bckgndlayerU_r[23:16] } :
				(which_min_r == 5'd1)?	{bckgndlayerU_r[31:16], bckgndlayerU_r[7:0], bckgndlayerU_r[15:8]} :
							{bckgndlayerU_r};

assign ordered_bckgndlayerV = 	(which_min_r == 5'd3)? 	{bckgndlayerV_r[7:0], bckgndlayerV_r[23:8], bckgndlayerV_r[31:24] }  :
				(which_min_r == 5'd2)?	{bckgndlayerV_r[31:24], bckgndlayerV_r[7:0], bckgndlayerV_r[15:8], bckgndlayerV_r[23:16] } :
				(which_min_r == 5'd1)?	{bckgndlayerV_r[31:16], bckgndlayerV_r[7:0], bckgndlayerV_r[15:8]} :
							{bckgndlayerV_r};

assign ordered_bckgndlayerW = 	(which_min_r == 5'd3)? 	{bckgndlayerW_r[7:0], bckgndlayerW_r[23:8], bckgndlayerW_r[31:24] }  :
				(which_min_r == 5'd2)?	{bckgndlayerW_r[31:24], bckgndlayerW_r[7:0], bckgndlayerW_r[15:8], bckgndlayerW_r[23:16] } :
				(which_min_r == 5'd1)?	{bckgndlayerW_r[31:16], bckgndlayerW_r[7:0], bckgndlayerW_r[15:8]} :
							{bckgndlayerW_r};

					/**Threshold Decision**/
					
SegThesholdDecision SegThesholdDecision0(	
.BDthY_o(decided_BDthY), .BDthU_o(decided_BDthU), .BDthV_o(decided_BDthV), .Bth_o(decided_Bth), .update_o(decided_update), .BckGndBuildTH_o(decided_BckGndBuildTH),
.lineidx_i(lineidx_r), .pixelidx_i(pixelidx_r), 
.BDthY_default_i(BDthY_default_i), .BDthU_default_i(BDthU_default_i), .BDthV_default_i(BDthV_default_i),  .Bth_default_i(Bth_default_i), .BckGndBuildTH_default_i(BckGndBuildTH_default_i),
.box1xmax_i(box1xmax_i),  .box1ymax_i(box1ymax_i),  .box1xmin_i(box1xmin_i),  .box1ymin_i(box1ymin_i),  .BDthY_box1_i(BDthY_box1_i),  .BDthU_box1_i(BDthU_box1_i),   .BDthV_box1_i(BDthV_box1_i),   .update_box1_i(update_box1_i),   .Bth_box1_i(Bth_box1_i),  .BckGndBuildTH_box1_i(BckGndBuildTH_box1_i),
.box2xmax_i(box2xmax_i),  .box2ymax_i(box2ymax_i),  .box2xmin_i(box2xmin_i),  .box2ymin_i(box2ymin_i),  .BDthY_box2_i(BDthY_box2_i),  .BDthU_box2_i(BDthU_box2_i),   .BDthV_box2_i(BDthV_box2_i),   .update_box2_i(update_box2_i),   .Bth_box2_i(Bth_box2_i),  .BckGndBuildTH_box2_i(BckGndBuildTH_box2_i),
.box3xmax_i(box3xmax_i),  .box3ymax_i(box3ymax_i),  .box3xmin_i(box3xmin_i),  .box3ymin_i(box3ymin_i),  .BDthY_box3_i(BDthY_box3_i),  .BDthU_box3_i(BDthU_box3_i),   .BDthV_box3_i(BDthV_box3_i),   .update_box3_i(update_box3_i),   .Bth_box3_i(Bth_box3_i),  .BckGndBuildTH_box3_i(BckGndBuildTH_box3_i),
.box4xmax_i(box4xmax_i),  .box4ymax_i(box4ymax_i),  .box4xmin_i(box4xmin_i),  .box4ymin_i(box4ymin_i),  .BDthY_box4_i(BDthY_box4_i),  .BDthU_box4_i(BDthU_box4_i),   .BDthV_box4_i(BDthV_box4_i),   .update_box4_i(update_box4_i),   .Bth_box4_i(Bth_box4_i),  .BckGndBuildTH_box4_i(BckGndBuildTH_box4_i),
.box5xmax_i(box5xmax_i),  .box5ymax_i(box5ymax_i),  .box5xmin_i(box5xmin_i),  .box5ymin_i(box5ymin_i),  .BDthY_box5_i(BDthY_box5_i),  .BDthU_box5_i(BDthU_box5_i),   .BDthV_box5_i(BDthV_box5_i),   .update_box5_i(update_box5_i),   .Bth_box5_i(Bth_box5_i),  .BckGndBuildTH_box5_i(BckGndBuildTH_box5_i),
.box6xmax_i(box6xmax_i),  .box6ymax_i(box6ymax_i),  .box6xmin_i(box6xmin_i),  .box6ymin_i(box6ymin_i),  .BDthY_box6_i(BDthY_box6_i),  .BDthU_box6_i(BDthU_box6_i),   .BDthV_box6_i(BDthV_box6_i),   .update_box6_i(update_box6_i),   .Bth_box6_i(Bth_box6_i),  .BckGndBuildTH_box6_i(BckGndBuildTH_box6_i),
.box7xmax_i(box7xmax_i),  .box7ymax_i(box7ymax_i),  .box7xmin_i(box7xmin_i),  .box7ymin_i(box7ymin_i),  .BDthY_box7_i(BDthY_box7_i),  .BDthU_box7_i(BDthU_box7_i),   .BDthV_box7_i(BDthV_box7_i),   .update_box7_i(update_box7_i),   .Bth_box7_i(Bth_box7_i),  .BckGndBuildTH_box7_i(BckGndBuildTH_box7_i),
.box8xmax_i(box8xmax_i),  .box8ymax_i(box8ymax_i),  .box8xmin_i(box8xmin_i),  .box8ymin_i(box8ymin_i),  .BDthY_box8_i(BDthY_box8_i),  .BDthU_box8_i(BDthU_box8_i),   .BDthV_box8_i(BDthV_box8_i),   .update_box8_i(update_box8_i),   .Bth_box8_i(Bth_box8_i),  .BckGndBuildTH_box8_i(BckGndBuildTH_box8_i),
.box9xmax_i(box9xmax_i),  .box9ymax_i(box9ymax_i),  .box9xmin_i(box9xmin_i),  .box9ymin_i(box9ymin_i),  .BDthY_box9_i(BDthY_box9_i),  .BDthU_box9_i(BDthU_box9_i),   .BDthV_box9_i(BDthV_box9_i),   .update_box9_i(update_box9_i),   .Bth_box9_i(Bth_box9_i),  .BckGndBuildTH_box9_i(BckGndBuildTH_box9_i),
.box10xmax_i(box10xmax_i),.box10ymax_i(box10ymax_i),.box10xmin_i(box10xmin_i),.box10ymin_i(box10ymin_i),.BDthY_box10_i(BDthY_box10_i),.BDthU_box10_i(BDthU_box10_i), .BDthV_box10_i(BDthV_box10_i), .update_box10_i(update_box10_i), .Bth_box10_i(Bth_box10_i),.BckGndBuildTH_box10_i(BckGndBuildTH_box10_i)
);
	
					
							
					/**Segmentation Core Processing**/
SegCore	SegCore0( 
                .BDthY_i(decided_BDthY), 
                .BDthU_i(decided_BDthU), 
                .BDthV_i(decided_BDthV), 
                .Bth_i(decided_Bth), 
                .update_i(decided_update), 
                .BckGndBuildTH_i(decided_BckGndBuildTH),                                          
                .curpixelY_i(curpixelY_r), 
                .curpixelU_i(curpixelU_r), 
                .curpixelV_i(curpixelV_r), 
                .bckgndlayerY_i(ordered_bckgndlayerY), 
                .bckgndlayerU_i(ordered_bckgndlayerU),  
                .bckgndlayerV_i(ordered_bckgndlayerV),  
                .bckgndlayerW_i(ordered_bckgndlayerW),
                .updatedbckgndlayerY_o(updatedbckgndlayerY_w),
                .updatedbckgndlayerU_o(updatedbckgndlayerU_w),
                .updatedbckgndlayerV_o(updatedbckgndlayerV_w),
                .updatedbckgndlayerW_o(updatedbckgndlayerW_w),
                .mask_o(mask_w)  
);   
			
			
			
			
				
					/**output stage**/                                             
                                                             

assign updatedbckgndlayerY_o    =       updatedbckgndlayerY_r   ;
assign updatedbckgndlayerU_o    =       updatedbckgndlayerU_r   ;
assign updatedbckgndlayerV_o    =       updatedbckgndlayerV_r   ;
assign updatedbckgndlayerW_o    =       updatedbckgndlayerW_r   ;
assign mask_o           =       mask_r          ;



assign updatedbckgndlayerY_ws   = (stall)?	updatedbckgndlayerY_r: updatedbckgndlayerY_w;
assign updatedbckgndlayerU_ws   = (stall)?	updatedbckgndlayerU_r: updatedbckgndlayerU_w;
assign updatedbckgndlayerV_ws   = (stall)?	updatedbckgndlayerV_r: updatedbckgndlayerV_w;
assign updatedbckgndlayerW_ws   = (stall)?	updatedbckgndlayerW_r: updatedbckgndlayerW_w;
assign mask_ws  		= (stall)?	mask_r               : mask_w               ;                
always@(posedge clk or posedge reset)
begin                
   if(reset)         
   begin
        updatedbckgndlayerY_r   <=32'd0 ;                        
        updatedbckgndlayerU_r   <=32'd0 ;
        updatedbckgndlayerV_r   <=32'd0 ;                        
        updatedbckgndlayerW_r   <=32'd0 ;
        mask_r                  <=1'b0  ;                        
   end               
   else if (ctrl_gateCLK)
   begin             
        updatedbckgndlayerY_r   <=      updatedbckgndlayerY_ws   ;
        updatedbckgndlayerU_r   <=      updatedbckgndlayerU_ws   ;
        updatedbckgndlayerV_r   <=      updatedbckgndlayerV_ws   ;
        updatedbckgndlayerW_r   <=      updatedbckgndlayerW_ws   ;
        mask_r                  <=      mask_ws  ;             
   end                 
end           













endmodule       