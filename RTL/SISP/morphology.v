module morphology(clk, reset, Data_in, Dline1_in, Dline2_in, vc0_in, vc1_in, vc2_in, hc0_in, hc63_in, choose, data_out, morphology_enable);
   input    [63:0]   Data_in;  //data in
   input    [63:0]   Dline1_in; 
   input    [63:0]   Dline2_in; //Delay line
   input             clk, morphology_enable;
   input             reset;
   input             choose;//0:Dilation 1:Erosion
   input             vc0_in, vc1_in, vc2_in;
   input             hc0_in, hc63_in;  //處理邊界用
   
   output   [63:0]   data_out;
   
   
   
   wire     [63:0]   data_out_w;
	wire     [63:0]   a_w, b_w, c_w;             
	wire              row_compute_00_w; 
	wire              row_compute_01_w; 
	wire              row_compute_02_w; 
	wire              row_compute_03_w; 
	wire              row_compute_04_w; 
	wire              row_compute_05_w; 
	wire              row_compute_06_w; 
	wire              row_compute_07_w; 
	wire              row_compute_08_w; 
	wire              row_compute_09_w; 
	wire              row_compute_10_w; 
	wire              row_compute_11_w; 
	wire              row_compute_12_w; 
	wire              row_compute_13_w; 
	wire              row_compute_14_w; 
	wire              row_compute_15_w; 
	wire              row_compute_16_w; 
	wire              row_compute_17_w; 
	wire              row_compute_18_w; 
	wire              row_compute_19_w; 
	wire              row_compute_20_w; 
	wire              row_compute_21_w; 
	wire              row_compute_22_w; 
	wire              row_compute_23_w; 
	wire              row_compute_24_w; 
	wire              row_compute_25_w; 
	wire              row_compute_26_w; 
	wire              row_compute_27_w; 
	wire              row_compute_28_w; 
	wire              row_compute_29_w; 
	wire              row_compute_30_w; 
	wire              row_compute_31_w; 
	wire              row_compute_32_w; 
	wire              row_compute_33_w; 
	wire              row_compute_34_w; 
	wire              row_compute_35_w; 
	wire              row_compute_36_w; 
	wire              row_compute_37_w; 
	wire              row_compute_38_w; 
	wire              row_compute_39_w; 
	wire              row_compute_40_w; 
	wire              row_compute_41_w; 
	wire              row_compute_42_w; 
	wire              row_compute_43_w; 
	wire              row_compute_44_w; 
	wire              row_compute_45_w; 
	wire              row_compute_46_w; 
	wire              row_compute_47_w; 
	wire              row_compute_48_w; 
	wire              row_compute_49_w; 
	wire              row_compute_50_w; 
	wire              row_compute_51_w; 
	wire              row_compute_52_w; 
	wire              row_compute_53_w; 
	wire              row_compute_54_w; 
	wire              row_compute_55_w; 
	wire              row_compute_56_w; 
	wire              row_compute_57_w; 
	wire              row_compute_58_w; 
	wire              row_compute_59_w; 
	wire              row_compute_60_w; 
	wire              row_compute_61_w; 
	wire              row_compute_62_w; 
	wire              row_compute_63_w; 
	
	wire     [63:0]   r_w; 
	
	
	wire              p00_w; 
	wire              p01_w; 
	wire              p02_w; 
	wire              p03_w; 
	wire              p04_w; 
	wire              p05_w; 
	wire              p06_w; 
	wire              p07_w; 
	wire              p08_w; 
	wire              p09_w; 
	wire              p10_w; 
	wire              p11_w; 
	wire              p12_w; 
	wire              p13_w; 
	wire              p14_w; 
	wire              p15_w; 
	wire              p16_w; 
	wire              p17_w; 
	wire              p18_w; 
	wire              p19_w; 
	wire              p20_w; 
	wire              p21_w; 
	wire              p22_w; 
	wire              p23_w; 
	wire              p24_w; 
	wire              p25_w; 
	wire              p26_w; 
	wire              p27_w; 
	wire              p28_w; 
	wire              p29_w; 
	wire              p30_w; 
	wire              p31_w; 
	wire              p32_w; 
	wire              p33_w; 
	wire              p34_w; 
	wire              p35_w; 
	wire              p36_w; 
	wire              p37_w; 
	wire              p38_w; 
	wire              p39_w; 
	wire              p40_w; 
	wire              p41_w; 
	wire              p42_w; 
	wire              p43_w; 
	wire              p44_w; 
	wire              p45_w; 
	wire              p46_w; 
	wire              p47_w; 
	wire              p48_w; 
	wire              p49_w; 
	wire              p50_w; 
	wire              p51_w; 
	wire              p52_w; 
	wire              p53_w; 
	wire              p54_w; 
	wire              p55_w; 
	wire              p56_w; 
	wire              p57_w; 
	wire              p58_w; 
	wire              p59_w; 
	wire              p60_w; 
	wire              p61_w; 
	wire              p62_w; 
	
	
	reg      [63:0]   data_out;
	reg               choose_r;
	reg               da_r, db_r;
	reg               d_00_r;
	reg               d_01_r;
	reg               d_02_r;
	reg               d_03_r;
	reg               d_04_r;
	reg               d_05_r;
	reg               d_06_r;
	reg               d_07_r;
	reg               d_08_r;
	reg               d_09_r;
	reg               d_10_r;
	reg               d_11_r;
	reg               d_12_r;
	reg               d_13_r;
	reg               d_14_r;
	reg               d_15_r;
	reg               d_16_r;
	reg               d_17_r;
	reg               d_18_r;
	reg               d_19_r;
	reg               d_20_r;
	reg               d_21_r;
	reg               d_22_r;
	reg               d_23_r;
	reg               d_24_r;
	reg               d_25_r;
	reg               d_26_r;
	reg               d_27_r;
	reg               d_28_r;
	reg               d_29_r;
	reg               d_30_r;
	reg               d_31_r;
	reg               d_32_r;
	reg               d_33_r;
	reg               d_34_r;
	reg               d_35_r;
	reg               d_36_r;
	reg               d_37_r;
	reg               d_38_r;
	reg               d_39_r;
	reg               d_40_r;
	reg               d_41_r;
	reg               d_42_r;
	reg               d_43_r;
	reg               d_44_r;
	reg               d_45_r;
	reg               d_46_r;
	reg               d_47_r;
	reg               d_48_r;
	reg               d_49_r;
	reg               d_50_r;
	reg               d_51_r;
	reg               d_52_r;
	reg               d_53_r;
	reg               d_54_r;
	reg               d_55_r;
	reg               d_56_r;
	reg               d_57_r;
	reg               d_58_r;
	reg               d_59_r;
	reg               d_60_r;
	reg               d_61_r;
	reg               d_62_r;
	
	
	
	
	
	
	
	assign a_w = (choose == 1'b0) ? Data_in : ~Data_in;
	assign b_w = (choose == 1'b0) ? Dline1_in : ~Dline1_in;
	assign c_w = (choose == 1'b0) ? Dline2_in : ~Dline2_in;
	
	assign row_compute_00_w = (vc0_in && a_w[00]) || (vc1_in && b_w[00]) || (vc2_in && c_w[00]); 
	assign row_compute_01_w = (vc0_in && a_w[01]) || (vc1_in && b_w[01]) || (vc2_in && c_w[01]); 
	assign row_compute_02_w = (vc0_in && a_w[02]) || (vc1_in && b_w[02]) || (vc2_in && c_w[02]); 
	assign row_compute_03_w = (vc0_in && a_w[03]) || (vc1_in && b_w[03]) || (vc2_in && c_w[03]); 
	assign row_compute_04_w = (vc0_in && a_w[04]) || (vc1_in && b_w[04]) || (vc2_in && c_w[04]); 
	assign row_compute_05_w = (vc0_in && a_w[05]) || (vc1_in && b_w[05]) || (vc2_in && c_w[05]); 
	assign row_compute_06_w = (vc0_in && a_w[06]) || (vc1_in && b_w[06]) || (vc2_in && c_w[06]); 
	assign row_compute_07_w = (vc0_in && a_w[07]) || (vc1_in && b_w[07]) || (vc2_in && c_w[07]); 
	assign row_compute_08_w = (vc0_in && a_w[08]) || (vc1_in && b_w[08]) || (vc2_in && c_w[08]); 
	assign row_compute_09_w = (vc0_in && a_w[09]) || (vc1_in && b_w[09]) || (vc2_in && c_w[09]); 
	assign row_compute_10_w = (vc0_in && a_w[10]) || (vc1_in && b_w[10]) || (vc2_in && c_w[10]); 
	assign row_compute_11_w = (vc0_in && a_w[11]) || (vc1_in && b_w[11]) || (vc2_in && c_w[11]); 
	assign row_compute_12_w = (vc0_in && a_w[12]) || (vc1_in && b_w[12]) || (vc2_in && c_w[12]); 
	assign row_compute_13_w = (vc0_in && a_w[13]) || (vc1_in && b_w[13]) || (vc2_in && c_w[13]); 
	assign row_compute_14_w = (vc0_in && a_w[14]) || (vc1_in && b_w[14]) || (vc2_in && c_w[14]); 
	assign row_compute_15_w = (vc0_in && a_w[15]) || (vc1_in && b_w[15]) || (vc2_in && c_w[15]); 
	assign row_compute_16_w = (vc0_in && a_w[16]) || (vc1_in && b_w[16]) || (vc2_in && c_w[16]); 
	assign row_compute_17_w = (vc0_in && a_w[17]) || (vc1_in && b_w[17]) || (vc2_in && c_w[17]); 
	assign row_compute_18_w = (vc0_in && a_w[18]) || (vc1_in && b_w[18]) || (vc2_in && c_w[18]); 
	assign row_compute_19_w = (vc0_in && a_w[19]) || (vc1_in && b_w[19]) || (vc2_in && c_w[19]); 
	assign row_compute_20_w = (vc0_in && a_w[20]) || (vc1_in && b_w[20]) || (vc2_in && c_w[20]); 
	assign row_compute_21_w = (vc0_in && a_w[21]) || (vc1_in && b_w[21]) || (vc2_in && c_w[21]); 
	assign row_compute_22_w = (vc0_in && a_w[22]) || (vc1_in && b_w[22]) || (vc2_in && c_w[22]); 
	assign row_compute_23_w = (vc0_in && a_w[23]) || (vc1_in && b_w[23]) || (vc2_in && c_w[23]); 
	assign row_compute_24_w = (vc0_in && a_w[24]) || (vc1_in && b_w[24]) || (vc2_in && c_w[24]); 
	assign row_compute_25_w = (vc0_in && a_w[25]) || (vc1_in && b_w[25]) || (vc2_in && c_w[25]); 
	assign row_compute_26_w = (vc0_in && a_w[26]) || (vc1_in && b_w[26]) || (vc2_in && c_w[26]); 
	assign row_compute_27_w = (vc0_in && a_w[27]) || (vc1_in && b_w[27]) || (vc2_in && c_w[27]); 
	assign row_compute_28_w = (vc0_in && a_w[28]) || (vc1_in && b_w[28]) || (vc2_in && c_w[28]); 
	assign row_compute_29_w = (vc0_in && a_w[29]) || (vc1_in && b_w[29]) || (vc2_in && c_w[29]); 
	assign row_compute_30_w = (vc0_in && a_w[30]) || (vc1_in && b_w[30]) || (vc2_in && c_w[30]); 
	assign row_compute_31_w = (vc0_in && a_w[31]) || (vc1_in && b_w[31]) || (vc2_in && c_w[31]); 
	assign row_compute_32_w = (vc0_in && a_w[32]) || (vc1_in && b_w[32]) || (vc2_in && c_w[32]); 
	assign row_compute_33_w = (vc0_in && a_w[33]) || (vc1_in && b_w[33]) || (vc2_in && c_w[33]); 
	assign row_compute_34_w = (vc0_in && a_w[34]) || (vc1_in && b_w[34]) || (vc2_in && c_w[34]); 
	assign row_compute_35_w = (vc0_in && a_w[35]) || (vc1_in && b_w[35]) || (vc2_in && c_w[35]); 
	assign row_compute_36_w = (vc0_in && a_w[36]) || (vc1_in && b_w[36]) || (vc2_in && c_w[36]); 
	assign row_compute_37_w = (vc0_in && a_w[37]) || (vc1_in && b_w[37]) || (vc2_in && c_w[37]); 
	assign row_compute_38_w = (vc0_in && a_w[38]) || (vc1_in && b_w[38]) || (vc2_in && c_w[38]); 
	assign row_compute_39_w = (vc0_in && a_w[39]) || (vc1_in && b_w[39]) || (vc2_in && c_w[39]); 
	assign row_compute_40_w = (vc0_in && a_w[40]) || (vc1_in && b_w[40]) || (vc2_in && c_w[40]); 
	assign row_compute_41_w = (vc0_in && a_w[41]) || (vc1_in && b_w[41]) || (vc2_in && c_w[41]); 
	assign row_compute_42_w = (vc0_in && a_w[42]) || (vc1_in && b_w[42]) || (vc2_in && c_w[42]); 
	assign row_compute_43_w = (vc0_in && a_w[43]) || (vc1_in && b_w[43]) || (vc2_in && c_w[43]); 
	assign row_compute_44_w = (vc0_in && a_w[44]) || (vc1_in && b_w[44]) || (vc2_in && c_w[44]); 
	assign row_compute_45_w = (vc0_in && a_w[45]) || (vc1_in && b_w[45]) || (vc2_in && c_w[45]); 
	assign row_compute_46_w = (vc0_in && a_w[46]) || (vc1_in && b_w[46]) || (vc2_in && c_w[46]); 
	assign row_compute_47_w = (vc0_in && a_w[47]) || (vc1_in && b_w[47]) || (vc2_in && c_w[47]); 
	assign row_compute_48_w = (vc0_in && a_w[48]) || (vc1_in && b_w[48]) || (vc2_in && c_w[48]); 
	assign row_compute_49_w = (vc0_in && a_w[49]) || (vc1_in && b_w[49]) || (vc2_in && c_w[49]); 
	assign row_compute_50_w = (vc0_in && a_w[50]) || (vc1_in && b_w[50]) || (vc2_in && c_w[50]); 
	assign row_compute_51_w = (vc0_in && a_w[51]) || (vc1_in && b_w[51]) || (vc2_in && c_w[51]); 
	assign row_compute_52_w = (vc0_in && a_w[52]) || (vc1_in && b_w[52]) || (vc2_in && c_w[52]); 
	assign row_compute_53_w = (vc0_in && a_w[53]) || (vc1_in && b_w[53]) || (vc2_in && c_w[53]); 
	assign row_compute_54_w = (vc0_in && a_w[54]) || (vc1_in && b_w[54]) || (vc2_in && c_w[54]); 
	assign row_compute_55_w = (vc0_in && a_w[55]) || (vc1_in && b_w[55]) || (vc2_in && c_w[55]); 
	assign row_compute_56_w = (vc0_in && a_w[56]) || (vc1_in && b_w[56]) || (vc2_in && c_w[56]); 
	assign row_compute_57_w = (vc0_in && a_w[57]) || (vc1_in && b_w[57]) || (vc2_in && c_w[57]); 
	assign row_compute_58_w = (vc0_in && a_w[58]) || (vc1_in && b_w[58]) || (vc2_in && c_w[58]); 
	assign row_compute_59_w = (vc0_in && a_w[59]) || (vc1_in && b_w[59]) || (vc2_in && c_w[59]); 
	assign row_compute_60_w = (vc0_in && a_w[60]) || (vc1_in && b_w[60]) || (vc2_in && c_w[60]); 
	assign row_compute_61_w = (vc0_in && a_w[61]) || (vc1_in && b_w[61]) || (vc2_in && c_w[61]); 
	assign row_compute_62_w = (vc0_in && a_w[62]) || (vc1_in && b_w[62]) || (vc2_in && c_w[62]); 
	assign row_compute_63_w = (vc0_in && a_w[63]) || (vc1_in && b_w[63]) || (vc2_in && c_w[63]); 
	
	assign r_w[00] = d_00_r;
   assign r_w[01] = d_01_r;
   assign r_w[02] = d_02_r;
   assign r_w[03] = d_03_r;
   assign r_w[04] = d_04_r;
   assign r_w[05] = d_05_r;
   assign r_w[06] = d_06_r;
   assign r_w[07] = d_07_r;
   assign r_w[08] = d_08_r;
   assign r_w[09] = d_09_r;
   assign r_w[10] = d_10_r;
   assign r_w[11] = d_11_r;
   assign r_w[12] = d_12_r;
   assign r_w[13] = d_13_r;
   assign r_w[14] = d_14_r;
   assign r_w[15] = d_15_r;
   assign r_w[16] = d_16_r;
   assign r_w[17] = d_17_r;
   assign r_w[18] = d_18_r;
   assign r_w[19] = d_19_r;
   assign r_w[20] = d_20_r;
   assign r_w[21] = d_21_r;
   assign r_w[22] = d_22_r;
   assign r_w[23] = d_23_r;
   assign r_w[24] = d_24_r;
   assign r_w[25] = d_25_r;
   assign r_w[26] = d_26_r;
   assign r_w[27] = d_27_r;
   assign r_w[28] = d_28_r;
   assign r_w[29] = d_29_r;
   assign r_w[30] = d_30_r;
   assign r_w[31] = d_31_r;
   assign r_w[32] = d_32_r;
   assign r_w[33] = d_33_r;
   assign r_w[34] = d_34_r;
   assign r_w[35] = d_35_r;
   assign r_w[36] = d_36_r;
   assign r_w[37] = d_37_r;
   assign r_w[38] = d_38_r;
   assign r_w[39] = d_39_r;
   assign r_w[40] = d_40_r;
   assign r_w[41] = d_41_r;
   assign r_w[42] = d_42_r;
   assign r_w[43] = d_43_r;
   assign r_w[44] = d_44_r;
   assign r_w[45] = d_45_r;
   assign r_w[46] = d_46_r;
   assign r_w[47] = d_47_r;
   assign r_w[48] = d_48_r;
   assign r_w[49] = d_49_r;
   assign r_w[50] = d_50_r;
   assign r_w[51] = d_51_r;
   assign r_w[52] = d_52_r;
   assign r_w[53] = d_53_r;
   assign r_w[54] = d_54_r;
   assign r_w[55] = d_55_r;
   assign r_w[56] = d_56_r;
   assign r_w[57] = d_57_r;
   assign r_w[58] = d_58_r;
   assign r_w[59] = d_59_r;
   assign r_w[60] = d_60_r;
   assign r_w[61] = d_61_r;
   assign r_w[62] = d_62_r;
   assign r_w[63] = (hc0_in && row_compute_00_w) || da_r || db_r;
   
   assign p00_w = (hc63_in && da_r) || row_compute_00_w || row_compute_01_w;
   assign p01_w = row_compute_00_w || row_compute_01_w || row_compute_02_w;
   assign p02_w = row_compute_01_w || row_compute_02_w || row_compute_03_w;
   assign p03_w = row_compute_02_w || row_compute_03_w || row_compute_04_w;
   assign p04_w = row_compute_03_w || row_compute_04_w || row_compute_05_w;
   assign p05_w = row_compute_04_w || row_compute_05_w || row_compute_06_w;
   assign p06_w = row_compute_05_w || row_compute_06_w || row_compute_07_w;
   assign p07_w = row_compute_06_w || row_compute_07_w || row_compute_08_w;
   assign p08_w = row_compute_07_w || row_compute_08_w || row_compute_09_w;
   assign p09_w = row_compute_08_w || row_compute_09_w || row_compute_10_w;
   assign p10_w = row_compute_09_w || row_compute_10_w || row_compute_11_w;
   assign p11_w = row_compute_10_w || row_compute_11_w || row_compute_12_w;
   assign p12_w = row_compute_11_w || row_compute_12_w || row_compute_13_w;
   assign p13_w = row_compute_12_w || row_compute_13_w || row_compute_14_w;
   assign p14_w = row_compute_13_w || row_compute_14_w || row_compute_15_w;
   assign p15_w = row_compute_14_w || row_compute_15_w || row_compute_16_w;
   assign p16_w = row_compute_15_w || row_compute_16_w || row_compute_17_w;
   assign p17_w = row_compute_16_w || row_compute_17_w || row_compute_18_w;
   assign p18_w = row_compute_17_w || row_compute_18_w || row_compute_19_w;
   assign p19_w = row_compute_18_w || row_compute_19_w || row_compute_20_w;
   assign p20_w = row_compute_19_w || row_compute_20_w || row_compute_21_w;
   assign p21_w = row_compute_20_w || row_compute_21_w || row_compute_22_w;
   assign p22_w = row_compute_21_w || row_compute_22_w || row_compute_23_w;
   assign p23_w = row_compute_22_w || row_compute_23_w || row_compute_24_w;
   assign p24_w = row_compute_23_w || row_compute_24_w || row_compute_25_w;
   assign p25_w = row_compute_24_w || row_compute_25_w || row_compute_26_w;
   assign p26_w = row_compute_25_w || row_compute_26_w || row_compute_27_w;
   assign p27_w = row_compute_26_w || row_compute_27_w || row_compute_28_w;
   assign p28_w = row_compute_27_w || row_compute_28_w || row_compute_29_w;
   assign p29_w = row_compute_28_w || row_compute_29_w || row_compute_30_w;
   assign p30_w = row_compute_29_w || row_compute_30_w || row_compute_31_w;
   assign p31_w = row_compute_30_w || row_compute_31_w || row_compute_32_w;
   assign p32_w = row_compute_31_w || row_compute_32_w || row_compute_33_w;
   assign p33_w = row_compute_32_w || row_compute_33_w || row_compute_34_w;
   assign p34_w = row_compute_33_w || row_compute_34_w || row_compute_35_w;
   assign p35_w = row_compute_34_w || row_compute_35_w || row_compute_36_w;
   assign p36_w = row_compute_35_w || row_compute_36_w || row_compute_37_w;
   assign p37_w = row_compute_36_w || row_compute_37_w || row_compute_38_w;
   assign p38_w = row_compute_37_w || row_compute_38_w || row_compute_39_w;
   assign p39_w = row_compute_38_w || row_compute_39_w || row_compute_40_w;
   assign p40_w = row_compute_39_w || row_compute_40_w || row_compute_41_w;
   assign p41_w = row_compute_40_w || row_compute_41_w || row_compute_42_w;
   assign p42_w = row_compute_41_w || row_compute_42_w || row_compute_43_w;
   assign p43_w = row_compute_42_w || row_compute_43_w || row_compute_44_w;
   assign p44_w = row_compute_43_w || row_compute_44_w || row_compute_45_w;
   assign p45_w = row_compute_44_w || row_compute_45_w || row_compute_46_w;
   assign p46_w = row_compute_45_w || row_compute_46_w || row_compute_47_w;
   assign p47_w = row_compute_46_w || row_compute_47_w || row_compute_48_w;
   assign p48_w = row_compute_47_w || row_compute_48_w || row_compute_49_w;
   assign p49_w = row_compute_48_w || row_compute_49_w || row_compute_50_w;
   assign p50_w = row_compute_49_w || row_compute_50_w || row_compute_51_w;
   assign p51_w = row_compute_50_w || row_compute_51_w || row_compute_52_w;
   assign p52_w = row_compute_51_w || row_compute_52_w || row_compute_53_w;
   assign p53_w = row_compute_52_w || row_compute_53_w || row_compute_54_w;
   assign p54_w = row_compute_53_w || row_compute_54_w || row_compute_55_w;
   assign p55_w = row_compute_54_w || row_compute_55_w || row_compute_56_w;
   assign p56_w = row_compute_55_w || row_compute_56_w || row_compute_57_w;
   assign p57_w = row_compute_56_w || row_compute_57_w || row_compute_58_w;
   assign p58_w = row_compute_57_w || row_compute_58_w || row_compute_59_w;
   assign p59_w = row_compute_58_w || row_compute_59_w || row_compute_60_w;
   assign p60_w = row_compute_59_w || row_compute_60_w || row_compute_61_w;
   assign p61_w = row_compute_60_w || row_compute_61_w || row_compute_62_w;
   assign p62_w = row_compute_61_w || row_compute_62_w || row_compute_63_w;
   
   
   assign data_out_w = (choose == 1'b0) ? r_w : ~r_w;
   
	
   
   
   
   always@(posedge clk or posedge reset)
   begin
      if(reset)
      begin
         da_r <= 1'b0;
         db_r <= 1'b0;
         d_00_r <= 1'b0;
         d_01_r <= 1'b0;
         d_02_r <= 1'b0;
         d_03_r <= 1'b0;
         d_04_r <= 1'b0;
         d_05_r <= 1'b0;
         d_06_r <= 1'b0;
         d_07_r <= 1'b0;
         d_08_r <= 1'b0;
         d_09_r <= 1'b0;
         d_10_r <= 1'b0;
         d_11_r <= 1'b0;
         d_12_r <= 1'b0;
         d_13_r <= 1'b0;
         d_14_r <= 1'b0;
         d_15_r <= 1'b0;
         d_16_r <= 1'b0;
         d_17_r <= 1'b0;
         d_18_r <= 1'b0;
         d_19_r <= 1'b0;
         d_20_r <= 1'b0;
         d_21_r <= 1'b0;
         d_22_r <= 1'b0;
         d_23_r <= 1'b0;
         d_24_r <= 1'b0;
         d_25_r <= 1'b0;
         d_26_r <= 1'b0;
         d_27_r <= 1'b0;
         d_28_r <= 1'b0;
         d_29_r <= 1'b0;
         d_30_r <= 1'b0;
         d_31_r <= 1'b0;
         d_32_r <= 1'b0;
         d_33_r <= 1'b0;
         d_34_r <= 1'b0;
         d_35_r <= 1'b0;
         d_36_r <= 1'b0;
         d_37_r <= 1'b0;
         d_38_r <= 1'b0;
         d_39_r <= 1'b0;
         d_40_r <= 1'b0;
         d_41_r <= 1'b0;
         d_42_r <= 1'b0;
         d_43_r <= 1'b0;
         d_44_r <= 1'b0;
         d_45_r <= 1'b0;
         d_46_r <= 1'b0;
         d_47_r <= 1'b0;
         d_48_r <= 1'b0;
         d_49_r <= 1'b0;
         d_50_r <= 1'b0;
         d_51_r <= 1'b0;
         d_52_r <= 1'b0;
         d_53_r <= 1'b0;
         d_54_r <= 1'b0;
         d_55_r <= 1'b0;
         d_56_r <= 1'b0;
         d_57_r <= 1'b0;
         d_58_r <= 1'b0;
         d_59_r <= 1'b0;
         d_60_r <= 1'b0;
         d_61_r <= 1'b0;
         d_62_r <= 1'b0;
         
         
         data_out <= 64'd0;
         
         
         
         
         
         
      end
      else
      begin
         if(morphology_enable)
         begin
            da_r <= row_compute_63_w;
            db_r <= row_compute_62_w;
            d_00_r <= p00_w;
            d_01_r <= p01_w;
            d_02_r <= p02_w;
            d_03_r <= p03_w;
            d_04_r <= p04_w;
            d_05_r <= p05_w;
            d_06_r <= p06_w;
            d_07_r <= p07_w;
            d_08_r <= p08_w;
            d_09_r <= p09_w;
            d_10_r <= p10_w;
            d_11_r <= p11_w;
            d_12_r <= p12_w;
            d_13_r <= p13_w;
            d_14_r <= p14_w;
            d_15_r <= p15_w;
            d_16_r <= p16_w;
            d_17_r <= p17_w;
            d_18_r <= p18_w;
            d_19_r <= p19_w;
            d_20_r <= p20_w;
            d_21_r <= p21_w;
            d_22_r <= p22_w;
            d_23_r <= p23_w;
            d_24_r <= p24_w;
            d_25_r <= p25_w;
            d_26_r <= p26_w;
            d_27_r <= p27_w;
            d_28_r <= p28_w;
            d_29_r <= p29_w;
            d_30_r <= p30_w;
            d_31_r <= p31_w;
            d_32_r <= p32_w;
            d_33_r <= p33_w;
            d_34_r <= p34_w;
            d_35_r <= p35_w;
            d_36_r <= p36_w;
            d_37_r <= p37_w;
            d_38_r <= p38_w;
            d_39_r <= p39_w;
            d_40_r <= p40_w;
            d_41_r <= p41_w;
            d_42_r <= p42_w;
            d_43_r <= p43_w;
            d_44_r <= p44_w;
            d_45_r <= p45_w;
            d_46_r <= p46_w;
            d_47_r <= p47_w;
            d_48_r <= p48_w;
            d_49_r <= p49_w;
            d_50_r <= p50_w;
            d_51_r <= p51_w;
            d_52_r <= p52_w;
            d_53_r <= p53_w;
            d_54_r <= p54_w;
            d_55_r <= p55_w;
            d_56_r <= p56_w;
            d_57_r <= p57_w;
            d_58_r <= p58_w;
            d_59_r <= p59_w;
            d_60_r <= p60_w;
            d_61_r <= p61_w;
            d_62_r <= p62_w;
            
            data_out <= data_out_w;
         end
         
      end
         
   end   
         
         
endmodule
         
         
         
         
         
         
         
         
         
         
         
         