//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from LAB421 NTU
//    (C) COPYRIGHT 2009-2012 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from  LAB421 NTU
//  
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name          : SegCore.v,v
//  File Revision      : 1.0
//  
//  Release Information : 
//  
//  ----------------------------------------------------------------------------
//  Purpose            : perform the background matching, update and foreground decision of a SINGLE pixel
//                       the thresholds (BDthY, BDthU, BDthV, Bth, update, BckGndBuildTH,) should be decided 
//                       before the processing and used as input in this module
//  --========================================================================--



module SegCore(
                //clk_i,
                //reset_i,
                //start_i,              
                //ctrl_gateCLK_i, 
                //stall_i,
                
                //lineidx_i, 
                //pixelidx_i,
                //MinWeightLayer, 
                BDthY_i, 
                BDthU_i, 
                BDthV_i, 
                Bth_i, 
                update_i, 
                BckGndBuildTH_i,                                          
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
                
//input clk_i;                     
//input reset_i;                 
//input start_i;                     
//input ctrl_gateCLK_i;            
//input stall_i;                   
                         
//input [15:0] lineidx_i;                 
//input [15:0] pixelidx_i;                
//input [3:0] MinWeightLayer;      //maximum 16 layers of background, 
                                   //but it is assumed that the minimal weight layer of background is already switched to the last position 
input [7:0] BDthY_i;                   
input [7:0] BDthU_i;                   
input [7:0] BDthV_i;                   
input [7:0] Bth_i;                     
input update_i;                  
input [7:0] BckGndBuildTH_i;                    
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

//Reg and Wire
wire [7:0] AbsDifflayer0Y;
wire [7:0] AbsDifflayer0U;
wire [7:0] AbsDifflayer0V;
wire [7:0] AbsDifflayer1Y;
wire [7:0] AbsDifflayer1U;
wire [7:0] AbsDifflayer1V;
wire [7:0] AbsDifflayer2Y;
wire [7:0] AbsDifflayer2U;
wire [7:0] AbsDifflayer2V;
wire [7:0] AbsDifflayer3Y;
wire [7:0] AbsDifflayer3U;
wire [7:0] AbsDifflayer3V;
wire Lay0Matched;
wire Lay1Matched;
wire Lay2Matched;
wire Lay3Matched;
wire [7:0] updatedlayer0Y;          
wire [7:0] updatedlayer0U;
wire [7:0] updatedlayer0V;
wire [7:0] updatedlayer1Y;
wire [7:0] updatedlayer1U;
wire [7:0] updatedlayer1V;
wire [7:0] updatedlayer2Y;
wire [7:0] updatedlayer2U;
wire [7:0] updatedlayer2V;
wire [7:0] updatedlayer3Y;
wire [7:0] updatedlayer3U;
wire [7:0] updatedlayer3V;
wire [7:0] updatedlayer0WINC;
wire [7:0] updatedlayer1WINC;
wire [7:0] updatedlayer2WINC;
wire [7:0] updatedlayer3WINC;
wire [7:0] updatedlayer0WDEC;
wire [7:0] updatedlayer1WDEC;
wire [7:0] updatedlayer2WDEC;
wire [7:0] updatedlayer3WDEC;
wire [31:0] updatedbckgndlayerY_w;
wire [31:0] updatedbckgndlayerU_w;
wire [31:0] updatedbckgndlayerV_w;
wire [31:0] updatedbckgndlayerW_w;




               
wire mask_w  ;   
wire [15:0] lineidx_w1    ;
wire [15:0] pixelidx_w1   ;
wire [7:0]  BDthY_w1      ;
wire [7:0]  BDthU_w1      ;
wire [7:0]  BDthV_w1      ;
wire [7:0]  Bth_w1        ;
wire update_w1            ;
wire [7:0] BckGndBuildTH_w1   ;
wire [7:0] curpixelY_w1       ;
wire [7:0] curpixelU_w1       ;
wire [7:0] curpixelV_w1       ;
wire [31:0] bckgndlayerY_w1   ;
wire [31:0] bckgndlayerU_w1   ;
wire [31:0] bckgndlayerV_w1   ;
wire [31:0] bckgndlayerW_w1   ;
wire [31:0]  updatedbckgndlayerY_w1   ;
wire [31:0]  updatedbckgndlayerU_w1   ;
wire [31:0]  updatedbckgndlayerV_w1   ;
wire [31:0]  updatedbckgndlayerW_w1   ;
wire mask_w1  ;                

							/**Input stage**/ 
           						//No input register
           						
           						
           						
                                                        /**Matching**/


assign AbsDifflayer0Y = (curpixelY_i > bckgndlayerY_i[7:0])?    (curpixelY_i - bckgndlayerY_i[7:0]):    (bckgndlayerY_i[7:0] - curpixelY_i);
assign AbsDifflayer0U = (curpixelU_i > bckgndlayerU_i[7:0])?    (curpixelU_i - bckgndlayerU_i[7:0]):    (bckgndlayerU_i[7:0] - curpixelU_i);
assign AbsDifflayer0V = (curpixelV_i > bckgndlayerV_i[7:0])?    (curpixelV_i - bckgndlayerV_i[7:0]):    (bckgndlayerV_i[7:0] - curpixelV_i);
assign AbsDifflayer1Y = (curpixelY_i > bckgndlayerY_i[15:8])?   (curpixelY_i - bckgndlayerY_i[15:8]):   (bckgndlayerY_i[15:8] - curpixelY_i);
assign AbsDifflayer1U = (curpixelU_i > bckgndlayerU_i[15:8])?   (curpixelU_i - bckgndlayerU_i[15:8]):   (bckgndlayerU_i[15:8] - curpixelU_i);
assign AbsDifflayer1V = (curpixelV_i > bckgndlayerV_i[15:8])?   (curpixelV_i - bckgndlayerV_i[15:8]):   (bckgndlayerV_i[15:8] - curpixelV_i);
assign AbsDifflayer2Y = (curpixelY_i > bckgndlayerY_i[23:16])?  (curpixelY_i - bckgndlayerY_i[23:16]):  (bckgndlayerY_i[23:16] - curpixelY_i);
assign AbsDifflayer2U = (curpixelU_i > bckgndlayerU_i[23:16])?  (curpixelU_i - bckgndlayerU_i[23:16]):  (bckgndlayerU_i[23:16] - curpixelU_i);
assign AbsDifflayer2V = (curpixelV_i > bckgndlayerV_i[23:16])?  (curpixelV_i - bckgndlayerV_i[23:16]):  (bckgndlayerV_i[23:16] - curpixelV_i);
assign AbsDifflayer3Y = (curpixelY_i > bckgndlayerY_i[31:24])?  (curpixelY_i - bckgndlayerY_i[31:24]):  (bckgndlayerY_i[31:24] - curpixelY_i);
assign AbsDifflayer3U = (curpixelU_i > bckgndlayerU_i[31:24])?  (curpixelU_i - bckgndlayerU_i[31:24]):  (bckgndlayerU_i[31:24] - curpixelU_i);
assign AbsDifflayer3V = (curpixelV_i > bckgndlayerV_i[31:24])?  (curpixelV_i - bckgndlayerV_i[31:24]):  (bckgndlayerV_i[31:24] - curpixelV_i);
        
assign Lay0Matched = ( (AbsDifflayer0Y < BDthY_i) &&  (AbsDifflayer0U < BDthU_i) && (AbsDifflayer0V < BDthV_i) )? 1'b1  : 1'b0;
assign Lay1Matched = ( (AbsDifflayer1Y < BDthY_i) &&  (AbsDifflayer1U < BDthU_i) && (AbsDifflayer1V < BDthV_i) )? 1'b1  : 1'b0;
assign Lay2Matched = ( (AbsDifflayer2Y < BDthY_i) &&  (AbsDifflayer2U < BDthU_i) && (AbsDifflayer2V < BDthV_i) )? 1'b1  : 1'b0;
assign Lay3Matched = ( (AbsDifflayer3Y < BDthY_i) &&  (AbsDifflayer3U < BDthU_i) && (AbsDifflayer3V < BDthV_i) )? 1'b1  : 1'b0;



                                                /**Foreground Decision**/
assign mask_w = ( (Lay0Matched&&(bckgndlayerW_i[7:0] > Bth_i) ) || (Lay1Matched&&(bckgndlayerW_i[15:8] > Bth_i)) || (Lay2Matched&&(bckgndlayerW_i[23:16] > Bth_i)) || (Lay3Matched&&(bckgndlayerW_i[31:24] > Bth_i)) )? 1'b0 : 1'b1;
                 
     



                                                /**Backgnd Update**/

//check below!!  overflow?
assign updatedlayer0Y = (curpixelY_i > bckgndlayerY_i[7:0])?    bckgndlayerY_i[7:0] + 1'b1      : 
                        (curpixelY_i < bckgndlayerY_i[7:0])?    bckgndlayerY_i[7:0] - 1'b1      :
                                                                bckgndlayerY_i[7:0]             ;       
assign updatedlayer0U = (curpixelU_i > bckgndlayerU_i[7:0])?    bckgndlayerU_i[7:0] + 1'b1      : 
                        (curpixelU_i < bckgndlayerU_i[7:0])?    bckgndlayerU_i[7:0] - 1'b1      :
                                                                bckgndlayerU_i[7:0]             ;               
assign updatedlayer0V = (curpixelV_i > bckgndlayerV_i[7:0]) ?   bckgndlayerV_i[7:0] + 1'b1      : 
                        (curpixelV_i < bckgndlayerV_i[7:0]) ?   bckgndlayerV_i[7:0] - 1'b1      :
                                                                bckgndlayerV_i[7:0]             ;       
assign updatedlayer1Y = (curpixelY_i > bckgndlayerY_i[15:8])?   bckgndlayerY_i[15:8] + 1'b1     : 
                        (curpixelY_i < bckgndlayerY_i[15:8])?   bckgndlayerY_i[15:8] - 1'b1     :
                                                                bckgndlayerY_i[15:8]            ; 
assign updatedlayer1U = (curpixelU_i > bckgndlayerU_i[15:8])?   bckgndlayerU_i[15:8] + 1'b1     : 
                        (curpixelU_i < bckgndlayerU_i[15:8])?   bckgndlayerU_i[15:8] - 1'b1     :
                                                                bckgndlayerU_i[15:8]            ; 
assign updatedlayer1V = (curpixelV_i > bckgndlayerV_i[15:8])?   bckgndlayerV_i[15:8] + 1'b1     : 
                        (curpixelV_i < bckgndlayerV_i[15:8])?   bckgndlayerV_i[15:8] - 1'b1     :
                                                                bckgndlayerV_i[15:8]            ; 
assign updatedlayer2Y = (curpixelY_i > bckgndlayerY_i[23:16])?  bckgndlayerY_i[23:16] + 1'b1    : 
                        (curpixelY_i < bckgndlayerY_i[23:16])?  bckgndlayerY_i[23:16] - 1'b1    :
                                                                bckgndlayerY_i[23:16]           ;
assign updatedlayer2U = (curpixelU_i > bckgndlayerU_i[23:16])?  bckgndlayerU_i[23:16] + 1'b1    : 
                        (curpixelU_i < bckgndlayerU_i[23:16])?  bckgndlayerU_i[23:16] - 1'b1    :
                                                                bckgndlayerU_i[23:16]           ;
assign updatedlayer2V = (curpixelV_i > bckgndlayerV_i[23:16])?  bckgndlayerV_i[23:16] + 1'b1    : 
                        (curpixelV_i < bckgndlayerV_i[23:16])?  bckgndlayerV_i[23:16] - 1'b1    :
                                                                bckgndlayerV_i[23:16]           ;
assign updatedlayer3Y = (curpixelY_i > bckgndlayerY_i[31:24])?  bckgndlayerY_i[31:24] + 1'b1    : 
                        (curpixelY_i < bckgndlayerY_i[31:24])?  bckgndlayerY_i[31:24] - 1'b1    :
                                                                bckgndlayerY_i[31:24]           ;
assign updatedlayer3U = (curpixelU_i > bckgndlayerU_i[31:24])?  bckgndlayerU_i[31:24] + 1'b1    : 
                        (curpixelU_i < bckgndlayerU_i[31:24])?  bckgndlayerU_i[31:24] - 1'b1    :
                                                                bckgndlayerU_i[31:24]           ;
assign updatedlayer3V = (curpixelV_i > bckgndlayerV_i[31:24])?  bckgndlayerV_i[31:24] + 1'b1    : 
                        (curpixelV_i < bckgndlayerV_i[31:24])?  bckgndlayerV_i[31:24] - 1'b1    :
                                                                bckgndlayerV_i[31:24]           ;
                                                                
assign updatedlayer0WINC = (bckgndlayerW_i[7:0] < (8'd255 - BckGndBuildTH_i))? bckgndlayerW_i[7:0] + BckGndBuildTH_i    :
                                                                          bckgndlayerW_i[7:0];
assign updatedlayer1WINC = (bckgndlayerW_i[15:8] < (8'd255 - BckGndBuildTH_i))? bckgndlayerW_i[15:8] + BckGndBuildTH_i  :
                                                                          bckgndlayerW_i[15:8];
assign updatedlayer2WINC = (bckgndlayerW_i[23:16] < (8'd255 - BckGndBuildTH_i))? bckgndlayerW_i[23:16] + BckGndBuildTH_i        :
                                                                          bckgndlayerW_i[23:16];
assign updatedlayer3WINC = (bckgndlayerW_i[31:24] < (8'd255 - BckGndBuildTH_i))? bckgndlayerW_i[31:24] + BckGndBuildTH_i        :
                                                                          bckgndlayerW_i[31:24];

assign updatedlayer0WDEC =  bckgndlayerW_i[7:0] - 1'b1;
                          
assign updatedlayer1WDEC =  bckgndlayerW_i[15:8] - 1'b1;
                          
assign updatedlayer2WDEC =  bckgndlayerW_i[23:16] - 1'b1;
                          
assign updatedlayer3WDEC =  bckgndlayerW_i[31:24] - 1'b1;
 

//layer 3 bckgnd is easiest to be update, is this ok¡H
assign updatedbckgndlayerY_w =  ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1111 )?     {updatedlayer3Y, bckgndlayerY_i[23:0]}  : 
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1110 )?     {updatedlayer3Y, bckgndlayerY_i[23:0]}  :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1101 )?     {updatedlayer3Y, bckgndlayerY_i[23:0]}  :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1100 )?     {updatedlayer3Y, bckgndlayerY_i[23:0]}  :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1011 )?     {updatedlayer3Y, bckgndlayerY_i[23:0]}  :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1010 )?     {updatedlayer3Y, bckgndlayerY_i[23:0]}  :       
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1001 )?     {updatedlayer3Y, bckgndlayerY_i[23:0]}  :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1000 )?     {updatedlayer3Y, bckgndlayerY_i[23:0]}  :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0111 )?     {bckgndlayerY_i[31:24], updatedlayer2Y, bckgndlayerY_i[15:0]}   :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0110 )?     {bckgndlayerY_i[31:24], updatedlayer2Y, bckgndlayerY_i[15:0]}   :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0101 )?     {bckgndlayerY_i[31:24], updatedlayer2Y, bckgndlayerY_i[15:0]}   :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0100 )?     {bckgndlayerY_i[31:24], updatedlayer2Y, bckgndlayerY_i[15:0]}   :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0011 )?     {bckgndlayerY_i[31:16], updatedlayer1Y, bckgndlayerY_i[7:0]}    :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0010 )?     {bckgndlayerY_i[31:16], updatedlayer1Y, bckgndlayerY_i[7:0]}    :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0001 )?     {bckgndlayerY_i[31:8], updatedlayer0Y}  :
                                /*({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0000 )?*/     {bckgndlayerY_i[31:8], curpixelY_i};
assign updatedbckgndlayerU_w =  ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1111 )?     {updatedlayer3U, bckgndlayerU_i[23:0]}  : 
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1110 )?     {updatedlayer3U, bckgndlayerU_i[23:0]}  :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1101 )?     {updatedlayer3U, bckgndlayerU_i[23:0]}  :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1100 )?     {updatedlayer3U, bckgndlayerU_i[23:0]}  :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1011 )?     {updatedlayer3U, bckgndlayerU_i[23:0]}  :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1010 )?     {updatedlayer3U, bckgndlayerU_i[23:0]}  :       
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1001 )?     {updatedlayer3U, bckgndlayerU_i[23:0]}  :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1000 )?     {updatedlayer3U, bckgndlayerU_i[23:0]}  :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0111 )?     {bckgndlayerU_i[31:24], updatedlayer2U, bckgndlayerU_i[15:0]}   :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0110 )?     {bckgndlayerU_i[31:24], updatedlayer2U, bckgndlayerU_i[15:0]}   :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0101 )?     {bckgndlayerU_i[31:24], updatedlayer2U, bckgndlayerU_i[15:0]}   :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0100 )?     {bckgndlayerU_i[31:24], updatedlayer2U, bckgndlayerU_i[15:0]}   :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0011 )?     {bckgndlayerU_i[31:16], updatedlayer1U, bckgndlayerU_i[7:0]}    :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0010 )?     {bckgndlayerU_i[31:16], updatedlayer1U, bckgndlayerU_i[7:0]}    :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0001 )?     {bckgndlayerU_i[31:8], updatedlayer0U}  :
                                /*({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0000 )?*/     {bckgndlayerU_i[31:8], curpixelU_i};
assign updatedbckgndlayerV_w =  ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1111 )?     {updatedlayer3V, bckgndlayerV_i[23:0]}  : 
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1110 )?     {updatedlayer3V, bckgndlayerV_i[23:0]}  :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1101 )?     {updatedlayer3V, bckgndlayerV_i[23:0]}  :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1100 )?     {updatedlayer3V, bckgndlayerV_i[23:0]}  :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1011 )?     {updatedlayer3V, bckgndlayerV_i[23:0]}  :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1010 )?     {updatedlayer3V, bckgndlayerV_i[23:0]}  :       
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1001 )?     {updatedlayer3V, bckgndlayerV_i[23:0]}  :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1000 )?     {updatedlayer3V, bckgndlayerV_i[23:0]}  :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0111 )?     {bckgndlayerV_i[31:24], updatedlayer2V, bckgndlayerV_i[15:0]}   :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0110 )?     {bckgndlayerV_i[31:24], updatedlayer2V, bckgndlayerV_i[15:0]}   :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0101 )?     {bckgndlayerV_i[31:24], updatedlayer2V, bckgndlayerV_i[15:0]}   :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0100 )?     {bckgndlayerV_i[31:24], updatedlayer2V, bckgndlayerV_i[15:0]}   :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0011 )?     {bckgndlayerV_i[31:16], updatedlayer1V, bckgndlayerV_i[7:0]}    :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0010 )?     {bckgndlayerV_i[31:16], updatedlayer1V, bckgndlayerV_i[7:0]}    :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0001 )?     {bckgndlayerV_i[31:8], updatedlayer0V}  :
                                /*({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0000 )?*/     {bckgndlayerV_i[31:8], curpixelV_i};
assign updatedbckgndlayerW_w =  ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1111 )?     {updatedlayer3WINC, updatedlayer2WDEC, updatedlayer1WDEC, updatedlayer0WDEC}    :       
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1110 )?     {updatedlayer3WINC, updatedlayer2WDEC, updatedlayer1WDEC, updatedlayer0WDEC}    :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1101 )?     {updatedlayer3WINC, updatedlayer2WDEC, updatedlayer1WDEC, updatedlayer0WDEC}    :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1100 )?     {updatedlayer3WINC, updatedlayer2WDEC, updatedlayer1WDEC, updatedlayer0WDEC}    :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1011 )?     {updatedlayer3WINC, updatedlayer2WDEC, updatedlayer1WDEC, updatedlayer0WDEC}    :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1010 )?     {updatedlayer3WINC, updatedlayer2WDEC, updatedlayer1WDEC, updatedlayer0WDEC}    :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1001 )?     {updatedlayer3WINC, updatedlayer2WDEC, updatedlayer1WDEC, updatedlayer0WDEC}    :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b1000 )?     {updatedlayer3WINC, updatedlayer2WDEC, updatedlayer1WDEC, updatedlayer0WDEC}    :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0111 )?     {updatedlayer3WDEC, updatedlayer2WINC, updatedlayer1WDEC, updatedlayer0WDEC}    :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0110 )?     {updatedlayer3WDEC, updatedlayer2WINC, updatedlayer1WDEC, updatedlayer0WDEC}    :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0101 )?     {updatedlayer3WDEC, updatedlayer2WINC, updatedlayer1WDEC, updatedlayer0WDEC}    :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0100 )?     {updatedlayer3WDEC, updatedlayer2WINC, updatedlayer1WDEC, updatedlayer0WDEC}    :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0011 )?     {updatedlayer3WDEC, updatedlayer2WDEC, updatedlayer1WINC, updatedlayer0WDEC}    :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0010 )?     {updatedlayer3WDEC, updatedlayer2WDEC, updatedlayer1WINC, updatedlayer0WDEC}    :
                                ({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0001 )?     {updatedlayer3WDEC, updatedlayer2WDEC, updatedlayer1WDEC, updatedlayer0WINC}    :
                                /*({Lay3Matched, Lay2Matched, Lay1Matched, Lay0Matched} == 4'b0000 )?*/     {updatedlayer3WDEC, updatedlayer2WDEC, updatedlayer1WDEC, 8'd0};

assign updatedbckgndlayerY_w1 = (update_i)? updatedbckgndlayerY_w:	bckgndlayerY_i	;
assign updatedbckgndlayerU_w1 = (update_i)? updatedbckgndlayerU_w:	bckgndlayerU_i	;
assign updatedbckgndlayerV_w1 = (update_i)? updatedbckgndlayerV_w:	bckgndlayerV_i	;
assign updatedbckgndlayerW_w1 = (update_i)? updatedbckgndlayerW_w:	bckgndlayerW_i	;
 
            
							/*output Stage*/
assign updatedbckgndlayerY_o    =       updatedbckgndlayerY_w1   ;
assign updatedbckgndlayerU_o    =       updatedbckgndlayerU_w1   ;
assign updatedbckgndlayerV_o    =       updatedbckgndlayerV_w1   ;
assign updatedbckgndlayerW_o    =       updatedbckgndlayerW_w1   ;
assign mask_o           =       mask_w          ;


endmodule
