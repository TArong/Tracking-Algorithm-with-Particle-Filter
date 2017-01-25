module BU(clk, reset, y1_in, y2_in, u1_in, u2_in, v1_in, v2_in, distance1_y_in, distance2_y_in, distance1_u_in, distance2_u_in, distance1_v_in, distance2_v_in, 
         BU_enable, data_read_A_Y, data_read_B_Y, data_read_A_U, data_read_B_U, data_read_A_V, data_read_B_V, 
         data_write_A_Y, data_write_B_Y, data_write_A_U, data_write_B_U, data_write_A_V, data_write_B_V, 
         wea_Y, web_Y, wea_U, web_U, wea_V, web_V, csa_Y, csb_Y, csa_U, csb_U, csa_V, csb_V, oea_Y, oeb_Y, oea_U, oeb_U, oea_V, oeb_V
         
);                                                                                                 
   input          clk;                                                                             
   input          reset;
   input    [7:0]    y1_in, y2_in, u1_in, u2_in, v1_in, v2_in;
   input    [7:0]   distance1_y_in, distance2_y_in;
   input    [7:0]   distance1_u_in, distance2_u_in;
   input    [7:0]   distance1_v_in, distance2_v_in;  //從cordic來的資料
   input             BU_enable;
   
   
   input    [15:0]   data_read_A_Y, data_read_B_Y, data_read_A_U, data_read_B_U, data_read_A_V, data_read_B_V;
   output   [15:0]   data_write_A_Y, data_write_B_Y, data_write_A_U, data_write_B_U, data_write_A_V, data_write_B_V;
   output            wea_Y, web_Y, wea_U, web_U, wea_V, web_V, csa_Y, csb_Y, csa_U, csb_U, csa_V, csb_V, oea_Y, oeb_Y, oea_U, oeb_U, oea_V, oeb_V;
   //output[255:0]  flag_Y_r, flag_U_r, flag_V_r;
   //從memory 來的資料
   
   
   
   
   reg      [15:0]   data_read_A_Y_r, data_read_B_Y_r;
   reg      [15:0]   data_read_A_U_r, data_read_B_U_r;
   reg      [15:0]   data_read_A_V_r, data_read_B_V_r;
   reg      [15:0]   data_write_A_Y_r, data_write_B_Y_r;
   reg      [15:0]   data_write_A_U_r, data_write_B_U_r;
   reg      [15:0]   data_write_A_V_r, data_write_B_V_r;
   
   
            
            
   wire     [15:0]   data_read_A_Y_w, data_read_B_Y_w;
   wire     [15:0]   data_read_A_U_w, data_read_B_U_w;
   wire     [15:0]   data_read_A_V_w, data_read_B_V_w;
   wire     [15:0]   data_write_A_Y_w, data_write_B_Y_w;
   wire     [15:0]   data_write_A_U_w, data_write_B_U_w;
   wire     [15:0]   data_write_A_V_w, data_write_B_V_w;
   
   
   
   
   
            
   wire     [7:0]    addressA_w, addressB_w;
            
            
   
   reg      [7:0]    distance1_y_in_r, distance1_y_in_2d_r, distance1_y_in_3d_r;
   reg      [7:0]    distance1_u_in_r, distance1_u_in_2d_r, distance1_u_in_3d_r;
   reg      [7:0]    distance1_v_in_r, distance1_v_in_2d_r, distance1_v_in_3d_r;
   reg      [7:0]    distance2_y_in_r, distance2_y_in_2d_r, distance2_y_in_3d_r;
   reg      [7:0]    distance2_u_in_r, distance2_u_in_2d_r, distance2_u_in_3d_r;
   reg      [7:0]    distance2_v_in_r, distance2_v_in_2d_r, distance2_v_in_3d_r;
   
   reg               wea_Y_w, web_Y_w, wea_U_w, web_U_w, wea_V_w, web_V_w;
   reg               csa_Y_w, csb_Y_w, csa_U_w, csb_U_w, csa_V_w, csb_V_w;
   reg               oea_Y_w, oeb_Y_w, oea_U_w, oeb_U_w, oea_V_w, oeb_V_w;
   reg               wea_Y_r, web_Y_r, wea_U_r, web_U_r, wea_V_r, web_V_r;
   reg               wea_Y_1d_r, web_Y_1d_r, wea_U_1d_r, web_U_1d_r, wea_V_1d_r, web_V_1d_r;
   reg               csa_Y_r, csb_Y_r, csa_U_r, csb_U_r, csa_V_r, csb_V_r;
   reg               oea_Y_r, oeb_Y_r, oea_U_r, oeb_U_r, oea_V_r, oeb_V_r;
   reg               wea_Y_2d_r, web_Y_2d_r, wea_U_2d_r, web_U_2d_r, wea_V_2d_r, web_V_2d_r;
   reg               csa_Y_2d_r, csb_Y_2d_r, csa_U_2d_r, csb_U_2d_r, csa_V_2d_r, csb_V_2d_r;
   reg               oea_Y_2d_r, oeb_Y_2d_r, oea_U_2d_r, oeb_U_2d_r, oea_V_2d_r, oeb_V_2d_r;
   //reg      [255:0]  flag_Y_r, flag_U_r, flag_V_r;
   //wire     [255:0]  flag_Y_w, flag_U_w, flag_V_w;
            
   reg      [2:0]    state_w, state_r, state_2d_r;
   
/*   
   pazen_memory_controller Y_cache (
      .A_in(y1_in),
      .B_in(y2_in),
      .DOA(data_read_A_Y_w),
      .DOB(data_read_B_Y_w),
      .DIA(data_write_A_Y_r),
      .DIB(data_write_B_Y_r),
      .WEAN(wea_Y_w),
      .WEBN(web_Y_w),
      .clk(clk),
      .reset(reset),
      .CSA(csa_Y_w),
      .CSB(csb_Y_w),
      .OEA(oea_Y_w),
      .OEB(oeb_Y_w)
   );
 */
  assign data_read_A_Y_w = (state_r == 3'd2) ? data_read_A_Y: data_read_A_Y_r;
  assign data_read_A_U_w = (state_r == 3'd2) ? data_read_A_U: data_read_A_U_r;
  assign data_read_A_V_w = (state_r == 3'd2) ? data_read_A_V: data_read_A_V_r;
  assign data_read_B_Y_w = (state_r == 3'd2) ? data_read_B_Y: data_read_B_Y_r;
  assign data_read_B_U_w = (state_r == 3'd2) ? data_read_B_U: data_read_B_U_r;
  assign data_read_B_V_w = (state_r == 3'd2) ? data_read_B_V: data_read_B_V_r;
  
  assign data_write_A_Y = data_write_A_Y_r;
  assign data_write_A_U = data_write_A_U_r;
  assign data_write_A_V = data_write_A_V_r;
  assign data_write_B_Y = data_write_B_Y_r;
  assign data_write_B_U = data_write_B_U_r;
  assign data_write_B_V = data_write_B_V_r;
  
  
  assign csa_Y = csa_Y_r;
  assign csa_U = csa_U_r;
  assign csa_V = csa_V_r;
  assign csb_Y = csb_Y_r;
  assign csb_U = csb_U_r;
  assign csb_V = csb_V_r;
  
  assign wea_Y = wea_Y_r;
  assign wea_U = wea_U_r;
  assign wea_V = wea_V_r;
  assign web_Y = web_Y_r;
  assign web_U = web_U_r;
  assign web_V = web_V_r;
  
  assign oea_Y = oea_Y_r;
  assign oea_U = oea_U_r;
  assign oea_V = oea_V_r;
  assign oeb_Y = oeb_Y_r;
  assign oeb_U = oeb_U_r;
  assign oeb_V = oeb_V_r;
  
  
  /*
  pazen_memory_controller U_cache (
      .A_in(u1_in),
      .B_in(u2_in),
      .DOA(data_read_A_U_w),
      .DOB(data_read_B_U_w),
      .DIA(data_write_A_U_r),
      .DIB(data_write_B_U_r),
      .WEAN(wea_U_w),
      .WEBN(web_U_w),
      .clk(clk),
      .reset(reset),
      .CSA(csa_U_w),
      .CSB(csb_U_w),
      .OEA(oea_U_w),
      .OEB(oeb_U_w)
   );
   
   pazen_memory_controller V_cache (
      .A_in(v1_in),
      .B_in(v2_in),
      .DOA(data_read_A_V_w),
      .DOB(data_read_B_V_w),
      .DIA(data_write_A_V_r),
      .DIB(data_write_B_V_r),
      .WEAN(wea_V_w),
      .WEBN(web_V_w),
      .clk(clk),
      .reset(reset),
      .CSA(csa_V_w),
      .CSB(csb_V_w),
      .OEA(oea_V_w),
      .OEB(oeb_V_w)
   );
   */ 
   /*
   assign flag_Y_w[000] = (state_r == 3'd3 && (y1_in == 8'd000 || y2_in == 8'd000)) ? (1'b1) : (flag_Y_r[000]);
   assign flag_Y_w[001] = (state_r == 3'd3 && (y1_in == 8'd001 || y2_in == 8'd001)) ? (1'b1) : (flag_Y_r[001]);
   assign flag_Y_w[002] = (state_r == 3'd3 && (y1_in == 8'd002 || y2_in == 8'd002)) ? (1'b1) : (flag_Y_r[002]);
   assign flag_Y_w[003] = (state_r == 3'd3 && (y1_in == 8'd003 || y2_in == 8'd003)) ? (1'b1) : (flag_Y_r[003]);
   assign flag_Y_w[004] = (state_r == 3'd3 && (y1_in == 8'd004 || y2_in == 8'd004)) ? (1'b1) : (flag_Y_r[004]);
   assign flag_Y_w[005] = (state_r == 3'd3 && (y1_in == 8'd005 || y2_in == 8'd005)) ? (1'b1) : (flag_Y_r[005]);
   assign flag_Y_w[006] = (state_r == 3'd3 && (y1_in == 8'd006 || y2_in == 8'd006)) ? (1'b1) : (flag_Y_r[006]);
   assign flag_Y_w[007] = (state_r == 3'd3 && (y1_in == 8'd007 || y2_in == 8'd007)) ? (1'b1) : (flag_Y_r[007]);
   assign flag_Y_w[008] = (state_r == 3'd3 && (y1_in == 8'd008 || y2_in == 8'd008)) ? (1'b1) : (flag_Y_r[008]);
   assign flag_Y_w[009] = (state_r == 3'd3 && (y1_in == 8'd009 || y2_in == 8'd009)) ? (1'b1) : (flag_Y_r[009]);
   assign flag_Y_w[010] = (state_r == 3'd3 && (y1_in == 8'd010 || y2_in == 8'd010)) ? (1'b1) : (flag_Y_r[010]);
   assign flag_Y_w[011] = (state_r == 3'd3 && (y1_in == 8'd011 || y2_in == 8'd011)) ? (1'b1) : (flag_Y_r[011]);
   assign flag_Y_w[012] = (state_r == 3'd3 && (y1_in == 8'd012 || y2_in == 8'd012)) ? (1'b1) : (flag_Y_r[012]);
   assign flag_Y_w[013] = (state_r == 3'd3 && (y1_in == 8'd013 || y2_in == 8'd013)) ? (1'b1) : (flag_Y_r[013]);
   assign flag_Y_w[014] = (state_r == 3'd3 && (y1_in == 8'd014 || y2_in == 8'd014)) ? (1'b1) : (flag_Y_r[014]);
   assign flag_Y_w[015] = (state_r == 3'd3 && (y1_in == 8'd015 || y2_in == 8'd015)) ? (1'b1) : (flag_Y_r[015]);
   assign flag_Y_w[016] = (state_r == 3'd3 && (y1_in == 8'd016 || y2_in == 8'd016)) ? (1'b1) : (flag_Y_r[016]);
   assign flag_Y_w[017] = (state_r == 3'd3 && (y1_in == 8'd017 || y2_in == 8'd017)) ? (1'b1) : (flag_Y_r[017]);
   assign flag_Y_w[018] = (state_r == 3'd3 && (y1_in == 8'd018 || y2_in == 8'd018)) ? (1'b1) : (flag_Y_r[018]);
   assign flag_Y_w[019] = (state_r == 3'd3 && (y1_in == 8'd019 || y2_in == 8'd019)) ? (1'b1) : (flag_Y_r[019]);
   assign flag_Y_w[020] = (state_r == 3'd3 && (y1_in == 8'd020 || y2_in == 8'd020)) ? (1'b1) : (flag_Y_r[020]);
   assign flag_Y_w[021] = (state_r == 3'd3 && (y1_in == 8'd021 || y2_in == 8'd021)) ? (1'b1) : (flag_Y_r[021]);
   assign flag_Y_w[022] = (state_r == 3'd3 && (y1_in == 8'd022 || y2_in == 8'd022)) ? (1'b1) : (flag_Y_r[022]);
   assign flag_Y_w[023] = (state_r == 3'd3 && (y1_in == 8'd023 || y2_in == 8'd023)) ? (1'b1) : (flag_Y_r[023]);
   assign flag_Y_w[024] = (state_r == 3'd3 && (y1_in == 8'd024 || y2_in == 8'd024)) ? (1'b1) : (flag_Y_r[024]);
   assign flag_Y_w[025] = (state_r == 3'd3 && (y1_in == 8'd025 || y2_in == 8'd025)) ? (1'b1) : (flag_Y_r[025]);
   assign flag_Y_w[026] = (state_r == 3'd3 && (y1_in == 8'd026 || y2_in == 8'd026)) ? (1'b1) : (flag_Y_r[026]);
   assign flag_Y_w[027] = (state_r == 3'd3 && (y1_in == 8'd027 || y2_in == 8'd027)) ? (1'b1) : (flag_Y_r[027]);
   assign flag_Y_w[028] = (state_r == 3'd3 && (y1_in == 8'd028 || y2_in == 8'd028)) ? (1'b1) : (flag_Y_r[028]);
   assign flag_Y_w[029] = (state_r == 3'd3 && (y1_in == 8'd029 || y2_in == 8'd029)) ? (1'b1) : (flag_Y_r[029]);
   assign flag_Y_w[030] = (state_r == 3'd3 && (y1_in == 8'd030 || y2_in == 8'd030)) ? (1'b1) : (flag_Y_r[030]);
   assign flag_Y_w[031] = (state_r == 3'd3 && (y1_in == 8'd031 || y2_in == 8'd031)) ? (1'b1) : (flag_Y_r[031]);
   assign flag_Y_w[032] = (state_r == 3'd3 && (y1_in == 8'd032 || y2_in == 8'd032)) ? (1'b1) : (flag_Y_r[032]);
   assign flag_Y_w[033] = (state_r == 3'd3 && (y1_in == 8'd033 || y2_in == 8'd033)) ? (1'b1) : (flag_Y_r[033]);
   assign flag_Y_w[034] = (state_r == 3'd3 && (y1_in == 8'd034 || y2_in == 8'd034)) ? (1'b1) : (flag_Y_r[034]);
   assign flag_Y_w[035] = (state_r == 3'd3 && (y1_in == 8'd035 || y2_in == 8'd035)) ? (1'b1) : (flag_Y_r[035]);
   assign flag_Y_w[036] = (state_r == 3'd3 && (y1_in == 8'd036 || y2_in == 8'd036)) ? (1'b1) : (flag_Y_r[036]);
   assign flag_Y_w[037] = (state_r == 3'd3 && (y1_in == 8'd037 || y2_in == 8'd037)) ? (1'b1) : (flag_Y_r[037]);
   assign flag_Y_w[038] = (state_r == 3'd3 && (y1_in == 8'd038 || y2_in == 8'd038)) ? (1'b1) : (flag_Y_r[038]);
   assign flag_Y_w[039] = (state_r == 3'd3 && (y1_in == 8'd039 || y2_in == 8'd039)) ? (1'b1) : (flag_Y_r[039]);
   assign flag_Y_w[040] = (state_r == 3'd3 && (y1_in == 8'd040 || y2_in == 8'd040)) ? (1'b1) : (flag_Y_r[040]);
   assign flag_Y_w[041] = (state_r == 3'd3 && (y1_in == 8'd041 || y2_in == 8'd041)) ? (1'b1) : (flag_Y_r[041]);
   assign flag_Y_w[042] = (state_r == 3'd3 && (y1_in == 8'd042 || y2_in == 8'd042)) ? (1'b1) : (flag_Y_r[042]);
   assign flag_Y_w[043] = (state_r == 3'd3 && (y1_in == 8'd043 || y2_in == 8'd043)) ? (1'b1) : (flag_Y_r[043]);
   assign flag_Y_w[044] = (state_r == 3'd3 && (y1_in == 8'd044 || y2_in == 8'd044)) ? (1'b1) : (flag_Y_r[044]);
   assign flag_Y_w[045] = (state_r == 3'd3 && (y1_in == 8'd045 || y2_in == 8'd045)) ? (1'b1) : (flag_Y_r[045]);
   assign flag_Y_w[046] = (state_r == 3'd3 && (y1_in == 8'd046 || y2_in == 8'd046)) ? (1'b1) : (flag_Y_r[046]);
   assign flag_Y_w[047] = (state_r == 3'd3 && (y1_in == 8'd047 || y2_in == 8'd047)) ? (1'b1) : (flag_Y_r[047]);
   assign flag_Y_w[048] = (state_r == 3'd3 && (y1_in == 8'd048 || y2_in == 8'd048)) ? (1'b1) : (flag_Y_r[048]);
   assign flag_Y_w[049] = (state_r == 3'd3 && (y1_in == 8'd049 || y2_in == 8'd049)) ? (1'b1) : (flag_Y_r[049]);
   assign flag_Y_w[050] = (state_r == 3'd3 && (y1_in == 8'd050 || y2_in == 8'd050)) ? (1'b1) : (flag_Y_r[050]);
   assign flag_Y_w[051] = (state_r == 3'd3 && (y1_in == 8'd051 || y2_in == 8'd051)) ? (1'b1) : (flag_Y_r[051]);
   assign flag_Y_w[052] = (state_r == 3'd3 && (y1_in == 8'd052 || y2_in == 8'd052)) ? (1'b1) : (flag_Y_r[052]);
   assign flag_Y_w[053] = (state_r == 3'd3 && (y1_in == 8'd053 || y2_in == 8'd053)) ? (1'b1) : (flag_Y_r[053]);
   assign flag_Y_w[054] = (state_r == 3'd3 && (y1_in == 8'd054 || y2_in == 8'd054)) ? (1'b1) : (flag_Y_r[054]);
   assign flag_Y_w[055] = (state_r == 3'd3 && (y1_in == 8'd055 || y2_in == 8'd055)) ? (1'b1) : (flag_Y_r[055]);
   assign flag_Y_w[056] = (state_r == 3'd3 && (y1_in == 8'd056 || y2_in == 8'd056)) ? (1'b1) : (flag_Y_r[056]);
   assign flag_Y_w[057] = (state_r == 3'd3 && (y1_in == 8'd057 || y2_in == 8'd057)) ? (1'b1) : (flag_Y_r[057]);
   assign flag_Y_w[058] = (state_r == 3'd3 && (y1_in == 8'd058 || y2_in == 8'd058)) ? (1'b1) : (flag_Y_r[058]);
   assign flag_Y_w[059] = (state_r == 3'd3 && (y1_in == 8'd059 || y2_in == 8'd059)) ? (1'b1) : (flag_Y_r[059]);
   assign flag_Y_w[060] = (state_r == 3'd3 && (y1_in == 8'd060 || y2_in == 8'd060)) ? (1'b1) : (flag_Y_r[060]);
   assign flag_Y_w[061] = (state_r == 3'd3 && (y1_in == 8'd061 || y2_in == 8'd061)) ? (1'b1) : (flag_Y_r[061]);
   assign flag_Y_w[062] = (state_r == 3'd3 && (y1_in == 8'd062 || y2_in == 8'd062)) ? (1'b1) : (flag_Y_r[062]);
   assign flag_Y_w[063] = (state_r == 3'd3 && (y1_in == 8'd063 || y2_in == 8'd063)) ? (1'b1) : (flag_Y_r[063]);
   assign flag_Y_w[064] = (state_r == 3'd3 && (y1_in == 8'd064 || y2_in == 8'd064)) ? (1'b1) : (flag_Y_r[064]);
   assign flag_Y_w[065] = (state_r == 3'd3 && (y1_in == 8'd065 || y2_in == 8'd065)) ? (1'b1) : (flag_Y_r[065]);
   assign flag_Y_w[066] = (state_r == 3'd3 && (y1_in == 8'd066 || y2_in == 8'd066)) ? (1'b1) : (flag_Y_r[066]);
   assign flag_Y_w[067] = (state_r == 3'd3 && (y1_in == 8'd067 || y2_in == 8'd067)) ? (1'b1) : (flag_Y_r[067]);
   assign flag_Y_w[068] = (state_r == 3'd3 && (y1_in == 8'd068 || y2_in == 8'd068)) ? (1'b1) : (flag_Y_r[068]);
   assign flag_Y_w[069] = (state_r == 3'd3 && (y1_in == 8'd069 || y2_in == 8'd069)) ? (1'b1) : (flag_Y_r[069]);
   assign flag_Y_w[070] = (state_r == 3'd3 && (y1_in == 8'd070 || y2_in == 8'd070)) ? (1'b1) : (flag_Y_r[070]);
   assign flag_Y_w[071] = (state_r == 3'd3 && (y1_in == 8'd071 || y2_in == 8'd071)) ? (1'b1) : (flag_Y_r[071]);
   assign flag_Y_w[072] = (state_r == 3'd3 && (y1_in == 8'd072 || y2_in == 8'd072)) ? (1'b1) : (flag_Y_r[072]);
   assign flag_Y_w[073] = (state_r == 3'd3 && (y1_in == 8'd073 || y2_in == 8'd073)) ? (1'b1) : (flag_Y_r[073]);
   assign flag_Y_w[074] = (state_r == 3'd3 && (y1_in == 8'd074 || y2_in == 8'd074)) ? (1'b1) : (flag_Y_r[074]);
   assign flag_Y_w[075] = (state_r == 3'd3 && (y1_in == 8'd075 || y2_in == 8'd075)) ? (1'b1) : (flag_Y_r[075]);
   assign flag_Y_w[076] = (state_r == 3'd3 && (y1_in == 8'd076 || y2_in == 8'd076)) ? (1'b1) : (flag_Y_r[076]);
   assign flag_Y_w[077] = (state_r == 3'd3 && (y1_in == 8'd077 || y2_in == 8'd077)) ? (1'b1) : (flag_Y_r[077]);
   assign flag_Y_w[078] = (state_r == 3'd3 && (y1_in == 8'd078 || y2_in == 8'd078)) ? (1'b1) : (flag_Y_r[078]);
   assign flag_Y_w[079] = (state_r == 3'd3 && (y1_in == 8'd079 || y2_in == 8'd079)) ? (1'b1) : (flag_Y_r[079]);
   assign flag_Y_w[080] = (state_r == 3'd3 && (y1_in == 8'd080 || y2_in == 8'd080)) ? (1'b1) : (flag_Y_r[080]);
   assign flag_Y_w[081] = (state_r == 3'd3 && (y1_in == 8'd081 || y2_in == 8'd081)) ? (1'b1) : (flag_Y_r[081]);
   assign flag_Y_w[082] = (state_r == 3'd3 && (y1_in == 8'd082 || y2_in == 8'd082)) ? (1'b1) : (flag_Y_r[082]);
   assign flag_Y_w[083] = (state_r == 3'd3 && (y1_in == 8'd083 || y2_in == 8'd083)) ? (1'b1) : (flag_Y_r[083]);
   assign flag_Y_w[084] = (state_r == 3'd3 && (y1_in == 8'd084 || y2_in == 8'd084)) ? (1'b1) : (flag_Y_r[084]);
   assign flag_Y_w[085] = (state_r == 3'd3 && (y1_in == 8'd085 || y2_in == 8'd085)) ? (1'b1) : (flag_Y_r[085]);
   assign flag_Y_w[086] = (state_r == 3'd3 && (y1_in == 8'd086 || y2_in == 8'd086)) ? (1'b1) : (flag_Y_r[086]);
   assign flag_Y_w[087] = (state_r == 3'd3 && (y1_in == 8'd087 || y2_in == 8'd087)) ? (1'b1) : (flag_Y_r[087]);
   assign flag_Y_w[088] = (state_r == 3'd3 && (y1_in == 8'd088 || y2_in == 8'd088)) ? (1'b1) : (flag_Y_r[088]);
   assign flag_Y_w[089] = (state_r == 3'd3 && (y1_in == 8'd089 || y2_in == 8'd089)) ? (1'b1) : (flag_Y_r[089]);
   assign flag_Y_w[090] = (state_r == 3'd3 && (y1_in == 8'd090 || y2_in == 8'd090)) ? (1'b1) : (flag_Y_r[090]);
   assign flag_Y_w[091] = (state_r == 3'd3 && (y1_in == 8'd091 || y2_in == 8'd091)) ? (1'b1) : (flag_Y_r[091]);
   assign flag_Y_w[092] = (state_r == 3'd3 && (y1_in == 8'd092 || y2_in == 8'd092)) ? (1'b1) : (flag_Y_r[092]);
   assign flag_Y_w[093] = (state_r == 3'd3 && (y1_in == 8'd093 || y2_in == 8'd093)) ? (1'b1) : (flag_Y_r[093]);
   assign flag_Y_w[094] = (state_r == 3'd3 && (y1_in == 8'd094 || y2_in == 8'd094)) ? (1'b1) : (flag_Y_r[094]);
   assign flag_Y_w[095] = (state_r == 3'd3 && (y1_in == 8'd095 || y2_in == 8'd095)) ? (1'b1) : (flag_Y_r[095]);
   assign flag_Y_w[096] = (state_r == 3'd3 && (y1_in == 8'd096 || y2_in == 8'd096)) ? (1'b1) : (flag_Y_r[096]);
   assign flag_Y_w[097] = (state_r == 3'd3 && (y1_in == 8'd097 || y2_in == 8'd097)) ? (1'b1) : (flag_Y_r[097]);
   assign flag_Y_w[098] = (state_r == 3'd3 && (y1_in == 8'd098 || y2_in == 8'd098)) ? (1'b1) : (flag_Y_r[098]);
   assign flag_Y_w[099] = (state_r == 3'd3 && (y1_in == 8'd099 || y2_in == 8'd099)) ? (1'b1) : (flag_Y_r[099]);
   assign flag_Y_w[100] = (state_r == 3'd3 && (y1_in == 8'd100 || y2_in == 8'd100)) ? (1'b1) : (flag_Y_r[100]);
   assign flag_Y_w[101] = (state_r == 3'd3 && (y1_in == 8'd101 || y2_in == 8'd101)) ? (1'b1) : (flag_Y_r[101]);
   assign flag_Y_w[102] = (state_r == 3'd3 && (y1_in == 8'd102 || y2_in == 8'd102)) ? (1'b1) : (flag_Y_r[102]);
   assign flag_Y_w[103] = (state_r == 3'd3 && (y1_in == 8'd103 || y2_in == 8'd103)) ? (1'b1) : (flag_Y_r[103]);
   assign flag_Y_w[104] = (state_r == 3'd3 && (y1_in == 8'd104 || y2_in == 8'd104)) ? (1'b1) : (flag_Y_r[104]);
   assign flag_Y_w[105] = (state_r == 3'd3 && (y1_in == 8'd105 || y2_in == 8'd105)) ? (1'b1) : (flag_Y_r[105]);
   assign flag_Y_w[106] = (state_r == 3'd3 && (y1_in == 8'd106 || y2_in == 8'd106)) ? (1'b1) : (flag_Y_r[106]);
   assign flag_Y_w[107] = (state_r == 3'd3 && (y1_in == 8'd107 || y2_in == 8'd107)) ? (1'b1) : (flag_Y_r[107]);
   assign flag_Y_w[108] = (state_r == 3'd3 && (y1_in == 8'd108 || y2_in == 8'd108)) ? (1'b1) : (flag_Y_r[108]);
   assign flag_Y_w[109] = (state_r == 3'd3 && (y1_in == 8'd109 || y2_in == 8'd109)) ? (1'b1) : (flag_Y_r[109]);
   assign flag_Y_w[110] = (state_r == 3'd3 && (y1_in == 8'd110 || y2_in == 8'd110)) ? (1'b1) : (flag_Y_r[110]);
   assign flag_Y_w[111] = (state_r == 3'd3 && (y1_in == 8'd111 || y2_in == 8'd111)) ? (1'b1) : (flag_Y_r[111]);
   assign flag_Y_w[112] = (state_r == 3'd3 && (y1_in == 8'd112 || y2_in == 8'd112)) ? (1'b1) : (flag_Y_r[112]);
   assign flag_Y_w[113] = (state_r == 3'd3 && (y1_in == 8'd113 || y2_in == 8'd113)) ? (1'b1) : (flag_Y_r[113]);
   assign flag_Y_w[114] = (state_r == 3'd3 && (y1_in == 8'd114 || y2_in == 8'd114)) ? (1'b1) : (flag_Y_r[114]);
   assign flag_Y_w[115] = (state_r == 3'd3 && (y1_in == 8'd115 || y2_in == 8'd115)) ? (1'b1) : (flag_Y_r[115]);
   assign flag_Y_w[116] = (state_r == 3'd3 && (y1_in == 8'd116 || y2_in == 8'd116)) ? (1'b1) : (flag_Y_r[116]);
   assign flag_Y_w[117] = (state_r == 3'd3 && (y1_in == 8'd117 || y2_in == 8'd117)) ? (1'b1) : (flag_Y_r[117]);
   assign flag_Y_w[118] = (state_r == 3'd3 && (y1_in == 8'd118 || y2_in == 8'd118)) ? (1'b1) : (flag_Y_r[118]);
   assign flag_Y_w[119] = (state_r == 3'd3 && (y1_in == 8'd119 || y2_in == 8'd119)) ? (1'b1) : (flag_Y_r[119]);
   assign flag_Y_w[120] = (state_r == 3'd3 && (y1_in == 8'd120 || y2_in == 8'd120)) ? (1'b1) : (flag_Y_r[120]);
   assign flag_Y_w[121] = (state_r == 3'd3 && (y1_in == 8'd121 || y2_in == 8'd121)) ? (1'b1) : (flag_Y_r[121]);
   assign flag_Y_w[122] = (state_r == 3'd3 && (y1_in == 8'd122 || y2_in == 8'd122)) ? (1'b1) : (flag_Y_r[122]);
   assign flag_Y_w[123] = (state_r == 3'd3 && (y1_in == 8'd123 || y2_in == 8'd123)) ? (1'b1) : (flag_Y_r[123]);
   assign flag_Y_w[124] = (state_r == 3'd3 && (y1_in == 8'd124 || y2_in == 8'd124)) ? (1'b1) : (flag_Y_r[124]);
   assign flag_Y_w[125] = (state_r == 3'd3 && (y1_in == 8'd125 || y2_in == 8'd125)) ? (1'b1) : (flag_Y_r[125]);
   assign flag_Y_w[126] = (state_r == 3'd3 && (y1_in == 8'd126 || y2_in == 8'd126)) ? (1'b1) : (flag_Y_r[126]);
   assign flag_Y_w[127] = (state_r == 3'd3 && (y1_in == 8'd127 || y2_in == 8'd127)) ? (1'b1) : (flag_Y_r[127]);
   assign flag_Y_w[128] = (state_r == 3'd3 && (y1_in == 8'd128 || y2_in == 8'd128)) ? (1'b1) : (flag_Y_r[128]);
   assign flag_Y_w[129] = (state_r == 3'd3 && (y1_in == 8'd129 || y2_in == 8'd129)) ? (1'b1) : (flag_Y_r[129]);
   assign flag_Y_w[130] = (state_r == 3'd3 && (y1_in == 8'd130 || y2_in == 8'd130)) ? (1'b1) : (flag_Y_r[130]);
   assign flag_Y_w[131] = (state_r == 3'd3 && (y1_in == 8'd131 || y2_in == 8'd131)) ? (1'b1) : (flag_Y_r[131]);
   assign flag_Y_w[132] = (state_r == 3'd3 && (y1_in == 8'd132 || y2_in == 8'd132)) ? (1'b1) : (flag_Y_r[132]);
   assign flag_Y_w[133] = (state_r == 3'd3 && (y1_in == 8'd133 || y2_in == 8'd133)) ? (1'b1) : (flag_Y_r[133]);
   assign flag_Y_w[134] = (state_r == 3'd3 && (y1_in == 8'd134 || y2_in == 8'd134)) ? (1'b1) : (flag_Y_r[134]);
   assign flag_Y_w[135] = (state_r == 3'd3 && (y1_in == 8'd135 || y2_in == 8'd135)) ? (1'b1) : (flag_Y_r[135]);
   assign flag_Y_w[136] = (state_r == 3'd3 && (y1_in == 8'd136 || y2_in == 8'd136)) ? (1'b1) : (flag_Y_r[136]);
   assign flag_Y_w[137] = (state_r == 3'd3 && (y1_in == 8'd137 || y2_in == 8'd137)) ? (1'b1) : (flag_Y_r[137]);
   assign flag_Y_w[138] = (state_r == 3'd3 && (y1_in == 8'd138 || y2_in == 8'd138)) ? (1'b1) : (flag_Y_r[138]);
   assign flag_Y_w[139] = (state_r == 3'd3 && (y1_in == 8'd139 || y2_in == 8'd139)) ? (1'b1) : (flag_Y_r[139]);
   assign flag_Y_w[140] = (state_r == 3'd3 && (y1_in == 8'd140 || y2_in == 8'd140)) ? (1'b1) : (flag_Y_r[140]);
   assign flag_Y_w[141] = (state_r == 3'd3 && (y1_in == 8'd141 || y2_in == 8'd141)) ? (1'b1) : (flag_Y_r[141]);
   assign flag_Y_w[142] = (state_r == 3'd3 && (y1_in == 8'd142 || y2_in == 8'd142)) ? (1'b1) : (flag_Y_r[142]);
   assign flag_Y_w[143] = (state_r == 3'd3 && (y1_in == 8'd143 || y2_in == 8'd143)) ? (1'b1) : (flag_Y_r[143]);
   assign flag_Y_w[144] = (state_r == 3'd3 && (y1_in == 8'd144 || y2_in == 8'd144)) ? (1'b1) : (flag_Y_r[144]);
   assign flag_Y_w[145] = (state_r == 3'd3 && (y1_in == 8'd145 || y2_in == 8'd145)) ? (1'b1) : (flag_Y_r[145]);
   assign flag_Y_w[146] = (state_r == 3'd3 && (y1_in == 8'd146 || y2_in == 8'd146)) ? (1'b1) : (flag_Y_r[146]);
   assign flag_Y_w[147] = (state_r == 3'd3 && (y1_in == 8'd147 || y2_in == 8'd147)) ? (1'b1) : (flag_Y_r[147]);
   assign flag_Y_w[148] = (state_r == 3'd3 && (y1_in == 8'd148 || y2_in == 8'd148)) ? (1'b1) : (flag_Y_r[148]);
   assign flag_Y_w[149] = (state_r == 3'd3 && (y1_in == 8'd149 || y2_in == 8'd149)) ? (1'b1) : (flag_Y_r[149]);
   assign flag_Y_w[150] = (state_r == 3'd3 && (y1_in == 8'd150 || y2_in == 8'd150)) ? (1'b1) : (flag_Y_r[150]);
   assign flag_Y_w[151] = (state_r == 3'd3 && (y1_in == 8'd151 || y2_in == 8'd151)) ? (1'b1) : (flag_Y_r[151]);
   assign flag_Y_w[152] = (state_r == 3'd3 && (y1_in == 8'd152 || y2_in == 8'd152)) ? (1'b1) : (flag_Y_r[152]);
   assign flag_Y_w[153] = (state_r == 3'd3 && (y1_in == 8'd153 || y2_in == 8'd153)) ? (1'b1) : (flag_Y_r[153]);
   assign flag_Y_w[154] = (state_r == 3'd3 && (y1_in == 8'd154 || y2_in == 8'd154)) ? (1'b1) : (flag_Y_r[154]);
   assign flag_Y_w[155] = (state_r == 3'd3 && (y1_in == 8'd155 || y2_in == 8'd155)) ? (1'b1) : (flag_Y_r[155]);
   assign flag_Y_w[156] = (state_r == 3'd3 && (y1_in == 8'd156 || y2_in == 8'd156)) ? (1'b1) : (flag_Y_r[156]);
   assign flag_Y_w[157] = (state_r == 3'd3 && (y1_in == 8'd157 || y2_in == 8'd157)) ? (1'b1) : (flag_Y_r[157]);
   assign flag_Y_w[158] = (state_r == 3'd3 && (y1_in == 8'd158 || y2_in == 8'd158)) ? (1'b1) : (flag_Y_r[158]);
   assign flag_Y_w[159] = (state_r == 3'd3 && (y1_in == 8'd159 || y2_in == 8'd159)) ? (1'b1) : (flag_Y_r[159]);
   assign flag_Y_w[160] = (state_r == 3'd3 && (y1_in == 8'd160 || y2_in == 8'd160)) ? (1'b1) : (flag_Y_r[160]);
   assign flag_Y_w[161] = (state_r == 3'd3 && (y1_in == 8'd161 || y2_in == 8'd161)) ? (1'b1) : (flag_Y_r[161]);
   assign flag_Y_w[162] = (state_r == 3'd3 && (y1_in == 8'd162 || y2_in == 8'd162)) ? (1'b1) : (flag_Y_r[162]);
   assign flag_Y_w[163] = (state_r == 3'd3 && (y1_in == 8'd163 || y2_in == 8'd163)) ? (1'b1) : (flag_Y_r[163]);
   assign flag_Y_w[164] = (state_r == 3'd3 && (y1_in == 8'd164 || y2_in == 8'd164)) ? (1'b1) : (flag_Y_r[164]);
   assign flag_Y_w[165] = (state_r == 3'd3 && (y1_in == 8'd165 || y2_in == 8'd165)) ? (1'b1) : (flag_Y_r[165]);
   assign flag_Y_w[166] = (state_r == 3'd3 && (y1_in == 8'd166 || y2_in == 8'd166)) ? (1'b1) : (flag_Y_r[166]);
   assign flag_Y_w[167] = (state_r == 3'd3 && (y1_in == 8'd167 || y2_in == 8'd167)) ? (1'b1) : (flag_Y_r[167]);
   assign flag_Y_w[168] = (state_r == 3'd3 && (y1_in == 8'd168 || y2_in == 8'd168)) ? (1'b1) : (flag_Y_r[168]);
   assign flag_Y_w[169] = (state_r == 3'd3 && (y1_in == 8'd169 || y2_in == 8'd169)) ? (1'b1) : (flag_Y_r[169]);
   assign flag_Y_w[170] = (state_r == 3'd3 && (y1_in == 8'd170 || y2_in == 8'd170)) ? (1'b1) : (flag_Y_r[170]);
   assign flag_Y_w[171] = (state_r == 3'd3 && (y1_in == 8'd171 || y2_in == 8'd171)) ? (1'b1) : (flag_Y_r[171]);
   assign flag_Y_w[172] = (state_r == 3'd3 && (y1_in == 8'd172 || y2_in == 8'd172)) ? (1'b1) : (flag_Y_r[172]);
   assign flag_Y_w[173] = (state_r == 3'd3 && (y1_in == 8'd173 || y2_in == 8'd173)) ? (1'b1) : (flag_Y_r[173]);
   assign flag_Y_w[174] = (state_r == 3'd3 && (y1_in == 8'd174 || y2_in == 8'd174)) ? (1'b1) : (flag_Y_r[174]);
   assign flag_Y_w[175] = (state_r == 3'd3 && (y1_in == 8'd175 || y2_in == 8'd175)) ? (1'b1) : (flag_Y_r[175]);
   assign flag_Y_w[176] = (state_r == 3'd3 && (y1_in == 8'd176 || y2_in == 8'd176)) ? (1'b1) : (flag_Y_r[176]);
   assign flag_Y_w[177] = (state_r == 3'd3 && (y1_in == 8'd177 || y2_in == 8'd177)) ? (1'b1) : (flag_Y_r[177]);
   assign flag_Y_w[178] = (state_r == 3'd3 && (y1_in == 8'd178 || y2_in == 8'd178)) ? (1'b1) : (flag_Y_r[178]);
   assign flag_Y_w[179] = (state_r == 3'd3 && (y1_in == 8'd179 || y2_in == 8'd179)) ? (1'b1) : (flag_Y_r[179]);
   assign flag_Y_w[180] = (state_r == 3'd3 && (y1_in == 8'd180 || y2_in == 8'd180)) ? (1'b1) : (flag_Y_r[180]);
   assign flag_Y_w[181] = (state_r == 3'd3 && (y1_in == 8'd181 || y2_in == 8'd181)) ? (1'b1) : (flag_Y_r[181]);
   assign flag_Y_w[182] = (state_r == 3'd3 && (y1_in == 8'd182 || y2_in == 8'd182)) ? (1'b1) : (flag_Y_r[182]);
   assign flag_Y_w[183] = (state_r == 3'd3 && (y1_in == 8'd183 || y2_in == 8'd183)) ? (1'b1) : (flag_Y_r[183]);
   assign flag_Y_w[184] = (state_r == 3'd3 && (y1_in == 8'd184 || y2_in == 8'd184)) ? (1'b1) : (flag_Y_r[184]);
   assign flag_Y_w[185] = (state_r == 3'd3 && (y1_in == 8'd185 || y2_in == 8'd185)) ? (1'b1) : (flag_Y_r[185]);
   assign flag_Y_w[186] = (state_r == 3'd3 && (y1_in == 8'd186 || y2_in == 8'd186)) ? (1'b1) : (flag_Y_r[186]);
   assign flag_Y_w[187] = (state_r == 3'd3 && (y1_in == 8'd187 || y2_in == 8'd187)) ? (1'b1) : (flag_Y_r[187]);
   assign flag_Y_w[188] = (state_r == 3'd3 && (y1_in == 8'd188 || y2_in == 8'd188)) ? (1'b1) : (flag_Y_r[188]);
   assign flag_Y_w[189] = (state_r == 3'd3 && (y1_in == 8'd189 || y2_in == 8'd189)) ? (1'b1) : (flag_Y_r[189]);
   assign flag_Y_w[190] = (state_r == 3'd3 && (y1_in == 8'd190 || y2_in == 8'd190)) ? (1'b1) : (flag_Y_r[190]);
   assign flag_Y_w[191] = (state_r == 3'd3 && (y1_in == 8'd191 || y2_in == 8'd191)) ? (1'b1) : (flag_Y_r[191]);
   assign flag_Y_w[192] = (state_r == 3'd3 && (y1_in == 8'd192 || y2_in == 8'd192)) ? (1'b1) : (flag_Y_r[192]);
   assign flag_Y_w[193] = (state_r == 3'd3 && (y1_in == 8'd193 || y2_in == 8'd193)) ? (1'b1) : (flag_Y_r[193]);
   assign flag_Y_w[194] = (state_r == 3'd3 && (y1_in == 8'd194 || y2_in == 8'd194)) ? (1'b1) : (flag_Y_r[194]);
   assign flag_Y_w[195] = (state_r == 3'd3 && (y1_in == 8'd195 || y2_in == 8'd195)) ? (1'b1) : (flag_Y_r[195]);
   assign flag_Y_w[196] = (state_r == 3'd3 && (y1_in == 8'd196 || y2_in == 8'd196)) ? (1'b1) : (flag_Y_r[196]);
   assign flag_Y_w[197] = (state_r == 3'd3 && (y1_in == 8'd197 || y2_in == 8'd197)) ? (1'b1) : (flag_Y_r[197]);
   assign flag_Y_w[198] = (state_r == 3'd3 && (y1_in == 8'd198 || y2_in == 8'd198)) ? (1'b1) : (flag_Y_r[198]);
   assign flag_Y_w[199] = (state_r == 3'd3 && (y1_in == 8'd199 || y2_in == 8'd199)) ? (1'b1) : (flag_Y_r[199]);
   assign flag_Y_w[200] = (state_r == 3'd3 && (y1_in == 8'd200 || y2_in == 8'd200)) ? (1'b1) : (flag_Y_r[200]);
   assign flag_Y_w[201] = (state_r == 3'd3 && (y1_in == 8'd201 || y2_in == 8'd201)) ? (1'b1) : (flag_Y_r[201]);
   assign flag_Y_w[202] = (state_r == 3'd3 && (y1_in == 8'd202 || y2_in == 8'd202)) ? (1'b1) : (flag_Y_r[202]);
   assign flag_Y_w[203] = (state_r == 3'd3 && (y1_in == 8'd203 || y2_in == 8'd203)) ? (1'b1) : (flag_Y_r[203]);
   assign flag_Y_w[204] = (state_r == 3'd3 && (y1_in == 8'd204 || y2_in == 8'd204)) ? (1'b1) : (flag_Y_r[204]);
   assign flag_Y_w[205] = (state_r == 3'd3 && (y1_in == 8'd205 || y2_in == 8'd205)) ? (1'b1) : (flag_Y_r[205]);
   assign flag_Y_w[206] = (state_r == 3'd3 && (y1_in == 8'd206 || y2_in == 8'd206)) ? (1'b1) : (flag_Y_r[206]);
   assign flag_Y_w[207] = (state_r == 3'd3 && (y1_in == 8'd207 || y2_in == 8'd207)) ? (1'b1) : (flag_Y_r[207]);
   assign flag_Y_w[208] = (state_r == 3'd3 && (y1_in == 8'd208 || y2_in == 8'd208)) ? (1'b1) : (flag_Y_r[208]);
   assign flag_Y_w[209] = (state_r == 3'd3 && (y1_in == 8'd209 || y2_in == 8'd209)) ? (1'b1) : (flag_Y_r[209]);
   assign flag_Y_w[210] = (state_r == 3'd3 && (y1_in == 8'd210 || y2_in == 8'd210)) ? (1'b1) : (flag_Y_r[210]);
   assign flag_Y_w[211] = (state_r == 3'd3 && (y1_in == 8'd211 || y2_in == 8'd211)) ? (1'b1) : (flag_Y_r[211]);
   assign flag_Y_w[212] = (state_r == 3'd3 && (y1_in == 8'd212 || y2_in == 8'd212)) ? (1'b1) : (flag_Y_r[212]);
   assign flag_Y_w[213] = (state_r == 3'd3 && (y1_in == 8'd213 || y2_in == 8'd213)) ? (1'b1) : (flag_Y_r[213]);
   assign flag_Y_w[214] = (state_r == 3'd3 && (y1_in == 8'd214 || y2_in == 8'd214)) ? (1'b1) : (flag_Y_r[214]);
   assign flag_Y_w[215] = (state_r == 3'd3 && (y1_in == 8'd215 || y2_in == 8'd215)) ? (1'b1) : (flag_Y_r[215]);
   assign flag_Y_w[216] = (state_r == 3'd3 && (y1_in == 8'd216 || y2_in == 8'd216)) ? (1'b1) : (flag_Y_r[216]);
   assign flag_Y_w[217] = (state_r == 3'd3 && (y1_in == 8'd217 || y2_in == 8'd217)) ? (1'b1) : (flag_Y_r[217]);
   assign flag_Y_w[218] = (state_r == 3'd3 && (y1_in == 8'd218 || y2_in == 8'd218)) ? (1'b1) : (flag_Y_r[218]);
   assign flag_Y_w[219] = (state_r == 3'd3 && (y1_in == 8'd219 || y2_in == 8'd219)) ? (1'b1) : (flag_Y_r[219]);
   assign flag_Y_w[220] = (state_r == 3'd3 && (y1_in == 8'd220 || y2_in == 8'd220)) ? (1'b1) : (flag_Y_r[220]);
   assign flag_Y_w[221] = (state_r == 3'd3 && (y1_in == 8'd221 || y2_in == 8'd221)) ? (1'b1) : (flag_Y_r[221]);
   assign flag_Y_w[222] = (state_r == 3'd3 && (y1_in == 8'd222 || y2_in == 8'd222)) ? (1'b1) : (flag_Y_r[222]);
   assign flag_Y_w[223] = (state_r == 3'd3 && (y1_in == 8'd223 || y2_in == 8'd223)) ? (1'b1) : (flag_Y_r[223]);
   assign flag_Y_w[224] = (state_r == 3'd3 && (y1_in == 8'd224 || y2_in == 8'd224)) ? (1'b1) : (flag_Y_r[224]);
   assign flag_Y_w[225] = (state_r == 3'd3 && (y1_in == 8'd225 || y2_in == 8'd225)) ? (1'b1) : (flag_Y_r[225]);
   assign flag_Y_w[226] = (state_r == 3'd3 && (y1_in == 8'd226 || y2_in == 8'd226)) ? (1'b1) : (flag_Y_r[226]);
   assign flag_Y_w[227] = (state_r == 3'd3 && (y1_in == 8'd227 || y2_in == 8'd227)) ? (1'b1) : (flag_Y_r[227]);
   assign flag_Y_w[228] = (state_r == 3'd3 && (y1_in == 8'd228 || y2_in == 8'd228)) ? (1'b1) : (flag_Y_r[228]);
   assign flag_Y_w[229] = (state_r == 3'd3 && (y1_in == 8'd229 || y2_in == 8'd229)) ? (1'b1) : (flag_Y_r[229]);
   assign flag_Y_w[230] = (state_r == 3'd3 && (y1_in == 8'd230 || y2_in == 8'd230)) ? (1'b1) : (flag_Y_r[230]);
   assign flag_Y_w[231] = (state_r == 3'd3 && (y1_in == 8'd231 || y2_in == 8'd231)) ? (1'b1) : (flag_Y_r[231]);
   assign flag_Y_w[232] = (state_r == 3'd3 && (y1_in == 8'd232 || y2_in == 8'd232)) ? (1'b1) : (flag_Y_r[232]);
   assign flag_Y_w[233] = (state_r == 3'd3 && (y1_in == 8'd233 || y2_in == 8'd233)) ? (1'b1) : (flag_Y_r[233]);
   assign flag_Y_w[234] = (state_r == 3'd3 && (y1_in == 8'd234 || y2_in == 8'd234)) ? (1'b1) : (flag_Y_r[234]);
   assign flag_Y_w[235] = (state_r == 3'd3 && (y1_in == 8'd235 || y2_in == 8'd235)) ? (1'b1) : (flag_Y_r[235]);
   assign flag_Y_w[236] = (state_r == 3'd3 && (y1_in == 8'd236 || y2_in == 8'd236)) ? (1'b1) : (flag_Y_r[236]);
   assign flag_Y_w[237] = (state_r == 3'd3 && (y1_in == 8'd237 || y2_in == 8'd237)) ? (1'b1) : (flag_Y_r[237]);
   assign flag_Y_w[238] = (state_r == 3'd3 && (y1_in == 8'd238 || y2_in == 8'd238)) ? (1'b1) : (flag_Y_r[238]);
   assign flag_Y_w[239] = (state_r == 3'd3 && (y1_in == 8'd239 || y2_in == 8'd239)) ? (1'b1) : (flag_Y_r[239]);
   assign flag_Y_w[240] = (state_r == 3'd3 && (y1_in == 8'd240 || y2_in == 8'd240)) ? (1'b1) : (flag_Y_r[240]);
   assign flag_Y_w[241] = (state_r == 3'd3 && (y1_in == 8'd241 || y2_in == 8'd241)) ? (1'b1) : (flag_Y_r[241]);
   assign flag_Y_w[242] = (state_r == 3'd3 && (y1_in == 8'd242 || y2_in == 8'd242)) ? (1'b1) : (flag_Y_r[242]);
   assign flag_Y_w[243] = (state_r == 3'd3 && (y1_in == 8'd243 || y2_in == 8'd243)) ? (1'b1) : (flag_Y_r[243]);
   assign flag_Y_w[244] = (state_r == 3'd3 && (y1_in == 8'd244 || y2_in == 8'd244)) ? (1'b1) : (flag_Y_r[244]);
   assign flag_Y_w[245] = (state_r == 3'd3 && (y1_in == 8'd245 || y2_in == 8'd245)) ? (1'b1) : (flag_Y_r[245]);
   assign flag_Y_w[246] = (state_r == 3'd3 && (y1_in == 8'd246 || y2_in == 8'd246)) ? (1'b1) : (flag_Y_r[246]);
   assign flag_Y_w[247] = (state_r == 3'd3 && (y1_in == 8'd247 || y2_in == 8'd247)) ? (1'b1) : (flag_Y_r[247]);
   assign flag_Y_w[248] = (state_r == 3'd3 && (y1_in == 8'd248 || y2_in == 8'd248)) ? (1'b1) : (flag_Y_r[248]);
   assign flag_Y_w[249] = (state_r == 3'd3 && (y1_in == 8'd249 || y2_in == 8'd249)) ? (1'b1) : (flag_Y_r[249]);
   assign flag_Y_w[250] = (state_r == 3'd3 && (y1_in == 8'd250 || y2_in == 8'd250)) ? (1'b1) : (flag_Y_r[250]);
   assign flag_Y_w[251] = (state_r == 3'd3 && (y1_in == 8'd251 || y2_in == 8'd251)) ? (1'b1) : (flag_Y_r[251]);
   assign flag_Y_w[252] = (state_r == 3'd3 && (y1_in == 8'd252 || y2_in == 8'd252)) ? (1'b1) : (flag_Y_r[252]);
   assign flag_Y_w[253] = (state_r == 3'd3 && (y1_in == 8'd253 || y2_in == 8'd253)) ? (1'b1) : (flag_Y_r[253]);
   assign flag_Y_w[254] = (state_r == 3'd3 && (y1_in == 8'd254 || y2_in == 8'd254)) ? (1'b1) : (flag_Y_r[254]);
   assign flag_Y_w[255] = (state_r == 3'd3 && (y1_in == 8'd255 || y2_in == 8'd255)) ? (1'b1) : (flag_Y_r[255]);
   
   assign flag_U_w[000] = (state_r == 3'd3 && (u1_in == 8'd000 || u2_in == 8'd000)) ? (1'b1) : (flag_U_r[000]);
   assign flag_U_w[001] = (state_r == 3'd3 && (u1_in == 8'd001 || u2_in == 8'd001)) ? (1'b1) : (flag_U_r[001]);
   assign flag_U_w[002] = (state_r == 3'd3 && (u1_in == 8'd002 || u2_in == 8'd002)) ? (1'b1) : (flag_U_r[002]);
   assign flag_U_w[003] = (state_r == 3'd3 && (u1_in == 8'd003 || u2_in == 8'd003)) ? (1'b1) : (flag_U_r[003]);
   assign flag_U_w[004] = (state_r == 3'd3 && (u1_in == 8'd004 || u2_in == 8'd004)) ? (1'b1) : (flag_U_r[004]);
   assign flag_U_w[005] = (state_r == 3'd3 && (u1_in == 8'd005 || u2_in == 8'd005)) ? (1'b1) : (flag_U_r[005]);
   assign flag_U_w[006] = (state_r == 3'd3 && (u1_in == 8'd006 || u2_in == 8'd006)) ? (1'b1) : (flag_U_r[006]);
   assign flag_U_w[007] = (state_r == 3'd3 && (u1_in == 8'd007 || u2_in == 8'd007)) ? (1'b1) : (flag_U_r[007]);
   assign flag_U_w[008] = (state_r == 3'd3 && (u1_in == 8'd008 || u2_in == 8'd008)) ? (1'b1) : (flag_U_r[008]);
   assign flag_U_w[009] = (state_r == 3'd3 && (u1_in == 8'd009 || u2_in == 8'd009)) ? (1'b1) : (flag_U_r[009]);
   assign flag_U_w[010] = (state_r == 3'd3 && (u1_in == 8'd010 || u2_in == 8'd010)) ? (1'b1) : (flag_U_r[010]);
   assign flag_U_w[011] = (state_r == 3'd3 && (u1_in == 8'd011 || u2_in == 8'd011)) ? (1'b1) : (flag_U_r[011]);
   assign flag_U_w[012] = (state_r == 3'd3 && (u1_in == 8'd012 || u2_in == 8'd012)) ? (1'b1) : (flag_U_r[012]);
   assign flag_U_w[013] = (state_r == 3'd3 && (u1_in == 8'd013 || u2_in == 8'd013)) ? (1'b1) : (flag_U_r[013]);
   assign flag_U_w[014] = (state_r == 3'd3 && (u1_in == 8'd014 || u2_in == 8'd014)) ? (1'b1) : (flag_U_r[014]);
   assign flag_U_w[015] = (state_r == 3'd3 && (u1_in == 8'd015 || u2_in == 8'd015)) ? (1'b1) : (flag_U_r[015]);
   assign flag_U_w[016] = (state_r == 3'd3 && (u1_in == 8'd016 || u2_in == 8'd016)) ? (1'b1) : (flag_U_r[016]);
   assign flag_U_w[017] = (state_r == 3'd3 && (u1_in == 8'd017 || u2_in == 8'd017)) ? (1'b1) : (flag_U_r[017]);
   assign flag_U_w[018] = (state_r == 3'd3 && (u1_in == 8'd018 || u2_in == 8'd018)) ? (1'b1) : (flag_U_r[018]);
   assign flag_U_w[019] = (state_r == 3'd3 && (u1_in == 8'd019 || u2_in == 8'd019)) ? (1'b1) : (flag_U_r[019]);
   assign flag_U_w[020] = (state_r == 3'd3 && (u1_in == 8'd020 || u2_in == 8'd020)) ? (1'b1) : (flag_U_r[020]);
   assign flag_U_w[021] = (state_r == 3'd3 && (u1_in == 8'd021 || u2_in == 8'd021)) ? (1'b1) : (flag_U_r[021]);
   assign flag_U_w[022] = (state_r == 3'd3 && (u1_in == 8'd022 || u2_in == 8'd022)) ? (1'b1) : (flag_U_r[022]);
   assign flag_U_w[023] = (state_r == 3'd3 && (u1_in == 8'd023 || u2_in == 8'd023)) ? (1'b1) : (flag_U_r[023]);
   assign flag_U_w[024] = (state_r == 3'd3 && (u1_in == 8'd024 || u2_in == 8'd024)) ? (1'b1) : (flag_U_r[024]);
   assign flag_U_w[025] = (state_r == 3'd3 && (u1_in == 8'd025 || u2_in == 8'd025)) ? (1'b1) : (flag_U_r[025]);
   assign flag_U_w[026] = (state_r == 3'd3 && (u1_in == 8'd026 || u2_in == 8'd026)) ? (1'b1) : (flag_U_r[026]);
   assign flag_U_w[027] = (state_r == 3'd3 && (u1_in == 8'd027 || u2_in == 8'd027)) ? (1'b1) : (flag_U_r[027]);
   assign flag_U_w[028] = (state_r == 3'd3 && (u1_in == 8'd028 || u2_in == 8'd028)) ? (1'b1) : (flag_U_r[028]);
   assign flag_U_w[029] = (state_r == 3'd3 && (u1_in == 8'd029 || u2_in == 8'd029)) ? (1'b1) : (flag_U_r[029]);
   assign flag_U_w[030] = (state_r == 3'd3 && (u1_in == 8'd030 || u2_in == 8'd030)) ? (1'b1) : (flag_U_r[030]);
   assign flag_U_w[031] = (state_r == 3'd3 && (u1_in == 8'd031 || u2_in == 8'd031)) ? (1'b1) : (flag_U_r[031]);
   assign flag_U_w[032] = (state_r == 3'd3 && (u1_in == 8'd032 || u2_in == 8'd032)) ? (1'b1) : (flag_U_r[032]);
   assign flag_U_w[033] = (state_r == 3'd3 && (u1_in == 8'd033 || u2_in == 8'd033)) ? (1'b1) : (flag_U_r[033]);
   assign flag_U_w[034] = (state_r == 3'd3 && (u1_in == 8'd034 || u2_in == 8'd034)) ? (1'b1) : (flag_U_r[034]);
   assign flag_U_w[035] = (state_r == 3'd3 && (u1_in == 8'd035 || u2_in == 8'd035)) ? (1'b1) : (flag_U_r[035]);
   assign flag_U_w[036] = (state_r == 3'd3 && (u1_in == 8'd036 || u2_in == 8'd036)) ? (1'b1) : (flag_U_r[036]);
   assign flag_U_w[037] = (state_r == 3'd3 && (u1_in == 8'd037 || u2_in == 8'd037)) ? (1'b1) : (flag_U_r[037]);
   assign flag_U_w[038] = (state_r == 3'd3 && (u1_in == 8'd038 || u2_in == 8'd038)) ? (1'b1) : (flag_U_r[038]);
   assign flag_U_w[039] = (state_r == 3'd3 && (u1_in == 8'd039 || u2_in == 8'd039)) ? (1'b1) : (flag_U_r[039]);
   assign flag_U_w[040] = (state_r == 3'd3 && (u1_in == 8'd040 || u2_in == 8'd040)) ? (1'b1) : (flag_U_r[040]);
   assign flag_U_w[041] = (state_r == 3'd3 && (u1_in == 8'd041 || u2_in == 8'd041)) ? (1'b1) : (flag_U_r[041]);
   assign flag_U_w[042] = (state_r == 3'd3 && (u1_in == 8'd042 || u2_in == 8'd042)) ? (1'b1) : (flag_U_r[042]);
   assign flag_U_w[043] = (state_r == 3'd3 && (u1_in == 8'd043 || u2_in == 8'd043)) ? (1'b1) : (flag_U_r[043]);
   assign flag_U_w[044] = (state_r == 3'd3 && (u1_in == 8'd044 || u2_in == 8'd044)) ? (1'b1) : (flag_U_r[044]);
   assign flag_U_w[045] = (state_r == 3'd3 && (u1_in == 8'd045 || u2_in == 8'd045)) ? (1'b1) : (flag_U_r[045]);
   assign flag_U_w[046] = (state_r == 3'd3 && (u1_in == 8'd046 || u2_in == 8'd046)) ? (1'b1) : (flag_U_r[046]);
   assign flag_U_w[047] = (state_r == 3'd3 && (u1_in == 8'd047 || u2_in == 8'd047)) ? (1'b1) : (flag_U_r[047]);
   assign flag_U_w[048] = (state_r == 3'd3 && (u1_in == 8'd048 || u2_in == 8'd048)) ? (1'b1) : (flag_U_r[048]);
   assign flag_U_w[049] = (state_r == 3'd3 && (u1_in == 8'd049 || u2_in == 8'd049)) ? (1'b1) : (flag_U_r[049]);
   assign flag_U_w[050] = (state_r == 3'd3 && (u1_in == 8'd050 || u2_in == 8'd050)) ? (1'b1) : (flag_U_r[050]);
   assign flag_U_w[051] = (state_r == 3'd3 && (u1_in == 8'd051 || u2_in == 8'd051)) ? (1'b1) : (flag_U_r[051]);
   assign flag_U_w[052] = (state_r == 3'd3 && (u1_in == 8'd052 || u2_in == 8'd052)) ? (1'b1) : (flag_U_r[052]);
   assign flag_U_w[053] = (state_r == 3'd3 && (u1_in == 8'd053 || u2_in == 8'd053)) ? (1'b1) : (flag_U_r[053]);
   assign flag_U_w[054] = (state_r == 3'd3 && (u1_in == 8'd054 || u2_in == 8'd054)) ? (1'b1) : (flag_U_r[054]);
   assign flag_U_w[055] = (state_r == 3'd3 && (u1_in == 8'd055 || u2_in == 8'd055)) ? (1'b1) : (flag_U_r[055]);
   assign flag_U_w[056] = (state_r == 3'd3 && (u1_in == 8'd056 || u2_in == 8'd056)) ? (1'b1) : (flag_U_r[056]);
   assign flag_U_w[057] = (state_r == 3'd3 && (u1_in == 8'd057 || u2_in == 8'd057)) ? (1'b1) : (flag_U_r[057]);
   assign flag_U_w[058] = (state_r == 3'd3 && (u1_in == 8'd058 || u2_in == 8'd058)) ? (1'b1) : (flag_U_r[058]);
   assign flag_U_w[059] = (state_r == 3'd3 && (u1_in == 8'd059 || u2_in == 8'd059)) ? (1'b1) : (flag_U_r[059]);
   assign flag_U_w[060] = (state_r == 3'd3 && (u1_in == 8'd060 || u2_in == 8'd060)) ? (1'b1) : (flag_U_r[060]);
   assign flag_U_w[061] = (state_r == 3'd3 && (u1_in == 8'd061 || u2_in == 8'd061)) ? (1'b1) : (flag_U_r[061]);
   assign flag_U_w[062] = (state_r == 3'd3 && (u1_in == 8'd062 || u2_in == 8'd062)) ? (1'b1) : (flag_U_r[062]);
   assign flag_U_w[063] = (state_r == 3'd3 && (u1_in == 8'd063 || u2_in == 8'd063)) ? (1'b1) : (flag_U_r[063]);
   assign flag_U_w[064] = (state_r == 3'd3 && (u1_in == 8'd064 || u2_in == 8'd064)) ? (1'b1) : (flag_U_r[064]);
   assign flag_U_w[065] = (state_r == 3'd3 && (u1_in == 8'd065 || u2_in == 8'd065)) ? (1'b1) : (flag_U_r[065]);
   assign flag_U_w[066] = (state_r == 3'd3 && (u1_in == 8'd066 || u2_in == 8'd066)) ? (1'b1) : (flag_U_r[066]);
   assign flag_U_w[067] = (state_r == 3'd3 && (u1_in == 8'd067 || u2_in == 8'd067)) ? (1'b1) : (flag_U_r[067]);
   assign flag_U_w[068] = (state_r == 3'd3 && (u1_in == 8'd068 || u2_in == 8'd068)) ? (1'b1) : (flag_U_r[068]);
   assign flag_U_w[069] = (state_r == 3'd3 && (u1_in == 8'd069 || u2_in == 8'd069)) ? (1'b1) : (flag_U_r[069]);
   assign flag_U_w[070] = (state_r == 3'd3 && (u1_in == 8'd070 || u2_in == 8'd070)) ? (1'b1) : (flag_U_r[070]);
   assign flag_U_w[071] = (state_r == 3'd3 && (u1_in == 8'd071 || u2_in == 8'd071)) ? (1'b1) : (flag_U_r[071]);
   assign flag_U_w[072] = (state_r == 3'd3 && (u1_in == 8'd072 || u2_in == 8'd072)) ? (1'b1) : (flag_U_r[072]);
   assign flag_U_w[073] = (state_r == 3'd3 && (u1_in == 8'd073 || u2_in == 8'd073)) ? (1'b1) : (flag_U_r[073]);
   assign flag_U_w[074] = (state_r == 3'd3 && (u1_in == 8'd074 || u2_in == 8'd074)) ? (1'b1) : (flag_U_r[074]);
   assign flag_U_w[075] = (state_r == 3'd3 && (u1_in == 8'd075 || u2_in == 8'd075)) ? (1'b1) : (flag_U_r[075]);
   assign flag_U_w[076] = (state_r == 3'd3 && (u1_in == 8'd076 || u2_in == 8'd076)) ? (1'b1) : (flag_U_r[076]);
   assign flag_U_w[077] = (state_r == 3'd3 && (u1_in == 8'd077 || u2_in == 8'd077)) ? (1'b1) : (flag_U_r[077]);
   assign flag_U_w[078] = (state_r == 3'd3 && (u1_in == 8'd078 || u2_in == 8'd078)) ? (1'b1) : (flag_U_r[078]);
   assign flag_U_w[079] = (state_r == 3'd3 && (u1_in == 8'd079 || u2_in == 8'd079)) ? (1'b1) : (flag_U_r[079]);
   assign flag_U_w[080] = (state_r == 3'd3 && (u1_in == 8'd080 || u2_in == 8'd080)) ? (1'b1) : (flag_U_r[080]);
   assign flag_U_w[081] = (state_r == 3'd3 && (u1_in == 8'd081 || u2_in == 8'd081)) ? (1'b1) : (flag_U_r[081]);
   assign flag_U_w[082] = (state_r == 3'd3 && (u1_in == 8'd082 || u2_in == 8'd082)) ? (1'b1) : (flag_U_r[082]);
   assign flag_U_w[083] = (state_r == 3'd3 && (u1_in == 8'd083 || u2_in == 8'd083)) ? (1'b1) : (flag_U_r[083]);
   assign flag_U_w[084] = (state_r == 3'd3 && (u1_in == 8'd084 || u2_in == 8'd084)) ? (1'b1) : (flag_U_r[084]);
   assign flag_U_w[085] = (state_r == 3'd3 && (u1_in == 8'd085 || u2_in == 8'd085)) ? (1'b1) : (flag_U_r[085]);
   assign flag_U_w[086] = (state_r == 3'd3 && (u1_in == 8'd086 || u2_in == 8'd086)) ? (1'b1) : (flag_U_r[086]);
   assign flag_U_w[087] = (state_r == 3'd3 && (u1_in == 8'd087 || u2_in == 8'd087)) ? (1'b1) : (flag_U_r[087]);
   assign flag_U_w[088] = (state_r == 3'd3 && (u1_in == 8'd088 || u2_in == 8'd088)) ? (1'b1) : (flag_U_r[088]);
   assign flag_U_w[089] = (state_r == 3'd3 && (u1_in == 8'd089 || u2_in == 8'd089)) ? (1'b1) : (flag_U_r[089]);
   assign flag_U_w[090] = (state_r == 3'd3 && (u1_in == 8'd090 || u2_in == 8'd090)) ? (1'b1) : (flag_U_r[090]);
   assign flag_U_w[091] = (state_r == 3'd3 && (u1_in == 8'd091 || u2_in == 8'd091)) ? (1'b1) : (flag_U_r[091]);
   assign flag_U_w[092] = (state_r == 3'd3 && (u1_in == 8'd092 || u2_in == 8'd092)) ? (1'b1) : (flag_U_r[092]);
   assign flag_U_w[093] = (state_r == 3'd3 && (u1_in == 8'd093 || u2_in == 8'd093)) ? (1'b1) : (flag_U_r[093]);
   assign flag_U_w[094] = (state_r == 3'd3 && (u1_in == 8'd094 || u2_in == 8'd094)) ? (1'b1) : (flag_U_r[094]);
   assign flag_U_w[095] = (state_r == 3'd3 && (u1_in == 8'd095 || u2_in == 8'd095)) ? (1'b1) : (flag_U_r[095]);
   assign flag_U_w[096] = (state_r == 3'd3 && (u1_in == 8'd096 || u2_in == 8'd096)) ? (1'b1) : (flag_U_r[096]);
   assign flag_U_w[097] = (state_r == 3'd3 && (u1_in == 8'd097 || u2_in == 8'd097)) ? (1'b1) : (flag_U_r[097]);
   assign flag_U_w[098] = (state_r == 3'd3 && (u1_in == 8'd098 || u2_in == 8'd098)) ? (1'b1) : (flag_U_r[098]);
   assign flag_U_w[099] = (state_r == 3'd3 && (u1_in == 8'd099 || u2_in == 8'd099)) ? (1'b1) : (flag_U_r[099]);
   assign flag_U_w[100] = (state_r == 3'd3 && (u1_in == 8'd100 || u2_in == 8'd100)) ? (1'b1) : (flag_U_r[100]);
   assign flag_U_w[101] = (state_r == 3'd3 && (u1_in == 8'd101 || u2_in == 8'd101)) ? (1'b1) : (flag_U_r[101]);
   assign flag_U_w[102] = (state_r == 3'd3 && (u1_in == 8'd102 || u2_in == 8'd102)) ? (1'b1) : (flag_U_r[102]);
   assign flag_U_w[103] = (state_r == 3'd3 && (u1_in == 8'd103 || u2_in == 8'd103)) ? (1'b1) : (flag_U_r[103]);
   assign flag_U_w[104] = (state_r == 3'd3 && (u1_in == 8'd104 || u2_in == 8'd104)) ? (1'b1) : (flag_U_r[104]);
   assign flag_U_w[105] = (state_r == 3'd3 && (u1_in == 8'd105 || u2_in == 8'd105)) ? (1'b1) : (flag_U_r[105]);
   assign flag_U_w[106] = (state_r == 3'd3 && (u1_in == 8'd106 || u2_in == 8'd106)) ? (1'b1) : (flag_U_r[106]);
   assign flag_U_w[107] = (state_r == 3'd3 && (u1_in == 8'd107 || u2_in == 8'd107)) ? (1'b1) : (flag_U_r[107]);
   assign flag_U_w[108] = (state_r == 3'd3 && (u1_in == 8'd108 || u2_in == 8'd108)) ? (1'b1) : (flag_U_r[108]);
   assign flag_U_w[109] = (state_r == 3'd3 && (u1_in == 8'd109 || u2_in == 8'd109)) ? (1'b1) : (flag_U_r[109]);
   assign flag_U_w[110] = (state_r == 3'd3 && (u1_in == 8'd110 || u2_in == 8'd110)) ? (1'b1) : (flag_U_r[110]);
   assign flag_U_w[111] = (state_r == 3'd3 && (u1_in == 8'd111 || u2_in == 8'd111)) ? (1'b1) : (flag_U_r[111]);
   assign flag_U_w[112] = (state_r == 3'd3 && (u1_in == 8'd112 || u2_in == 8'd112)) ? (1'b1) : (flag_U_r[112]);
   assign flag_U_w[113] = (state_r == 3'd3 && (u1_in == 8'd113 || u2_in == 8'd113)) ? (1'b1) : (flag_U_r[113]);
   assign flag_U_w[114] = (state_r == 3'd3 && (u1_in == 8'd114 || u2_in == 8'd114)) ? (1'b1) : (flag_U_r[114]);
   assign flag_U_w[115] = (state_r == 3'd3 && (u1_in == 8'd115 || u2_in == 8'd115)) ? (1'b1) : (flag_U_r[115]);
   assign flag_U_w[116] = (state_r == 3'd3 && (u1_in == 8'd116 || u2_in == 8'd116)) ? (1'b1) : (flag_U_r[116]);
   assign flag_U_w[117] = (state_r == 3'd3 && (u1_in == 8'd117 || u2_in == 8'd117)) ? (1'b1) : (flag_U_r[117]);
   assign flag_U_w[118] = (state_r == 3'd3 && (u1_in == 8'd118 || u2_in == 8'd118)) ? (1'b1) : (flag_U_r[118]);
   assign flag_U_w[119] = (state_r == 3'd3 && (u1_in == 8'd119 || u2_in == 8'd119)) ? (1'b1) : (flag_U_r[119]);
   assign flag_U_w[120] = (state_r == 3'd3 && (u1_in == 8'd120 || u2_in == 8'd120)) ? (1'b1) : (flag_U_r[120]);
   assign flag_U_w[121] = (state_r == 3'd3 && (u1_in == 8'd121 || u2_in == 8'd121)) ? (1'b1) : (flag_U_r[121]);
   assign flag_U_w[122] = (state_r == 3'd3 && (u1_in == 8'd122 || u2_in == 8'd122)) ? (1'b1) : (flag_U_r[122]);
   assign flag_U_w[123] = (state_r == 3'd3 && (u1_in == 8'd123 || u2_in == 8'd123)) ? (1'b1) : (flag_U_r[123]);
   assign flag_U_w[124] = (state_r == 3'd3 && (u1_in == 8'd124 || u2_in == 8'd124)) ? (1'b1) : (flag_U_r[124]);
   assign flag_U_w[125] = (state_r == 3'd3 && (u1_in == 8'd125 || u2_in == 8'd125)) ? (1'b1) : (flag_U_r[125]);
   assign flag_U_w[126] = (state_r == 3'd3 && (u1_in == 8'd126 || u2_in == 8'd126)) ? (1'b1) : (flag_U_r[126]);
   assign flag_U_w[127] = (state_r == 3'd3 && (u1_in == 8'd127 || u2_in == 8'd127)) ? (1'b1) : (flag_U_r[127]);
   assign flag_U_w[128] = (state_r == 3'd3 && (u1_in == 8'd128 || u2_in == 8'd128)) ? (1'b1) : (flag_U_r[128]);
   assign flag_U_w[129] = (state_r == 3'd3 && (u1_in == 8'd129 || u2_in == 8'd129)) ? (1'b1) : (flag_U_r[129]);
   assign flag_U_w[130] = (state_r == 3'd3 && (u1_in == 8'd130 || u2_in == 8'd130)) ? (1'b1) : (flag_U_r[130]);
   assign flag_U_w[131] = (state_r == 3'd3 && (u1_in == 8'd131 || u2_in == 8'd131)) ? (1'b1) : (flag_U_r[131]);
   assign flag_U_w[132] = (state_r == 3'd3 && (u1_in == 8'd132 || u2_in == 8'd132)) ? (1'b1) : (flag_U_r[132]);
   assign flag_U_w[133] = (state_r == 3'd3 && (u1_in == 8'd133 || u2_in == 8'd133)) ? (1'b1) : (flag_U_r[133]);
   assign flag_U_w[134] = (state_r == 3'd3 && (u1_in == 8'd134 || u2_in == 8'd134)) ? (1'b1) : (flag_U_r[134]);
   assign flag_U_w[135] = (state_r == 3'd3 && (u1_in == 8'd135 || u2_in == 8'd135)) ? (1'b1) : (flag_U_r[135]);
   assign flag_U_w[136] = (state_r == 3'd3 && (u1_in == 8'd136 || u2_in == 8'd136)) ? (1'b1) : (flag_U_r[136]);
   assign flag_U_w[137] = (state_r == 3'd3 && (u1_in == 8'd137 || u2_in == 8'd137)) ? (1'b1) : (flag_U_r[137]);
   assign flag_U_w[138] = (state_r == 3'd3 && (u1_in == 8'd138 || u2_in == 8'd138)) ? (1'b1) : (flag_U_r[138]);
   assign flag_U_w[139] = (state_r == 3'd3 && (u1_in == 8'd139 || u2_in == 8'd139)) ? (1'b1) : (flag_U_r[139]);
   assign flag_U_w[140] = (state_r == 3'd3 && (u1_in == 8'd140 || u2_in == 8'd140)) ? (1'b1) : (flag_U_r[140]);
   assign flag_U_w[141] = (state_r == 3'd3 && (u1_in == 8'd141 || u2_in == 8'd141)) ? (1'b1) : (flag_U_r[141]);
   assign flag_U_w[142] = (state_r == 3'd3 && (u1_in == 8'd142 || u2_in == 8'd142)) ? (1'b1) : (flag_U_r[142]);
   assign flag_U_w[143] = (state_r == 3'd3 && (u1_in == 8'd143 || u2_in == 8'd143)) ? (1'b1) : (flag_U_r[143]);
   assign flag_U_w[144] = (state_r == 3'd3 && (u1_in == 8'd144 || u2_in == 8'd144)) ? (1'b1) : (flag_U_r[144]);
   assign flag_U_w[145] = (state_r == 3'd3 && (u1_in == 8'd145 || u2_in == 8'd145)) ? (1'b1) : (flag_U_r[145]);
   assign flag_U_w[146] = (state_r == 3'd3 && (u1_in == 8'd146 || u2_in == 8'd146)) ? (1'b1) : (flag_U_r[146]);
   assign flag_U_w[147] = (state_r == 3'd3 && (u1_in == 8'd147 || u2_in == 8'd147)) ? (1'b1) : (flag_U_r[147]);
   assign flag_U_w[148] = (state_r == 3'd3 && (u1_in == 8'd148 || u2_in == 8'd148)) ? (1'b1) : (flag_U_r[148]);
   assign flag_U_w[149] = (state_r == 3'd3 && (u1_in == 8'd149 || u2_in == 8'd149)) ? (1'b1) : (flag_U_r[149]);
   assign flag_U_w[150] = (state_r == 3'd3 && (u1_in == 8'd150 || u2_in == 8'd150)) ? (1'b1) : (flag_U_r[150]);
   assign flag_U_w[151] = (state_r == 3'd3 && (u1_in == 8'd151 || u2_in == 8'd151)) ? (1'b1) : (flag_U_r[151]);
   assign flag_U_w[152] = (state_r == 3'd3 && (u1_in == 8'd152 || u2_in == 8'd152)) ? (1'b1) : (flag_U_r[152]);
   assign flag_U_w[153] = (state_r == 3'd3 && (u1_in == 8'd153 || u2_in == 8'd153)) ? (1'b1) : (flag_U_r[153]);
   assign flag_U_w[154] = (state_r == 3'd3 && (u1_in == 8'd154 || u2_in == 8'd154)) ? (1'b1) : (flag_U_r[154]);
   assign flag_U_w[155] = (state_r == 3'd3 && (u1_in == 8'd155 || u2_in == 8'd155)) ? (1'b1) : (flag_U_r[155]);
   assign flag_U_w[156] = (state_r == 3'd3 && (u1_in == 8'd156 || u2_in == 8'd156)) ? (1'b1) : (flag_U_r[156]);
   assign flag_U_w[157] = (state_r == 3'd3 && (u1_in == 8'd157 || u2_in == 8'd157)) ? (1'b1) : (flag_U_r[157]);
   assign flag_U_w[158] = (state_r == 3'd3 && (u1_in == 8'd158 || u2_in == 8'd158)) ? (1'b1) : (flag_U_r[158]);
   assign flag_U_w[159] = (state_r == 3'd3 && (u1_in == 8'd159 || u2_in == 8'd159)) ? (1'b1) : (flag_U_r[159]);
   assign flag_U_w[160] = (state_r == 3'd3 && (u1_in == 8'd160 || u2_in == 8'd160)) ? (1'b1) : (flag_U_r[160]);
   assign flag_U_w[161] = (state_r == 3'd3 && (u1_in == 8'd161 || u2_in == 8'd161)) ? (1'b1) : (flag_U_r[161]);
   assign flag_U_w[162] = (state_r == 3'd3 && (u1_in == 8'd162 || u2_in == 8'd162)) ? (1'b1) : (flag_U_r[162]);
   assign flag_U_w[163] = (state_r == 3'd3 && (u1_in == 8'd163 || u2_in == 8'd163)) ? (1'b1) : (flag_U_r[163]);
   assign flag_U_w[164] = (state_r == 3'd3 && (u1_in == 8'd164 || u2_in == 8'd164)) ? (1'b1) : (flag_U_r[164]);
   assign flag_U_w[165] = (state_r == 3'd3 && (u1_in == 8'd165 || u2_in == 8'd165)) ? (1'b1) : (flag_U_r[165]);
   assign flag_U_w[166] = (state_r == 3'd3 && (u1_in == 8'd166 || u2_in == 8'd166)) ? (1'b1) : (flag_U_r[166]);
   assign flag_U_w[167] = (state_r == 3'd3 && (u1_in == 8'd167 || u2_in == 8'd167)) ? (1'b1) : (flag_U_r[167]);
   assign flag_U_w[168] = (state_r == 3'd3 && (u1_in == 8'd168 || u2_in == 8'd168)) ? (1'b1) : (flag_U_r[168]);
   assign flag_U_w[169] = (state_r == 3'd3 && (u1_in == 8'd169 || u2_in == 8'd169)) ? (1'b1) : (flag_U_r[169]);
   assign flag_U_w[170] = (state_r == 3'd3 && (u1_in == 8'd170 || u2_in == 8'd170)) ? (1'b1) : (flag_U_r[170]);
   assign flag_U_w[171] = (state_r == 3'd3 && (u1_in == 8'd171 || u2_in == 8'd171)) ? (1'b1) : (flag_U_r[171]);
   assign flag_U_w[172] = (state_r == 3'd3 && (u1_in == 8'd172 || u2_in == 8'd172)) ? (1'b1) : (flag_U_r[172]);
   assign flag_U_w[173] = (state_r == 3'd3 && (u1_in == 8'd173 || u2_in == 8'd173)) ? (1'b1) : (flag_U_r[173]);
   assign flag_U_w[174] = (state_r == 3'd3 && (u1_in == 8'd174 || u2_in == 8'd174)) ? (1'b1) : (flag_U_r[174]);
   assign flag_U_w[175] = (state_r == 3'd3 && (u1_in == 8'd175 || u2_in == 8'd175)) ? (1'b1) : (flag_U_r[175]);
   assign flag_U_w[176] = (state_r == 3'd3 && (u1_in == 8'd176 || u2_in == 8'd176)) ? (1'b1) : (flag_U_r[176]);
   assign flag_U_w[177] = (state_r == 3'd3 && (u1_in == 8'd177 || u2_in == 8'd177)) ? (1'b1) : (flag_U_r[177]);
   assign flag_U_w[178] = (state_r == 3'd3 && (u1_in == 8'd178 || u2_in == 8'd178)) ? (1'b1) : (flag_U_r[178]);
   assign flag_U_w[179] = (state_r == 3'd3 && (u1_in == 8'd179 || u2_in == 8'd179)) ? (1'b1) : (flag_U_r[179]);
   assign flag_U_w[180] = (state_r == 3'd3 && (u1_in == 8'd180 || u2_in == 8'd180)) ? (1'b1) : (flag_U_r[180]);
   assign flag_U_w[181] = (state_r == 3'd3 && (u1_in == 8'd181 || u2_in == 8'd181)) ? (1'b1) : (flag_U_r[181]);
   assign flag_U_w[182] = (state_r == 3'd3 && (u1_in == 8'd182 || u2_in == 8'd182)) ? (1'b1) : (flag_U_r[182]);
   assign flag_U_w[183] = (state_r == 3'd3 && (u1_in == 8'd183 || u2_in == 8'd183)) ? (1'b1) : (flag_U_r[183]);
   assign flag_U_w[184] = (state_r == 3'd3 && (u1_in == 8'd184 || u2_in == 8'd184)) ? (1'b1) : (flag_U_r[184]);
   assign flag_U_w[185] = (state_r == 3'd3 && (u1_in == 8'd185 || u2_in == 8'd185)) ? (1'b1) : (flag_U_r[185]);
   assign flag_U_w[186] = (state_r == 3'd3 && (u1_in == 8'd186 || u2_in == 8'd186)) ? (1'b1) : (flag_U_r[186]);
   assign flag_U_w[187] = (state_r == 3'd3 && (u1_in == 8'd187 || u2_in == 8'd187)) ? (1'b1) : (flag_U_r[187]);
   assign flag_U_w[188] = (state_r == 3'd3 && (u1_in == 8'd188 || u2_in == 8'd188)) ? (1'b1) : (flag_U_r[188]);
   assign flag_U_w[189] = (state_r == 3'd3 && (u1_in == 8'd189 || u2_in == 8'd189)) ? (1'b1) : (flag_U_r[189]);
   assign flag_U_w[190] = (state_r == 3'd3 && (u1_in == 8'd190 || u2_in == 8'd190)) ? (1'b1) : (flag_U_r[190]);
   assign flag_U_w[191] = (state_r == 3'd3 && (u1_in == 8'd191 || u2_in == 8'd191)) ? (1'b1) : (flag_U_r[191]);
   assign flag_U_w[192] = (state_r == 3'd3 && (u1_in == 8'd192 || u2_in == 8'd192)) ? (1'b1) : (flag_U_r[192]);
   assign flag_U_w[193] = (state_r == 3'd3 && (u1_in == 8'd193 || u2_in == 8'd193)) ? (1'b1) : (flag_U_r[193]);
   assign flag_U_w[194] = (state_r == 3'd3 && (u1_in == 8'd194 || u2_in == 8'd194)) ? (1'b1) : (flag_U_r[194]);
   assign flag_U_w[195] = (state_r == 3'd3 && (u1_in == 8'd195 || u2_in == 8'd195)) ? (1'b1) : (flag_U_r[195]);
   assign flag_U_w[196] = (state_r == 3'd3 && (u1_in == 8'd196 || u2_in == 8'd196)) ? (1'b1) : (flag_U_r[196]);
   assign flag_U_w[197] = (state_r == 3'd3 && (u1_in == 8'd197 || u2_in == 8'd197)) ? (1'b1) : (flag_U_r[197]);
   assign flag_U_w[198] = (state_r == 3'd3 && (u1_in == 8'd198 || u2_in == 8'd198)) ? (1'b1) : (flag_U_r[198]);
   assign flag_U_w[199] = (state_r == 3'd3 && (u1_in == 8'd199 || u2_in == 8'd199)) ? (1'b1) : (flag_U_r[199]);
   assign flag_U_w[200] = (state_r == 3'd3 && (u1_in == 8'd200 || u2_in == 8'd200)) ? (1'b1) : (flag_U_r[200]);
   assign flag_U_w[201] = (state_r == 3'd3 && (u1_in == 8'd201 || u2_in == 8'd201)) ? (1'b1) : (flag_U_r[201]);
   assign flag_U_w[202] = (state_r == 3'd3 && (u1_in == 8'd202 || u2_in == 8'd202)) ? (1'b1) : (flag_U_r[202]);
   assign flag_U_w[203] = (state_r == 3'd3 && (u1_in == 8'd203 || u2_in == 8'd203)) ? (1'b1) : (flag_U_r[203]);
   assign flag_U_w[204] = (state_r == 3'd3 && (u1_in == 8'd204 || u2_in == 8'd204)) ? (1'b1) : (flag_U_r[204]);
   assign flag_U_w[205] = (state_r == 3'd3 && (u1_in == 8'd205 || u2_in == 8'd205)) ? (1'b1) : (flag_U_r[205]);
   assign flag_U_w[206] = (state_r == 3'd3 && (u1_in == 8'd206 || u2_in == 8'd206)) ? (1'b1) : (flag_U_r[206]);
   assign flag_U_w[207] = (state_r == 3'd3 && (u1_in == 8'd207 || u2_in == 8'd207)) ? (1'b1) : (flag_U_r[207]);
   assign flag_U_w[208] = (state_r == 3'd3 && (u1_in == 8'd208 || u2_in == 8'd208)) ? (1'b1) : (flag_U_r[208]);
   assign flag_U_w[209] = (state_r == 3'd3 && (u1_in == 8'd209 || u2_in == 8'd209)) ? (1'b1) : (flag_U_r[209]);
   assign flag_U_w[210] = (state_r == 3'd3 && (u1_in == 8'd210 || u2_in == 8'd210)) ? (1'b1) : (flag_U_r[210]);
   assign flag_U_w[211] = (state_r == 3'd3 && (u1_in == 8'd211 || u2_in == 8'd211)) ? (1'b1) : (flag_U_r[211]);
   assign flag_U_w[212] = (state_r == 3'd3 && (u1_in == 8'd212 || u2_in == 8'd212)) ? (1'b1) : (flag_U_r[212]);
   assign flag_U_w[213] = (state_r == 3'd3 && (u1_in == 8'd213 || u2_in == 8'd213)) ? (1'b1) : (flag_U_r[213]);
   assign flag_U_w[214] = (state_r == 3'd3 && (u1_in == 8'd214 || u2_in == 8'd214)) ? (1'b1) : (flag_U_r[214]);
   assign flag_U_w[215] = (state_r == 3'd3 && (u1_in == 8'd215 || u2_in == 8'd215)) ? (1'b1) : (flag_U_r[215]);
   assign flag_U_w[216] = (state_r == 3'd3 && (u1_in == 8'd216 || u2_in == 8'd216)) ? (1'b1) : (flag_U_r[216]);
   assign flag_U_w[217] = (state_r == 3'd3 && (u1_in == 8'd217 || u2_in == 8'd217)) ? (1'b1) : (flag_U_r[217]);
   assign flag_U_w[218] = (state_r == 3'd3 && (u1_in == 8'd218 || u2_in == 8'd218)) ? (1'b1) : (flag_U_r[218]);
   assign flag_U_w[219] = (state_r == 3'd3 && (u1_in == 8'd219 || u2_in == 8'd219)) ? (1'b1) : (flag_U_r[219]);
   assign flag_U_w[220] = (state_r == 3'd3 && (u1_in == 8'd220 || u2_in == 8'd220)) ? (1'b1) : (flag_U_r[220]);
   assign flag_U_w[221] = (state_r == 3'd3 && (u1_in == 8'd221 || u2_in == 8'd221)) ? (1'b1) : (flag_U_r[221]);
   assign flag_U_w[222] = (state_r == 3'd3 && (u1_in == 8'd222 || u2_in == 8'd222)) ? (1'b1) : (flag_U_r[222]);
   assign flag_U_w[223] = (state_r == 3'd3 && (u1_in == 8'd223 || u2_in == 8'd223)) ? (1'b1) : (flag_U_r[223]);
   assign flag_U_w[224] = (state_r == 3'd3 && (u1_in == 8'd224 || u2_in == 8'd224)) ? (1'b1) : (flag_U_r[224]);
   assign flag_U_w[225] = (state_r == 3'd3 && (u1_in == 8'd225 || u2_in == 8'd225)) ? (1'b1) : (flag_U_r[225]);
   assign flag_U_w[226] = (state_r == 3'd3 && (u1_in == 8'd226 || u2_in == 8'd226)) ? (1'b1) : (flag_U_r[226]);
   assign flag_U_w[227] = (state_r == 3'd3 && (u1_in == 8'd227 || u2_in == 8'd227)) ? (1'b1) : (flag_U_r[227]);
   assign flag_U_w[228] = (state_r == 3'd3 && (u1_in == 8'd228 || u2_in == 8'd228)) ? (1'b1) : (flag_U_r[228]);
   assign flag_U_w[229] = (state_r == 3'd3 && (u1_in == 8'd229 || u2_in == 8'd229)) ? (1'b1) : (flag_U_r[229]);
   assign flag_U_w[230] = (state_r == 3'd3 && (u1_in == 8'd230 || u2_in == 8'd230)) ? (1'b1) : (flag_U_r[230]);
   assign flag_U_w[231] = (state_r == 3'd3 && (u1_in == 8'd231 || u2_in == 8'd231)) ? (1'b1) : (flag_U_r[231]);
   assign flag_U_w[232] = (state_r == 3'd3 && (u1_in == 8'd232 || u2_in == 8'd232)) ? (1'b1) : (flag_U_r[232]);
   assign flag_U_w[233] = (state_r == 3'd3 && (u1_in == 8'd233 || u2_in == 8'd233)) ? (1'b1) : (flag_U_r[233]);
   assign flag_U_w[234] = (state_r == 3'd3 && (u1_in == 8'd234 || u2_in == 8'd234)) ? (1'b1) : (flag_U_r[234]);
   assign flag_U_w[235] = (state_r == 3'd3 && (u1_in == 8'd235 || u2_in == 8'd235)) ? (1'b1) : (flag_U_r[235]);
   assign flag_U_w[236] = (state_r == 3'd3 && (u1_in == 8'd236 || u2_in == 8'd236)) ? (1'b1) : (flag_U_r[236]);
   assign flag_U_w[237] = (state_r == 3'd3 && (u1_in == 8'd237 || u2_in == 8'd237)) ? (1'b1) : (flag_U_r[237]);
   assign flag_U_w[238] = (state_r == 3'd3 && (u1_in == 8'd238 || u2_in == 8'd238)) ? (1'b1) : (flag_U_r[238]);
   assign flag_U_w[239] = (state_r == 3'd3 && (u1_in == 8'd239 || u2_in == 8'd239)) ? (1'b1) : (flag_U_r[239]);
   assign flag_U_w[240] = (state_r == 3'd3 && (u1_in == 8'd240 || u2_in == 8'd240)) ? (1'b1) : (flag_U_r[240]);
   assign flag_U_w[241] = (state_r == 3'd3 && (u1_in == 8'd241 || u2_in == 8'd241)) ? (1'b1) : (flag_U_r[241]);
   assign flag_U_w[242] = (state_r == 3'd3 && (u1_in == 8'd242 || u2_in == 8'd242)) ? (1'b1) : (flag_U_r[242]);
   assign flag_U_w[243] = (state_r == 3'd3 && (u1_in == 8'd243 || u2_in == 8'd243)) ? (1'b1) : (flag_U_r[243]);
   assign flag_U_w[244] = (state_r == 3'd3 && (u1_in == 8'd244 || u2_in == 8'd244)) ? (1'b1) : (flag_U_r[244]);
   assign flag_U_w[245] = (state_r == 3'd3 && (u1_in == 8'd245 || u2_in == 8'd245)) ? (1'b1) : (flag_U_r[245]);
   assign flag_U_w[246] = (state_r == 3'd3 && (u1_in == 8'd246 || u2_in == 8'd246)) ? (1'b1) : (flag_U_r[246]);
   assign flag_U_w[247] = (state_r == 3'd3 && (u1_in == 8'd247 || u2_in == 8'd247)) ? (1'b1) : (flag_U_r[247]);
   assign flag_U_w[248] = (state_r == 3'd3 && (u1_in == 8'd248 || u2_in == 8'd248)) ? (1'b1) : (flag_U_r[248]);
   assign flag_U_w[249] = (state_r == 3'd3 && (u1_in == 8'd249 || u2_in == 8'd249)) ? (1'b1) : (flag_U_r[249]);
   assign flag_U_w[250] = (state_r == 3'd3 && (u1_in == 8'd250 || u2_in == 8'd250)) ? (1'b1) : (flag_U_r[250]);
   assign flag_U_w[251] = (state_r == 3'd3 && (u1_in == 8'd251 || u2_in == 8'd251)) ? (1'b1) : (flag_U_r[251]);
   assign flag_U_w[252] = (state_r == 3'd3 && (u1_in == 8'd252 || u2_in == 8'd252)) ? (1'b1) : (flag_U_r[252]);
   assign flag_U_w[253] = (state_r == 3'd3 && (u1_in == 8'd253 || u2_in == 8'd253)) ? (1'b1) : (flag_U_r[253]);
   assign flag_U_w[254] = (state_r == 3'd3 && (u1_in == 8'd254 || u2_in == 8'd254)) ? (1'b1) : (flag_U_r[254]);
   assign flag_U_w[255] = (state_r == 3'd3 && (u1_in == 8'd255 || u2_in == 8'd255)) ? (1'b1) : (flag_U_r[255]);
   
   assign flag_V_w[000] = (state_r == 3'd3 && (v1_in == 8'd000 || v2_in == 8'd000)) ? (1'b1) : (flag_V_r[000]);
   assign flag_V_w[001] = (state_r == 3'd3 && (v1_in == 8'd001 || v2_in == 8'd001)) ? (1'b1) : (flag_V_r[001]);
   assign flag_V_w[002] = (state_r == 3'd3 && (v1_in == 8'd002 || v2_in == 8'd002)) ? (1'b1) : (flag_V_r[002]);
   assign flag_V_w[003] = (state_r == 3'd3 && (v1_in == 8'd003 || v2_in == 8'd003)) ? (1'b1) : (flag_V_r[003]);
   assign flag_V_w[004] = (state_r == 3'd3 && (v1_in == 8'd004 || v2_in == 8'd004)) ? (1'b1) : (flag_V_r[004]);
   assign flag_V_w[005] = (state_r == 3'd3 && (v1_in == 8'd005 || v2_in == 8'd005)) ? (1'b1) : (flag_V_r[005]);
   assign flag_V_w[006] = (state_r == 3'd3 && (v1_in == 8'd006 || v2_in == 8'd006)) ? (1'b1) : (flag_V_r[006]);
   assign flag_V_w[007] = (state_r == 3'd3 && (v1_in == 8'd007 || v2_in == 8'd007)) ? (1'b1) : (flag_V_r[007]);
   assign flag_V_w[008] = (state_r == 3'd3 && (v1_in == 8'd008 || v2_in == 8'd008)) ? (1'b1) : (flag_V_r[008]);
   assign flag_V_w[009] = (state_r == 3'd3 && (v1_in == 8'd009 || v2_in == 8'd009)) ? (1'b1) : (flag_V_r[009]);
   assign flag_V_w[010] = (state_r == 3'd3 && (v1_in == 8'd010 || v2_in == 8'd010)) ? (1'b1) : (flag_V_r[010]);
   assign flag_V_w[011] = (state_r == 3'd3 && (v1_in == 8'd011 || v2_in == 8'd011)) ? (1'b1) : (flag_V_r[011]);
   assign flag_V_w[012] = (state_r == 3'd3 && (v1_in == 8'd012 || v2_in == 8'd012)) ? (1'b1) : (flag_V_r[012]);
   assign flag_V_w[013] = (state_r == 3'd3 && (v1_in == 8'd013 || v2_in == 8'd013)) ? (1'b1) : (flag_V_r[013]);
   assign flag_V_w[014] = (state_r == 3'd3 && (v1_in == 8'd014 || v2_in == 8'd014)) ? (1'b1) : (flag_V_r[014]);
   assign flag_V_w[015] = (state_r == 3'd3 && (v1_in == 8'd015 || v2_in == 8'd015)) ? (1'b1) : (flag_V_r[015]);
   assign flag_V_w[016] = (state_r == 3'd3 && (v1_in == 8'd016 || v2_in == 8'd016)) ? (1'b1) : (flag_V_r[016]);
   assign flag_V_w[017] = (state_r == 3'd3 && (v1_in == 8'd017 || v2_in == 8'd017)) ? (1'b1) : (flag_V_r[017]);
   assign flag_V_w[018] = (state_r == 3'd3 && (v1_in == 8'd018 || v2_in == 8'd018)) ? (1'b1) : (flag_V_r[018]);
   assign flag_V_w[019] = (state_r == 3'd3 && (v1_in == 8'd019 || v2_in == 8'd019)) ? (1'b1) : (flag_V_r[019]);
   assign flag_V_w[020] = (state_r == 3'd3 && (v1_in == 8'd020 || v2_in == 8'd020)) ? (1'b1) : (flag_V_r[020]);
   assign flag_V_w[021] = (state_r == 3'd3 && (v1_in == 8'd021 || v2_in == 8'd021)) ? (1'b1) : (flag_V_r[021]);
   assign flag_V_w[022] = (state_r == 3'd3 && (v1_in == 8'd022 || v2_in == 8'd022)) ? (1'b1) : (flag_V_r[022]);
   assign flag_V_w[023] = (state_r == 3'd3 && (v1_in == 8'd023 || v2_in == 8'd023)) ? (1'b1) : (flag_V_r[023]);
   assign flag_V_w[024] = (state_r == 3'd3 && (v1_in == 8'd024 || v2_in == 8'd024)) ? (1'b1) : (flag_V_r[024]);
   assign flag_V_w[025] = (state_r == 3'd3 && (v1_in == 8'd025 || v2_in == 8'd025)) ? (1'b1) : (flag_V_r[025]);
   assign flag_V_w[026] = (state_r == 3'd3 && (v1_in == 8'd026 || v2_in == 8'd026)) ? (1'b1) : (flag_V_r[026]);
   assign flag_V_w[027] = (state_r == 3'd3 && (v1_in == 8'd027 || v2_in == 8'd027)) ? (1'b1) : (flag_V_r[027]);
   assign flag_V_w[028] = (state_r == 3'd3 && (v1_in == 8'd028 || v2_in == 8'd028)) ? (1'b1) : (flag_V_r[028]);
   assign flag_V_w[029] = (state_r == 3'd3 && (v1_in == 8'd029 || v2_in == 8'd029)) ? (1'b1) : (flag_V_r[029]);
   assign flag_V_w[030] = (state_r == 3'd3 && (v1_in == 8'd030 || v2_in == 8'd030)) ? (1'b1) : (flag_V_r[030]);
   assign flag_V_w[031] = (state_r == 3'd3 && (v1_in == 8'd031 || v2_in == 8'd031)) ? (1'b1) : (flag_V_r[031]);
   assign flag_V_w[032] = (state_r == 3'd3 && (v1_in == 8'd032 || v2_in == 8'd032)) ? (1'b1) : (flag_V_r[032]);
   assign flag_V_w[033] = (state_r == 3'd3 && (v1_in == 8'd033 || v2_in == 8'd033)) ? (1'b1) : (flag_V_r[033]);
   assign flag_V_w[034] = (state_r == 3'd3 && (v1_in == 8'd034 || v2_in == 8'd034)) ? (1'b1) : (flag_V_r[034]);
   assign flag_V_w[035] = (state_r == 3'd3 && (v1_in == 8'd035 || v2_in == 8'd035)) ? (1'b1) : (flag_V_r[035]);
   assign flag_V_w[036] = (state_r == 3'd3 && (v1_in == 8'd036 || v2_in == 8'd036)) ? (1'b1) : (flag_V_r[036]);
   assign flag_V_w[037] = (state_r == 3'd3 && (v1_in == 8'd037 || v2_in == 8'd037)) ? (1'b1) : (flag_V_r[037]);
   assign flag_V_w[038] = (state_r == 3'd3 && (v1_in == 8'd038 || v2_in == 8'd038)) ? (1'b1) : (flag_V_r[038]);
   assign flag_V_w[039] = (state_r == 3'd3 && (v1_in == 8'd039 || v2_in == 8'd039)) ? (1'b1) : (flag_V_r[039]);
   assign flag_V_w[040] = (state_r == 3'd3 && (v1_in == 8'd040 || v2_in == 8'd040)) ? (1'b1) : (flag_V_r[040]);
   assign flag_V_w[041] = (state_r == 3'd3 && (v1_in == 8'd041 || v2_in == 8'd041)) ? (1'b1) : (flag_V_r[041]);
   assign flag_V_w[042] = (state_r == 3'd3 && (v1_in == 8'd042 || v2_in == 8'd042)) ? (1'b1) : (flag_V_r[042]);
   assign flag_V_w[043] = (state_r == 3'd3 && (v1_in == 8'd043 || v2_in == 8'd043)) ? (1'b1) : (flag_V_r[043]);
   assign flag_V_w[044] = (state_r == 3'd3 && (v1_in == 8'd044 || v2_in == 8'd044)) ? (1'b1) : (flag_V_r[044]);
   assign flag_V_w[045] = (state_r == 3'd3 && (v1_in == 8'd045 || v2_in == 8'd045)) ? (1'b1) : (flag_V_r[045]);
   assign flag_V_w[046] = (state_r == 3'd3 && (v1_in == 8'd046 || v2_in == 8'd046)) ? (1'b1) : (flag_V_r[046]);
   assign flag_V_w[047] = (state_r == 3'd3 && (v1_in == 8'd047 || v2_in == 8'd047)) ? (1'b1) : (flag_V_r[047]);
   assign flag_V_w[048] = (state_r == 3'd3 && (v1_in == 8'd048 || v2_in == 8'd048)) ? (1'b1) : (flag_V_r[048]);
   assign flag_V_w[049] = (state_r == 3'd3 && (v1_in == 8'd049 || v2_in == 8'd049)) ? (1'b1) : (flag_V_r[049]);
   assign flag_V_w[050] = (state_r == 3'd3 && (v1_in == 8'd050 || v2_in == 8'd050)) ? (1'b1) : (flag_V_r[050]);
   assign flag_V_w[051] = (state_r == 3'd3 && (v1_in == 8'd051 || v2_in == 8'd051)) ? (1'b1) : (flag_V_r[051]);
   assign flag_V_w[052] = (state_r == 3'd3 && (v1_in == 8'd052 || v2_in == 8'd052)) ? (1'b1) : (flag_V_r[052]);
   assign flag_V_w[053] = (state_r == 3'd3 && (v1_in == 8'd053 || v2_in == 8'd053)) ? (1'b1) : (flag_V_r[053]);
   assign flag_V_w[054] = (state_r == 3'd3 && (v1_in == 8'd054 || v2_in == 8'd054)) ? (1'b1) : (flag_V_r[054]);
   assign flag_V_w[055] = (state_r == 3'd3 && (v1_in == 8'd055 || v2_in == 8'd055)) ? (1'b1) : (flag_V_r[055]);
   assign flag_V_w[056] = (state_r == 3'd3 && (v1_in == 8'd056 || v2_in == 8'd056)) ? (1'b1) : (flag_V_r[056]);
   assign flag_V_w[057] = (state_r == 3'd3 && (v1_in == 8'd057 || v2_in == 8'd057)) ? (1'b1) : (flag_V_r[057]);
   assign flag_V_w[058] = (state_r == 3'd3 && (v1_in == 8'd058 || v2_in == 8'd058)) ? (1'b1) : (flag_V_r[058]);
   assign flag_V_w[059] = (state_r == 3'd3 && (v1_in == 8'd059 || v2_in == 8'd059)) ? (1'b1) : (flag_V_r[059]);
   assign flag_V_w[060] = (state_r == 3'd3 && (v1_in == 8'd060 || v2_in == 8'd060)) ? (1'b1) : (flag_V_r[060]);
   assign flag_V_w[061] = (state_r == 3'd3 && (v1_in == 8'd061 || v2_in == 8'd061)) ? (1'b1) : (flag_V_r[061]);
   assign flag_V_w[062] = (state_r == 3'd3 && (v1_in == 8'd062 || v2_in == 8'd062)) ? (1'b1) : (flag_V_r[062]);
   assign flag_V_w[063] = (state_r == 3'd3 && (v1_in == 8'd063 || v2_in == 8'd063)) ? (1'b1) : (flag_V_r[063]);
   assign flag_V_w[064] = (state_r == 3'd3 && (v1_in == 8'd064 || v2_in == 8'd064)) ? (1'b1) : (flag_V_r[064]);
   assign flag_V_w[065] = (state_r == 3'd3 && (v1_in == 8'd065 || v2_in == 8'd065)) ? (1'b1) : (flag_V_r[065]);
   assign flag_V_w[066] = (state_r == 3'd3 && (v1_in == 8'd066 || v2_in == 8'd066)) ? (1'b1) : (flag_V_r[066]);
   assign flag_V_w[067] = (state_r == 3'd3 && (v1_in == 8'd067 || v2_in == 8'd067)) ? (1'b1) : (flag_V_r[067]);
   assign flag_V_w[068] = (state_r == 3'd3 && (v1_in == 8'd068 || v2_in == 8'd068)) ? (1'b1) : (flag_V_r[068]);
   assign flag_V_w[069] = (state_r == 3'd3 && (v1_in == 8'd069 || v2_in == 8'd069)) ? (1'b1) : (flag_V_r[069]);
   assign flag_V_w[070] = (state_r == 3'd3 && (v1_in == 8'd070 || v2_in == 8'd070)) ? (1'b1) : (flag_V_r[070]);
   assign flag_V_w[071] = (state_r == 3'd3 && (v1_in == 8'd071 || v2_in == 8'd071)) ? (1'b1) : (flag_V_r[071]);
   assign flag_V_w[072] = (state_r == 3'd3 && (v1_in == 8'd072 || v2_in == 8'd072)) ? (1'b1) : (flag_V_r[072]);
   assign flag_V_w[073] = (state_r == 3'd3 && (v1_in == 8'd073 || v2_in == 8'd073)) ? (1'b1) : (flag_V_r[073]);
   assign flag_V_w[074] = (state_r == 3'd3 && (v1_in == 8'd074 || v2_in == 8'd074)) ? (1'b1) : (flag_V_r[074]);
   assign flag_V_w[075] = (state_r == 3'd3 && (v1_in == 8'd075 || v2_in == 8'd075)) ? (1'b1) : (flag_V_r[075]);
   assign flag_V_w[076] = (state_r == 3'd3 && (v1_in == 8'd076 || v2_in == 8'd076)) ? (1'b1) : (flag_V_r[076]);
   assign flag_V_w[077] = (state_r == 3'd3 && (v1_in == 8'd077 || v2_in == 8'd077)) ? (1'b1) : (flag_V_r[077]);
   assign flag_V_w[078] = (state_r == 3'd3 && (v1_in == 8'd078 || v2_in == 8'd078)) ? (1'b1) : (flag_V_r[078]);
   assign flag_V_w[079] = (state_r == 3'd3 && (v1_in == 8'd079 || v2_in == 8'd079)) ? (1'b1) : (flag_V_r[079]);
   assign flag_V_w[080] = (state_r == 3'd3 && (v1_in == 8'd080 || v2_in == 8'd080)) ? (1'b1) : (flag_V_r[080]);
   assign flag_V_w[081] = (state_r == 3'd3 && (v1_in == 8'd081 || v2_in == 8'd081)) ? (1'b1) : (flag_V_r[081]);
   assign flag_V_w[082] = (state_r == 3'd3 && (v1_in == 8'd082 || v2_in == 8'd082)) ? (1'b1) : (flag_V_r[082]);
   assign flag_V_w[083] = (state_r == 3'd3 && (v1_in == 8'd083 || v2_in == 8'd083)) ? (1'b1) : (flag_V_r[083]);
   assign flag_V_w[084] = (state_r == 3'd3 && (v1_in == 8'd084 || v2_in == 8'd084)) ? (1'b1) : (flag_V_r[084]);
   assign flag_V_w[085] = (state_r == 3'd3 && (v1_in == 8'd085 || v2_in == 8'd085)) ? (1'b1) : (flag_V_r[085]);
   assign flag_V_w[086] = (state_r == 3'd3 && (v1_in == 8'd086 || v2_in == 8'd086)) ? (1'b1) : (flag_V_r[086]);
   assign flag_V_w[087] = (state_r == 3'd3 && (v1_in == 8'd087 || v2_in == 8'd087)) ? (1'b1) : (flag_V_r[087]);
   assign flag_V_w[088] = (state_r == 3'd3 && (v1_in == 8'd088 || v2_in == 8'd088)) ? (1'b1) : (flag_V_r[088]);
   assign flag_V_w[089] = (state_r == 3'd3 && (v1_in == 8'd089 || v2_in == 8'd089)) ? (1'b1) : (flag_V_r[089]);
   assign flag_V_w[090] = (state_r == 3'd3 && (v1_in == 8'd090 || v2_in == 8'd090)) ? (1'b1) : (flag_V_r[090]);
   assign flag_V_w[091] = (state_r == 3'd3 && (v1_in == 8'd091 || v2_in == 8'd091)) ? (1'b1) : (flag_V_r[091]);
   assign flag_V_w[092] = (state_r == 3'd3 && (v1_in == 8'd092 || v2_in == 8'd092)) ? (1'b1) : (flag_V_r[092]);
   assign flag_V_w[093] = (state_r == 3'd3 && (v1_in == 8'd093 || v2_in == 8'd093)) ? (1'b1) : (flag_V_r[093]);
   assign flag_V_w[094] = (state_r == 3'd3 && (v1_in == 8'd094 || v2_in == 8'd094)) ? (1'b1) : (flag_V_r[094]);
   assign flag_V_w[095] = (state_r == 3'd3 && (v1_in == 8'd095 || v2_in == 8'd095)) ? (1'b1) : (flag_V_r[095]);
   assign flag_V_w[096] = (state_r == 3'd3 && (v1_in == 8'd096 || v2_in == 8'd096)) ? (1'b1) : (flag_V_r[096]);
   assign flag_V_w[097] = (state_r == 3'd3 && (v1_in == 8'd097 || v2_in == 8'd097)) ? (1'b1) : (flag_V_r[097]);
   assign flag_V_w[098] = (state_r == 3'd3 && (v1_in == 8'd098 || v2_in == 8'd098)) ? (1'b1) : (flag_V_r[098]);
   assign flag_V_w[099] = (state_r == 3'd3 && (v1_in == 8'd099 || v2_in == 8'd099)) ? (1'b1) : (flag_V_r[099]);
   assign flag_V_w[100] = (state_r == 3'd3 && (v1_in == 8'd100 || v2_in == 8'd100)) ? (1'b1) : (flag_V_r[100]);
   assign flag_V_w[101] = (state_r == 3'd3 && (v1_in == 8'd101 || v2_in == 8'd101)) ? (1'b1) : (flag_V_r[101]);
   assign flag_V_w[102] = (state_r == 3'd3 && (v1_in == 8'd102 || v2_in == 8'd102)) ? (1'b1) : (flag_V_r[102]);
   assign flag_V_w[103] = (state_r == 3'd3 && (v1_in == 8'd103 || v2_in == 8'd103)) ? (1'b1) : (flag_V_r[103]);
   assign flag_V_w[104] = (state_r == 3'd3 && (v1_in == 8'd104 || v2_in == 8'd104)) ? (1'b1) : (flag_V_r[104]);
   assign flag_V_w[105] = (state_r == 3'd3 && (v1_in == 8'd105 || v2_in == 8'd105)) ? (1'b1) : (flag_V_r[105]);
   assign flag_V_w[106] = (state_r == 3'd3 && (v1_in == 8'd106 || v2_in == 8'd106)) ? (1'b1) : (flag_V_r[106]);
   assign flag_V_w[107] = (state_r == 3'd3 && (v1_in == 8'd107 || v2_in == 8'd107)) ? (1'b1) : (flag_V_r[107]);
   assign flag_V_w[108] = (state_r == 3'd3 && (v1_in == 8'd108 || v2_in == 8'd108)) ? (1'b1) : (flag_V_r[108]);
   assign flag_V_w[109] = (state_r == 3'd3 && (v1_in == 8'd109 || v2_in == 8'd109)) ? (1'b1) : (flag_V_r[109]);
   assign flag_V_w[110] = (state_r == 3'd3 && (v1_in == 8'd110 || v2_in == 8'd110)) ? (1'b1) : (flag_V_r[110]);
   assign flag_V_w[111] = (state_r == 3'd3 && (v1_in == 8'd111 || v2_in == 8'd111)) ? (1'b1) : (flag_V_r[111]);
   assign flag_V_w[112] = (state_r == 3'd3 && (v1_in == 8'd112 || v2_in == 8'd112)) ? (1'b1) : (flag_V_r[112]);
   assign flag_V_w[113] = (state_r == 3'd3 && (v1_in == 8'd113 || v2_in == 8'd113)) ? (1'b1) : (flag_V_r[113]);
   assign flag_V_w[114] = (state_r == 3'd3 && (v1_in == 8'd114 || v2_in == 8'd114)) ? (1'b1) : (flag_V_r[114]);
   assign flag_V_w[115] = (state_r == 3'd3 && (v1_in == 8'd115 || v2_in == 8'd115)) ? (1'b1) : (flag_V_r[115]);
   assign flag_V_w[116] = (state_r == 3'd3 && (v1_in == 8'd116 || v2_in == 8'd116)) ? (1'b1) : (flag_V_r[116]);
   assign flag_V_w[117] = (state_r == 3'd3 && (v1_in == 8'd117 || v2_in == 8'd117)) ? (1'b1) : (flag_V_r[117]);
   assign flag_V_w[118] = (state_r == 3'd3 && (v1_in == 8'd118 || v2_in == 8'd118)) ? (1'b1) : (flag_V_r[118]);
   assign flag_V_w[119] = (state_r == 3'd3 && (v1_in == 8'd119 || v2_in == 8'd119)) ? (1'b1) : (flag_V_r[119]);
   assign flag_V_w[120] = (state_r == 3'd3 && (v1_in == 8'd120 || v2_in == 8'd120)) ? (1'b1) : (flag_V_r[120]);
   assign flag_V_w[121] = (state_r == 3'd3 && (v1_in == 8'd121 || v2_in == 8'd121)) ? (1'b1) : (flag_V_r[121]);
   assign flag_V_w[122] = (state_r == 3'd3 && (v1_in == 8'd122 || v2_in == 8'd122)) ? (1'b1) : (flag_V_r[122]);
   assign flag_V_w[123] = (state_r == 3'd3 && (v1_in == 8'd123 || v2_in == 8'd123)) ? (1'b1) : (flag_V_r[123]);
   assign flag_V_w[124] = (state_r == 3'd3 && (v1_in == 8'd124 || v2_in == 8'd124)) ? (1'b1) : (flag_V_r[124]);
   assign flag_V_w[125] = (state_r == 3'd3 && (v1_in == 8'd125 || v2_in == 8'd125)) ? (1'b1) : (flag_V_r[125]);
   assign flag_V_w[126] = (state_r == 3'd3 && (v1_in == 8'd126 || v2_in == 8'd126)) ? (1'b1) : (flag_V_r[126]);
   assign flag_V_w[127] = (state_r == 3'd3 && (v1_in == 8'd127 || v2_in == 8'd127)) ? (1'b1) : (flag_V_r[127]);
   assign flag_V_w[128] = (state_r == 3'd3 && (v1_in == 8'd128 || v2_in == 8'd128)) ? (1'b1) : (flag_V_r[128]);
   assign flag_V_w[129] = (state_r == 3'd3 && (v1_in == 8'd129 || v2_in == 8'd129)) ? (1'b1) : (flag_V_r[129]);
   assign flag_V_w[130] = (state_r == 3'd3 && (v1_in == 8'd130 || v2_in == 8'd130)) ? (1'b1) : (flag_V_r[130]);
   assign flag_V_w[131] = (state_r == 3'd3 && (v1_in == 8'd131 || v2_in == 8'd131)) ? (1'b1) : (flag_V_r[131]);
   assign flag_V_w[132] = (state_r == 3'd3 && (v1_in == 8'd132 || v2_in == 8'd132)) ? (1'b1) : (flag_V_r[132]);
   assign flag_V_w[133] = (state_r == 3'd3 && (v1_in == 8'd133 || v2_in == 8'd133)) ? (1'b1) : (flag_V_r[133]);
   assign flag_V_w[134] = (state_r == 3'd3 && (v1_in == 8'd134 || v2_in == 8'd134)) ? (1'b1) : (flag_V_r[134]);
   assign flag_V_w[135] = (state_r == 3'd3 && (v1_in == 8'd135 || v2_in == 8'd135)) ? (1'b1) : (flag_V_r[135]);
   assign flag_V_w[136] = (state_r == 3'd3 && (v1_in == 8'd136 || v2_in == 8'd136)) ? (1'b1) : (flag_V_r[136]);
   assign flag_V_w[137] = (state_r == 3'd3 && (v1_in == 8'd137 || v2_in == 8'd137)) ? (1'b1) : (flag_V_r[137]);
   assign flag_V_w[138] = (state_r == 3'd3 && (v1_in == 8'd138 || v2_in == 8'd138)) ? (1'b1) : (flag_V_r[138]);
   assign flag_V_w[139] = (state_r == 3'd3 && (v1_in == 8'd139 || v2_in == 8'd139)) ? (1'b1) : (flag_V_r[139]);
   assign flag_V_w[140] = (state_r == 3'd3 && (v1_in == 8'd140 || v2_in == 8'd140)) ? (1'b1) : (flag_V_r[140]);
   assign flag_V_w[141] = (state_r == 3'd3 && (v1_in == 8'd141 || v2_in == 8'd141)) ? (1'b1) : (flag_V_r[141]);
   assign flag_V_w[142] = (state_r == 3'd3 && (v1_in == 8'd142 || v2_in == 8'd142)) ? (1'b1) : (flag_V_r[142]);
   assign flag_V_w[143] = (state_r == 3'd3 && (v1_in == 8'd143 || v2_in == 8'd143)) ? (1'b1) : (flag_V_r[143]);
   assign flag_V_w[144] = (state_r == 3'd3 && (v1_in == 8'd144 || v2_in == 8'd144)) ? (1'b1) : (flag_V_r[144]);
   assign flag_V_w[145] = (state_r == 3'd3 && (v1_in == 8'd145 || v2_in == 8'd145)) ? (1'b1) : (flag_V_r[145]);
   assign flag_V_w[146] = (state_r == 3'd3 && (v1_in == 8'd146 || v2_in == 8'd146)) ? (1'b1) : (flag_V_r[146]);
   assign flag_V_w[147] = (state_r == 3'd3 && (v1_in == 8'd147 || v2_in == 8'd147)) ? (1'b1) : (flag_V_r[147]);
   assign flag_V_w[148] = (state_r == 3'd3 && (v1_in == 8'd148 || v2_in == 8'd148)) ? (1'b1) : (flag_V_r[148]);
   assign flag_V_w[149] = (state_r == 3'd3 && (v1_in == 8'd149 || v2_in == 8'd149)) ? (1'b1) : (flag_V_r[149]);
   assign flag_V_w[150] = (state_r == 3'd3 && (v1_in == 8'd150 || v2_in == 8'd150)) ? (1'b1) : (flag_V_r[150]);
   assign flag_V_w[151] = (state_r == 3'd3 && (v1_in == 8'd151 || v2_in == 8'd151)) ? (1'b1) : (flag_V_r[151]);
   assign flag_V_w[152] = (state_r == 3'd3 && (v1_in == 8'd152 || v2_in == 8'd152)) ? (1'b1) : (flag_V_r[152]);
   assign flag_V_w[153] = (state_r == 3'd3 && (v1_in == 8'd153 || v2_in == 8'd153)) ? (1'b1) : (flag_V_r[153]);
   assign flag_V_w[154] = (state_r == 3'd3 && (v1_in == 8'd154 || v2_in == 8'd154)) ? (1'b1) : (flag_V_r[154]);
   assign flag_V_w[155] = (state_r == 3'd3 && (v1_in == 8'd155 || v2_in == 8'd155)) ? (1'b1) : (flag_V_r[155]);
   assign flag_V_w[156] = (state_r == 3'd3 && (v1_in == 8'd156 || v2_in == 8'd156)) ? (1'b1) : (flag_V_r[156]);
   assign flag_V_w[157] = (state_r == 3'd3 && (v1_in == 8'd157 || v2_in == 8'd157)) ? (1'b1) : (flag_V_r[157]);
   assign flag_V_w[158] = (state_r == 3'd3 && (v1_in == 8'd158 || v2_in == 8'd158)) ? (1'b1) : (flag_V_r[158]);
   assign flag_V_w[159] = (state_r == 3'd3 && (v1_in == 8'd159 || v2_in == 8'd159)) ? (1'b1) : (flag_V_r[159]);
   assign flag_V_w[160] = (state_r == 3'd3 && (v1_in == 8'd160 || v2_in == 8'd160)) ? (1'b1) : (flag_V_r[160]);
   assign flag_V_w[161] = (state_r == 3'd3 && (v1_in == 8'd161 || v2_in == 8'd161)) ? (1'b1) : (flag_V_r[161]);
   assign flag_V_w[162] = (state_r == 3'd3 && (v1_in == 8'd162 || v2_in == 8'd162)) ? (1'b1) : (flag_V_r[162]);
   assign flag_V_w[163] = (state_r == 3'd3 && (v1_in == 8'd163 || v2_in == 8'd163)) ? (1'b1) : (flag_V_r[163]);
   assign flag_V_w[164] = (state_r == 3'd3 && (v1_in == 8'd164 || v2_in == 8'd164)) ? (1'b1) : (flag_V_r[164]);
   assign flag_V_w[165] = (state_r == 3'd3 && (v1_in == 8'd165 || v2_in == 8'd165)) ? (1'b1) : (flag_V_r[165]);
   assign flag_V_w[166] = (state_r == 3'd3 && (v1_in == 8'd166 || v2_in == 8'd166)) ? (1'b1) : (flag_V_r[166]);
   assign flag_V_w[167] = (state_r == 3'd3 && (v1_in == 8'd167 || v2_in == 8'd167)) ? (1'b1) : (flag_V_r[167]);
   assign flag_V_w[168] = (state_r == 3'd3 && (v1_in == 8'd168 || v2_in == 8'd168)) ? (1'b1) : (flag_V_r[168]);
   assign flag_V_w[169] = (state_r == 3'd3 && (v1_in == 8'd169 || v2_in == 8'd169)) ? (1'b1) : (flag_V_r[169]);
   assign flag_V_w[170] = (state_r == 3'd3 && (v1_in == 8'd170 || v2_in == 8'd170)) ? (1'b1) : (flag_V_r[170]);
   assign flag_V_w[171] = (state_r == 3'd3 && (v1_in == 8'd171 || v2_in == 8'd171)) ? (1'b1) : (flag_V_r[171]);
   assign flag_V_w[172] = (state_r == 3'd3 && (v1_in == 8'd172 || v2_in == 8'd172)) ? (1'b1) : (flag_V_r[172]);
   assign flag_V_w[173] = (state_r == 3'd3 && (v1_in == 8'd173 || v2_in == 8'd173)) ? (1'b1) : (flag_V_r[173]);
   assign flag_V_w[174] = (state_r == 3'd3 && (v1_in == 8'd174 || v2_in == 8'd174)) ? (1'b1) : (flag_V_r[174]);
   assign flag_V_w[175] = (state_r == 3'd3 && (v1_in == 8'd175 || v2_in == 8'd175)) ? (1'b1) : (flag_V_r[175]);
   assign flag_V_w[176] = (state_r == 3'd3 && (v1_in == 8'd176 || v2_in == 8'd176)) ? (1'b1) : (flag_V_r[176]);
   assign flag_V_w[177] = (state_r == 3'd3 && (v1_in == 8'd177 || v2_in == 8'd177)) ? (1'b1) : (flag_V_r[177]);
   assign flag_V_w[178] = (state_r == 3'd3 && (v1_in == 8'd178 || v2_in == 8'd178)) ? (1'b1) : (flag_V_r[178]);
   assign flag_V_w[179] = (state_r == 3'd3 && (v1_in == 8'd179 || v2_in == 8'd179)) ? (1'b1) : (flag_V_r[179]);
   assign flag_V_w[180] = (state_r == 3'd3 && (v1_in == 8'd180 || v2_in == 8'd180)) ? (1'b1) : (flag_V_r[180]);
   assign flag_V_w[181] = (state_r == 3'd3 && (v1_in == 8'd181 || v2_in == 8'd181)) ? (1'b1) : (flag_V_r[181]);
   assign flag_V_w[182] = (state_r == 3'd3 && (v1_in == 8'd182 || v2_in == 8'd182)) ? (1'b1) : (flag_V_r[182]);
   assign flag_V_w[183] = (state_r == 3'd3 && (v1_in == 8'd183 || v2_in == 8'd183)) ? (1'b1) : (flag_V_r[183]);
   assign flag_V_w[184] = (state_r == 3'd3 && (v1_in == 8'd184 || v2_in == 8'd184)) ? (1'b1) : (flag_V_r[184]);
   assign flag_V_w[185] = (state_r == 3'd3 && (v1_in == 8'd185 || v2_in == 8'd185)) ? (1'b1) : (flag_V_r[185]);
   assign flag_V_w[186] = (state_r == 3'd3 && (v1_in == 8'd186 || v2_in == 8'd186)) ? (1'b1) : (flag_V_r[186]);
   assign flag_V_w[187] = (state_r == 3'd3 && (v1_in == 8'd187 || v2_in == 8'd187)) ? (1'b1) : (flag_V_r[187]);
   assign flag_V_w[188] = (state_r == 3'd3 && (v1_in == 8'd188 || v2_in == 8'd188)) ? (1'b1) : (flag_V_r[188]);
   assign flag_V_w[189] = (state_r == 3'd3 && (v1_in == 8'd189 || v2_in == 8'd189)) ? (1'b1) : (flag_V_r[189]);
   assign flag_V_w[190] = (state_r == 3'd3 && (v1_in == 8'd190 || v2_in == 8'd190)) ? (1'b1) : (flag_V_r[190]);
   assign flag_V_w[191] = (state_r == 3'd3 && (v1_in == 8'd191 || v2_in == 8'd191)) ? (1'b1) : (flag_V_r[191]);
   assign flag_V_w[192] = (state_r == 3'd3 && (v1_in == 8'd192 || v2_in == 8'd192)) ? (1'b1) : (flag_V_r[192]);
   assign flag_V_w[193] = (state_r == 3'd3 && (v1_in == 8'd193 || v2_in == 8'd193)) ? (1'b1) : (flag_V_r[193]);
   assign flag_V_w[194] = (state_r == 3'd3 && (v1_in == 8'd194 || v2_in == 8'd194)) ? (1'b1) : (flag_V_r[194]);
   assign flag_V_w[195] = (state_r == 3'd3 && (v1_in == 8'd195 || v2_in == 8'd195)) ? (1'b1) : (flag_V_r[195]);
   assign flag_V_w[196] = (state_r == 3'd3 && (v1_in == 8'd196 || v2_in == 8'd196)) ? (1'b1) : (flag_V_r[196]);
   assign flag_V_w[197] = (state_r == 3'd3 && (v1_in == 8'd197 || v2_in == 8'd197)) ? (1'b1) : (flag_V_r[197]);
   assign flag_V_w[198] = (state_r == 3'd3 && (v1_in == 8'd198 || v2_in == 8'd198)) ? (1'b1) : (flag_V_r[198]);
   assign flag_V_w[199] = (state_r == 3'd3 && (v1_in == 8'd199 || v2_in == 8'd199)) ? (1'b1) : (flag_V_r[199]);
   assign flag_V_w[200] = (state_r == 3'd3 && (v1_in == 8'd200 || v2_in == 8'd200)) ? (1'b1) : (flag_V_r[200]);
   assign flag_V_w[201] = (state_r == 3'd3 && (v1_in == 8'd201 || v2_in == 8'd201)) ? (1'b1) : (flag_V_r[201]);
   assign flag_V_w[202] = (state_r == 3'd3 && (v1_in == 8'd202 || v2_in == 8'd202)) ? (1'b1) : (flag_V_r[202]);
   assign flag_V_w[203] = (state_r == 3'd3 && (v1_in == 8'd203 || v2_in == 8'd203)) ? (1'b1) : (flag_V_r[203]);
   assign flag_V_w[204] = (state_r == 3'd3 && (v1_in == 8'd204 || v2_in == 8'd204)) ? (1'b1) : (flag_V_r[204]);
   assign flag_V_w[205] = (state_r == 3'd3 && (v1_in == 8'd205 || v2_in == 8'd205)) ? (1'b1) : (flag_V_r[205]);
   assign flag_V_w[206] = (state_r == 3'd3 && (v1_in == 8'd206 || v2_in == 8'd206)) ? (1'b1) : (flag_V_r[206]);
   assign flag_V_w[207] = (state_r == 3'd3 && (v1_in == 8'd207 || v2_in == 8'd207)) ? (1'b1) : (flag_V_r[207]);
   assign flag_V_w[208] = (state_r == 3'd3 && (v1_in == 8'd208 || v2_in == 8'd208)) ? (1'b1) : (flag_V_r[208]);
   assign flag_V_w[209] = (state_r == 3'd3 && (v1_in == 8'd209 || v2_in == 8'd209)) ? (1'b1) : (flag_V_r[209]);
   assign flag_V_w[210] = (state_r == 3'd3 && (v1_in == 8'd210 || v2_in == 8'd210)) ? (1'b1) : (flag_V_r[210]);
   assign flag_V_w[211] = (state_r == 3'd3 && (v1_in == 8'd211 || v2_in == 8'd211)) ? (1'b1) : (flag_V_r[211]);
   assign flag_V_w[212] = (state_r == 3'd3 && (v1_in == 8'd212 || v2_in == 8'd212)) ? (1'b1) : (flag_V_r[212]);
   assign flag_V_w[213] = (state_r == 3'd3 && (v1_in == 8'd213 || v2_in == 8'd213)) ? (1'b1) : (flag_V_r[213]);
   assign flag_V_w[214] = (state_r == 3'd3 && (v1_in == 8'd214 || v2_in == 8'd214)) ? (1'b1) : (flag_V_r[214]);
   assign flag_V_w[215] = (state_r == 3'd3 && (v1_in == 8'd215 || v2_in == 8'd215)) ? (1'b1) : (flag_V_r[215]);
   assign flag_V_w[216] = (state_r == 3'd3 && (v1_in == 8'd216 || v2_in == 8'd216)) ? (1'b1) : (flag_V_r[216]);
   assign flag_V_w[217] = (state_r == 3'd3 && (v1_in == 8'd217 || v2_in == 8'd217)) ? (1'b1) : (flag_V_r[217]);
   assign flag_V_w[218] = (state_r == 3'd3 && (v1_in == 8'd218 || v2_in == 8'd218)) ? (1'b1) : (flag_V_r[218]);
   assign flag_V_w[219] = (state_r == 3'd3 && (v1_in == 8'd219 || v2_in == 8'd219)) ? (1'b1) : (flag_V_r[219]);
   assign flag_V_w[220] = (state_r == 3'd3 && (v1_in == 8'd220 || v2_in == 8'd220)) ? (1'b1) : (flag_V_r[220]);
   assign flag_V_w[221] = (state_r == 3'd3 && (v1_in == 8'd221 || v2_in == 8'd221)) ? (1'b1) : (flag_V_r[221]);
   assign flag_V_w[222] = (state_r == 3'd3 && (v1_in == 8'd222 || v2_in == 8'd222)) ? (1'b1) : (flag_V_r[222]);
   assign flag_V_w[223] = (state_r == 3'd3 && (v1_in == 8'd223 || v2_in == 8'd223)) ? (1'b1) : (flag_V_r[223]);
   assign flag_V_w[224] = (state_r == 3'd3 && (v1_in == 8'd224 || v2_in == 8'd224)) ? (1'b1) : (flag_V_r[224]);
   assign flag_V_w[225] = (state_r == 3'd3 && (v1_in == 8'd225 || v2_in == 8'd225)) ? (1'b1) : (flag_V_r[225]);
   assign flag_V_w[226] = (state_r == 3'd3 && (v1_in == 8'd226 || v2_in == 8'd226)) ? (1'b1) : (flag_V_r[226]);
   assign flag_V_w[227] = (state_r == 3'd3 && (v1_in == 8'd227 || v2_in == 8'd227)) ? (1'b1) : (flag_V_r[227]);
   assign flag_V_w[228] = (state_r == 3'd3 && (v1_in == 8'd228 || v2_in == 8'd228)) ? (1'b1) : (flag_V_r[228]);
   assign flag_V_w[229] = (state_r == 3'd3 && (v1_in == 8'd229 || v2_in == 8'd229)) ? (1'b1) : (flag_V_r[229]);
   assign flag_V_w[230] = (state_r == 3'd3 && (v1_in == 8'd230 || v2_in == 8'd230)) ? (1'b1) : (flag_V_r[230]);
   assign flag_V_w[231] = (state_r == 3'd3 && (v1_in == 8'd231 || v2_in == 8'd231)) ? (1'b1) : (flag_V_r[231]);
   assign flag_V_w[232] = (state_r == 3'd3 && (v1_in == 8'd232 || v2_in == 8'd232)) ? (1'b1) : (flag_V_r[232]);
   assign flag_V_w[233] = (state_r == 3'd3 && (v1_in == 8'd233 || v2_in == 8'd233)) ? (1'b1) : (flag_V_r[233]);
   assign flag_V_w[234] = (state_r == 3'd3 && (v1_in == 8'd234 || v2_in == 8'd234)) ? (1'b1) : (flag_V_r[234]);
   assign flag_V_w[235] = (state_r == 3'd3 && (v1_in == 8'd235 || v2_in == 8'd235)) ? (1'b1) : (flag_V_r[235]);
   assign flag_V_w[236] = (state_r == 3'd3 && (v1_in == 8'd236 || v2_in == 8'd236)) ? (1'b1) : (flag_V_r[236]);
   assign flag_V_w[237] = (state_r == 3'd3 && (v1_in == 8'd237 || v2_in == 8'd237)) ? (1'b1) : (flag_V_r[237]);
   assign flag_V_w[238] = (state_r == 3'd3 && (v1_in == 8'd238 || v2_in == 8'd238)) ? (1'b1) : (flag_V_r[238]);
   assign flag_V_w[239] = (state_r == 3'd3 && (v1_in == 8'd239 || v2_in == 8'd239)) ? (1'b1) : (flag_V_r[239]);
   assign flag_V_w[240] = (state_r == 3'd3 && (v1_in == 8'd240 || v2_in == 8'd240)) ? (1'b1) : (flag_V_r[240]);
   assign flag_V_w[241] = (state_r == 3'd3 && (v1_in == 8'd241 || v2_in == 8'd241)) ? (1'b1) : (flag_V_r[241]);
   assign flag_V_w[242] = (state_r == 3'd3 && (v1_in == 8'd242 || v2_in == 8'd242)) ? (1'b1) : (flag_V_r[242]);
   assign flag_V_w[243] = (state_r == 3'd3 && (v1_in == 8'd243 || v2_in == 8'd243)) ? (1'b1) : (flag_V_r[243]);
   assign flag_V_w[244] = (state_r == 3'd3 && (v1_in == 8'd244 || v2_in == 8'd244)) ? (1'b1) : (flag_V_r[244]);
   assign flag_V_w[245] = (state_r == 3'd3 && (v1_in == 8'd245 || v2_in == 8'd245)) ? (1'b1) : (flag_V_r[245]);
   assign flag_V_w[246] = (state_r == 3'd3 && (v1_in == 8'd246 || v2_in == 8'd246)) ? (1'b1) : (flag_V_r[246]);
   assign flag_V_w[247] = (state_r == 3'd3 && (v1_in == 8'd247 || v2_in == 8'd247)) ? (1'b1) : (flag_V_r[247]);
   assign flag_V_w[248] = (state_r == 3'd3 && (v1_in == 8'd248 || v2_in == 8'd248)) ? (1'b1) : (flag_V_r[248]);
   assign flag_V_w[249] = (state_r == 3'd3 && (v1_in == 8'd249 || v2_in == 8'd249)) ? (1'b1) : (flag_V_r[249]);
   assign flag_V_w[250] = (state_r == 3'd3 && (v1_in == 8'd250 || v2_in == 8'd250)) ? (1'b1) : (flag_V_r[250]);
   assign flag_V_w[251] = (state_r == 3'd3 && (v1_in == 8'd251 || v2_in == 8'd251)) ? (1'b1) : (flag_V_r[251]);
   assign flag_V_w[252] = (state_r == 3'd3 && (v1_in == 8'd252 || v2_in == 8'd252)) ? (1'b1) : (flag_V_r[252]);
   assign flag_V_w[253] = (state_r == 3'd3 && (v1_in == 8'd253 || v2_in == 8'd253)) ? (1'b1) : (flag_V_r[253]);
   assign flag_V_w[254] = (state_r == 3'd3 && (v1_in == 8'd254 || v2_in == 8'd254)) ? (1'b1) : (flag_V_r[254]);
   assign flag_V_w[255] = (state_r == 3'd3 && (v1_in == 8'd255 || v2_in == 8'd255)) ? (1'b1) : (flag_V_r[255]);
 */  
   assign data_write_A_Y_w = (state_r == 3'd3)?((y1_in == y2_in) ? ({8'd0, distance1_y_in_2d_r} + {8'd0, distance2_y_in_2d_r} + ( data_read_A_Y_r )) : ({8'd0, distance1_y_in_2d_r} + (data_read_A_Y_r))): data_write_A_Y_r;
   assign data_write_A_U_w = (state_r == 3'd3)?((u1_in == u2_in) ? ({8'd0, distance1_u_in_2d_r} + {8'd0, distance2_u_in_2d_r} + ( data_read_A_U_r )) : ({8'd0, distance1_u_in_2d_r} + (data_read_A_U_r))): data_write_A_U_r;
   assign data_write_A_V_w = (state_r == 3'd3)?((v1_in == v2_in) ? ({8'd0, distance1_v_in_2d_r} + {8'd0, distance2_v_in_2d_r} + ( data_read_A_V_r )) : ({8'd0, distance1_v_in_2d_r} + (data_read_A_V_r))): data_write_A_V_r;
   
   //wire  temp = (flag_Y_r[y1_in] == 1'b1);
   
   assign data_write_B_Y_w = (state_r == 3'd3 && y1_in != y2_in)?({8'd0, distance2_y_in_2d_r} + (data_read_B_Y_r )): data_write_B_Y_r;
   assign data_write_B_U_w = (state_r == 3'd3 && u1_in != u2_in)?({8'd0, distance2_u_in_2d_r} + (data_read_B_U_r )): data_write_B_U_r;
   assign data_write_B_V_w = (state_r == 3'd3 && v1_in != v2_in)?({8'd0, distance2_v_in_2d_r} + (data_read_B_V_r )): data_write_B_V_r;
   
   
   always@(*)
   begin
      case(state_r)
         3'd0:
         begin
            if(BU_enable)
               state_w = 3'd1;
            else
               state_w = state_r;
         end
         3'd1:
         begin
            if(BU_enable)
               state_w = 3'd2;
            else
               state_w = state_r;
         end
   /*      2'd1:
         begin
            state_w = 2'd2;
         end
  */       3'd2:
         begin
            state_w = 3'd3;
         end
         3'd3:
         begin
            state_w = 3'd4;
         end
          3'd4:
         begin
            state_w = 3'd1;
         end
         default:
         begin
            state_w = 3'd0;
         end
      
      endcase
   
   end
   
   always@(*)
   begin
      case(state_r)
      
        3'd0:
         begin
            wea_Y_w = 1'b1;
            web_Y_w = 1'b1;
            csa_Y_w = 1'b0;
            csb_Y_w = 1'b0;
            oea_Y_w = 1'b1;
            oeb_Y_w = 1'b1;
            wea_U_w = 1'b1;
            web_U_w = 1'b1;
            csa_U_w = 1'b0;
            csb_U_w = 1'b0;
            oea_U_w = 1'b1;
            oeb_U_w = 1'b1;
            wea_V_w = 1'b1;
            web_V_w = 1'b1;
            csa_V_w = 1'b0;
            csb_V_w = 1'b0;
            oea_V_w = 1'b1;
            oeb_V_w = 1'b1;
            
            
         end
         3'd1:
         begin
            wea_Y_w = 1'b1;
            web_Y_w = 1'b1;
            csa_Y_w = 1'b1;
            csb_Y_w = 1'b1;
            
           // if(flag_Y_r[y1_in] != 1'b0)
           //    csa_Y_w = 1'b1;
           // else
           //    csa_Y_w = 1'b0;
           // if(y1_in != y2_in && flag_Y_r[y2_in] != 1'b0)
           //    csb_Y_w = 1'b1;
           // else
           //    csb_Y_w = 1'b0;
            
               oea_Y_w = 1'b1;
            
            if(y1_in != y2_in)
               oeb_Y_w = 1'b1;
            else
               oeb_Y_w = 1'b0;
            wea_U_w = 1'b1;
            web_U_w = 1'b1;
            csa_U_w = 1'b1;
            csb_U_w = 1'b1;
            //if(flag_U_r[u1_in] != 1'b0)
            //   csa_U_w = 1'b1;
            //else
            //   csa_U_w = 1'b0;
            //if(u1_in != u2_in && flag_U_r[u2_in] != 1'b0)
            //   csb_U_w = 1'b1;
            //else
            //   csb_U_w = 1'b0;
            oea_U_w = 1'b1;
            
            if(u1_in != u2_in)
               oeb_U_w = 1'b1;
            else
               oeb_U_w = 1'b0;
            wea_V_w = 1'b1;
            web_V_w = 1'b1;
            csa_V_w = 1'b1;
            csb_V_w = 1'b1;
            //if(flag_V_r[v1_in] != 1'b0)
            //   csa_V_w = 1'b1;
            //else
            //   csa_V_w = 1'b0;
            //if(v1_in != v2_in && flag_V_r[v2_in] != 1'b0)
            //   csb_V_w = 1'b1;
            //else
            //   csb_V_w = 1'b0;
            oea_V_w = 1'b1;
            if(v1_in != v2_in)
               oeb_V_w = 1'b1;
            else
               oeb_V_w = 1'b0;
         end
         3'd2:
         begin
            wea_Y_w = 1'b1;
            web_Y_w = 1'b1;
            csa_Y_w = 1'b1;
            csb_Y_w = 1'b1;
            
           // if(flag_Y_r[y1_in] != 1'b0)
           //    csa_Y_w = 1'b1;
           // else
           //    csa_Y_w = 1'b0;
           // if(y1_in != y2_in && flag_Y_r[y2_in] != 1'b0)
           //    csb_Y_w = 1'b1;
           // else
           //    csb_Y_w = 1'b0;
            oea_Y_w = 1'b1;
            if(y1_in != y2_in)
               oeb_Y_w = 1'b1;
            else
               oeb_Y_w = 1'b0;
            wea_U_w = 1'b1;
            web_U_w = 1'b1;
            csa_U_w = 1'b1;
            csb_U_w = 1'b1;
            //if(flag_U_r[u1_in] != 1'b0)
            //   csa_U_w = 1'b1;
            //else
            //   csa_U_w = 1'b0;
            //if(u1_in != u2_in && flag_U_r[u2_in] != 1'b0)
            //   csb_U_w = 1'b1;
            //else
            //   csb_U_w = 1'b0;
            oea_U_w = 1'b1;
            if(u1_in != u2_in)
               oeb_U_w = 1'b1;
            else
               oeb_U_w = 1'b0;
            wea_V_w = 1'b1;
            web_V_w = 1'b1;
            csa_V_w = 1'b1;
            csb_V_w = 1'b1;
            //if(flag_V_r[v1_in] != 1'b0)
            //   csa_V_w = 1'b1;
            //else
            //   csa_V_w = 1'b0;
            //if(v1_in != v2_in && flag_V_r[v2_in] != 1'b0)
            //   csb_V_w = 1'b1;
            //else
            //   csb_V_w = 1'b0;
            oea_V_w = 1'b1;
            if(v1_in != v2_in)
               oeb_V_w = 1'b1;
            else
               oeb_V_w = 1'b0;
         end
         3'd3:
         begin
            wea_Y_w = 1'b0;
            if(y1_in != y2_in)
               web_Y_w = 1'b0;
            else
               web_Y_w = 1'b1;
            csa_Y_w = 1'b1;
            csb_Y_w = 1'b1;
            //if(y1_in != y2_in)
            //   csb_Y_w = 1'b1;
            //else
            //   csb_Y_w = 1'b0;
            oea_Y_w = 1'b0;
            oeb_Y_w = 1'b0;
            wea_U_w = 1'b0;
            if(u1_in != u2_in)
               web_U_w = 1'b0;
            else
               web_U_w = 1'b1;
            csa_U_w = 1'b1;
            csb_U_w = 1'b1;
            //if(u1_in != u2_in)
            //   csb_U_w = 1'b1;
            //else
            //   csb_U_w = 1'b0;   
            oea_U_w = 1'b0;
            oeb_U_w = 1'b0;
            wea_V_w = 1'b0;
            if(v1_in != v2_in)
               web_V_w = 1'b0;
            else
               web_V_w = 1'b1;
            csa_V_w = 1'b1;
            csb_V_w = 1'b1;
            //if(v1_in != v2_in)
            //   csb_V_w = 1'b1;
            //else  
            //   csb_V_w = 1'b0; 
            oea_V_w = 1'b0;
            oeb_V_w = 1'b0;
         end
         3'd4:
         begin
            wea_Y_w = 1'b1;
            web_Y_w = 1'b1;
            csa_Y_w = 1'b1;
            csb_Y_w = 1'b1;
            
           // if(flag_Y_r[y1_in] != 1'b0)
           //    csa_Y_w = 1'b1;
           // else
           //    csa_Y_w = 1'b0;
           // if(y1_in != y2_in && flag_Y_r[y2_in] != 1'b0)
           //    csb_Y_w = 1'b1;
           // else
           //    csb_Y_w = 1'b0;
            oea_Y_w = 1'b1;
            if(y1_in != y2_in)
               oeb_Y_w = 1'b1;
            else
               oeb_Y_w = 1'b0;
            wea_U_w = 1'b1;
            web_U_w = 1'b1;
            csa_U_w = 1'b1;
            csb_U_w = 1'b1;
            //if(flag_U_r[u1_in] != 1'b0)
            //   csa_U_w = 1'b1;
            //else
            //   csa_U_w = 1'b0;
            //if(u1_in != u2_in && flag_U_r[u2_in] != 1'b0)
            //   csb_U_w = 1'b1;
            //else
            //   csb_U_w = 1'b0;
            oea_U_w = 1'b1;
            if(u1_in != u2_in)
               oeb_U_w = 1'b1;
            else
               oeb_U_w = 1'b0;
            wea_V_w = 1'b1;
            web_V_w = 1'b1;
            csa_V_w = 1'b1;
            csb_V_w = 1'b1;
            //if(flag_V_r[v1_in] != 1'b0)
            //   csa_V_w = 1'b1;
            //else
            //   csa_V_w = 1'b0;
            //if(v1_in != v2_in && flag_V_r[v2_in] != 1'b0)
            //   csb_V_w = 1'b1;
            //else
            //   csb_V_w = 1'b0;
            oea_V_w = 1'b1;
            if(v1_in != v2_in)
               oeb_V_w = 1'b1;
            else
               oeb_V_w = 1'b0;
         end
         default:
         begin
            wea_Y_w = 1'b1;
            web_Y_w = 1'b1;
            csa_Y_w = 1'b0;
            csb_Y_w = 1'b0;
            oea_Y_w = 1'b1;
            oeb_Y_w = 1'b1;
            wea_U_w = 1'b1;
            web_U_w = 1'b1;
            csa_U_w = 1'b0;
            csb_U_w = 1'b0;
            oea_U_w = 1'b1;
            oeb_U_w = 1'b1;
            wea_V_w = 1'b1;
            web_V_w = 1'b1;
            csa_V_w = 1'b0;
            csb_V_w = 1'b0;
            oea_V_w = 1'b1;
            oeb_V_w = 1'b1;
         end 
      endcase
   end
   
//   wire gclk = clk & BU_enable;
   
   
   always@(posedge clk or posedge reset)
   begin
      
      if(reset)
      begin
         data_write_A_Y_r <=16'd0;
         data_write_A_U_r <=16'd0;
         data_write_A_V_r <=16'd0;
         data_write_B_Y_r <=16'd0;
         data_write_B_U_r <=16'd0;
         data_write_B_V_r <=16'd0;
         data_read_A_Y_r <=16'd0;
         data_read_A_U_r <=16'd0;
         data_read_A_V_r <=16'd0;
         data_read_B_Y_r <=16'd0;
         data_read_B_U_r <=16'd0;
         data_read_B_V_r <=16'd0;
         //flag_Y_r <= 256'd0;
         //flag_U_r <= 256'd0;
         //flag_V_r <= 256'd0;
         state_r <= 3'd0;
         state_2d_r <= 3'd0;
         wea_Y_r <= 1'd1;
         web_Y_r <= 1'd1;
         wea_U_r <= 1'd1;
         web_U_r <= 1'd1;
         wea_V_r <= 1'd0;
         web_V_r <= 1'd0;
         csa_Y_r <= 1'd0;
         csb_Y_r <= 1'd0;
         csa_U_r <= 1'd0;
         csb_U_r <= 1'd0;
         csa_V_r <= 1'd0;
         csb_V_r <= 1'd0;
         oea_Y_r <= 1'd0;
         oeb_Y_r <= 1'd0;
         oea_U_r <= 1'd0;
         oeb_U_r <= 1'd0;
         oea_V_r <= 1'd0;
         oeb_V_r <= 1'd0;
         distance1_y_in_r <= 8'd0;
         distance1_u_in_r <= 8'd0;
         distance1_v_in_r <= 8'd0;
         distance2_y_in_r <= 8'd0;
         distance2_u_in_r <= 8'd0;
         distance2_v_in_r <= 8'd0;   
         distance1_y_in_2d_r <= 8'd0;
         distance1_u_in_2d_r <= 8'd0;
         distance1_v_in_2d_r <= 8'd0;
         distance2_y_in_2d_r <= 8'd0; 
         distance2_u_in_2d_r <= 8'd0;  
         distance2_v_in_2d_r <= 8'd0;  
         distance1_y_in_3d_r <= 8'd0;
         distance1_u_in_3d_r <= 8'd0;
         distance1_v_in_3d_r <= 8'd0;
         distance2_y_in_3d_r <= 8'd0;
         distance2_u_in_3d_r <= 8'd0;
         distance2_v_in_3d_r <= 8'd0;
      end
      
      else
      begin
         if(BU_enable)
         begin
            data_write_A_Y_r <= data_write_A_Y_w;
            data_write_A_U_r <= data_write_A_U_w;
            data_write_A_V_r <= data_write_A_V_w;
            data_write_B_Y_r <= data_write_B_Y_w;
            data_write_B_U_r <= data_write_B_U_w;
            data_write_B_V_r <= data_write_B_V_w;
            data_read_A_Y_r <= data_read_A_Y_w;
            data_read_A_U_r <= data_read_A_U_w;
            data_read_A_V_r <= data_read_A_V_w;
            data_read_B_Y_r <= data_read_B_Y_w;
            data_read_B_U_r <= data_read_B_U_w;
            data_read_B_V_r <= data_read_B_V_w;
            //flag_Y_r <= flag_Y_w;
            //flag_U_r <= flag_U_w;
            //flag_V_r <= flag_V_w;
            state_r <= state_w;
            state_2d_r <= state_r;
            wea_Y_r <= wea_Y_w;
            web_Y_r <= web_Y_w;
            wea_U_r <= wea_U_w;
            web_U_r <= web_U_w;
            wea_V_r <= wea_V_w;
            web_V_r <= web_V_w;
            csa_Y_r <= csa_Y_w;
            csb_Y_r <= csb_Y_w;
            csa_U_r <= csa_U_w;
            csb_U_r <= csb_U_w;
            csa_V_r <= csa_V_w;
            csb_V_r <= csb_V_w;
            oea_Y_r <= oea_Y_w;
            oeb_Y_r <= oeb_Y_w;
            oea_U_r <= oea_U_w;
            oeb_U_r <= oeb_U_w;
            oea_V_r <= oea_V_w;
            oeb_V_r <= oeb_V_w;
            distance1_y_in_r <= distance1_y_in;
            distance1_u_in_r <= distance1_u_in;
            distance1_v_in_r <= distance1_v_in;
            distance2_y_in_r <= distance2_y_in;
            distance2_u_in_r <= distance2_u_in;
            distance2_v_in_r <= distance2_v_in;
            distance1_y_in_2d_r <= distance1_y_in_r;
            distance1_u_in_2d_r <= distance1_u_in_r;
            distance1_v_in_2d_r <= distance1_v_in_r;
            distance2_y_in_2d_r <= distance2_y_in_r;
            distance2_u_in_2d_r <= distance2_u_in_r;
            distance2_v_in_2d_r <= distance2_v_in_r;
            distance1_y_in_3d_r <= distance1_y_in_2d_r;
            distance1_u_in_3d_r <= distance1_u_in_2d_r;
            distance1_v_in_3d_r <= distance1_v_in_2d_r;
            distance2_y_in_3d_r <= distance2_y_in_2d_r;
            distance2_u_in_3d_r <= distance2_u_in_2d_r;
            distance2_v_in_3d_r <= distance2_v_in_2d_r;
         end
      
      
      end
   
   end
   always@(posedge clk or posedge reset)
   begin
      
      if(reset)
      begin
         wea_Y_2d_r <= 1'd1;
         web_Y_2d_r <= 1'd1;
         wea_U_2d_r <= 1'd1;
         web_U_2d_r <= 1'd1;
         wea_V_2d_r <= 1'd0;
         web_V_2d_r <= 1'd0;
         csa_Y_2d_r <= 1'd0;
         csa_U_2d_r <= 1'd0;
         csa_V_2d_r <= 1'd0;
         csb_Y_2d_r <= 1'd0;
         csb_U_2d_r <= 1'd0;
         csb_V_2d_r <= 1'd0;
         oea_Y_2d_r <= 1'd0;
         oea_U_2d_r <= 1'd0;
         oea_V_2d_r <= 1'd0;
         oeb_Y_2d_r <= 1'd0;
         oeb_U_2d_r <= 1'd0;
         oeb_V_2d_r <= 1'd0;
         
         
      end
         
      else
      begin
         wea_Y_2d_r <= wea_Y_r;
         web_Y_2d_r <= web_Y_r;
         wea_U_2d_r <= wea_U_r;
         web_U_2d_r <= web_U_r;
         wea_V_2d_r <= wea_V_r;
         web_V_2d_r <= web_V_r;
         csa_Y_2d_r <= csa_Y_r;
         csa_U_2d_r <= csa_U_r;
         csa_V_2d_r <= csa_V_r;
         csb_Y_2d_r <= csb_Y_r;
         csb_U_2d_r <= csb_U_r;
         csb_V_2d_r <= csb_V_r;
         oea_Y_2d_r <= oea_Y_r;
         oea_U_2d_r <= oea_U_r;
         oea_V_2d_r <= oea_V_r;
         oeb_Y_2d_r <= oeb_Y_r;
         oeb_U_2d_r <= oeb_U_r;
         oeb_V_2d_r <= oeb_V_r;
         
         
         
         
      
      
      end
   
   end
   
   




endmodule