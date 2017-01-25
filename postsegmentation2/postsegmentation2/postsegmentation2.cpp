#include <stdio.h>
#include <fstream>
#include <iostream>
#include <cmath>
#include <vector>
#include <map>

#define AreaThreshold img_height * img_width * 0.0050
#define BlockSize 1
#define Percent BlockSize*BlockSize*0.9

using namespace std;

void dilation (unsigned int **, unsigned int **, int, int);
void erosion (unsigned int **, unsigned int **, int, int);

int main(int argc, char *argv[]){
/******  input / output file declaration  ******/

	int size_sequence = atoi(argv[2]);
	int img_width = atoi(argv[3]);
	int img_height = atoi(argv[4]);
	int img_width_2 = img_width/2;
	int img_height_2 = img_height/2;
	char filename [500];
	
	FILE* fp_objmsk;// *fp_bckgnd0, *fp_built0, *fp_occupied0, *fp_bckgnd1, *fp_built1, *fp_occupied1, *fp_bckgnd2, *fp_built2, *fp_occupied2, *fp_bckgnd3, *fp_built3, *fp_occupied3/*, *fp_bckgnd4, *fp_built4, *fp_occupied4, *fp_bckgnd5, *fp_built5, *fp_occupied5*/, *fp_GTResult, *fp_FDGTResult, *fp_NoiLvlRpt;
	strcpy(filename, argv[1]);
	
	
	strncat(filename, "_ObjMsk.y", strlen("_ObjMsk.y"));
	cout << "Read " << filename << ".......\n";
	fp_objmsk = fopen(filename,"rb");
	
	FILE* foutimg;
	strcpy(filename, argv[1]);
	strncat(filename, "_seg_img.y", strlen("_seg_img.y"));
	foutimg = fopen(filename, "wb");
/*
	FILE* fbonding;
	strcpy(filename, argv[1]);
	strncat(filename, "_bonding.y", strlen("_bonding.y"));
	fbonding = fopen(filename,"wb");
*/
	

	
	int i, j, m, n, k;
	int frame_idx;
	int counter;
	float countwhite;
	int smallest, position;
	map<int,int> area;
    map<int,int>::iterator iter;
    map<int,int>::iterator itersort;
	map<int,int> sort;
	bool done, donel;
//	int top, right, left, down;
//	unsigned int sk;
	
	

/******  current images ******/
	
	unsigned int *objmsk_ptr = new unsigned int [img_height*img_width];
	unsigned int **objmsk = new unsigned int* [img_height];
	

	
	unsigned int *temp_img_ptr = new unsigned int [img_height*img_width];
	unsigned int **temp_img = new unsigned int* [img_height];
	
	
	unsigned int *temp_img2_ptr = new unsigned int [img_height*img_width];
	unsigned int **temp_img2 = new unsigned int* [img_height];

	unsigned int *temp_img3_ptr = new unsigned int [img_height*img_width];
	unsigned int **temp_img3 = new unsigned int* [img_height];
	
	unsigned int *out_img_ptr = new unsigned int [img_height*img_width];
	unsigned int **out_img = new unsigned int* [img_height];



	for(i = 0; i < img_height; i++){
		temp_img2[i] = & temp_img2_ptr[img_width * i];
		temp_img3[i] = & temp_img3_ptr[img_width * i];
		temp_img[i] = & temp_img_ptr[img_width * i];
		objmsk[i] = & objmsk_ptr[img_width * i];
		out_img[i] = & out_img_ptr[img_width * i];

		
	}//end for i


	for(frame_idx = 0; frame_idx < size_sequence; frame_idx++ ) {
		cout << "Frame: " << frame_idx << "\n";


		//fread ( objmsk_ptr, 1, img_width*img_height, fp_objmsk);
		for(j = 0; j <  img_height; j++){
            for(i = 0; i <  img_width; i++){
	   		// if(temp_img[j][i] == 0)
	   		//	fputc(0, fbonding);
	   		 //else
	   		//	fputc(255, fbonding);
			objmsk[j][i] = fgetc(fp_objmsk);
         }//end inner for i
      }//end outer for j
		
/*
		erosion(objmsk, temp_img3, img_height, img_width);

		dilation(temp_img3, temp_img2, img_height, img_width);

		dilation(temp_img2, temp_img3, img_height, img_width);
		erosion(temp_img3, objmsk, img_height, img_width);
		*/

		//先作2次dilation，讓缺口被補起來，然後再接著作area thesholding，比較不會因為缺口而沒反白成功。
		//erosion(objmsk, temp_img3, img_height, img_width);

		//dilation(temp_img3, objmsk, img_height, img_width);

		for(i = 0; i < img_height; i++){
			for(j = 0; j < img_width; j++){
				temp_img[i][j] = 0;
				objmsk[i][j] = 255 - objmsk[i][j];
			}
 		}
		
//fwrite ( objmsk_ptr, 1, img_width*img_height, foutimg);
/**********************************************************************************************/
//Connecting Component Analysis
	/******************************************************************/
/*                             TOP DOWN                           */
/******************************************************************/
		
		for(j = 0; j < img_height; j+=BlockSize){
			for(i = 0; i < img_width; i+=BlockSize){
				countwhite = 0;
				
				for(m = 0; m < BlockSize; m++){
					for(n = 0; n < BlockSize; n++){
						if(objmsk[j+m][i+n] != 0)countwhite++;
					}//end for n
				}//end for m
				for(m = 0; m < BlockSize; m++){
					for(n = 0; n < BlockSize; n++){
						if(countwhite > Percent)objmsk[j+m][i+n] = 255;
						else objmsk[j+m][i+n] = 0;
					}//end for n
				}//end for m
				
			}//end for i
		}//end for j
		/*
		for(j = 0; j < img_height * img_width; j++){
     	   temp_img_ptr[j] = 0;
	   }*/
		

		counter = 0;
	   for(j = 0; j < img_height; j++){
         smallest = 999;
      
	     for(i = 0; i < img_width; i++){
			
            if(j == 0){
               if(i == 0){
                  if(objmsk[j][i] != 0){
                     counter++;
                     temp_img[j][i] = counter;
                  }
               }//end if i == 0
               else{
                  if(objmsk[j][i] != 0){
                     if(objmsk[j][i-1] !=  0){
                        temp_img[j][i] = temp_img[j][i-1];
                     }//end img[j][i-1] != 0
                     else{
                        counter++;
                        temp_img[j][i] = counter;
                     }//end img[j][i-1] == 0
                  }//end if img[j][i] != 0
               }//if i > 0
            }//end if j == 0
            else{
               if(objmsk[j][i] != 0){
				  
                  if(i == 0){
                     counter++;
                     temp_img[j][i] = counter;
                  }// end i == 0
                  else{
                     if(objmsk[j][ i -1] != 0){
                        temp_img[j][i] = temp_img[j][i-1];
                     }//end img[j][i-1] != 0
                     else{
                        counter++;
                        temp_img[j][i] = counter;
                     }//end img[j][i-1] != 0
                  }//i != 0
				  
                  if(objmsk[j-1][i] != 0){
                     smallest = temp_img[j-1][i];
                     position = i;
                     while((position >= 0) && (objmsk[j][position] != 0) && ((temp_img[j][position] > smallest)||(temp_img[j][position] == 0))){                   
                        temp_img[j][position] = smallest;
                        position--;
                     }//end while
                  }//end if img[j-1][i] != 0
				  
/*    
	   		   if(objmsk_ptr[(j-1)*img_width + max(0,i - 1)] != 0){
                     smallest = temp_img_ptr[(j-1)*img_width + max(0,i - 1)];
                     position = max(0,i - 1);
                     while((position >= 0) && (objmsk[j][position] != 0) && ((temp_img[j][position] > smallest)||(temp_img[j][position] == 0))){                   
                        temp_img[j][position] = smallest;
                        position--;
                     }//end while
                  }//end if img[j-1][i] != 0
*/    
               }// end if img[j][i] != 0
            }//end j > 0
			
         }//end inner for i
      }//end outer for j



/******************************************************************/
/*                            BOTTOM UP                           */
/******************************************************************/
	  for(k = 0; k < 3; k++){
		  
	  for(j =  img_height -1; j >= 0; j--){
         for(i =  img_width -1; i >= 0; i--){
            if(i <  img_width -1){
               if((temp_img[j][i] != 0) && (temp_img[j][i+1] != 0) && (temp_img[j][i+1] < temp_img[j][i])){
                  temp_img[j][i] = temp_img[j][i+1];
               }//end if temp_img[j][i] != 0
            }//end if i == 0
            if(j <  img_height -1){
               if((temp_img[j][i] != 0) && (temp_img[j+1][i] != 0) && (temp_img[j+1][i] < (temp_img[j][i]))){
                  position = i;
                  smallest = temp_img[j+1][i];
                  while((position <= img_width -1) && (temp_img[j][position] != 0) && (temp_img[j][position] > smallest)){                   
                     temp_img[j][position] = smallest;
                     position++;
                  }//end while
               }//end if
  /*  
	   		if((temp_img[j][i] != 0) && (temp_img_ptr[min((j+1)*img_width + i + 1, img_width * img_height - 1)] != 0) && (temp_img[j+1][i] < (temp_img[j][i]))){
                  position = min(i+1, img_height-1);
                  smallest = temp_img_ptr[min((j+1)*img_width + i + 1, img_width * img_height - 1)];
                  while((position <= img_width -1) && (temp_img[j][position] != 0) && (temp_img[j][position] > smallest)){                   
                     temp_img[j][position] = smallest;
                     position++;
                  }//end while
               }//end if
    */
            }//end j < 511
         }//end inner for i
      }//end outer for j
    
/******************************************************************/
/*                             TOP DOWN                           */
/******************************************************************/
    
      for(j = 0; j <  img_height; j++){
         for(i = 0; i <  img_width; i++){
            if(i > 0){
               if((temp_img[j][i] != 0) && (temp_img[j][i-1] != 0) && (temp_img[j][i-1] < temp_img[j][i])){
                  temp_img[j][i] = temp_img[j][i-1];
               }//end if temp_img[j][i] != 0
            }//end if i == 0
            if(j > 0){
               if((temp_img[j][i] != 0) && (temp_img[j-1][i] != 0) && (temp_img[j-1][i] < (temp_img[j][i]))){
                  position = i;
                  smallest = temp_img[j-1][i];
                  while((position > 0) && (temp_img[j][position] != 0) && (temp_img[j][position] > smallest)){                   
                     temp_img[j][position] = smallest;
                     position--;
                  }//end while
               }//end if
/*    
	   		if((temp_img[j][i] != 0) && (temp_img_ptr[(j-1)*img_width + max(0, i-1)] != 0) && (temp_img[j-1][i] < (temp_img[j][i]))){
                  position = max(0, i-1);
                  smallest = temp_img_ptr[(j-1)*img_width + max(0, i-1)];
                  while((position > 0) && (temp_img[j][position] != 0) && (temp_img[j][position] > smallest)){                   
                     temp_img[j][position] = smallest;
                     position--;
                  }//end while
               }//end if
  */  
            }//end j < 511
            
            
         }//end inner for i
      }//end outer for j
	  }
    
    
/******************************************************************/
/*                                      Area > AreaThreshold                                       */
/******************************************************************/
      area.clear();
	  iter = area.begin();
	  sort.clear();
	  itersort = sort.begin();
	 
      
      for(j = 0; j <  img_height; j++){
         for(i = 0; i <  img_width; i++){
			iter = area.begin();
            if(temp_img[j][i] != 0){
               iter = area.find(temp_img[j][i]);
               if(iter == area.end()){
                  //area[(temp_img[j][i])] = 1;
				   area.insert(make_pair(temp_img[j][i], 1));
               }//end if iter == area.end
               else{
                  iter->second++;
               }//end else
            }//end if temp_img[j][i] != 0
         }//end for i
      }//end for j
   
      counter = 1;
      
      for(j = 0; j <  img_height; j++){
         for(i = 0; i <  img_width; i++){
            iter = area.find(temp_img[j][i]);
            if(iter != area.end()){
               if(iter->second < AreaThreshold ){
                  temp_img[j][i] = 0; 
               }//end if iter->second < 500
               else{
                  itersort = sort.find(temp_img[j][i]);
                  if(itersort == sort.end()){
                     if(temp_img[j][i] != 0){
                        sort[(temp_img[j][i])] = counter;
                        temp_img[j][i] = counter;
                        counter++;
                     }// end if itersort->second != 0
                  }//end if itersort == sort.end()
                  else{
                     temp_img[j][i] = itersort->second;
                  }//end if itersort != sort.end()
               }//end if iter->second >= 500
            }//end if iter == area.end
			else{
			   temp_img[j][i] = 0;
			}
         }//end for i
      }//end for j
    
		
    
/******************************************************************/
/*                        Bounding Box                            */
/******************************************************************/
    
      
    /*  
      done = false;
	  donel = false;
	  left = 0;
	  right = 0;
	  top = 0;
	  down = 0;
*/
	  for(j = 0; j <  img_height; j++){
         for(i = 0; i <  img_width; i++){
	        if(temp_img[j][i] == 0)objmsk[j][i] = 255;
	        else objmsk[j][i] = 0;
               
               
         }//end for i
      }//end for j
//dilation(objmsk, temp_img3, img_height, img_width);
/*erosion(objmsk, temp_img3, img_height, img_width);
	  dilation(temp_img3, objmsk, img_height, img_width);  


	  for(j = 0; j <  img_height; j++){
            for(i = 0; i <  img_width; i++){
	   		// if(temp_img[j][i] == 0)
	   		//	fputc(0, fbonding);
	   		 //else
	   		//	fputc(255, fbonding);
			fputc(objmsk[j][i], foutimg);
         }//end inner for i
      }//end outer for j
*/
	  erosion(objmsk, temp_img3, img_height, img_width);

      erosion(temp_img3, temp_img2, img_height, img_width);
/*	  erosion(temp_img2, temp_img3, img_height, img_width);
	  erosion(temp_img3, temp_img2, img_height, img_width);
	  erosion(temp_img2, temp_img3, img_height, img_width);
	  erosion(temp_img3, temp_img2, img_height, img_width);
	  erosion(temp_img2, temp_img3, img_height, img_width);
	  dilation(temp_img3, temp_img2, img_height, img_width);
	  dilation(temp_img2, temp_img3, img_height, img_width);
	  dilation(temp_img3, temp_img2, img_height, img_width);

	  dilation(temp_img2, temp_img3, img_height, img_width);
	  dilation(temp_img3, temp_img2, img_height, img_width);
*/
      dilation(temp_img2, temp_img3, img_height, img_width);
	  dilation(temp_img3, objmsk, img_height, img_width);  
	  

      
    
	  /*


      for(sk = 1; sk <= sort.size(); sk++){
	     
	     done = false;
		 donel = false;
		 left = 0;
	     right = 0;
	     top = 0;
	     down = 0;
         
		 

		 

	     
	 //    cout << nownode << " " << end->left << "\n";
         for(j = 0; j <  img_height; j++){
            for(i = 0; i <  img_width; i++){
			   
               if(temp_img[j][i] == sk){
                  if(done == false){
                     top = j;
                     done = true;
	   				
					
                  }//end top == 0
	   			  else{ down = j;
	   			
	   			   
				   
	   		       }
               }//end if temp_img[j][i] = k
               
            }//end for i
         }//end for j
		 
		 
	     for(j = 0; j <  img_width; j++){
            for(i = 0; i <  img_height; i++){
               
               if(temp_img[i][j] == sk){
                  if(donel == false){
                     left = j;
	   			  
                     donel = true;
                  }//end left == 0
	   		      else{ 
	   			      right = j;
	   			      
	   		      }
               }//end if temp_img_ptr[i][j] = k
	   		
	   		
            }//end for i
         }//end for j
		 
         done = false;
         donel = false;
	    
         for(j = 0; j <  img_height; j++){
            for(i = 0; i <  img_width; i++){
               if((j == top)||(j == down)){
                  if((i >= left)&&(i <= right)){
                     objmsk[j][i] = 128;
                  }//end left~right
               }//end if j == top
               if((i == left)||(i == right)){
                  if((j >= top)&&(j <= down)){
                     objmsk[j][i] = 128;
                  }//end left~right
               }//end if j == top 
            }//end for i
         }//end for j
		
    
      }//end for k   

	*/  
      
      for(j = 0; j <  img_height; j++){
            for(i = 0; i <  img_width; i++){
	   		// if(temp_img[j][i] == 0)
	   		//	fputc(0, fbonding);
	   		 //else
	   		//	fputc(255, fbonding);
			fputc(objmsk[j][i], foutimg);
         }//end inner for i
      }//end outer for j


/*


      for(j = 0; j <  img_height; j++){
            for(i = 0; i <  img_width; i++){
	   		 if(temp_img[j][i] == 0)
	   			fputc(0, foutimg);
	   		 else
	   			fputc(255, foutimg);
			//fputc(temp_img[j][i], foutimg);
         }//end inner for i
      }//end outer for j


*/




	   	
	}
    cout << "end\n" ;
	return 0;

}


void dilation (unsigned int ** i_img, unsigned int ** o_img, int Height, int Width){
   int i;
   int j;

   for(j = 0; j < Height; j++){
      for(i = 0; i < Width; i++){
         o_img[j][i] = 0;
		 
      }//end for i
   }//end for j
   for(j = 0; j < Height; j++){
      for(i = 0; i < Width; i++){
		  if((i >= 2) && (i < Width-2) && (j >= 2) && (j < Height-2))	{  	
			if(i_img[j][i] != 0){
	            o_img[max(0,j-2)][max(0,i-1)] = 255;
				o_img[max(0,j-2)][i]          = 255;
				o_img[max(0,j-2)][min(Width-1,i+1)] = 255;
				o_img[max(0,j-1)][max(0,i-2)] = 255;
				o_img[max(0,j-1)][max(0,i-1)] = 255;
				o_img[max(0,j-1)][i]          = 255;
				o_img[max(0,j-1)][min(Width-1,i+1)] = 255;
				o_img[max(0,j-1)][min(Width-1,i+2)] = 255;
				o_img[j][max(0,i-2)] = 255;
				o_img[j][max(0,i-1)] = 255;
				o_img[j][i]          = 255;
				o_img[j][min(Width-1,i+1)] = 255;
				o_img[j][min(Width-1,i+2)] = 255;
				o_img[min(Height-1,j+1)][max(0,i-2)] = 255;
				o_img[min(Height-1,j+1)][max(0,i-1)] = 255;
				o_img[min(Height-1,j+1)][i]          = 255;
				o_img[min(Height-1,j+1)][min(Width-1,i+1)] = 255;
				o_img[min(Height-1,j+1)][min(Width-1,i+2)] = 255;
				o_img[min(Height-1,j+2)][max(0,i-1)] = 255;
				o_img[min(Height-1,j+2)][i]          = 255;
				o_img[min(Height-1,j+2)][min(Width-1,i+1)] = 255;
			}//end if
		  }
		  else o_img[j][i] = 0;
		 
      }//end for i
   }//end for j
}
void erosion (unsigned int ** img, unsigned int ** o_img, int Height, int Width){
   int i;
   int j;
   for(j = 0; j < Height; j++){
      for(i = 0; i < Width; i++){
         o_img[j][i] = 0;
      }//end for i
   }//end for j
   for(j = 0; j < Height; j++){
      for(i = 0; i < Width; i++){
		  //cout << (int) img[j][i] << "\n";
         if((i >= 2) && (i < Width-2) && (j >= 2) && (j < Height-2)){
            if(((int)img[j-2][i-1] == 255) && 
               ((int)img[j-2][i]   == 255) &&
               ((int)img[j-2][i+1] == 255) &&
               ((int)img[j-1][i-2] == 255) &&
               ((int)img[j-1][i-1] == 255) &&
               ((int)img[j-1][i]   == 255) &&
               ((int)img[j-1][i+1] == 255) &&
               ((int)img[j-1][i+2] == 255) &&
               ((int)img[j][i-2]   == 255) &&
               ((int)img[j][i-1]   == 255) &&
               ((int)img[j][i]     == 255) &&
               ((int)img[j][i+1]   == 255) &&
               ((int)img[j][i+2]   == 255) &&
               ((int)img[j+1][i-2] == 255) &&
               ((int)img[j+1][i-1] == 255) &&
               ((int)img[j+1][i]   == 255) &&
               ((int)img[j+1][i+1] == 255) &&
               ((int)img[j+1][i+2] == 255) &&
               ((int)img[j+2][i-1] == 255) &&
               ((int)img[j+2][i]   == 255) &&
               ((int)img[j+2][i+1] == 255)
			   )
				  o_img[j][i] = 255;
             else o_img[j][i] = 0;
          }
          else o_img[j][i] = 0;
      }//end for i
   }//end for j
}