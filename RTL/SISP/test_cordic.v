`timescale 1ns/1ps

//x=-a0000, y=-10000, z=0, choose=1  =>xn=a0ad1, yn=646a, zn=-2ffaf
module test_cordic();
   parameter TIMEOUT = 50*2*(256+128+64+32+16+8) + 1000;// Provide a value
   parameter DELAY = 100;
   parameter HALF_CYCLE = 50;
   reg   clk;
   reg   reset;
   reg   choose;
   reg   cordic_enable;
   reg   [31:0]   x, y, z;  
   wire  [31:0]   xn, yn, zn;
   cordic c0(clk, reset, x, y, z, xn, yn, zn, choose, cordic_enable/*, loop*/);
   
   
    always #(HALF_CYCLE) clk = ~clk;
   
   
//7 cycles stop 3 cycles   
   
   
   initial
   begin
      //$sdf_annotate("Cordic_syn_v10.sdf",S0);
      $dumpfile("Cordic.vcd");						
	   $dumpvars;
	   clk = 0;
	   reset = 0;
	   x = 0-32'ha0000;
	   y = 0-32'h10000;
	   z = 0;
	   choose = 1;
	   cordic_enable = 1;
	   #DELAY reset = 1;
	   #DELAY reset = 0;
	   //x = 32'ha0000;
	   //y = 32'ha0000;
      
      
      
   end
      
   initial #TIMEOUT $finish;

endmodule