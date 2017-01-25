#include <cstdlib>
#include <cmath>
#include <iostream>
#include <cstdio>
#include <fstream>
#include "distance_compute.h"

using namespace std;
#define t 1

void distance_compute(long long int data_C_E[128], long long int data_C_O[128], long long int data_T_E[128], long long int data_T_O[128], unsigned long long int & distance, int iteration_times, long long int total_histogram_C, long long int total_histogram_T){
   int A_C;
  // ofstream fcout("test3.txt", ios::out);
   long long int normalize_C_E_w, normalize_C_O_w, normalize_T_E_w, normalize_T_O_w;
   long long int temp_normalize_C_E_w, temp_normalize_C_O_w;
   long long int temp_normalize_T_E_w, temp_normalize_T_O_w;
   long long int exe_D2_w, exe_D1_w, exe_D3_w;
   
   long long int exe_C1_w, exe_C2_w, exe_A1_w, exe_A2_w, exe_B2_w, exe_B1_w;
   long long int exe_F1_w, exe_F2_w;
   long long int exe_E1_w, exe_E2_w, exe_E3_w;
   long long int exe_C3_w, exe_A3_w, exe_B3_w;
   long long int exe_F3_w;


   long long int exe_A4_w, exe_B4_w, exe_C4_w, exe_D4_w, exe_E4_w, exe_F4_w;
   long long int exe_G1_w, exe_G2_w, exe_G3_w, exe_G4_w;
   long long int exe_H1_w, exe_H2_w, exe_H3_w, exe_H4_w;
   long long int exe_J1_w, exe_J2_w, exe_J3_w, exe_J4_w;
   

   long long int t_exe_A2_w, t_exe_H2_w, t_exe_E2_w, t_exe_H3_w, t_exe_G3_w, t_exe_B3_w, t_exe_F2_w, t_exe_C4_w, t_exe_F1_w, t_exe_E1_w, t_exe_A3_w, t_exe_B4_w, t_exe_G4_w;
   long long int t_exe_J4_w;

   long long int add_A2_B1_C2_w = 0;
   long long int add_B2_C1_D2_w = 0;
   long long int down_sample_w = 0;
   
   unsigned long long int abs_add_down_sample_w = 0;

   long long int difference_of_nC_nT_E = 0;
   long long int difference_of_nC_nT_O = 0;
   unsigned long long int abs_difference_of_nC_nT_E = 0;
   unsigned long long int abs_difference_of_nC_nT_O = 0;

   long long int temp_exe_C1_w, temp_exe_C2_w, temp_exe_D2_w, temp_exe_D1_w;
   long long int temp_exe_C3_w, temp_exe_D3_w, temp_exe_C4_w, temp_exe_D4_w;
   
   int index = 0;
   int iter_count_r = 0;
   int temp;
   
   
   exe_C1_w = 0;
   exe_C2_w = 0;
   exe_C3_w = 0;
   exe_C4_w = 0;
   exe_A1_w = 0;
   exe_A2_w = 0;
   exe_A3_w = 0;
   exe_A4_w = 0;
   exe_B4_w = 0;
   exe_B3_w = 0;
   exe_B2_w = 0;
   exe_B1_w = 0;
   exe_F1_w = 0;
   exe_F2_w = 0;
   exe_F3_w = 0;
   exe_F4_w = 0;
   
   exe_E1_w = 0;
   exe_E2_w = 0;
   exe_E3_w = 0;
   exe_E4_w = 0;

   exe_G1_w = 0;
   exe_G2_w = 0;
   exe_G3_w = 0;
   exe_G4_w = 0;
   exe_H1_w = 0;
   exe_H2_w = 0;
   exe_H3_w = 0;
   exe_H4_w = 0;

   exe_J1_w = 0;
   exe_J2_w = 0;
   exe_J3_w = 0;
   exe_J4_w = 0;


   temp_exe_C1_w = 0;
   temp_exe_C2_w = 0;
   temp_exe_C3_w = 0;
   temp_exe_C4_w = 0;
   temp_exe_D4_w = 0;
   temp_exe_D3_w = 0;
   temp_exe_D2_w = 0;
   temp_exe_D1_w = 0;
   
   index = 128;
   
   distance = 0;

   bool normalize = false;
   
int i;
int A_d_C = 0;
int A_2d_C = 0;
int A_3d_C = 0;
int A_4d_C = 0;
int index_d = 0;
int index_2d = 0;
int index_3d = 0;

/*
for(i = 0; i < 128; i++){
   fcout << (double)data_T_E[i] / total_histogram_T *100<< "\t" << (double)data_C_E[i] / total_histogram_C *100<< endl;
   fcout << (double)data_T_O[i] / total_histogram_T *100<< "\t" << (double)data_C_O[i] / total_histogram_C *100<< endl;
}
*/
   

   for(iter_count_r = 1; iter_count_r <= iteration_times; iter_count_r++){
//      cout << iter_count_r << ":" << endl;
      for(A_C = 0; A_C < index; A_C++){
         normalize = (iter_count_r == 1);
         temp_normalize_C_E_w = data_C_E[A_C] * total_histogram_T;   //candidate * total target
         temp_normalize_C_O_w = data_C_O[A_C] * total_histogram_T;
         temp_normalize_T_E_w = data_T_E[A_C] * total_histogram_C;   //target * total candidate
         temp_normalize_T_O_w = data_T_O[A_C] * total_histogram_C;
         //fcout << 2 * A_C << "\t" << temp_normalize_T_E_w << "\t" << temp_normalize_C_E_w << endl;
         //fcout << 2 * A_C + 1 << "\t" << temp_normalize_T_O_w << "\t" << temp_normalize_C_O_w << endl;
         normalize_C_E_w = (normalize)? temp_normalize_C_E_w/pow((double)2, 5) : data_C_E[A_C];                //No negative in first read (without normalize)
         normalize_C_O_w = (normalize)? temp_normalize_C_O_w/pow((double)2, 5) : data_C_O[A_C];
         normalize_T_E_w = (normalize)? temp_normalize_T_E_w/pow((double)2, 5) : data_T_E[A_C];
         normalize_T_O_w = (normalize)? temp_normalize_T_O_w/pow((double)2, 5) : data_T_O[A_C];
         //cout << normalize_C_E_w << " " << normalize_C_O_w << " " << normalize_T_E_w << " " << normalize_T_O_w << endl;
         
         difference_of_nC_nT_E = (iter_count_r == 1) ? normalize_C_E_w - normalize_T_E_w : normalize_C_E_w;
         
		   abs_difference_of_nC_nT_E = difference_of_nC_nT_E > 0 ? difference_of_nC_nT_E : (0 - difference_of_nC_nT_E);
         difference_of_nC_nT_O = (iter_count_r == 1) ? normalize_C_O_w  - normalize_T_O_w  : normalize_C_O_w;
         abs_difference_of_nC_nT_O = difference_of_nC_nT_O > 0 ? difference_of_nC_nT_O : (0 - difference_of_nC_nT_O);


		 temp_exe_C1_w = difference_of_nC_nT_E * 0x91e6;
         temp_exe_C2_w = difference_of_nC_nT_E * 0x3497;
         temp_exe_C3_w = difference_of_nC_nT_E * 0x276;
		 temp_exe_C4_w = difference_of_nC_nT_E * 0x4;
         temp_exe_D1_w = difference_of_nC_nT_O * 0x91e6;
         temp_exe_D2_w = difference_of_nC_nT_O * 0x3497;
         temp_exe_D3_w = difference_of_nC_nT_O * 0x276;
		 temp_exe_D4_w = difference_of_nC_nT_O * 0x4;
         //fcout << 2 * (A_C) << "\t"<< difference_of_nC_nT_E << endl;
/*
		 temp_exe_C1_w = difference_of_nC_nT_E * 0x7f9a;
         temp_exe_C2_w = difference_of_nC_nT_E * 0x3a73; 
         temp_exe_C3_w = difference_of_nC_nT_E * 0x59c;
		 temp_exe_C4_w = difference_of_nC_nT_E * 0x1d;
         temp_exe_D1_w = difference_of_nC_nT_O * 0x7f9a;
         temp_exe_D2_w = difference_of_nC_nT_O * 0x3a73;
         temp_exe_D3_w = difference_of_nC_nT_O * 0x59c;
		 temp_exe_D4_w = difference_of_nC_nT_O * 0x1d;
*///         fcout << 2 * (A_C) + 1 << "\t"<< difference_of_nC_nT_O <<endl;
         
         
//         switch(t/*iter_count_r*/){
/*
            case 0:
                  
                    temp_exe_C1_w = difference_of_nC_nT_E * 0x6621;
                    temp_exe_C2_w = difference_of_nC_nT_E * 0x3df1;
                    temp_exe_C3_w = difference_of_nC_nT_E * 0xdd2;
					     temp_exe_C4_w = difference_of_nC_nT_E * 0x122;
                    temp_exe_D1_w = difference_of_nC_nT_O * 0x6621;
                    temp_exe_D2_w = difference_of_nC_nT_O * 0x3df1;
                    temp_exe_D3_w = difference_of_nC_nT_O * 0xdd2;
					     temp_exe_D4_w = difference_of_nC_nT_O * 0x122;
                    break;
            case 6:
                  
                    temp_exe_C1_w = difference_of_nC_nT_E * 0x6621;
                    temp_exe_C2_w = difference_of_nC_nT_E * 0x3df1;
                    temp_exe_C3_w = difference_of_nC_nT_E * 0xdd2;
					     temp_exe_C4_w = difference_of_nC_nT_E * 0x122;
                    temp_exe_D1_w = difference_of_nC_nT_O * 0x6621;
                    temp_exe_D2_w = difference_of_nC_nT_O * 0x3df1;
                    temp_exe_D3_w = difference_of_nC_nT_O * 0xdd2;
					     temp_exe_D4_w = difference_of_nC_nT_O * 0x122;
                    break;
            case 1:
                  
                    temp_exe_C1_w = difference_of_nC_nT_E * 0x3311;
                    temp_exe_C2_w = difference_of_nC_nT_E * 0x2d10;
                    temp_exe_C3_w = difference_of_nC_nT_E * 0x1ef9;
					     temp_exe_C4_w = difference_of_nC_nT_E * 0x1094;
                    temp_exe_D1_w = difference_of_nC_nT_O * 0x3311;
                    temp_exe_D2_w = difference_of_nC_nT_O * 0x2d10;
                    temp_exe_D3_w = difference_of_nC_nT_O * 0x1ef9;
                    temp_exe_D4_w = difference_of_nC_nT_O * 0x1094;
                   break;
            case 2:
                  
                    temp_exe_C1_w = difference_of_nC_nT_E * 0x220b;
                    temp_exe_C2_w = difference_of_nC_nT_E * 0x2034;
                    temp_exe_C3_w = difference_of_nC_nT_E * 0x1b42;
					     temp_exe_C4_w = difference_of_nC_nT_E * 0x14a6;
                    temp_exe_D1_w = difference_of_nC_nT_O * 0x220b;
                    temp_exe_D2_w = difference_of_nC_nT_O * 0x2034;
                    temp_exe_D3_w = difference_of_nC_nT_O * 0x1b42;
					     temp_exe_D4_w = difference_of_nC_nT_O * 0x14a6;
                    break;
            case 3:
                  
                    temp_exe_C1_w = difference_of_nC_nT_E * 0x1988;
                    temp_exe_C2_w = difference_of_nC_nT_E * 0x18bf;
                    temp_exe_C3_w = difference_of_nC_nT_E * 0x1688;
					     temp_exe_C4_w = difference_of_nC_nT_E * 0x1346;
                    temp_exe_D1_w = difference_of_nC_nT_O * 0x1988;
                    temp_exe_D2_w = difference_of_nC_nT_O * 0x18bf;
                    temp_exe_D3_w = difference_of_nC_nT_O * 0x1688;
					     temp_exe_D4_w = difference_of_nC_nT_O * 0x1346;
                    break;
            case 4:
                    temp_exe_C1_w = difference_of_nC_nT_E * 0x146d;
                    temp_exe_C2_w = difference_of_nC_nT_E * 0x1405;
                    temp_exe_C3_w = difference_of_nC_nT_E * 0x12db;
					     temp_exe_C4_w = difference_of_nC_nT_E * 0x110f;
                    temp_exe_D1_w = difference_of_nC_nT_O * 0x146d;
                    temp_exe_D2_w = difference_of_nC_nT_O * 0x1405;
                    temp_exe_D3_w = difference_of_nC_nT_O * 0x12db;
					     temp_exe_D4_w = difference_of_nC_nT_O * 0x110f;
                    break;
            default :
                    temp_exe_C1_w = difference_of_nC_nT_E * 0x146d;
                    temp_exe_C2_w = difference_of_nC_nT_E * 0x1405;
                    temp_exe_C3_w = difference_of_nC_nT_E * 0x12db;
					     temp_exe_C4_w = difference_of_nC_nT_E * 0x110f;
                    temp_exe_D1_w = difference_of_nC_nT_O * 0x146d;
                    temp_exe_D2_w = difference_of_nC_nT_O * 0x1405; 
                    temp_exe_D3_w = difference_of_nC_nT_O * 0x12db;
					     temp_exe_D4_w = difference_of_nC_nT_O * 0x110f;
         }//end for switch
*/
         //cout << "temp: "<<  temp_exe_C2_w << endl;

         exe_C1_w = temp_exe_C1_w/pow((double)2,16) + (temp_exe_C1_w >0 ? 0.5 : -0.5);    
         exe_C2_w = temp_exe_C2_w/pow((double)2,16) + (temp_exe_C2_w >0 ? 0.5 : -0.5);
         exe_C3_w = temp_exe_C3_w/pow((double)2,16) + (temp_exe_C3_w >0 ? 0.5 : -0.5);
		   exe_C4_w = temp_exe_C4_w/pow((double)2,16) + (temp_exe_C4_w >0 ? 0.5 : -0.5);
         exe_D1_w = temp_exe_D1_w/pow((double)2,16) + (temp_exe_D1_w >0 ? 0.5 : -0.5);
         exe_D2_w = temp_exe_D2_w/pow((double)2,16) + (temp_exe_D2_w >0 ? 0.5 : -0.5);
         exe_D3_w = temp_exe_D3_w/pow((double)2,16) + (temp_exe_D3_w >0 ? 0.5 : -0.5);
		   exe_D4_w = temp_exe_D4_w/pow((double)2,16) + (temp_exe_D4_w >0 ? 0.5 : -0.5);

         //cout << "not : "<< exe_C1_w << " " << exe_C2_w << " " << exe_D1_w << " " << exe_D2_w << endl;
         //fcout << exe_C1_w << endl;
         //fcout << exe_D1_w << endl;
         //fcout << exe_F2_w  << "\t" <<  exe_A1_w << "\t" << exe_B2_w << endl;
         //fcout << exe_A2_w  << "\t" <<  exe_B1_w << "\t" << exe_C2_w << endl;
         t_exe_C4_w = (A_C < A_2d_C && iter_count_r != 1)? 0 : exe_C4_w;
         t_exe_A2_w = (A_d_C < A_2d_C && iter_count_r != 1)? 0 : exe_A2_w;
         t_exe_A3_w = (A_d_C < A_2d_C && iter_count_r != 1)? 0 : exe_A3_w;
         t_exe_E2_w = exe_E2_w;
         t_exe_E1_w = exe_E1_w;
         t_exe_G3_w = (A_2d_C < A_3d_C && iter_count_r != 1) ? 0: exe_G3_w;
         t_exe_G4_w = (A_2d_C < A_3d_C && iter_count_r != 1) ? 0: exe_G4_w;
         
         t_exe_B3_w = (A_d_C < A_2d_C && iter_count_r != 1)? 0 : exe_B3_w;
         t_exe_B4_w = (A_d_C < A_2d_C && iter_count_r != 1)? 0 : exe_B4_w;
         t_exe_F2_w = exe_F2_w;
         t_exe_F1_w = exe_F1_w;
         t_exe_H2_w = (A_2d_C < A_3d_C && iter_count_r != 1) ? 0: exe_H2_w;
         t_exe_H3_w = (A_2d_C < A_3d_C && iter_count_r != 1) ? 0: exe_H3_w;
         t_exe_J4_w = (A_2d_C < A_4d_C && iter_count_r != 1) ? 0: exe_J4_w;
         
         
         
         
         
         add_A2_B1_C2_w = t_exe_F1_w + t_exe_E2_w + t_exe_A2_w + t_exe_B3_w + t_exe_H3_w + t_exe_C4_w + t_exe_G4_w;
         add_B2_C1_D2_w = t_exe_E1_w + t_exe_H2_w + t_exe_F2_w + t_exe_G3_w + t_exe_A3_w + t_exe_B4_w + t_exe_J4_w;
         //fcout << " ADD\t"<< 2 * (A_2d_C) << "\t" << add_B2_C1_D2_w << endl;
         //fcout << "ADD\t" << 2 * (A_2d_C) +1<< "\t" << add_A2_B1_C2_w<< endl;
         //cout << "add : "<< add_A2_B1_C2_w << " " << add_B2_C1_D2_w << endl;
/*         if(add_A2_B1_C2_w != 0 || add_B2_C1_D2_w!= 0){
            cout << "exe" << endl;
            cout << t_exe_F1_w << "\t" << t_exe_E2_w << "\t" << t_exe_A2_w << "\t" << t_exe_B3_w << "\t" << t_exe_H3_w << "\t" << t_exe_C4_w << "\t" << t_exe_G4_w << endl;
            cout << t_exe_E1_w << "\t" << t_exe_H2_w << "\t" << t_exe_F2_w << "\t" << t_exe_G3_w << "\t" << t_exe_A3_w << "\t" << t_exe_B4_w << "\t" << exe_J4_w << endl;
         
         
         }
*/
         down_sample_w = add_A2_B1_C2_w + add_B2_C1_D2_w;
         //cout << A_3d_C/2 << "\t" << (index_3d)/2 - 1 << endl;
         //if((A_3d_C-1)/2 == (index_3d)/2 - 1) down_sample_w = 0;
            //cout << "DOWN\t" << (A_2d_C) << "\t" << down_sample_w/2<< "\t" <<endl;//<<(A_3d_C-1)/2 << "\t" << (index_3d)/2 - 1 <<endl;
 /*        if(exe_B4_w != 0 ||  exe_D4_w != 0){
            cout << "B4: " << exe_B4_w << " D4:" << exe_D4_w  << endl; //<< " C2:" << exe_C2_w << endl;
            //cout << "A1: " << exe_A1_w << " F2:" << exe_F2_w << " B2:" << exe_B2_w << endl;
         
         }
  */       if((A_2d_C)%2 == 0){
            data_C_E[(A_2d_C)/2] = down_sample_w / 2;   
            //if (down_sample_w != 0)cout << "Address: " << (A_2d_C)/2 << " Data: " << down_sample_w / 2 << endl;
         }
         else{
            data_C_O[((A_2d_C)-1)/2] = down_sample_w / 2;   
            //if (down_sample_w != 0)cout << "Address: " << ((A_2d_C)-1)/2 << " Data: " << down_sample_w / 2 << endl;
         }
         
		 abs_add_down_sample_w = (down_sample_w > 0 ) ? floor((double)down_sample_w  ) : (0 - floor((double)down_sample_w ));
//       cout << "abs : "<< abs_add_down_sample_w << endl;
         
         distance = distance + ((iter_count_r == 1) ? (abs_add_down_sample_w + abs_difference_of_nC_nT_E + abs_difference_of_nC_nT_O) : abs_add_down_sample_w );
       /*  if( abs_add_down_sample_w != 0 || abs_difference_of_nC_nT_E != 0 || abs_difference_of_nC_nT_O != 0){
            cout << abs_add_down_sample_w << " " <<abs_difference_of_nC_nT_E << " " <<abs_difference_of_nC_nT_O << endl;
            cout << distance << endl;
         }
         */
         //if(A_3d_C == index_3d)
         //cout << distance << endl;
         
         
         //DELAY
         index_3d = index_2d;
         index_2d = index_d;
         index_d = index;
         A_4d_C = A_3d_C;
         A_3d_C = A_2d_C;
         A_2d_C = A_d_C;
         A_d_C = A_C;
         exe_J1_w = exe_H1_w;
         exe_J2_w = exe_H2_w;
         exe_J3_w = exe_H3_w;
         exe_J4_w = exe_H4_w;


		   exe_G1_w = exe_E1_w;
         exe_G2_w = exe_E2_w;
         exe_G3_w = exe_E3_w;
		   exe_G4_w = exe_E4_w;
		   exe_H1_w = exe_F1_w;
         exe_H2_w = exe_F2_w;
         exe_H3_w = exe_F3_w;
		   exe_H4_w = exe_F4_w;



         exe_E1_w = exe_A1_w;
         exe_E2_w = exe_A2_w;
         exe_E3_w = exe_A3_w;
		   exe_E4_w = exe_A4_w;
         exe_F1_w = exe_B1_w;
         exe_F2_w = exe_B2_w;
         exe_F3_w = exe_B3_w;
		   exe_F4_w = exe_B4_w;
         exe_A1_w = exe_C1_w;
         exe_A2_w = exe_C2_w;
         exe_A3_w = exe_C3_w;
		   exe_A4_w = exe_C4_w;
		   exe_B4_w = exe_D4_w;
         exe_B3_w = exe_D3_w;
         exe_B2_w = exe_D2_w;
         exe_B1_w = exe_D1_w;
      }//end for A_C
      index = index/2;
      //cout << iter_count_r<< " "<< distance << endl;
      
   }//end for iter_count_r
   //fcout << "here" << endl;
   //system("pause");
   


}
