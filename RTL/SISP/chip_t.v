//用來加pad
//將synthesis後的.v檔一起合   將synthesis後的.v檔做don't care
//這是tsmc18版本


module CHIP(clk, reset, stall, ctrl_gateCLK, buffer_input_stop_i, 
        reset_register_i, reset_buffer_i, Address_from_DMA_i, 
        choose_reg_from_DMA_i, WEAN_from_DMA_i, MUXA_from_DMA_i, DataIn_i, 
        DataInReady_i, ContextRegAddr_i, seg_enable_i, seg_stall, DataOut_o, 
        DataOutReady_o);
  input [3:0] Address_from_DMA_i;
  input [5:0] choose_reg_from_DMA_i;
  input [3:0] MUXA_from_DMA_i;
  input [63:0] DataIn_i;
  input [7:0] ContextRegAddr_i;
  output [63:0] DataOut_o;
  input clk, reset, stall, ctrl_gateCLK, buffer_input_stop_i, reset_register_i,
         reset_buffer_i, WEAN_from_DMA_i, DataInReady_i, seg_enable_i,
         seg_stall;
  output DataOutReady_o;  
  
  wire [3:0] PI_Address_from_DMA_i;
  wire [5:0] PI_choose_reg_from_DMA_i;
  wire [3:0] PI_MUXA_from_DMA_i;
  wire [63:0] PI_DataIn_i;
  wire [7:0] PI_ContextRegAddr_i;
  wire  [63:0] PO_DataOut_o;
  wire PI_clk, PI_reset, PI_stall, PI_ctrl_gateCLK, PI_buffer_input_stop_i, PI_reset_register_i,
  wire  PI_reset_buffer_i, PI_WEAN_from_DMA_i, PI_DataInReady_i, PI_seg_enable_i,
  wire  PI_seg_stall;
  wire  PO_DataOutReady_o;
  
  PDIDGZ ipad_clk                      (.PAD(clk), .C(PI_clk));
  PDIDGZ ipad_reset                    (.PAD(reset), .C(PI_reset));
  PDIDGZ ipad_stall                    (.PAD(stall), .C(PI_stall));
  PDIDGZ ipad_ctrl_gateCLK             (.PAD(ctrl_gateCLK), .C(PI_ctrl_gateCLK));
  PDIDGZ ipad_buffer_input_stop_i      (.PAD(buffer_input_stop_i), .C(PI_buffer_input_stop_i));
  PDIDGZ ipad_reset_register_i         (.PAD(reset_register_i), .C(PI_reset_register_i));
  PDIDGZ ipad_reset_buffer_i           (.PAD(reset_buffer_i), .C(PI_reset_buffer_i));
  PDIDGZ ipad_WEAN_from_DMA_i          (.PAD(WEAN_from_DMA_i), .C(PI_WEAN_from_DMA_i));
  PDIDGZ ipad_DataInReady_i            (.PAD(DataInReady_i), .C(PI_DataInReady_i));
  PDIDGZ ipad_seg_enable_i             (.PAD(seg_enable_i), .C(PI_seg_enable_i));
  PDIDGZ ipad_seg_stall                (.PAD(seg_stall), .C(PI_seg_stall));
  PDIDGZ ipad_Address_from_DMA_i0      (.PAD(Address_from_DMA_i[0]), .C(PI_Address_from_DMA_i[0]));
  PDIDGZ ipad_Address_from_DMA_i1      (.PAD(Address_from_DMA_i[1]), .C(PI_Address_from_DMA_i[1]));
  PDIDGZ ipad_Address_from_DMA_i2      (.PAD(Address_from_DMA_i[2]), .C(PI_Address_from_DMA_i[2]));
  PDIDGZ ipad_Address_from_DMA_i3      (.PAD(Address_from_DMA_i[3]), .C(PI_Address_from_DMA_i[3]));
  PDIDGZ ipad_choose_reg_from_DMA_i0   (.PAD(choose_reg_from_DMA_i[0]), .C(PI_choose_reg_from_DMA_i[0]));
  PDIDGZ ipad_choose_reg_from_DMA_i1   (.PAD(choose_reg_from_DMA_i[1]), .C(PI_choose_reg_from_DMA_i[1]));
  PDIDGZ ipad_choose_reg_from_DMA_i2   (.PAD(choose_reg_from_DMA_i[2]), .C(PI_choose_reg_from_DMA_i[2]));
  PDIDGZ ipad_choose_reg_from_DMA_i3   (.PAD(choose_reg_from_DMA_i[3]), .C(PI_choose_reg_from_DMA_i[3]));
  PDIDGZ ipad_choose_reg_from_DMA_i4   (.PAD(choose_reg_from_DMA_i[4]), .C(PI_choose_reg_from_DMA_i[4]));
  PDIDGZ ipad_choose_reg_from_DMA_i5   (.PAD(choose_reg_from_DMA_i[5]), .C(PI_choose_reg_from_DMA_i[5]));
  PDIDGZ ipad_MUXA_from_DMA_i0         (.PAD(MUXA_from_DMA_i[0]), .C(PI_MUXA_from_DMA_i[0]));
  PDIDGZ ipad_MUXA_from_DMA_i1         (.PAD(MUXA_from_DMA_i[1]), .C(PI_MUXA_from_DMA_i[1]));
  PDIDGZ ipad_MUXA_from_DMA_i2         (.PAD(MUXA_from_DMA_i[2]), .C(PI_MUXA_from_DMA_i[2]));
  PDIDGZ ipad_MUXA_from_DMA_i3         (.PAD(MUXA_from_DMA_i[3]), .C(PI_MUXA_from_DMA_i[3]));
  PDIDGZ ipad_DataIn_i00               (.PAD(DataIn_i[00]), .C(PI_DataIn_i[00]));
  PDIDGZ ipad_DataIn_i01               (.PAD(DataIn_i[01]), .C(PI_DataIn_i[01]));
  PDIDGZ ipad_DataIn_i02               (.PAD(DataIn_i[02]), .C(PI_DataIn_i[02]));
  PDIDGZ ipad_DataIn_i03               (.PAD(DataIn_i[03]), .C(PI_DataIn_i[03]));
  PDIDGZ ipad_DataIn_i04               (.PAD(DataIn_i[04]), .C(PI_DataIn_i[04]));
  PDIDGZ ipad_DataIn_i05               (.PAD(DataIn_i[05]), .C(PI_DataIn_i[05]));
  PDIDGZ ipad_DataIn_i06               (.PAD(DataIn_i[06]), .C(PI_DataIn_i[06]));
  PDIDGZ ipad_DataIn_i07               (.PAD(DataIn_i[07]), .C(PI_DataIn_i[07]));
  PDIDGZ ipad_DataIn_i08               (.PAD(DataIn_i[08]), .C(PI_DataIn_i[08]));
  PDIDGZ ipad_DataIn_i09               (.PAD(DataIn_i[09]), .C(PI_DataIn_i[09]));
  PDIDGZ ipad_DataIn_i10               (.PAD(DataIn_i[10]), .C(PI_DataIn_i[10]));
  PDIDGZ ipad_DataIn_i11               (.PAD(DataIn_i[11]), .C(PI_DataIn_i[11]));
  PDIDGZ ipad_DataIn_i12               (.PAD(DataIn_i[12]), .C(PI_DataIn_i[12]));
  PDIDGZ ipad_DataIn_i13               (.PAD(DataIn_i[13]), .C(PI_DataIn_i[13]));
  PDIDGZ ipad_DataIn_i14               (.PAD(DataIn_i[14]), .C(PI_DataIn_i[14]));
  PDIDGZ ipad_DataIn_i15               (.PAD(DataIn_i[15]), .C(PI_DataIn_i[15]));
  PDIDGZ ipad_DataIn_i16               (.PAD(DataIn_i[16]), .C(PI_DataIn_i[16]));
  PDIDGZ ipad_DataIn_i17               (.PAD(DataIn_i[17]), .C(PI_DataIn_i[17]));
  PDIDGZ ipad_DataIn_i18               (.PAD(DataIn_i[18]), .C(PI_DataIn_i[18]));
  PDIDGZ ipad_DataIn_i19               (.PAD(DataIn_i[19]), .C(PI_DataIn_i[19]));
  PDIDGZ ipad_DataIn_i20               (.PAD(DataIn_i[20]), .C(PI_DataIn_i[20]));
  PDIDGZ ipad_DataIn_i21               (.PAD(DataIn_i[21]), .C(PI_DataIn_i[21]));
  PDIDGZ ipad_DataIn_i22               (.PAD(DataIn_i[22]), .C(PI_DataIn_i[22]));
  PDIDGZ ipad_DataIn_i23               (.PAD(DataIn_i[23]), .C(PI_DataIn_i[23]));
  PDIDGZ ipad_DataIn_i24               (.PAD(DataIn_i[24]), .C(PI_DataIn_i[24]));
  PDIDGZ ipad_DataIn_i25               (.PAD(DataIn_i[25]), .C(PI_DataIn_i[25]));
  PDIDGZ ipad_DataIn_i26               (.PAD(DataIn_i[26]), .C(PI_DataIn_i[26]));
  PDIDGZ ipad_DataIn_i27               (.PAD(DataIn_i[27]), .C(PI_DataIn_i[27]));
  PDIDGZ ipad_DataIn_i28               (.PAD(DataIn_i[28]), .C(PI_DataIn_i[28]));
  PDIDGZ ipad_DataIn_i29               (.PAD(DataIn_i[29]), .C(PI_DataIn_i[29]));
  PDIDGZ ipad_DataIn_i30               (.PAD(DataIn_i[30]), .C(PI_DataIn_i[30]));
  PDIDGZ ipad_DataIn_i31               (.PAD(DataIn_i[31]), .C(PI_DataIn_i[31]));
  PDIDGZ ipad_DataIn_i32               (.PAD(DataIn_i[32]), .C(PI_DataIn_i[32]));
  PDIDGZ ipad_DataIn_i33               (.PAD(DataIn_i[33]), .C(PI_DataIn_i[33]));
  PDIDGZ ipad_DataIn_i34               (.PAD(DataIn_i[34]), .C(PI_DataIn_i[34]));
  PDIDGZ ipad_DataIn_i35               (.PAD(DataIn_i[35]), .C(PI_DataIn_i[35]));
  PDIDGZ ipad_DataIn_i36               (.PAD(DataIn_i[36]), .C(PI_DataIn_i[36]));
  PDIDGZ ipad_DataIn_i37               (.PAD(DataIn_i[37]), .C(PI_DataIn_i[37]));
  PDIDGZ ipad_DataIn_i38               (.PAD(DataIn_i[38]), .C(PI_DataIn_i[38]));
  PDIDGZ ipad_DataIn_i39               (.PAD(DataIn_i[39]), .C(PI_DataIn_i[39]));
  PDIDGZ ipad_DataIn_i40               (.PAD(DataIn_i[40]), .C(PI_DataIn_i[40]));
  PDIDGZ ipad_DataIn_i41               (.PAD(DataIn_i[41]), .C(PI_DataIn_i[41]));
  PDIDGZ ipad_DataIn_i42               (.PAD(DataIn_i[42]), .C(PI_DataIn_i[42]));
  PDIDGZ ipad_DataIn_i43               (.PAD(DataIn_i[43]), .C(PI_DataIn_i[43]));
  PDIDGZ ipad_DataIn_i44               (.PAD(DataIn_i[44]), .C(PI_DataIn_i[44]));
  PDIDGZ ipad_DataIn_i45               (.PAD(DataIn_i[45]), .C(PI_DataIn_i[45]));
  PDIDGZ ipad_DataIn_i46               (.PAD(DataIn_i[46]), .C(PI_DataIn_i[46]));
  PDIDGZ ipad_DataIn_i47               (.PAD(DataIn_i[47]), .C(PI_DataIn_i[47]));
  PDIDGZ ipad_DataIn_i48               (.PAD(DataIn_i[48]), .C(PI_DataIn_i[48]));
  PDIDGZ ipad_DataIn_i49               (.PAD(DataIn_i[49]), .C(PI_DataIn_i[49]));
  PDIDGZ ipad_DataIn_i50               (.PAD(DataIn_i[50]), .C(PI_DataIn_i[50]));
  PDIDGZ ipad_DataIn_i51               (.PAD(DataIn_i[51]), .C(PI_DataIn_i[51]));
  PDIDGZ ipad_DataIn_i52               (.PAD(DataIn_i[52]), .C(PI_DataIn_i[52]));
  PDIDGZ ipad_DataIn_i53               (.PAD(DataIn_i[53]), .C(PI_DataIn_i[53]));
  PDIDGZ ipad_DataIn_i54               (.PAD(DataIn_i[54]), .C(PI_DataIn_i[54]));
  PDIDGZ ipad_DataIn_i55               (.PAD(DataIn_i[55]), .C(PI_DataIn_i[55]));
  PDIDGZ ipad_DataIn_i56               (.PAD(DataIn_i[56]), .C(PI_DataIn_i[56]));
  PDIDGZ ipad_DataIn_i57               (.PAD(DataIn_i[57]), .C(PI_DataIn_i[57]));
  PDIDGZ ipad_DataIn_i58               (.PAD(DataIn_i[58]), .C(PI_DataIn_i[58]));
  PDIDGZ ipad_DataIn_i59               (.PAD(DataIn_i[59]), .C(PI_DataIn_i[59]));
  PDIDGZ ipad_DataIn_i60               (.PAD(DataIn_i[60]), .C(PI_DataIn_i[60]));
  PDIDGZ ipad_DataIn_i61               (.PAD(DataIn_i[61]), .C(PI_DataIn_i[61]));
  PDIDGZ ipad_DataIn_i62               (.PAD(DataIn_i[62]), .C(PI_DataIn_i[62]));
  PDIDGZ ipad_DataIn_i63               (.PAD(DataIn_i[63]), .C(PI_DataIn_i[63]));
  PDIDGZ ipad_ContextRegAddr_i0        (.PAD(ContextRegAddr_i[0]), .C(PI_ContextRegAddr_i[0]));
  PDIDGZ ipad_ContextRegAddr_i1        (.PAD(ContextRegAddr_i[1]), .C(PI_ContextRegAddr_i[1]));
  PDIDGZ ipad_ContextRegAddr_i2        (.PAD(ContextRegAddr_i[2]), .C(PI_ContextRegAddr_i[2]));
  PDIDGZ ipad_ContextRegAddr_i3        (.PAD(ContextRegAddr_i[3]), .C(PI_ContextRegAddr_i[3]));
  PDIDGZ ipad_ContextRegAddr_i4        (.PAD(ContextRegAddr_i[4]), .C(PI_ContextRegAddr_i[4]));
  PDIDGZ ipad_ContextRegAddr_i5        (.PAD(ContextRegAddr_i[5]), .C(PI_ContextRegAddr_i[5]));
  PDIDGZ ipad_ContextRegAddr_i6        (.PAD(ContextRegAddr_i[6]), .C(PI_ContextRegAddr_i[6]));
  PDIDGZ ipad_ContextRegAddr_i7        (.PAD(ContextRegAddr_i[7]), .C(PI_ContextRegAddr_i[7]));
  

  
  PDO08CDG opad_DataOutReady_o         ( .I(PO_DataOutReady_o) ,.PAD(DataOutReady_o) );
  PDO08CDG opad_DataOut_o00            ( .I(PO_DataOut_o[00]) ,.PAD(DataOut_o[00]) );
  PDO08CDG opad_DataOut_o01            ( .I(PO_DataOut_o[01]) ,.PAD(DataOut_o[01]) );
  PDO08CDG opad_DataOut_o02            ( .I(PO_DataOut_o[02]) ,.PAD(DataOut_o[02]) );
  PDO08CDG opad_DataOut_o03            ( .I(PO_DataOut_o[03]) ,.PAD(DataOut_o[03]) );
  PDO08CDG opad_DataOut_o04            ( .I(PO_DataOut_o[04]) ,.PAD(DataOut_o[04]) );
  PDO08CDG opad_DataOut_o05            ( .I(PO_DataOut_o[05]) ,.PAD(DataOut_o[05]) );
  PDO08CDG opad_DataOut_o06            ( .I(PO_DataOut_o[06]) ,.PAD(DataOut_o[06]) );
  PDO08CDG opad_DataOut_o07            ( .I(PO_DataOut_o[07]) ,.PAD(DataOut_o[07]) );
  PDO08CDG opad_DataOut_o08            ( .I(PO_DataOut_o[08]) ,.PAD(DataOut_o[08]) );
  PDO08CDG opad_DataOut_o09            ( .I(PO_DataOut_o[09]) ,.PAD(DataOut_o[09]) );
  PDO08CDG opad_DataOut_o10            ( .I(PO_DataOut_o[10]) ,.PAD(DataOut_o[10]) );
  PDO08CDG opad_DataOut_o11            ( .I(PO_DataOut_o[11]) ,.PAD(DataOut_o[11]) );
  PDO08CDG opad_DataOut_o12            ( .I(PO_DataOut_o[12]) ,.PAD(DataOut_o[12]) );
  PDO08CDG opad_DataOut_o13            ( .I(PO_DataOut_o[13]) ,.PAD(DataOut_o[13]) );
  PDO08CDG opad_DataOut_o14            ( .I(PO_DataOut_o[14]) ,.PAD(DataOut_o[14]) );
  PDO08CDG opad_DataOut_o15            ( .I(PO_DataOut_o[15]) ,.PAD(DataOut_o[15]) );
  PDO08CDG opad_DataOut_o16            ( .I(PO_DataOut_o[16]) ,.PAD(DataOut_o[16]) );
  PDO08CDG opad_DataOut_o17            ( .I(PO_DataOut_o[17]) ,.PAD(DataOut_o[17]) );
  PDO08CDG opad_DataOut_o18            ( .I(PO_DataOut_o[18]) ,.PAD(DataOut_o[18]) );
  PDO08CDG opad_DataOut_o19            ( .I(PO_DataOut_o[19]) ,.PAD(DataOut_o[19]) );
  PDO08CDG opad_DataOut_o20            ( .I(PO_DataOut_o[20]) ,.PAD(DataOut_o[20]) );
  PDO08CDG opad_DataOut_o21            ( .I(PO_DataOut_o[21]) ,.PAD(DataOut_o[21]) );
  PDO08CDG opad_DataOut_o22            ( .I(PO_DataOut_o[22]) ,.PAD(DataOut_o[22]) );
  PDO08CDG opad_DataOut_o23            ( .I(PO_DataOut_o[23]) ,.PAD(DataOut_o[23]) );
  PDO08CDG opad_DataOut_o24            ( .I(PO_DataOut_o[24]) ,.PAD(DataOut_o[24]) );
  PDO08CDG opad_DataOut_o25            ( .I(PO_DataOut_o[25]) ,.PAD(DataOut_o[25]) );
  PDO08CDG opad_DataOut_o26            ( .I(PO_DataOut_o[26]) ,.PAD(DataOut_o[26]) );
  PDO08CDG opad_DataOut_o27            ( .I(PO_DataOut_o[27]) ,.PAD(DataOut_o[27]) );
  PDO08CDG opad_DataOut_o28            ( .I(PO_DataOut_o[28]) ,.PAD(DataOut_o[28]) );
  PDO08CDG opad_DataOut_o29            ( .I(PO_DataOut_o[29]) ,.PAD(DataOut_o[29]) );
  PDO08CDG opad_DataOut_o30            ( .I(PO_DataOut_o[30]) ,.PAD(DataOut_o[30]) );
  PDO08CDG opad_DataOut_o31            ( .I(PO_DataOut_o[31]) ,.PAD(DataOut_o[31]) );
  PDO08CDG opad_DataOut_o32            ( .I(PO_DataOut_o[32]) ,.PAD(DataOut_o[32]) );
  PDO08CDG opad_DataOut_o33            ( .I(PO_DataOut_o[33]) ,.PAD(DataOut_o[33]) );
  PDO08CDG opad_DataOut_o34            ( .I(PO_DataOut_o[34]) ,.PAD(DataOut_o[34]) );
  PDO08CDG opad_DataOut_o35            ( .I(PO_DataOut_o[35]) ,.PAD(DataOut_o[35]) );
  PDO08CDG opad_DataOut_o36            ( .I(PO_DataOut_o[36]) ,.PAD(DataOut_o[36]) );
  PDO08CDG opad_DataOut_o37            ( .I(PO_DataOut_o[37]) ,.PAD(DataOut_o[37]) );
  PDO08CDG opad_DataOut_o38            ( .I(PO_DataOut_o[38]) ,.PAD(DataOut_o[38]) );
  PDO08CDG opad_DataOut_o39            ( .I(PO_DataOut_o[39]) ,.PAD(DataOut_o[39]) );
  PDO08CDG opad_DataOut_o40            ( .I(PO_DataOut_o[40]) ,.PAD(DataOut_o[40]) );
  PDO08CDG opad_DataOut_o41            ( .I(PO_DataOut_o[41]) ,.PAD(DataOut_o[41]) );
  PDO08CDG opad_DataOut_o42            ( .I(PO_DataOut_o[42]) ,.PAD(DataOut_o[42]) );
  PDO08CDG opad_DataOut_o43            ( .I(PO_DataOut_o[43]) ,.PAD(DataOut_o[43]) );
  PDO08CDG opad_DataOut_o44            ( .I(PO_DataOut_o[44]) ,.PAD(DataOut_o[44]) );
  PDO08CDG opad_DataOut_o45            ( .I(PO_DataOut_o[45]) ,.PAD(DataOut_o[45]) );
  PDO08CDG opad_DataOut_o46            ( .I(PO_DataOut_o[46]) ,.PAD(DataOut_o[46]) );
  PDO08CDG opad_DataOut_o47            ( .I(PO_DataOut_o[47]) ,.PAD(DataOut_o[47]) );
  PDO08CDG opad_DataOut_o48            ( .I(PO_DataOut_o[48]) ,.PAD(DataOut_o[48]) );
  PDO08CDG opad_DataOut_o49            ( .I(PO_DataOut_o[49]) ,.PAD(DataOut_o[49]) );
  PDO08CDG opad_DataOut_o50            ( .I(PO_DataOut_o[50]) ,.PAD(DataOut_o[50]) );
  PDO08CDG opad_DataOut_o51            ( .I(PO_DataOut_o[51]) ,.PAD(DataOut_o[51]) );
  PDO08CDG opad_DataOut_o52            ( .I(PO_DataOut_o[52]) ,.PAD(DataOut_o[52]) );
  PDO08CDG opad_DataOut_o53            ( .I(PO_DataOut_o[53]) ,.PAD(DataOut_o[53]) );
  PDO08CDG opad_DataOut_o54            ( .I(PO_DataOut_o[54]) ,.PAD(DataOut_o[54]) );
  PDO08CDG opad_DataOut_o55            ( .I(PO_DataOut_o[55]) ,.PAD(DataOut_o[55]) );
  PDO08CDG opad_DataOut_o56            ( .I(PO_DataOut_o[56]) ,.PAD(DataOut_o[56]) );
  PDO08CDG opad_DataOut_o57            ( .I(PO_DataOut_o[57]) ,.PAD(DataOut_o[57]) );
  PDO08CDG opad_DataOut_o58            ( .I(PO_DataOut_o[58]) ,.PAD(DataOut_o[58]) );
  PDO08CDG opad_DataOut_o59            ( .I(PO_DataOut_o[59]) ,.PAD(DataOut_o[59]) );
  PDO08CDG opad_DataOut_o60            ( .I(PO_DataOut_o[60]) ,.PAD(DataOut_o[60]) );
  PDO08CDG opad_DataOut_o61            ( .I(PO_DataOut_o[61]) ,.PAD(DataOut_o[61]) );
  PDO08CDG opad_DataOut_o62            ( .I(PO_DataOut_o[62]) ,.PAD(DataOut_o[62]) );
  PDO08CDG opad_DataOut_o63            ( .I(PO_DataOut_o[63]) ,.PAD(DataOut_o[63]) );
  
   
  SISP_top S0( PI_clk, PI_reset, PI_stall, PI_ctrl_gateCLK, PI_buffer_input_stop_i, 
        PI_reset_register_i, PI_reset_buffer_i, PI_Address_from_DMA_i, 
        PI_choose_reg_from_DMA_i, PI_WEAN_from_DMA_i, PI_MUXA_from_DMA_i, PI_DataIn_i, 
        PI_DataInReady_i, PI_ContextRegAddr_i, PI_seg_enable_i, PI_seg_stall, PO_DataOut_o, 
        PO_DataOutReady_o );
     
  

endmodule