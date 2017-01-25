//用來加pad
//將synthesis後的.v檔一起合   將synthesis後的.v檔做don't care
//這是umc90版本
module CHIP(clk, reset, stall, ctrl_gateCLK, buffer_input_stop_i, 
        reset_register_i, reset_buffer_i, Address_from_DMA_i, 
        choose_reg_from_DMA_i, WEAN_from_DMA_i, MUXA_from_DMA_i, DataInOut_io, 
        DataInReady_i, ContextRegAddr_i, seg_enable_i, seg_stall,
        DataOutReady_o, WREN_i);
  input [3:0] Address_from_DMA_i;
  input [5:0] choose_reg_from_DMA_i;
  input [3:0] MUXA_from_DMA_i;
  inout [63:0] DataInOut_io;
  input [7:0] ContextRegAddr_i;
  
  
  input clk, reset, stall, ctrl_gateCLK, buffer_input_stop_i, reset_register_i,
         reset_buffer_i, WEAN_from_DMA_i, DataInReady_i, seg_enable_i,
         seg_stall;
  input       WREN_i;
  output DataOutReady_o;  
  
  wire [3:0] PI_Address_from_DMA_i;
  wire [5:0] PI_choose_reg_from_DMA_i;
  wire [3:0] PI_MUXA_from_DMA_i;
  wire [63:0] PI_DataIn_i;
  wire [7:0] PI_ContextRegAddr_i;
  wire  [63:0] PO_DataOut_o;
  wire PI_clk;
  wire PI_reset;
  wire PI_stall;
  wire PI_ctrl_gateCLK;
  wire PI_buffer_input_stop_i;
  wire PI_reset_register_i;
  wire  PI_reset_buffer_i;
  wire PI_WEAN_from_DMA_i;
  wire PI_DataInReady_i;
  wire PI_seg_enable_i;
  wire  PI_seg_stall;
  wire  PO_DataOutReady_o;
  
  wire n_128_net_0, n_132_net_0;
  wire PI_WREN_i;
  
  INVXLP I_31 ( .I(PI_WREN_i), .O(n_128_net_0) );
  INVXLP I_30 ( .I(PI_WREN_i), .O(n_132_net_0) );
  //這裡直接寫 o_128_net_0 = ~PI_WREN_i也行  net名是隨便取的  反正之後會再syn一次  
  

//接法要看手冊
XMPA    ipad_clk                      (.I(clk),                     .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_clk));
XMPA    ipad_reset                    (.I(reset),                   .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_reset));
XMPA    ipad_WREN_i                   (.I(WREN_i),                   .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_WREN_i));
XMPA    ipad_stall                    (.I(stall),                   .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_stall));
XMPA    ipad_ctrl_gateCLK             (.I(ctrl_gateCLK),            .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_ctrl_gateCLK));
XMPA    ipad_buffer_input_stop_i      (.I(buffer_input_stop_i),     .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_buffer_input_stop_i));
XMPA    ipad_reset_register_i         (.I(reset_register_i),        .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_reset_register_i));
XMPA    ipad_reset_buffer_i           (.I(reset_buffer_i),          .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_reset_buffer_i));
XMPA    ipad_WEAN_from_DMA_i          (.I(WEAN_from_DMA_i),         .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_WEAN_from_DMA_i));
XMPA    ipad_DataInReady_i            (.I(DataInReady_i),           .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_DataInReady_i));
XMPA    ipad_seg_enable_i             (.I(seg_enable_i),            .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_seg_enable_i));
XMPA    ipad_seg_stall                (.I(seg_stall),               .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_seg_stall));
XMPA    ipad_Address_from_DMA_i0      (.I(Address_from_DMA_i[0]),   .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_Address_from_DMA_i[0]));
XMPA    ipad_Address_from_DMA_i1      (.I(Address_from_DMA_i[1]),   .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_Address_from_DMA_i[1]));
XMPA    ipad_Address_from_DMA_i2      (.I(Address_from_DMA_i[2]),   .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_Address_from_DMA_i[2]));
XMPA    ipad_Address_from_DMA_i3      (.I(Address_from_DMA_i[3]),   .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_Address_from_DMA_i[3]));
XMPA    ipad_choose_reg_from_DMA_i0   (.I(choose_reg_from_DMA_i[0]),.IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_choose_reg_from_DMA_i[0]));
XMPA    ipad_choose_reg_from_DMA_i1   (.I(choose_reg_from_DMA_i[1]),.IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_choose_reg_from_DMA_i[1]));
XMPA    ipad_choose_reg_from_DMA_i2   (.I(choose_reg_from_DMA_i[2]),.IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_choose_reg_from_DMA_i[2]));
XMPA    ipad_choose_reg_from_DMA_i3   (.I(choose_reg_from_DMA_i[3]),.IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_choose_reg_from_DMA_i[3]));
XMPA    ipad_choose_reg_from_DMA_i4   (.I(choose_reg_from_DMA_i[4]),.IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_choose_reg_from_DMA_i[4]));
XMPA    ipad_choose_reg_from_DMA_i5   (.I(choose_reg_from_DMA_i[5]),.IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_choose_reg_from_DMA_i[5]));
XMPA    ipad_MUXA_from_DMA_i0         (.I(MUXA_from_DMA_i[0]),      .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_MUXA_from_DMA_i[0]));
XMPA    ipad_MUXA_from_DMA_i1         (.I(MUXA_from_DMA_i[1]),      .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_MUXA_from_DMA_i[1]));
XMPA    ipad_MUXA_from_DMA_i2         (.I(MUXA_from_DMA_i[2]),      .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_MUXA_from_DMA_i[2]));
XMPA    ipad_MUXA_from_DMA_i3         (.I(MUXA_from_DMA_i[3]),      .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_MUXA_from_DMA_i[3]));
XMPA    ipad_ContextRegAddr_i0        (.I(ContextRegAddr_i[0]),     .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_ContextRegAddr_i[0]));
XMPA    ipad_ContextRegAddr_i1        (.I(ContextRegAddr_i[1]),     .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_ContextRegAddr_i[1]));
XMPA    ipad_ContextRegAddr_i2        (.I(ContextRegAddr_i[2]),     .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_ContextRegAddr_i[2]));
XMPA    ipad_ContextRegAddr_i3        (.I(ContextRegAddr_i[3]),     .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_ContextRegAddr_i[3]));
XMPA    ipad_ContextRegAddr_i4        (.I(ContextRegAddr_i[4]),     .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_ContextRegAddr_i[4]));
XMPA    ipad_ContextRegAddr_i5        (.I(ContextRegAddr_i[5]),     .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_ContextRegAddr_i[5]));
XMPA    ipad_ContextRegAddr_i6        (.I(ContextRegAddr_i[6]),     .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_ContextRegAddr_i[6]));
XMPA    ipad_ContextRegAddr_i7        (.I(ContextRegAddr_i[7]),     .IE(1'b1),   .PU(1'b0), .PD(1'b0), .SMT(1'b0), .O(PI_ContextRegAddr_i[7]));


                                               


ZMP0CBA opad_DataOutReady_o         ( .I(PO_DataOutReady_o) , .E(1'b1), .IE(1'b0), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataOutReady_o) );
ZMP0CBA iopad_DataInOut_o00         ( .O(PI_DataIn_i[00]), .I(PO_DataOut_o[00])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[00]) );
ZMP0CBA iopad_DataInOut_o01         ( .O(PI_DataIn_i[01]), .I(PO_DataOut_o[01])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[01]) );
ZMP0CBA iopad_DataInOut_o02         ( .O(PI_DataIn_i[02]), .I(PO_DataOut_o[02])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[02]) );
ZMP0CBA iopad_DataInOut_o03         ( .O(PI_DataIn_i[03]), .I(PO_DataOut_o[03])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[03]) );
ZMP0CBA iopad_DataInOut_o04         ( .O(PI_DataIn_i[04]), .I(PO_DataOut_o[04])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[04]) );
ZMP0CBA iopad_DataInOut_o05         ( .O(PI_DataIn_i[05]), .I(PO_DataOut_o[05])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[05]) );
ZMP0CBA iopad_DataInOut_o06         ( .O(PI_DataIn_i[06]), .I(PO_DataOut_o[06])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[06]) );
ZMP0CBA iopad_DataInOut_o07         ( .O(PI_DataIn_i[07]), .I(PO_DataOut_o[07])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[07]) );
ZMP0CBA iopad_DataInOut_o08         ( .O(PI_DataIn_i[08]), .I(PO_DataOut_o[08])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[08]) );
ZMP0CBA iopad_DataInOut_o09         ( .O(PI_DataIn_i[09]), .I(PO_DataOut_o[09])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[09]) );
ZMP0CBA iopad_DataInOut_o10         ( .O(PI_DataIn_i[10]), .I(PO_DataOut_o[10])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[10]) );
ZMP0CBA iopad_DataInOut_o11         ( .O(PI_DataIn_i[11]), .I(PO_DataOut_o[11])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[11]) );
ZMP0CBA iopad_DataInOut_o12         ( .O(PI_DataIn_i[12]), .I(PO_DataOut_o[12])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[12]) );
ZMP0CBA iopad_DataInOut_o13         ( .O(PI_DataIn_i[13]), .I(PO_DataOut_o[13])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[13]) );
ZMP0CBA iopad_DataInOut_o14         ( .O(PI_DataIn_i[14]), .I(PO_DataOut_o[14])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[14]) );
ZMP0CBA iopad_DataInOut_o15         ( .O(PI_DataIn_i[15]), .I(PO_DataOut_o[15])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[15]) );
ZMP0CBA iopad_DataInOut_o16         ( .O(PI_DataIn_i[16]), .I(PO_DataOut_o[16])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[16]) );
ZMP0CBA iopad_DataInOut_o17         ( .O(PI_DataIn_i[17]), .I(PO_DataOut_o[17])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[17]) );
ZMP0CBA iopad_DataInOut_o18         ( .O(PI_DataIn_i[18]), .I(PO_DataOut_o[18])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[18]) );
ZMP0CBA iopad_DataInOut_o19         ( .O(PI_DataIn_i[19]), .I(PO_DataOut_o[19])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[19]) );
ZMP0CBA iopad_DataInOut_o20         ( .O(PI_DataIn_i[20]), .I(PO_DataOut_o[20])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[20]) );
ZMP0CBA iopad_DataInOut_o21         ( .O(PI_DataIn_i[21]), .I(PO_DataOut_o[21])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[21]) );
ZMP0CBA iopad_DataInOut_o22         ( .O(PI_DataIn_i[22]), .I(PO_DataOut_o[22])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[22]) );
ZMP0CBA iopad_DataInOut_o23         ( .O(PI_DataIn_i[23]), .I(PO_DataOut_o[23])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[23]) );
ZMP0CBA iopad_DataInOut_o24         ( .O(PI_DataIn_i[24]), .I(PO_DataOut_o[24])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[24]) );
ZMP0CBA iopad_DataInOut_o25         ( .O(PI_DataIn_i[25]), .I(PO_DataOut_o[25])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[25]) );
ZMP0CBA iopad_DataInOut_o26         ( .O(PI_DataIn_i[26]), .I(PO_DataOut_o[26])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[26]) );
ZMP0CBA iopad_DataInOut_o27         ( .O(PI_DataIn_i[27]), .I(PO_DataOut_o[27])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[27]) );
ZMP0CBA iopad_DataInOut_o28         ( .O(PI_DataIn_i[28]), .I(PO_DataOut_o[28])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[28]) );
ZMP0CBA iopad_DataInOut_o29         ( .O(PI_DataIn_i[29]), .I(PO_DataOut_o[29])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[29]) );
ZMP0CBA iopad_DataInOut_o30         ( .O(PI_DataIn_i[30]), .I(PO_DataOut_o[30])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[30]) );
ZMP0CBA iopad_DataInOut_o31         ( .O(PI_DataIn_i[31]), .I(PO_DataOut_o[31])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[31]) );
ZMP0CBA iopad_DataInOut_o32         ( .O(PI_DataIn_i[32]), .I(PO_DataOut_o[32])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[32]) );
ZMP0CBA iopad_DataInOut_o33         ( .O(PI_DataIn_i[33]), .I(PO_DataOut_o[33])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[33]) );
ZMP0CBA iopad_DataInOut_o34         ( .O(PI_DataIn_i[34]), .I(PO_DataOut_o[34])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[34]) );
ZMP0CBA iopad_DataInOut_o35         ( .O(PI_DataIn_i[35]), .I(PO_DataOut_o[35])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[35]) );
ZMP0CBA iopad_DataInOut_o36         ( .O(PI_DataIn_i[36]), .I(PO_DataOut_o[36])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[36]) );
ZMP0CBA iopad_DataInOut_o37         ( .O(PI_DataIn_i[37]), .I(PO_DataOut_o[37])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[37]) );
ZMP0CBA iopad_DataInOut_o38         ( .O(PI_DataIn_i[38]), .I(PO_DataOut_o[38])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[38]) );
ZMP0CBA iopad_DataInOut_o39         ( .O(PI_DataIn_i[39]), .I(PO_DataOut_o[39])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[39]) );
ZMP0CBA iopad_DataInOut_o40         ( .O(PI_DataIn_i[40]), .I(PO_DataOut_o[40])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[40]) );
ZMP0CBA iopad_DataInOut_o41         ( .O(PI_DataIn_i[41]), .I(PO_DataOut_o[41])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[41]) );
ZMP0CBA iopad_DataInOut_o42         ( .O(PI_DataIn_i[42]), .I(PO_DataOut_o[42])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[42]) );
ZMP0CBA iopad_DataInOut_o43         ( .O(PI_DataIn_i[43]), .I(PO_DataOut_o[43])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[43]) );
ZMP0CBA iopad_DataInOut_o44         ( .O(PI_DataIn_i[44]), .I(PO_DataOut_o[44])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[44]) );
ZMP0CBA iopad_DataInOut_o45         ( .O(PI_DataIn_i[45]), .I(PO_DataOut_o[45])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[45]) );
ZMP0CBA iopad_DataInOut_o46         ( .O(PI_DataIn_i[46]), .I(PO_DataOut_o[46])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[46]) );
ZMP0CBA iopad_DataInOut_o47         ( .O(PI_DataIn_i[47]), .I(PO_DataOut_o[47])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[47]) );
ZMP0CBA iopad_DataInOut_o48         ( .O(PI_DataIn_i[48]), .I(PO_DataOut_o[48])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[48]) );
ZMP0CBA iopad_DataInOut_o49         ( .O(PI_DataIn_i[49]), .I(PO_DataOut_o[49])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[49]) );
ZMP0CBA iopad_DataInOut_o50         ( .O(PI_DataIn_i[50]), .I(PO_DataOut_o[50])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[50]) );
ZMP0CBA iopad_DataInOut_o51         ( .O(PI_DataIn_i[51]), .I(PO_DataOut_o[51])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[51]) );
ZMP0CBA iopad_DataInOut_o52         ( .O(PI_DataIn_i[52]), .I(PO_DataOut_o[52])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[52]) );
ZMP0CBA iopad_DataInOut_o53         ( .O(PI_DataIn_i[53]), .I(PO_DataOut_o[53])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[53]) );
ZMP0CBA iopad_DataInOut_o54         ( .O(PI_DataIn_i[54]), .I(PO_DataOut_o[54])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[54]) );
ZMP0CBA iopad_DataInOut_o55         ( .O(PI_DataIn_i[55]), .I(PO_DataOut_o[55])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[55]) );
ZMP0CBA iopad_DataInOut_o56         ( .O(PI_DataIn_i[56]), .I(PO_DataOut_o[56])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[56]) );
ZMP0CBA iopad_DataInOut_o57         ( .O(PI_DataIn_i[57]), .I(PO_DataOut_o[57])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[57]) );
ZMP0CBA iopad_DataInOut_o58         ( .O(PI_DataIn_i[58]), .I(PO_DataOut_o[58])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[58]) );
ZMP0CBA iopad_DataInOut_o59         ( .O(PI_DataIn_i[59]), .I(PO_DataOut_o[59])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[59]) );
ZMP0CBA iopad_DataInOut_o60         ( .O(PI_DataIn_i[60]), .I(PO_DataOut_o[60])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[60]) );
ZMP0CBA iopad_DataInOut_o61         ( .O(PI_DataIn_i[61]), .I(PO_DataOut_o[61])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[61]) );
ZMP0CBA iopad_DataInOut_o62         ( .O(PI_DataIn_i[62]), .I(PO_DataOut_o[62])  , .E(n_128_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[62]) );
ZMP0CBA iopad_DataInOut_o63         ( .O(PI_DataIn_i[63]), .I(PO_DataOut_o[63])  , .E(n_132_net_0), .IE(PI_WREN_i), .PU(1'b0), .PD(1'b0), .SMT(1'b0), .IO(DataInOut_io[63]) );
  
//TIE0X1 U3 (.O(1'b0));
//TIE1X1 U4 (.O(1'b1));
     
  SISP_top S0( .clk(PI_clk), 
               .reset(PI_reset), 
               .stall(PI_stall), 
               .ctrl_gateCLK(PI_ctrl_gateCLK), 
               .buffer_input_stop_i(PI_buffer_input_stop_i), 
               .reset_register_i(PI_reset_register_i), 
               .reset_buffer_i(PI_reset_buffer_i), 
               .Address_from_DMA_i(PI_Address_from_DMA_i),
               .choose_reg_from_DMA_i(PI_choose_reg_from_DMA_i), 
               .WEAN_from_DMA_i(PI_WEAN_from_DMA_i), 
               .MUXA_from_DMA_i(PI_MUXA_from_DMA_i), 
               .DataIn_i(PI_DataIn_i), 
               .DataInReady_i(PI_DataInReady_i), 
               .ContextRegAddr_i(PI_ContextRegAddr_i), 
               .seg_enable_i(PI_seg_enable_i), 
               .seg_stall(PI_seg_stall), 
               .DataOut_o(PO_DataOut_o), 
               .DataOutReady_o(PO_DataOutReady_o) );

endmodule