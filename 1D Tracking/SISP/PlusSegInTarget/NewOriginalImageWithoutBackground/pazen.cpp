#include <cstdlib>
#include <cmath>
#include <iostream>
#include <cstdio>
#include "pazen.h"
#include "cordic.h"
#include "BU.h"

void pazen(
		 unsigned char y1_in, unsigned char y2_in, unsigned char u1_in, unsigned char u2_in, unsigned char v1_in, unsigned char v2_in, 
		 int positionx1_in, int positionx2_in, int positiony1_in, int positiony2_in, int centerx_in, int centery_in,
         long long int data_Y_E[128], long long int data_Y_O[128],
         long long int data_U_E[128], long long int data_U_O[128],
         long long int data_V_E[128], long long int data_V_O[128],
         long long int & total_histogram, long long int diag,
		 bool flag_Y_w[256], bool flag_U_w[256], bool flag_V_w[256]
		 ){
	
	int differencex1_w, differencex2_w;
	int differencey1_w, differencey2_w;
	int i;
	
	long int distance1_in_w, distance2_in_w;

	differencex1_w = (positionx1_in > centerx_in) ? (positionx1_in - centerx_in) : (centerx_in - positionx1_in);
    differencex2_w = (positionx2_in > centerx_in) ? (positionx2_in - centerx_in) : (centerx_in - positionx2_in);
	differencey1_w = (positiony1_in > centery_in) ? (positiony1_in - centery_in) : (centery_in - positiony1_in);
	differencey2_w = (positiony2_in > centery_in) ? (positiony2_in - centery_in) : (centery_in - positiony2_in);




//STATE == INIT_ST
	

//STATE == DIST_ST
	long int tempa0_1, tempa0_2, tempan_1, tempan_2;
	long int tempyn_1, tempyn_2;
	long int tempzn_1, tempzn_2;
	long int tempx1, tempx2;
	long int tempy1, tempy2;
	long int tempz1, tempz2;
	long int temp_distance1_w, temp_distance2_w;


	tempa0_1 = 1;
	tempa0_2 = 1;
	tempx1 = differencex1_w * pow((double)2,16);
	tempx2 = differencex2_w * pow((double)2,16);
	tempy1 = differencey1_w * pow((double)2,16);
	tempy2 = differencey2_w * pow((double)2,16);
	tempz1 = 0;
	tempz2 = 0;
	for(i = 0; i < 5; i++){
		cordic(tempx1, tempy1, tempz1, tempa0_1, temp_distance1_w, tempyn_1, tempzn_1, tempan_1, 1, i);
		cordic(tempx2, tempy2, tempz2, tempa0_2, temp_distance2_w, tempyn_2, tempzn_2, tempan_2, 1, i);
		tempa0_1 = tempan_1;
		tempa0_2 = tempan_2;
		tempx1 = temp_distance1_w;
		tempx2 = temp_distance2_w;
		tempy1 = tempyn_1;
		tempy2 = tempyn_2;
		tempz1 = tempzn_1;
		tempz2 = tempzn_2;
	}
	

//STATE == BU_ST
	distance1_in_w = diag - temp_distance1_w;
	distance2_in_w = diag - temp_distance2_w;

	BU(y1_in, y2_in, u1_in, u2_in, v1_in, v2_in, distance1_in_w, distance2_in_w,distance1_in_w, distance2_in_w,distance1_in_w, distance2_in_w,
		 flag_Y_w, flag_U_w, flag_V_w,
         data_Y_E, data_Y_O,
         data_U_E, data_U_O,
         data_V_E, data_V_O, 
         1, 1
         
         );

	total_histogram =  total_histogram + distance1_in_w + distance2_in_w;
}