#include <cstdlib>
#include <cmath>
#include <iostream>
#include <cstdio>
#include "BU.h"
#include "CnvntnlPFTrial.h"
using namespace std;

void BU(
		unsigned char y1_in, unsigned char y2_in, unsigned char u1_in, unsigned char u2_in, unsigned char v1_in, unsigned char v2_in, 
		 long int distancey1_in, long int distancey2_in,
		 long int distanceu1_in, long int distanceu2_in,
		 long int distancev1_in, long int distancev2_in,
		 bool flag_Y_w[256], bool flag_U_w[256], bool flag_V_w[256],
         long long int data_Y_E[128], long long int data_Y_O[128],
         long long int data_U_E[128], long long int data_U_O[128],
         long long int data_V_E[128], long long int data_V_O[128], 
         unsigned int segbufferY_1_in, unsigned int segbufferY_2_in
         //bool choose;
         
         ){


	
	



//state == 0

//state == 1
if(segbufferY_1_in != 0){
   if(y1_in %2 == 0){
	  
      data_Y_E[y1_in/2] = (y1_in == y2_in && segbufferY_2_in != 0) ? (distancey1_in + distancey2_in + ((flag_Y_w[y1_in] == 1) ? data_Y_E[y1_in/2] : 0)) : (distancey1_in + ((flag_Y_w[y1_in] == 1) ? data_Y_E[y1_in/2] : 0));
      
	  
   }
   else{
	
      data_Y_O[(y1_in-1)/2] = (y1_in == y2_in && segbufferY_2_in != 0) ? (distancey1_in + distancey2_in + ((flag_Y_w[y1_in] == 1) ? data_Y_O[(y1_in-1)/2] : 0)) : (distancey1_in + ((flag_Y_w[y1_in] == 1) ? data_Y_O[(y1_in-1)/2] : 0));
      

   }
   if(u1_in %2 == 0){
   
      data_U_E[u1_in/2] = (u1_in == u2_in && segbufferY_2_in != 0) ? (distanceu1_in + distanceu2_in + ((flag_U_w[u1_in] == 1) ? data_U_E[u1_in/2] : 0)) : (distanceu1_in + ((flag_U_w[u1_in] == 1) ? data_U_E[u1_in/2] : 0));
      

   }
   else{
   
      data_U_O[(u1_in-1)/2] = (u1_in == u2_in && segbufferY_2_in != 0) ? (distanceu1_in + distanceu2_in + ((flag_U_w[u1_in] == 1) ? data_U_O[(u1_in-1)/2] : 0)) : (distanceu1_in + ((flag_U_w[u1_in] == 1) ? data_U_O[(u1_in-1)/2] : 0));
      

   }
   if(v1_in %2 == 0){
   
      data_V_E[v1_in/2] = (v1_in == v2_in && segbufferY_2_in != 0) ? (distancev1_in + distancev2_in + ((flag_V_w[v1_in] == 1) ? data_V_E[v1_in/2] : 0)) : (distancev1_in + ((flag_V_w[v1_in] == 1) ? data_V_E[v1_in/2] : 0));
      

   }
   else{
   
      data_V_O[(v1_in-1)/2] = (v1_in == v2_in && segbufferY_2_in != 0) ? (distancev1_in + distancev2_in + ((flag_V_w[v1_in] == 1) ? data_V_O[(v1_in-1)/2] : 0)) : (distancev1_in + ((flag_V_w[v1_in] == 1) ? data_V_O[(v1_in-1)/2] : 0));
      

   }
}
if(segbufferY_2_in != 0)
{
   if(y2_in %2 == 0){
	  
      
      
      

      if(y1_in!=y2_in)data_Y_E[y2_in/2] = (distancey2_in + ((flag_Y_w[y2_in] == 1) ? data_Y_E[y2_in/2] : 0));	   
	  
	  
   }
   else{
	

      if(y1_in!=y2_in)data_Y_O[(y2_in-1)/2] = (distancey2_in + ((flag_Y_w[y2_in] == 1) ? data_Y_O[(y2_in-1)/2] : 0));	   

   }
   if(u2_in %2 == 0){
   
      
      if(u1_in!=u2_in)data_U_E[u2_in/2] = (distanceu2_in + ((flag_U_w[u2_in] == 1) ? data_U_E[u2_in/2] : 0));	   

   }
   else{
   
      
      if(u1_in!=u2_in)data_U_O[(u2_in-1)/2] = (distanceu2_in + ((flag_U_w[u2_in] == 1) ? data_U_O[(u2_in-1)/2] : 0));	   

   }
   if(v2_in %2 == 0){
   
      
      if(v1_in!=v2_in)data_V_E[v2_in/2] = (distancev2_in + ((flag_V_w[v2_in] == 1) ? data_V_E[v2_in/2] : 0));	   

   }
   else{
   
      
      if(v1_in!=v2_in)data_V_O[(v2_in-1)/2] = (distancev2_in + ((flag_V_w[v2_in] == 1) ? data_V_O[(v2_in-1)/2] : 0));	   

   }
   
}
   

    
//state == 2
if(segbufferY_1_in != 0)   flag_Y_w[y1_in] = 1;
   
   if(segbufferY_2_in != 0)  flag_Y_w[y2_in] = 1;
   
   if(segbufferY_1_in != 0)  flag_U_w[u1_in] = 1;
   
   if(segbufferY_2_in != 0)  flag_U_w[u2_in] = 1;
   
   if(segbufferY_1_in != 0)  flag_V_w[v1_in] = 1;
   
   if(segbufferY_2_in != 0)  flag_V_w[v2_in] = 1;

   
   
    
//state == 3

}