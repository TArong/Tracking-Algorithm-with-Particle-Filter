module SegThesholdDecision(	BDthY_o, BDthU_o, BDthV_o, Bth_o, update_o, BckGndBuildTH_o,
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
				box10xmax_i, box10ymax_i, box10xmin_i, box10ymin_i, BDthY_box10_i, BDthU_box10_i, BDthV_box10_i,  update_box10_i,  Bth_box10_i, BckGndBuildTH_box10_i
				);
				
output [7:0] BDthY_o;        
output [7:0] BDthU_o;        
output [7:0] BDthV_o;        
output [7:0] Bth_o;          
output       update_o;       
output [7:0] BckGndBuildTH_o;

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



//wire and reg
wire insideBox1	;
wire insideBox2	;
wire insideBox3	;
wire insideBox4	;
wire insideBox5	;
wire insideBox6	;
wire insideBox7	;
wire insideBox8	;
wire insideBox9	;
wire insideBox10 ;
reg [7:0]BDthY_w ;	
reg [7:0]BDthU_w;		
reg [7:0]BDthV_w;		
reg [7:0]Bth_w		;
reg      update_w	;
reg [7:0]BckGndBuildTH_w	;


						/**Input Stage**/
						//no input register
						
						/**Threshod Decision**/
assign insideBox1   	=	( ( lineidx_i > box1ymin_i  ) && ( lineidx_i < box1ymax_i  ) && ( pixelidx_i > box1xmin_i  ) && ( pixelidx_i < box1xmax_i  ) )? 1'b1: 1'b0;
assign insideBox2	=	( ( lineidx_i > box2ymin_i  ) && ( lineidx_i < box2ymax_i  ) && ( pixelidx_i > box2xmin_i  ) && ( pixelidx_i < box2xmax_i  ) )? 1'b1: 1'b0;
assign insideBox3	=	( ( lineidx_i > box3ymin_i  ) && ( lineidx_i < box3ymax_i  ) && ( pixelidx_i > box3xmin_i  ) && ( pixelidx_i < box3xmax_i  ) )? 1'b1: 1'b0;
assign insideBox4	=	( ( lineidx_i > box4ymin_i  ) && ( lineidx_i < box4ymax_i  ) && ( pixelidx_i > box4xmin_i  ) && ( pixelidx_i < box4xmax_i  ) )? 1'b1: 1'b0;
assign insideBox5	=	( ( lineidx_i > box5ymin_i  ) && ( lineidx_i < box5ymax_i  ) && ( pixelidx_i > box5xmin_i  ) && ( pixelidx_i < box5xmax_i  ) )? 1'b1: 1'b0;
assign insideBox6	=	( ( lineidx_i > box6ymin_i  ) && ( lineidx_i < box6ymax_i  ) && ( pixelidx_i > box6xmin_i  ) && ( pixelidx_i < box6xmax_i  ) )? 1'b1: 1'b0;
assign insideBox7	=	( ( lineidx_i > box7ymin_i  ) && ( lineidx_i < box7ymax_i  ) && ( pixelidx_i > box7xmin_i  ) && ( pixelidx_i < box7xmax_i  ) )? 1'b1: 1'b0;
assign insideBox8	=	( ( lineidx_i > box8ymin_i  ) && ( lineidx_i < box8ymax_i  ) && ( pixelidx_i > box8xmin_i  ) && ( pixelidx_i < box8xmax_i  ) )? 1'b1: 1'b0;
assign insideBox9	=	( ( lineidx_i > box9ymin_i  ) && ( lineidx_i < box9ymax_i  ) && ( pixelidx_i > box9xmin_i  ) && ( pixelidx_i < box9xmax_i  ) )? 1'b1: 1'b0;
assign insideBox10      =	( ( lineidx_i > box10ymin_i ) && ( lineidx_i < box10ymax_i ) && ( pixelidx_i > box10xmin_i ) && ( pixelidx_i < box10xmax_i ) )? 1'b1: 1'b0;

always@(insideBox1 or insideBox2 or insideBox3 or insideBox4 or insideBox5 or insideBox6 or insideBox7 or insideBox8 or insideBox9 or insideBox10 or
	BDthY_default_i or BDthU_default_i or BDthV_default_i or  Bth_default_i or BckGndBuildTH_default_i or
	BDthY_box1_i or  BDthU_box1_i or  BDthV_box1_i or   update_box1_i or   Bth_box1_i or  BckGndBuildTH_box1_i or
	BDthY_box2_i or  BDthU_box2_i or  BDthV_box2_i or   update_box2_i or   Bth_box2_i or  BckGndBuildTH_box2_i or
	BDthY_box3_i or  BDthU_box3_i or  BDthV_box3_i or   update_box3_i or   Bth_box3_i or  BckGndBuildTH_box3_i or
	BDthY_box4_i or  BDthU_box4_i or  BDthV_box4_i or   update_box4_i or   Bth_box4_i or  BckGndBuildTH_box4_i or
	BDthY_box5_i or  BDthU_box5_i or  BDthV_box5_i or   update_box5_i or   Bth_box5_i or  BckGndBuildTH_box5_i or
	BDthY_box6_i or  BDthU_box6_i or  BDthV_box6_i or   update_box6_i or   Bth_box6_i or  BckGndBuildTH_box6_i or
	BDthY_box7_i or  BDthU_box7_i or  BDthV_box7_i or   update_box7_i or   Bth_box7_i or  BckGndBuildTH_box7_i or
	BDthY_box8_i or  BDthU_box8_i or  BDthV_box8_i or   update_box8_i or   Bth_box8_i or  BckGndBuildTH_box8_i or
	BDthY_box9_i or  BDthU_box9_i or  BDthV_box9_i or   update_box9_i or   Bth_box9_i or  BckGndBuildTH_box9_i or
	BDthY_box10_i or BDthU_box10_i or BDthV_box10_i or  update_box10_i or  Bth_box10_i or BckGndBuildTH_box10_i)
begin
	if(insideBox1)
	begin
		BDthY_w 	= 		BDthY_box1_i;
		BDthU_w		= 		BDthU_box1_i;                                
		BDthV_w		= 		BDthV_box1_i;                                
		Bth_w		= 		Bth_box1_i;                                  
		update_w	= 		update_box1_i;                               
		BckGndBuildTH_w	= 		BckGndBuildTH_box1_i; 
	end
	else
	begin
		if(insideBox2)
		begin
			BDthY_w 	= 		BDthY_box2_i;        
			BDthU_w		= 		BDthU_box2_i;        
			BDthV_w		= 		BDthV_box2_i;        
			Bth_w		= 		Bth_box2_i;          
			update_w	= 		update_box2_i;       
			BckGndBuildTH_w	= 		BckGndBuildTH_box2_i;
		end
		else
		begin
			if(insideBox3)
			begin
				BDthY_w 	= 		BDthY_box3_i;        
				BDthU_w		= 		BDthU_box3_i;        
				BDthV_w		= 		BDthV_box3_i;        
				Bth_w		= 		Bth_box3_i;          
				update_w	= 		update_box3_i;       
				BckGndBuildTH_w	= 		BckGndBuildTH_box3_i;
			end
			else
			begin
				if(insideBox4)
				begin
					BDthY_w 	= 		BDthY_box4_i;        
					BDthU_w		= 		BDthU_box4_i;        
					BDthV_w		= 		BDthV_box4_i;        
					Bth_w		= 		Bth_box4_i;          
					update_w	= 		update_box4_i;       
					BckGndBuildTH_w	= 		BckGndBuildTH_box4_i;
				end
				else
				begin
					if(insideBox5)
					begin
						BDthY_w 	= 		BDthY_box5_i;        
						BDthU_w		= 		BDthU_box5_i;        
						BDthV_w		= 		BDthV_box5_i;        
						Bth_w		= 		Bth_box5_i;          
						update_w	= 		update_box5_i;       
						BckGndBuildTH_w	= 		BckGndBuildTH_box5_i;
					end
					else
					begin
						if(insideBox6)
						begin
							BDthY_w 	= 		BDthY_box6_i;        
							BDthU_w		= 		BDthU_box6_i;        
							BDthV_w		= 		BDthV_box6_i;        
							Bth_w		= 		Bth_box6_i;          
							update_w	= 		update_box6_i;       
							BckGndBuildTH_w	= 		BckGndBuildTH_box6_i;
						end
						else
						begin
							if(insideBox7)
							begin
								BDthY_w 	= 		BDthY_box7_i;        
								BDthU_w		= 		BDthU_box7_i;        
								BDthV_w		= 		BDthV_box7_i;        
								Bth_w		= 		Bth_box7_i;          
								update_w	= 		update_box7_i;       
								BckGndBuildTH_w	= 		BckGndBuildTH_box7_i;
							end
							else
							begin
								if(insideBox8)
								begin
									BDthY_w 	= 		BDthY_box8_i;        
									BDthU_w		= 		BDthU_box8_i;        
									BDthV_w		= 		BDthV_box8_i;        
									Bth_w		= 		Bth_box8_i;          
									update_w	= 		update_box8_i;       
									BckGndBuildTH_w	= 		BckGndBuildTH_box8_i;
								end
								else
								begin
									if(insideBox9)
									begin
										BDthY_w 	= 		BDthY_box9_i;        
										BDthU_w		= 		BDthU_box9_i;        
										BDthV_w		= 		BDthV_box9_i;        
										Bth_w		= 		Bth_box9_i;          
										update_w	= 		update_box9_i;       
										BckGndBuildTH_w	= 		BckGndBuildTH_box9_i;
									end
									else
									begin
										if(insideBox10)
										begin
											BDthY_w 	= 		BDthY_box10_i;        
											BDthU_w		= 		BDthU_box10_i;        
											BDthV_w		= 		BDthV_box10_i;        
											Bth_w		= 		Bth_box10_i;          
											update_w	= 		update_box10_i;       
											BckGndBuildTH_w	= 		BckGndBuildTH_box10_i;
										end
										else
										begin
											BDthY_w 	= 		BDthY_default_i;        
											BDthU_w		= 		BDthU_default_i;        
											BDthV_w		= 		BDthV_default_i;        
											Bth_w		= 		Bth_default_i;          
											update_w	= 		1'b1;       
											BckGndBuildTH_w	= 		BckGndBuildTH_default_i;
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end
							/**Output Stage**/    
							//no output register  
							
							
assign BDthY_o		=	BDthY_w 		;
assign BDthU_o		=	BDthU_w			;                                
assign BDthV_o		=	BDthV_w			;                                
assign Bth_o		=	Bth_w			;                                  
assign update_o		=	update_w		;                               
assign BckGndBuildTH_o	=	BckGndBuildTH_w		;                        
                                        
                                        
                                        	
endmodule





