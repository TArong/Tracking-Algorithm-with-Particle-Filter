#include "CnvntnlPFTrial.h"
#include <ctime>
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <cmath>
//#include <map>
#include "segnode.h"
#include "tracker.h"

#include "emd.h"
#include "BD.h"
//#include "diffusion.h"
#include "pazen.h"
#include "BU.h"
#include "distance_compute.h"

#define ColorThreshold 0
#define HistogramThreshold 0
//#define StartFrame 340
#define AreaThreshold FrameH * FrameW * 0.005  //電池用0.005  其他用0.01
#define apha 0
#define ConfidenceThreshold -1//0.001
#define LeftThreshold 10
#define RightThreshold FrameW - 10
#define TopThreshold 5
#define BottomThreshold FrameH - 5
#define MoreSpace 30/10
#define LearningRatio 0.5

#define AddLeftThreshold 0
#define AddRightThreshold 0
#define AddTopThreshold 0
#define AddBottomThreshold 0

#define WeightThresholdDD 0//2500000000//500
#define WeightThresholdBD 50
#define WeightThresholdEMD 50
#define MAX_TRACKER 1

#define BlockSize 1
#define Percent BlockSize*BlockSize*0.9

#define Space 0

#define G 100

#define CENTER 1  //CENTER: 1 CENTER

#define NOPARTICLE 10
#define BHistogramThreshold 0
#define BColorThreshold 0

#define ChooseNumofParticle 25
#define NoTopOnes 0
#define Shrink 0.7
#define Bguse 1  //1: background removal 0: no background removal




using namespace std;

int gcolor, numoftracker;
float grandom();

int main(int argc, char* argv[])
{
	//function();
	if(argc != 9){
	   cout << "NewOrignalImage SequenceName StartFrame EndFrame FrameWidth FrameHeight ChooseAlgorithm" << endl;
	   cout << "Choose:" << endl;
	   cout << "\t0: Earth Mover's Distance\n\t1:Diffusion Distance\n\t2:Bhattacharyya Distance" << endl;
	   system("pause");
	   return 0;

	}
	
	FILE* fpin;
	//FILE* fpout0;
	FILE* fpout1;
	//FILE* fpout2;
	//FILE* fpParticleStatus;
	FILE* fseg;
	FILE* fbonding;
	FILE* fbg;
	//FILE* fpost;
	//ofstream fouttest3("test3.txt", ios::app);
	
	//ofstream if(debugfout == 1) fouttest2("test2.txt");
	clock_t time1;
	clock_t time2;
	clock_t time3, time4;
	bool testbool = false;

	int vX, vY;
	

	
/****************/
/*   
	char* argv[2];
	argv[0] = new char [50];
	argv[1] = new char [50];
	strcpy(argv[1],"Cars_720x480_420");
*/	
/****************/
   bool flag_Y_w[256];
   bool flag_U_w[256];
   bool flag_V_w[256];

//   long long int temp_data;
	
	int IDcount;
	
	//argv[0] = 0;
//	argv = "Cars_720x480_420";
	int StartFrame = atoi(argv[2]);
	int SeqSize = atoi(argv[3]);
	int FrameH = atoi(argv[5]);
	int FrameW = atoi(argv[4]);
	int FrameH2 = FrameH/2;
	int FrameW2 = FrameW/2;
//	double clock1, clock2;
//	double timing;
	char filename [500];
	int Choose;
	Choose = atoi(argv[6]);
	int debugcout = atoi(argv[7]);
	int debugfout = atoi(argv[8]);

//	map<int,int> area;
    //map<int,int>::iterator iter;
    //map<int,int>::iterator itersort;
   int area[500][2];
   int sort[500][2];
   int count_area_size;
   int count_sort_size;
//   int count_area_index;
   bool done_count;
	float TotalHistogramValuet;//, TotalHistogramValue1, TotalHistogramValue2;
	
	//float* WeightT;
	float totalweight;
	int centroid[2];
	tracker* nowtracker;
	segnode* nownode;
	float Distance;
	float EMDtotal;
	double tempPBoxW1, tempPBoxH1;
	double temptempy, temptempx;
////	double tempPBoxW2, tempPBoxH2;
//	int temphistogramb;
	double maxweight[ChooseNumofParticle], maxx[ChooseNumofParticle], maxy[ChooseNumofParticle];//, maxw[ChooseNumofParticle], maxh[ChooseNumofParticle];
	
	

	int top, right, left, down;
    
    bool done;
    bool donel;
	bool doneadd;

	//double nowtracker->GaussianKernel;
	//double nowtracker->GaussianKernel_temp = 0;
	float tempboxw, tempboxh, tempx, tempy;

	int whichone, whichonecount;
	
	
	strcpy(filename, argv[1]);
	strncat(filename, ".yuv", strlen(".yuv"));
	if(debugcout == 1) cout << "Reading file " << filename << endl;
	fpin  = fopen(filename,"rb");
	
	
	strcpy(filename, argv[1]);
	strncat(filename, "_seg_img.y", strlen("_seg_img.y"));
	fseg = fopen(filename,"rb");

	strcpy(filename, argv[1]);
	strncat(filename, "_bg.yuv", strlen("_bg.yuv"));
	fbg = fopen(filename,"wb");


	ofstream fouttest;
	ofstream ftime;
	ofstream fposttracker, fpostseg;

	if(Choose == 0){
		strcpy(filename, argv[1]);
		strncat(filename, "_bonding_NO_EMD.y", strlen("_bonding_NO_EMD.y"));
		fbonding = fopen(filename,"wb");
		//fpout0 = fopen(filename,"wb");
		strcpy(filename, argv[1]);
		strncat(filename, "_object_NO_EMD.yuv", strlen("_object_NO_EMD.yuv"));
		fpout1 = fopen(filename,"wb");

		

		strcpy(filename, argv[1]);
		strncat(filename, "_test_NO_EMD.txt", strlen("_test_NO_EMD.txt"));
		if(debugfout == 1) fouttest.open(filename);

		strcpy(filename, argv[1]);
		strncat(filename, "_time_NO_EMD.txt", strlen("_time_NO_EMD.txt"));
		if(debugfout == 1) ftime.open(filename);

		strcpy(filename, argv[1]);
		strncat(filename, "_position_NO_EMD.txt", strlen("_position_NO_EMD.txt"));
		fposttracker.open(filename);
		//nowtracker->GaussianKernel = 1;

		strcpy(filename, argv[1]);
		strncat(filename, "_answer_NO_EMD.txt", strlen("_answer_NO_EMD.txt"));
		fpostseg.open(filename);
	}
	else if(Choose == 1){
		strcpy(filename, argv[1]);
		strncat(filename, "_bonding_NO_DD.y", strlen("_bonding_NO_DD.y"));
		fbonding = fopen(filename,"wb");
		//fpout0 = fopen(filename,"wb");
		strcpy(filename, argv[1]);
		strncat(filename, "_object_NO_DD.yuv", strlen("_object_NO_DD.yuv"));
		fpout1 = fopen(filename,"wb");

		strcpy(filename, argv[1]);
		strncat(filename, "_test_NO_DD.txt", strlen("_test_NO_DD.txt"));
		if(debugfout == 1) fouttest.open(filename);

		strcpy(filename, argv[1]);
		strncat(filename, "_time_NO_DD.txt", strlen("_time_NO_DD.txt"));
		if(debugfout == 1) ftime.open(filename);

		strcpy(filename, argv[1]);
		strncat(filename, "_position_NO_DD.txt", strlen("_position_NO_DD.txt"));
		fposttracker.open(filename);

		strcpy(filename, argv[1]);
		strncat(filename, "_answer_NO_DD.txt", strlen("_answer_NO_DD.txt"));
		fpostseg.open(filename);
		//nowtracker->GaussianKernel = 40;
	}

	else if(Choose == 2){
		strcpy(filename, argv[1]);
		strncat(filename, "_bonding_NO_BD.y", strlen("_bonding_NO_BD.y"));
		fbonding = fopen(filename,"wb");
		//fpout0 = fopen(filename,"wb");
		strcpy(filename, argv[1]);
		strncat(filename, "_object_NO_BD.yuv", strlen("_object_NO_BD.yuv"));
		fpout1 = fopen(filename,"wb");

		strcpy(filename, argv[1]);
		strncat(filename, "_test_NO_BD.txt", strlen("_test_NO_BD.txt"));
		if(debugfout == 1) fouttest.open(filename);

		strcpy(filename, argv[1]);
		strncat(filename, "_time_NO_BD.txt", strlen("_time_NO_BD.txt"));
		if(debugfout == 1) ftime.open(filename);
		//nowtracker->GaussianKernel = 160000;

		strcpy(filename, argv[1]);
		strncat(filename, "_position_NO_BD.txt", strlen("_position_NO_BD.txt"));
		fposttracker.open(filename);

		strcpy(filename, argv[1]);
		strncat(filename, "_answer_NO_BD.txt", strlen("_answer_NO_BD.txt"));
		fpostseg.open(filename);
	}
	
	
	//int PPostion[NumParticleonObject][2];// 0 =x, 1 =y
	//int PBoxWH[NumParticleonObject][2]; // 0 = width, 1= height
	//float PWeight[NumParticleonObject];
	unsigned char* framebufferY;
	unsigned char* framebufferU;
	unsigned char* framebufferV;
	unsigned char* bg_Y;
	unsigned char* bg_U;
	unsigned char* bg_V;
	unsigned int* segbufferY;
   unsigned long long int DistanceY, DistanceU, DistanceV;

	framebufferY = new unsigned char [FrameH*FrameW];
	framebufferU = new unsigned char [FrameH2*FrameW2];
	framebufferV = new unsigned char [FrameH2*FrameW2];

	bg_Y = new unsigned char [FrameH*FrameW];
	bg_U = new unsigned char [FrameH2*FrameW2];
	bg_V = new unsigned char [FrameH2*FrameW2];

	segbufferY = new unsigned int [FrameH*FrameW];
	//float HistogramTarget[NumHistBin];
	//float HistogramCandidate[NumHistBin];
	//vector<float> HistogramCandidate;
	//vector<float> HistogramBackground;

   long long int* HistogramCandidate_Y_O = new long long int [128];
   long long int* HistogramCandidate_Y_E = new long long int [128];
   long long int* HistogramCandidate_U_O = new long long int [128];
   long long int* HistogramCandidate_U_E = new long long int [128];
   long long int* HistogramCandidate_V_O = new long long int [128];
   long long int* HistogramCandidate_V_E = new long long int [128];

   long long int* BackgroundHistogram_Y_O = new long long int [128];
   long long int* BackgroundHistogram_Y_E = new long long int [128];
   long long int* BackgroundHistogram_U_O = new long long int [128];
   long long int* BackgroundHistogram_U_E = new long long int [128];
   long long int* BackgroundHistogram_V_O = new long long int [128];
   long long int* BackgroundHistogram_V_E = new long long int [128];

   long long int* LearningHistogram_Y_O = new long long int [128];
   long long int* LearningHistogram_Y_E = new long long int [128];
   long long int* LearningHistogram_U_O = new long long int [128];
   long long int* LearningHistogram_U_E = new long long int [128];
   long long int* LearningHistogram_V_O = new long long int [128];
   long long int* LearningHistogram_V_E = new long long int [128];

	//vector<float> LearningHistogram;
//	vector<float> LearningHistogram_B;
	float TotalHistogramValue;
	float TotalHistogramValueY;
	float TotalHistogramValueU;
	float TotalHistogramValueV;
	float diag;
//	int TempBinIdx;
	float TempHistValue;
	float TempHistValuey1;
	float TempHistValuey2;
	float TempHistValueu1;
	float TempHistValueu2;
	float TempHistValuev1;
	float TempHistValuev2;

	float SumofWeight;
	float BhaCoef;
//	float BhaDist2;
//	int NumRes;
//	int ResPPostion[NumParticleonObject][2];// 0 =x, 1 =y
//	int ResPBoxWH[NumParticleonObject][2]; // 0 = width, 1= height
//	float ResPWeight[NumParticleonObject];
//	bool donehistogram;
	float NCi, NBCi;
	//float ObjectPX_f;
	//float ObjectPY_f;
	//float ObjectBoxW_f;
	//float ObjectBoxH_f;
	//int ObjectPX;
	//int ObjectPY;
	//int ObjectBoxW;
	//int ObjectBoxH;
	unsigned char* FrameDisplayY = new unsigned char [FrameH*FrameW];
	unsigned char* FrameDisplayU = new unsigned char [FrameH2*FrameW2];
	unsigned char* FrameDisplayV = new unsigned char [FrameH2*FrameW2];
	int f,i,j,k,l;
//	int tmp;
	//int countseg[NumParticleonObject];
	float TempSumofWeight;
	float** countseg;
	float maxcountseg[NumParticleonObject];
	int tempA, tempB, tempC, tempD;
	double tempE, tempF, tempG, tempH;
	double tempI, tempJ, tempK, tempL;
	double tempM, tempN;
	int m, n;
	float countwhite;
//	map<int,int> sort;
////	float VarWU, StdWU;
	float mindist;

	segnode* tempnode1;
	segnode* tempnode2;
	
	feature_t* f1 = new feature_t [256];
	feature_t* f2 = new feature_t [256];

	

	signature_t s1, s2;
	float* weight1 = new float [256];
	float* weight2 = new float [256];
	for(i = 0; i < 256; i++){
		f1[i].X = i;
		f2[i].X = i;
	}//end for i

	
	
	
	


	//s1.n = NumHistBin;
	//s2.n = NumHistBin;
	
	
	
	//s1.Features = f1;
	//s2.Features = f2;


	//initialization
	//clock1 = clock();
	/*
	fread ( framebufferY, 1, FrameH*FrameW, fpin);	//read first frame		
	fread ( framebufferU, 1, FrameH2*FrameW2, fpin);			
	fread ( framebufferV, 1, FrameH2*FrameW2, fpin);	
	fread ( segbufferY, 1, FrameH*FrameW, fseg);
	*/
	unsigned int* temp_img;
	temp_img = new unsigned int [FrameH*FrameW];

	gcolor = rand()%256;

	for(f = 0; f< StartFrame; ++f){
		fread ( framebufferY, 1, FrameH*FrameW, fpin);			
		fread ( framebufferU, 1, FrameH2*FrameW2, fpin);			
		fread ( framebufferV, 1, FrameH2*FrameW2, fpin);
		if(f==0){
			for(j= 0; j < FrameH*FrameW; j++){
				bg_Y[j] = framebufferY[j];
				if(j < FrameH*FrameW/4){
					bg_U[j] = framebufferU[j];
					bg_V[j] = framebufferV[j];
				}
			}
			fwrite (bg_Y, 1, FrameH*FrameW, fbg);
			fwrite (bg_U, 1, FrameH2*FrameW2, fbg);
			fwrite (bg_V, 1, FrameH2*FrameW2, fbg);
		}


		fread( segbufferY , 1, FrameH*FrameW, fseg);
//		for(j = 0; j < FrameH*FrameW; j++)
			//segbufferY[j] = fgetc(fseg);
	}//CUT
	//for(j = 0; j < FrameH*FrameW; j++)
		//segbufferY[j] = fgetc(fseg);
	fread( segbufferY , 1, FrameH*FrameW, fseg);


	int	 counter = 0;
	int smallest = 0;
	int position = 0;
	int sk;

	segnode* root = new segnode;
	segnode* end = new segnode;
	root->right = end;
	end->left = root;

	tracker* trackerroot = new tracker;
	tracker* trackerend = new tracker;
	trackerroot->right = trackerend;
	trackerend->left = trackerroot;

double timeCCA = 0;	

	/*8888frame interation888*/
	
	for(f=StartFrame;f<SeqSize;++f){
		if(f==StartFrame+1) time1 = clock();
		//system("pause");
		if(debugcout == 1) cout << "frame: " << f << endl;
		if(debugfout == 1) fouttest << "frame: " << f << endl;
		fposttracker << endl;
		fpostseg << endl;
		//if(debugfout == 1) fouttest3 << "frame: " << f << endl;
		//if(f == StartFrame){

		fread ( framebufferY, 1, FrameH*FrameW, fpin);			

		fread ( framebufferU, 1, FrameH2*FrameW2, fpin);			

		fread ( framebufferV, 1, FrameH2*FrameW2, fpin);



	
	
		position = 0;
	


		IDcount = 0;
		//if(f == StartFrame)
		for(j = 0; j < FrameH*FrameW; j++)
			segbufferY[j] = fgetc(fseg);
		//time1 = clock();
		timeCCA = 0;
/**********************************************************************************************/
//Connecting Component Analysis
	/******************************************************************/
/*                             TOP DOWN                           */
/******************************************************************/
		
		for(j = 0; j < FrameH; j+=BlockSize){
			for(i = 0; i < FrameW; i+=BlockSize){
				countwhite = 0;
				
				for(m = 0; m < BlockSize; m++){
					for(n = 0; n < BlockSize; n++){
						if(segbufferY[(j+m)*FrameW+(i+n)] != 0)countwhite++;
					}//end for n
				}//end for m
				for(m = 0; m < BlockSize; m++){
					for(n = 0; n < BlockSize; n++){
						if(countwhite > Percent)segbufferY[(j+m)*FrameW+(i+n)] = 255;
						else segbufferY[(j+m)*FrameW+(i+n)] = 0;
					}//end for n
				}//end for m
				
			}//end for i
		}//end for j
		for(j = 0; j < FrameH * FrameW; j++){
     	   temp_img[j] = 0;
	   }
		counter = 0;
	   for(j = 0; j < FrameH; j++){
         smallest = 512;
      
	     for(i = 0; i < FrameW; i++){
            if(j == 0){
               if(i == 0){
                  if(segbufferY[j*FrameW + i] != 0){
                     counter++;
                     temp_img[j*FrameW + i] = counter;
                  }
               }//end if i == 0
               else{
                  if(segbufferY[j*FrameW + i] != 0){
                     if(segbufferY[j*FrameW + i - 1] !=  0){
                        temp_img[j*FrameW + i] = temp_img[j*FrameW + i - 1];
                     }//end img[j][i-1] != 0
                     else{
                        counter++;
                        temp_img[j*FrameW + i] = counter;
                     }//end img[j][i-1] == 0
                  }//end if img[j][i] != 0
               }//if i > 0
            }//end if j == 0
            else{
               if(segbufferY[j*FrameW + i] != 0){
                  if(i == 0){
                     counter++;
                     temp_img[j*FrameW + i] = counter;
                  }// end i == 0
                  else{
                     if(segbufferY[j*FrameW + i -1] != 0){
                        temp_img[j*FrameW + i] = temp_img[j*FrameW + i - 1];
                     }//end img[j][i-1] != 0
                     else{
                        counter++;
                        temp_img[j*FrameW + i] = counter;
                     }//end img[j][i-1] != 0
                  }//i != 0
                  if(segbufferY[(j-1)*FrameW + i] != 0){
                     smallest = temp_img[(j-1)*FrameW + i];
                     position = i;
                     while((position >= 0) && (segbufferY[j*FrameW + position] != 0) && ((temp_img[j*FrameW + position] > smallest)||(temp_img[j*FrameW + position] == 0))){                   
                        temp_img[j*FrameW + position] = smallest;
                        position--;
                     }//end while
                  }//end if img[j-1][i] != 0
  
               }// end if img[j][i] != 0
            }//end j > 0
         }//end inner for i
      }//end outer for j
	       
    
/******************************************************************/
/*                            BOTTOM UP                           */
/******************************************************************/
      for(j =  FrameH -1; j >= 0; j--){
         for(i =  FrameW -1; i >= 0; i--){
            if(i <  FrameW -1){
               if((temp_img[j*FrameW + i] != 0) && (temp_img[j*FrameW + i + 1] != 0) && (temp_img[j*FrameW + i + 1] < temp_img[j*FrameW + i])){
                  temp_img[j*FrameW + i] = temp_img[j*FrameW + i + 1];
               }//end if temp_img[j*FrameW + i] != 0
            }//end if i == 0
            if(j <  FrameH -1){
               if((temp_img[j*FrameW + i] != 0) && (temp_img[(j+1)*FrameW + i] != 0) && (temp_img[(j+1)*FrameW + i] < (temp_img[j*FrameW + i]))){
                  position = i;
                  smallest = temp_img[(j+1)*FrameW + i];
                  while((position <= FrameW -1) && (temp_img[j*FrameW + position] != 0) && (temp_img[j*FrameW + position] > smallest)){                   
                     temp_img[j*FrameW + position] = smallest;
                     position++;
                  }//end while
               }//end if

            }//end j < 511
         }//end inner for i
      }//end outer for j
    
/******************************************************************/
/*                             TOP DOWN                           */
/******************************************************************/
    
      for(j = 0; j <  FrameH; j++){
         for(i = 0; i <  FrameW; i++){
            if(i > 0){
               if((temp_img[j*FrameW + i] != 0) && (temp_img[j*FrameW + i - 1] != 0) && (temp_img[j*FrameW + i - 1] < temp_img[j*FrameW + i])){
                  temp_img[j*FrameW + i] = temp_img[j*FrameW + i - 1];
               }//end if temp_img[j*FrameW + i] != 0
            }//end if i == 0
            if(j > 0){
               if((temp_img[j*FrameW + i] != 0) && (temp_img[(j-1)*FrameW + i] != 0) && (temp_img[(j-1)*FrameW + i] < (temp_img[j*FrameW + i]))){
                  position = i;
                  smallest = temp_img[(j-1)*FrameW + i];
                  while((position > 0) && (temp_img[j*FrameW + position] != 0) && (temp_img[j*FrameW + position] > smallest)){                   
                     temp_img[j*FrameW + position] = smallest;
                     position--;
                  }//end while
               }//end if

            }//end j < 511
            
            
         }//end inner for i
      }//end outer for j
    
    
/******************************************************************/
/*                            BOTTOM UP                           */
/******************************************************************/
      for(j =  FrameH -1; j >= 0; j--){
         for(i =  FrameW -1; i >= 0; i--){
            if(i <  FrameW -1){
               if((temp_img[j*FrameW + i] != 0) && (temp_img[j*FrameW + i + 1] != 0) && (temp_img[j*FrameW + i + 1] < temp_img[j*FrameW + i])){
                  temp_img[j*FrameW + i] = temp_img[j*FrameW + i + 1];
               }//end if temp_img[j*FrameW + i] != 0
            }//end if i == 0
            if(j <  FrameH -1){
               if((temp_img[j*FrameW + i] != 0) && (temp_img[(j+1)*FrameW + i] != 0) && (temp_img[(j+1)*FrameW + i] < (temp_img[j*FrameW + i]))){
                  position = i;
                  smallest = temp_img[(j+1)*FrameW + i];
                  while((position <= FrameW -1) && (temp_img[j*FrameW + position] != 0) && (temp_img[j*FrameW + position] > smallest)){                   
                     temp_img[j*FrameW + position] = smallest;
                     position++;
                  }//end while
               }//end if

            }//end j < 511
         }//end inner for i
      }//end outer for j    
    
/******************************************************************/
/*                                      Area > AreaThreshold                                       */
/******************************************************************/
      
	  
	  
	  
	  //area.clear();
	  //iter = area.begin();
	  //sort.clear();
	  //itersort = sort.begin();
      count_area_size = 0;
      count_sort_size = 0;
      done_count = false;
      for(k = 0; k < 500; k++){
         area[k][0] = 0;
         area[k][1] = 0;
         sort[k][0] = 0;
         sort[k][1] = 0;
         //area[k][2] = 0;
      }
      
      for(j = 0; j <  FrameH; j++){
         for(i = 0; i <  FrameW; i++){
			//iter = area.begin();
            if(temp_img[j*FrameW + i] != 0){
               //iter = area.find(temp_img[j*FrameW + i]);
               
			   k = 0;
			   while(k < count_area_size){
				if(area[k][0] == temp_img[j*FrameW + i]){
                    area[k][1]++;
                    break;
                 }//end if area
				 k++;
			   }
			   //k++;
               if(k == count_area_size){
                  //cout << "here" << endl;
                  count_area_size++;
                  area[k][0] = temp_img[j*FrameW + i];
                  area[k][1] = 1;
                  //area[(temp_img[j*FrameW + i])] = 1;
				      //area.insert(make_pair(temp_img[j*FrameW + i], 1));
                  
               }//end if k == count_area_size
               
            }//end if temp_img[j*FrameW + i] != 0
         }//end for i
      }//end for j

      //cout << count_area_size << endl;
    
      counter = 1;
      
      for(j = 0; j <  FrameH; j++){
         for(i = 0; i <  FrameW; i++){
            //iter = area.find(temp_img[j*FrameW + i]);
			 k = 0;
			 while(k < count_area_size){
			 //for(k = 0; k < count_area_size; k++){
               if(area[k][0] == temp_img[j*FrameW + i]){
                  if(area[k][1] < AreaThreshold)temp_img[j*FrameW + i] = 0;
                  else{
				     l = 0;
					 while(l < count_sort_size ){
                     //for(l = 0; l < count_sort_size; l++){
                        if(sort[l][0] == temp_img[j*FrameW + i]){
                           temp_img[j*FrameW + i] = sort[l][1];
                           break;
                        }
                        
                        l++;
                     }//end for l
                     if(l == count_sort_size){
                        count_sort_size++;
                        if(temp_img[j*FrameW + i] != 0){
                           sort[l][0] = temp_img[j*FrameW + i];
                           sort[l][1] = counter;
						   temp_img[j*FrameW + i] = counter;
                           counter++;
						   
                        }
                     }
                  }//end else if area[k][1] < AreaThreshold
                  break;
               }// end if area
			   k++;

            }//end for k
			//k++;
            if(k == count_area_size){
               temp_img[j*FrameW + i] = 0;
            }

         }//end for i
      }//end for j
    
		countseg = new float* [counter];
		for(i = 0; i < counter; i++){
			countseg[i] = new float [NumParticleonObject];
		}//end for i
    
/******************************************************************/
/*                        Bounding Box                            */
/******************************************************************/
    
      
      
      done = false;
	  donel = false;
	  left = 0;
	  right = 0;
	  top = 0;
	  down = 0;
    
	  tempnode1 = root->right;
	  
	  while(tempnode1 != end){
		  tempnode2 = tempnode1;
		  tempnode1 = tempnode1->right;
		  delete tempnode2;
		  root->right = tempnode1;
		  tempnode1->left = root;
		  IDcount = 0;
		  
	  }


      for(sk = 1; sk <= count_sort_size; sk++){
	     segnode* nownode = new segnode;
	     nownode->left = end->left;
	     end->left->right = nownode;
	     end->left = nownode;
	     nownode->right = end;
	     nownode->newtracker = true;
		 nownode->ID = IDcount;
		 IDcount++;
	     done = false;
		 donel = false;
	     
	 //    if(debugcout == 1) cout << nownode << " " << end->left << endl;
         for(j = 0; j <  FrameH; j++){
            for(i = 0; i <  FrameW; i++){
               if(temp_img[j*FrameW + i] == sk){
                  if(done == false){
                     top = j;
                     done = true;
	   				nownode->upbound = top; 
					
                  }//end top == 0
	   			  else{ down = j;
	   			
	   			   nownode->downbound = down;
				   
	   		       }
               }//end if temp_img[j*FrameW + i] = k
               
            }//end for i
         }//end for j
		 
	     for(j = 0; j <  FrameW; j++){
            for(i = 0; i <  FrameH; i++){
               
               if(temp_img[i*FrameW + j] == sk){
                  if(donel == false){
                     left = j;
	   			  nownode->leftbound = left;
                     donel = true;
                  }//end left == 0
	   		      else{ 
	   			      right = j;
                     if ((right - left )%2!=0)right--;
	   			      nownode->rightbound = right;
	   		      }
               }//end if temp_img[i][j] = k
	   		
	   		
            }//end for i
         }//end for j
         done = false;
         donel = false;
    
         for(j = 0; j <  FrameH; j++){
            for(i = 0; i <  FrameW; i++){
               if((j == top)||(j == down)){
                  if((i >= left)&&(i <= right)){
                     segbufferY[j*FrameW + i] = 128;
                  }//end left~right
               }//end if j == top
               if((i == left)||(i == right)){
                  if((j >= top)&&(j <= down)){
                     segbufferY[j*FrameW + i] = 128;
                  }//end left~right
               }//end if j == top 
            }//end for i
         }//end for j
    
    
      }//end for k   
      
      for(j = 0; j <  FrameH; j++){
            for(i = 0; i <  FrameW; i++){
	   		 //if(temp_img[j*FrameW + i] == 0)
	   			//fputc(0, fbonding);
	   		 //else
	   			//fputc(255, fbonding);
			fputc(segbufferY[j*FrameW + i], fbonding);
         }//end inner for i
      }//end outer for j

	if(debugcout == 1) cout << IDcount << endl;

	//time2 = clock();
	//timeCCA = time2 - time1;

	double timeWeightUpdate = 0;
	double timeDistance = 0;
	double timeEO = 0;
	double timeUTM = 0;
	double timeDT = 0;

	

/**********************************************************************************************/
		// Sampling + Importance 1(Weight update)
		
/**********************************************************************************************/		
	    nowtracker = trackerroot->right;
		nownode = root;
		if(debugcout == 1) cout << "\tNumber of Tracker:\t"<< numoftracker << endl;
		if(debugfout == 1) fouttest << "\tNumber of Tracker:\t"<< numoftracker << endl;
		nowtracker->confidence = 0;
		if(1){
			
 			//if(debugcout == 1) cout << "NO TRACKER" << endl;
 	  		//fwrite ( framebufferY, 1, FrameH*FrameW, fpout1);			
 	  		//fwrite ( framebufferU, 1, FrameH2*FrameW2, fpout1);			
 	  		//fwrite ( framebufferV, 1, FrameH2*FrameW2, fpout1);

			for(k=0;k<FrameH;++k){
 	  			for(l=0;l<FrameW;++l){
 	  				FrameDisplayY[k*FrameW+l] =  framebufferY[k*FrameW+l];
//					if(l % 10 == 0)FrameDisplayY[k*FrameW+l] =  0;  //DEBUG!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 	  			}
 	  		}
 	  		for(k=0;k<FrameH2;++k){
 	  			for(l=0;l<FrameW2;++l){
 	  				FrameDisplayU[k*FrameW2+l] =  framebufferU[k*FrameW2+l];
 	  				FrameDisplayV[k*FrameW2+l] =  framebufferV[k*FrameW2+l];
 	  			}
 	  		}
		}//end if

		nownode = root->right;
		while(nownode != end){
			//if(debugcout == 1) cout << "Up:\t" << nownode->upbound << "\tDown:\t" << nownode->downbound << "\tLeft:\t" << nownode->leftbound << "\tRight:\t" << nownode->rightbound << endl;
			//if(debugfout == 1) fouttest << "Up:\t" << nownode->upbound << "\tDown:\t" << nownode->downbound << "\tLeft:\t" << nownode->leftbound << "\tRight:\t" << nownode->rightbound << endl;
			fpostseg << (int)(nownode->rightbound + nownode->leftbound)/2 << "\t" <<(int)(nownode->downbound + nownode->upbound)/2 << "\t" << (int)(nownode->rightbound - nownode->leftbound) << "\t" <<(int)(nownode->downbound - nownode->upbound) << "\t\t";
					//if(nownode->newtracker == false){
				
					//	if(debugcout == 1) cout << "IN" << endl;
						//if(debugfout == 1) fouttest << "IN" << endl;
						
						//nownode->countpass++;
//					}//end if
				
			nownode = nownode->right;
		}//end while
		
		while(nowtracker != trackerend){
//			time1 = clock();
			SumofWeight = 0;
			TempSumofWeight = 0; 
			EMDtotal = 0;
			nowtracker->GaussianKernel_temp = 0;
 	  		for(i=0;i<NumParticleonObject;++i){
 	  			//Sampling
 	  			nownode = root;
				vX = (nowtracker->pre_previousX != 0) ? nowtracker->velocityX : 1;
				vY = (nowtracker->pre_previousY != 0) ? nowtracker->velocityY : 1;
				
				//if(debugcout == 1) cout << "Velocity:\t" << vX <<"\t" <<  vY << endl;

				tempPBoxW1 = ((5*grandom())) + 0.5;
				
				while(tempPBoxW1 >=9 || tempPBoxW1 <= -9) tempPBoxW1 = ((5*grandom())) + 0.5;
				tempPBoxH1 = ((5*grandom())) + 0.5;			

                while(tempPBoxH1 >=10 || tempPBoxH1 <= -9) tempPBoxH1 = ((5*grandom())) + 0.5;

				//tempPBoxW2 = max((double)0-20,tempPBoxW1);
				//tempPBoxH2 = max((double)0-20,tempPBoxH1);
				
				tempE = (double)nowtracker->PPostion[i][0] + tempPBoxW1  * max(1,vX);//min(tempPBoxW2, (double)20);//80*(float)rand()/(float)RAND_MAX - 40;
				
				tempF = (double)nowtracker->PPostion[i][1] + tempPBoxH1  * max(1,vY);//min(tempPBoxH2, (double)20);//80*(float)rand()/(float)RAND_MAX - 40;
	
				tempG = (double)nowtracker->PBoxWH[i][0];//   + (((double)nowtracker->PBoxWH[i][0]*grandom()/25));
				
				tempH = (double)nowtracker->PBoxWH[i][1];//  + (((double)nowtracker->PBoxWH[i][1]*grandom()/25));

				tempI = (tempE > 0)?tempE:0;
				tempJ = (tempF > 0)?tempF:0;
				tempK = (tempG > 4)?tempG:4;
				tempL = (tempH > 4)?tempH:4;
 				
				nowtracker->PPostion[i][0]	=	(tempI < FrameW-1)?tempI+0.5:FrameW-1;
 	  			nowtracker->PPostion[i][1]	=	(tempJ < FrameH-1)?tempJ+0.5:FrameH-1;
				nowtracker->PBoxWH[i][0]	=	(tempK < 250)?tempK+0.5:250;
 	  			nowtracker->PBoxWH[i][1]	=	(tempL < 150)?tempL+0.5:150;
 	            maxcountseg[i] = 0;  

				tempM = max(0, nowtracker->PPostion[i][0] - nowtracker->PBoxWH[i][0]);
				tempN = min(FrameW - 1, nowtracker->PPostion[i][0] + nowtracker->PBoxWH[i][0]);

				nowtracker->PPostion[i][0]	=	(tempM + tempN + 1) / 2;
				nowtracker->PBoxWH[i][0]	=	(tempN - tempM + 1) / 2;

				tempM = max(0, nowtracker->PPostion[i][1] - nowtracker->PBoxWH[i][1]);
				tempN = min(FrameH - 1, nowtracker->PPostion[i][1] + nowtracker->PBoxWH[i][1]);

				nowtracker->PPostion[i][1]	=	(tempM + tempN + 1) / 2;
				nowtracker->PBoxWH[i][1]	=	(tempN - tempM + 1) / 2;
 	  			
				for(k = 0; k < counter; k++)
 					countseg[k][i] = 0;

/*******************************/
//    BACKGROUND HISTOGRAM 		
/*******************************/
                TotalHistogramValue = 0;//histogram
 	  			diag = (float)sqrt((float)(nowtracker->PBoxWH[i][0]*nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1]*nowtracker->PBoxWH[i][1]));

				centroid[0] = (max(0,nowtracker->PPostion[i][1]-nowtracker->PBoxWH[i][1]) + min(FrameH-1, nowtracker->PPostion[i][1] + nowtracker->PBoxWH[i][1])) / 2;
				centroid[1] = (max(0, nowtracker->PPostion[i][0]-nowtracker->PBoxWH[i][0]) + min(FrameW-1, nowtracker->PPostion[i][0] + nowtracker->PBoxWH[i][0])) / 2;
            for(k = 0; k < 128; k++){
               BackgroundHistogram_Y_O[k] = 0;
               BackgroundHistogram_U_O[k] = 0;
               BackgroundHistogram_V_O[k] = 0;
               BackgroundHistogram_Y_E[k] = 0;
               BackgroundHistogram_U_E[k] = 0;
               BackgroundHistogram_V_E[k] = 0;
            }//end for k
            for(k = 0; k < 256; k++){
				   flag_Y_w[k] =0;
               flag_U_w[k] =0;
               flag_V_w[k] =0;

            }
 	  			for(k=max(0,nowtracker->PPostion[i][1]-nowtracker->PBoxWH[i][1]); k<= min(FrameH-1, nowtracker->PPostion[i][1] + nowtracker->PBoxWH[i][1]); k++){
 	  				for(l=max(0, nowtracker->PPostion[i][0]-nowtracker->PBoxWH[i][0]); l< min(FrameW-1, nowtracker->PPostion[i][0] + nowtracker->PBoxWH[i][0]); l+=2){
 	  					//if(k<0) k=0;
 	  					//if(k>=FrameH) k=FrameH-1;
 	  					//if(l<0) l=0;
 	  					//if(l>=FrameW) l=FrameW-1;
 	  					//TempBinIdx = (int)(framebufferY[k*FrameW + l]*NumYBin/256) * NumUSubBin * NumVSubBin + (int)(framebufferU[k*FrameW2 + l]*NumUSubBin/256) * NumVSubBin + (int)(framebufferV[k*FrameW2 + l]*NumVSubBin/256) ;
						//TempBinIdx = (int)(framebufferY[k*FrameW + l] * NumUSubBin * NumVSubBin) + (int)(framebufferU[k*FrameW2 + l]) * NumVSubBin + (int)(framebufferV[k*FrameW2 + l]) ;
						
 	  					//TempHistValue = EpanechnikovKenerlConst*(1 - ( sqrt((float)( (k - nowtracker->PPostion[i][1])*(k - nowtracker->PPostion[i][1]) +   (l - nowtracker->PPostion[i][0])*(l - nowtracker->PPostion[i][0])) )/diag ));
						//TempHistValue = 1;
						if(CENTER)
							TempHistValue = diag - ( sqrt((float)( (k - centroid[0])*(k - centroid[0]) +   (l - centroid[1])*(l - centroid[1])))) + 1;
						else
							TempHistValue = 1;

						TotalHistogramValue+=2*TempHistValue;
	 	  				
						BU(bg_Y[k*FrameW + l], bg_Y[k*FrameW + l + 1], bg_U[k/2*FrameW2+ l/2], bg_U[k/2*FrameW2+ (l+1)/2], bg_V[k/2*FrameW2+ l/2] , bg_V[k/2*FrameW2+ (l+1)/2], 
						TempHistValue, TempHistValue, TempHistValue, TempHistValue, TempHistValue, TempHistValue, flag_Y_w, flag_U_w, flag_V_w, BackgroundHistogram_Y_E, BackgroundHistogram_Y_O, BackgroundHistogram_U_E, BackgroundHistogram_U_O, BackgroundHistogram_V_E, BackgroundHistogram_V_O, 1, 1);
							
 	  					
						if(segbufferY[k*FrameW+l] != 0){
							maxcountseg[i]++;
							
							
						}//end if
							

 	  				}
 	  			}
 	  			
 				
 	  			BhaCoef = 0;
				NCi = 0;
				NBCi = 0;
				totalweight = 0;
				
					
 	  				//BhaCoef += sqrt(HistogramCandidate[j]*nowtracker->HistogramTarget[j]); //calculating Bhattacharyya Coefficient
					//if(i >= 35) if(debugcout == 1) cout << "BhaCoef: " << BhaCoef << " HistogramCaondidate " << HistogramCandidate[j] << " HistogramTarget " << nowtracker->HistogramTarget[j] << endl;
					NCi = 1;
					NBCi = 0;

/*******************************/
//  BACKGROUND HISTOGRAM  END		
/*******************************/
 	  
 	  			//Importance 1(Weight update)
 	  			TotalHistogramValueY = 0;//histogram
				TotalHistogramValueU = 0;//histogram
				TotalHistogramValueV = 0;//histogram

 	  			diag = (float)sqrt((float)(nowtracker->PBoxWH[i][0]*nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1]*nowtracker->PBoxWH[i][1]));

				centroid[0] = (max(0,nowtracker->PPostion[i][1]-nowtracker->PBoxWH[i][1]) + min(FrameH-1, nowtracker->PPostion[i][1] + nowtracker->PBoxWH[i][1])) / 2;
				centroid[1] = (max(0, nowtracker->PPostion[i][0]-nowtracker->PBoxWH[i][0]) + min(FrameW-1, nowtracker->PPostion[i][0] + nowtracker->PBoxWH[i][0])) / 2;
            for(k = 0; k < 128; k++){
               HistogramCandidate_Y_O[k] = 0;
               HistogramCandidate_U_O[k] = 0;
               HistogramCandidate_V_O[k] = 0;
               HistogramCandidate_Y_E[k] = 0;
               HistogramCandidate_U_E[k] = 0;
               HistogramCandidate_V_E[k] = 0;
            }//end for k
            for(k = 0; k < 256; k++){
				   flag_Y_w[k] =0;
               flag_U_w[k] =0;
               flag_V_w[k] =0;

            }
 	  			for(k=max(0,nowtracker->PPostion[i][1]-nowtracker->PBoxWH[i][1]); k<= min(FrameH-1, nowtracker->PPostion[i][1] + nowtracker->PBoxWH[i][1]); k++){
 	  				for(l=max(0, nowtracker->PPostion[i][0]-nowtracker->PBoxWH[i][0]); l< min(FrameW-1, nowtracker->PPostion[i][0] + nowtracker->PBoxWH[i][0]); l+=2){
 	  					//if(k<0) k=0;
 	  					//if(k>=FrameH) k=FrameH-1;
 	  					//if(l<0) l=0;
 	  					//if(l>=FrameW) l=FrameW-1;
 	  					//TempBinIdx = (int)(framebufferY[k*FrameW + l]*NumYBin/256) * NumUSubBin * NumVSubBin + (int)(framebufferU[k*FrameW2 + l]*NumUSubBin/256) * NumVSubBin + (int)(framebufferV[k*FrameW2 + l]*NumVSubBin/256) ;
						//TempBinIdx = (int)(framebufferY[k*FrameW + l] * NumUSubBin * NumVSubBin) + (int)(framebufferU[k*FrameW2 + l]) * NumVSubBin + (int)(framebufferV[k*FrameW2 + l]) ;
						
 	  					//TempHistValue = EpanechnikovKenerlConst*(1 - ( sqrt((float)( (k - nowtracker->PPostion[i][1])*(k - nowtracker->PPostion[i][1]) +   (l - nowtracker->PPostion[i][0])*(l - nowtracker->PPostion[i][0])) )/diag ));
						//TempHistValue = 1;
						if(CENTER){
							TempHistValuey1 = diag - ( sqrt((float)( (k - centroid[0])*(k - centroid[0]) +   (l - centroid[1])*(l - centroid[1])))) + 1;
						    TempHistValuey2 = diag - ( sqrt((float)( (k - centroid[0])*(k - centroid[0]) +   (l+1 - centroid[1])*(l+1 - centroid[1])))) + 1;
							TempHistValueu1 = diag - ( sqrt((float)( (k - centroid[0])*(k - centroid[0]) +   (l - centroid[1])*(l - centroid[1])))) + 1;
						    TempHistValueu2 = diag - ( sqrt((float)( (k - centroid[0])*(k - centroid[0]) +   (l+1 - centroid[1])*(l+1 - centroid[1])))) + 1;
							TempHistValuev1 = diag - ( sqrt((float)( (k - centroid[0])*(k - centroid[0]) +   (l - centroid[1])*(l - centroid[1])))) + 1;
						    TempHistValuev2 = diag - ( sqrt((float)( (k - centroid[0])*(k - centroid[0]) +   (l+1 - centroid[1])*(l+1 - centroid[1])))) + 1;
						}
						else{
							TempHistValuey1 = 1;
						    TempHistValuey2 = 1;
							TempHistValueu1 = 1;
						    TempHistValueu2 = 1;
							TempHistValuev1 = 1;
						    TempHistValuev2 = 1;
						}
						if(Bguse == 1){
							if(bg_Y[k*FrameW + l]%2 == 0){
								TempHistValuey1 = (BackgroundHistogram_Y_E[bg_Y[k*FrameW + l]] > 10) ? 0 : TempHistValuey1;
							}
							else{
								TempHistValuey1 = (BackgroundHistogram_Y_O[bg_Y[k*FrameW + l]] > 10) ? 0 : TempHistValuey1;
							}
							if(bg_Y[k*FrameW + l + 1]%2 == 0){
								TempHistValuey2 = (BackgroundHistogram_Y_E[bg_Y[k*FrameW + l + 1]] > 10) ? 0 : TempHistValuey2;
							}
							else{
								TempHistValuey2 = (BackgroundHistogram_Y_O[bg_Y[k*FrameW + l + 1]] > 10) ? 0 : TempHistValuey2;
							}
							if(bg_U[k/2*FrameW2+ l/2]%2 == 0){
								TempHistValueu1 = (BackgroundHistogram_U_E[bg_U[k/2*FrameW2+ l/2]] > 10) ? 0 : TempHistValueu1;
							}
							else{
								TempHistValueu1 = (BackgroundHistogram_U_O[bg_U[k/2*FrameW2+ l/2]] > 10) ? 0 : TempHistValueu1;
							}
							if(bg_U[k/2*FrameW2+ (l+1)/2]%2 == 0){
								TempHistValueu2 = (BackgroundHistogram_U_E[bg_U[k/2*FrameW2+ (l+1)/2]] > 10) ? 0 : TempHistValueu2;
							}
							else{
								TempHistValueu2 = (BackgroundHistogram_U_O[bg_U[k/2*FrameW2+ (l+1)/2]] > 10) ? 0 : TempHistValueu2;
							}
							if(bg_V[k/2*FrameW2+ l/2]%2 == 0){
								TempHistValuev1 = (BackgroundHistogram_V_E[bg_V[k/2*FrameW2+ l/2]] > 10) ? 0 : TempHistValuev1;
							}
							else{
								TempHistValuev1 = (BackgroundHistogram_V_O[bg_V[k/2*FrameW2+ l/2]] > 10) ? 0 : TempHistValuev1;
							}
							if(bg_V[k/2*FrameW2+ (l+1)/2]%2 == 0){
								TempHistValuev2 = (BackgroundHistogram_V_E[bg_V[k/2*FrameW2+ (l+1)/2]] > 10) ? 0 : TempHistValuev2;
							}
							else{
								TempHistValuev2 = (BackgroundHistogram_V_O[bg_V[k/2*FrameW2+ (l+1)/2]] > 10) ? 0 : TempHistValuev2;
							}
						}
						else{
							TempHistValuey1 = 1;
							TempHistValuey2 = 1;
							TempHistValuey1 = 1;
							TempHistValueu2 = 1;
							TempHistValuev1 = 1;
							TempHistValuev2 = 1;
							
						}

						TotalHistogramValueY+=TempHistValuey1 + TempHistValuey2;
						TotalHistogramValueU+=TempHistValueu1 + TempHistValueu2;
						TotalHistogramValueV+=TempHistValuev1 + TempHistValuev2;
	 	  				
						BU(framebufferY[k*FrameW + l], framebufferY[k*FrameW + l + 1], framebufferU[k/2*FrameW2+ l/2], framebufferU[k/2*FrameW2+ (l+1)/2], framebufferV[k/2*FrameW2+ l/2] , framebufferV[k/2*FrameW2+ (l+1)/2], 
						TempHistValuey1, TempHistValuey2, TempHistValueu1, TempHistValueu2, TempHistValuev1, TempHistValuev2, flag_Y_w, flag_U_w, flag_V_w, HistogramCandidate_Y_E, HistogramCandidate_Y_O, HistogramCandidate_U_E, HistogramCandidate_U_O, HistogramCandidate_V_E, HistogramCandidate_V_O, 1, 1);
							
 	  					
						if(segbufferY[k*FrameW+l] != 0){
							maxcountseg[i]++;
							
							
						}//end if
							

 	  				}
 	  			}
 	  			
 				
 	  			BhaCoef = 0;
				NCi = 0;
				NBCi = 0;
				totalweight = 0;
				
					
 	  				//BhaCoef += sqrt(HistogramCandidate[j]*nowtracker->HistogramTarget[j]); //calculating Bhattacharyya Coefficient
					//if(i >= 35) if(debugcout == 1) cout << "BhaCoef: " << BhaCoef << " HistogramCaondidate " << HistogramCandidate[j] << " HistogramTarget " << nowtracker->HistogramTarget[j] << endl;
					NCi = 1;
					NBCi = 0;
	
				
				//time2 = clock();
				//timeWeightUpdate += time2-time1;
           
//				time1 = clock();
//            fouttest3 << "frame: " << f << endl;
				if(TotalHistogramValueY == 1 || TotalHistogramValueU == 1 || TotalHistogramValueV == 1)
					Distance = 99999999999999999;
				else{
				DistanceY = 0;
				DistanceU = 0;
				DistanceV = 0;
               
               if(Choose == 1){
					distance_compute(HistogramCandidate_Y_E, HistogramCandidate_Y_O, nowtracker->HistogramTarget_Y_E, nowtracker->HistogramTarget_Y_O, DistanceY, 4, TotalHistogramValueY, nowtracker->totalhistogram );
						//cout << DistanceY << endl;
						//if(f == 653)system("pause")	;
					distance_compute(HistogramCandidate_U_E, HistogramCandidate_U_O, nowtracker->HistogramTarget_U_E, nowtracker->HistogramTarget_U_O, DistanceU, 4, TotalHistogramValueU, nowtracker->totalhistogram );
						//system("pause")	;
						//system("pause")	;
					distance_compute(HistogramCandidate_V_E, HistogramCandidate_V_O, nowtracker->HistogramTarget_V_E, nowtracker->HistogramTarget_V_O, DistanceV, 4, TotalHistogramValueV, nowtracker->totalhistogram );
					Distance = (DistanceY*DistanceY / TotalHistogramValueY/ TotalHistogramValueY + DistanceU*DistanceU/ TotalHistogramValueU/ TotalHistogramValueU + DistanceV*DistanceV/ TotalHistogramValueV/ TotalHistogramValueV)  / nowtracker->totalhistogram / nowtracker->totalhistogram*10000;// * 10000 * 1024 * 21.5;
					if(TotalHistogramValueU <= 10 || TotalHistogramValueV <= 10 || TotalHistogramValueY <= 10 || nowtracker->totalhistogram <= 10) Distance = 99999999999999999;
					//if(debugfout == 1) fouttest << DistanceY << "\t" << DistanceU << "\t" << DistanceV << endl;
				}
				else if(Choose ==2){
					s1.Features = f1;
					s2.Features = f2;
					s1.n = 256;
					s2.n = 256;
					for(k = 0; k < 256; k++){
						if(k%2 == 0){
							
							weight1[k] = (float)HistogramCandidate_Y_E[k/2]/(float)TotalHistogramValueY;
							weight2[k] = (float)nowtracker->HistogramTarget_Y_E[k/2]/(float)nowtracker->totalhistogram;
							
						}
						else{
							
							weight1[k] = (float)HistogramCandidate_Y_O[(k-1)/2]/(float)TotalHistogramValueY;
							weight2[k] = (float)nowtracker->HistogramTarget_Y_O[(k-1)/2]/(float)nowtracker->totalhistogram;
						}
						

					}
					s1.Weights = weight1;
					s2.Weights = weight2;
					DistanceY = BDdist(&s1, &s2);
					for(k = 0; k < 256; k++){
						if(k%2 == 0){
							weight1[k] = (float)HistogramCandidate_U_E[k/2]/(float)TotalHistogramValueU;
							weight2[k] = (float)nowtracker->HistogramTarget_U_E[k/2]/(float)nowtracker->totalhistogram;
						}
						else{
							weight1[k] = (float)HistogramCandidate_U_O[(k-1)/2]/(float)TotalHistogramValueU;
							weight2[k] = (float)nowtracker->HistogramTarget_U_O[(k-1)/2]/(float)nowtracker->totalhistogram;
						}

					}
					s1.Weights = weight1;
					s2.Weights = weight2;
					DistanceU = BDdist(&s1, &s2);
					for(k = 0; k < 256; k++){
						if(k%2 == 0){
							weight1[k] = (float)HistogramCandidate_V_E[k/2]/(float)TotalHistogramValueV;
							weight2[k] = (float)nowtracker->HistogramTarget_V_E[k/2]/(float)nowtracker->totalhistogram;
						}
						else{
							weight1[k] = (float)HistogramCandidate_V_O[(k-1)/2]/(float)TotalHistogramValueV;
							weight2[k] = (float)nowtracker->HistogramTarget_V_O[(k-1)/2]/(float)nowtracker->totalhistogram;
						}

					}
					s1.Weights = weight1;
					s2.Weights = weight2;
					DistanceV = BDdist(&s1, &s2);
					Distance = (DistanceY*DistanceY  + DistanceU*DistanceU + DistanceV*DistanceV)*10000;// * 10000 * 1024 * 21.5;
				
				
				}
				else if(Choose ==0){
					s1.Features = f1;
					s2.Features = f2;
					s1.n = 256;
					s2.n = 256;
					for(k = 0; k < 256; k++){
						if(k%2 == 0){
							weight1[k] = (float)HistogramCandidate_Y_E[k/2]/(float)TotalHistogramValueY;
							weight2[k] = (float)nowtracker->HistogramTarget_Y_E[k/2]/(float)nowtracker->totalhistogram;
						}
						else{
							weight1[k] = (float)HistogramCandidate_Y_O[(k-1)/2]/(float)TotalHistogramValueY;
							weight2[k] = (float)nowtracker->HistogramTarget_Y_O[(k-1)/2]/(float)nowtracker->totalhistogram;
						}

					}
					s1.Weights = weight1;
					s2.Weights = weight2;
					DistanceY = emd(&s1, &s2, dist, 0, 0);
					for(k = 0; k < 256; k++){
						if(k%2 == 0){
							weight1[k] = (float)HistogramCandidate_U_E[k/2]/(float)TotalHistogramValueU;
							weight2[k] = (float)nowtracker->HistogramTarget_U_E[k/2]/(float)nowtracker->totalhistogram;
						}
						else{
							weight1[k] = (float)HistogramCandidate_U_O[(k-1)/2]/(float)TotalHistogramValueU;
							weight2[k] = (float)nowtracker->HistogramTarget_U_O[(k-1)/2]/(float)nowtracker->totalhistogram;
						}

					}
					s1.Weights = weight1;
					s2.Weights = weight2;
					DistanceU = emd(&s1, &s2, dist, 0, 0);
					for(k = 0; k < 256; k++){
						if(k%2 == 0){
							weight1[k] = (float)HistogramCandidate_V_E[k/2]/(float)TotalHistogramValueV;
							weight2[k] = (float)nowtracker->HistogramTarget_V_E[k/2]/(float)nowtracker->totalhistogram;
						}
						else{
							weight1[k] = (float)HistogramCandidate_V_O[(k-1)/2]/(float)TotalHistogramValueV;
							weight2[k] = (float)nowtracker->HistogramTarget_V_O[(k-1)/2]/(float)nowtracker->totalhistogram;
						}

					}
					s1.Weights = weight1;
					s2.Weights = weight2;
					DistanceV = emd(&s1, &s2, dist, 0, 0);
					Distance = (DistanceY*DistanceY  + DistanceU*DistanceU + DistanceV*DistanceV);// * 10000 * 1024 * 21.5;
				
				
				}
               
               
               //Distance = (DistanceY*DistanceY / TotalHistogramValueY/ TotalHistogramValueY + DistanceU*DistanceU/ TotalHistogramValueU/ TotalHistogramValueU + DistanceV*DistanceV/ TotalHistogramValueV/ TotalHistogramValueV)  / nowtracker->totalhistogram / nowtracker->totalhistogram*10000;// * 10000 * 1024 * 21.5;
				}
				//time2 = clock();
				//timeDistance += time2-time1;
				//nowtracker->PWeight[i] = Distance;
				//EMDtotal+=Distance;
				//nowtracker->PWeight[i] = emd(&s1, &s2, dist, 0, 0);//exp(-(Distance/(2*VarWU)))/(2.50663*StdWU);//weight update
				nowtracker->GaussianKernel_temp += Distance;
				//if(nowtracker->GaussianKernel <= 0) {nowtracker->GaussianKernel = 20000;}
				if(Distance == 0) nowtracker->PWeight[i] = 0.0000001;
				else if(Distance < 0) {
					if(debugcout == 1) cout << "Frame: " << f << endl;
					system("pause");}
			
				else if(Choose == 1 || Choose == 0) nowtracker->PWeight[i] = exp(0-Distance/nowtracker->GaussianKernel*1);//*pow((1-(double)abs((double)nowtracker->PBoxWH[i][0] - (double)nowtracker->ObjectBoxW)/(double)max(nowtracker->PBoxWH[i][0], nowtracker->ObjectBoxW)) ;//* (1-(double)abs((double)nowtracker->PBoxWH[i][1] - (double)nowtracker->ObjectBoxH)/(double)max(nowtracker->PBoxWH[i][1], nowtracker->ObjectBoxH)), 1) * pow((double)(nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][0]),5);// * nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][0];
				else if(Choose == 2) nowtracker->PWeight[i] = exp(0-Distance/nowtracker->GaussianKernel*2);
				//else if(Choose == 0) nowtracker->PWeight[i] = exp(0-Distance/nowtracker->GaussianKernel*pow((1-(double)abs((double)nowtracker->PBoxWH[i][0] - (double)nowtracker->ObjectBoxW)/(double)max(nowtracker->PBoxWH[i][0], nowtracker->ObjectBoxW)) * (1-(double)abs((double)nowtracker->PBoxWH[i][1] - (double)nowtracker->ObjectBoxH)/(double)max(nowtracker->PBoxWH[i][1], nowtracker->ObjectBoxH)), 0.25));
				else nowtracker->PWeight[i] = 1/Distance*pow((1-(double)abs((double)nowtracker->PBoxWH[i][0] - (double)nowtracker->ObjectBoxW)/(double)nowtracker->ObjectBoxW) * (1-(double)abs((double)nowtracker->PBoxWH[i][1] - (double)nowtracker->ObjectBoxH)/(double)nowtracker->ObjectBoxH), 4);
				if(nowtracker->PWeight[i] < 0) nowtracker->PWeight[i] = 0;
				//if(debugcout == 1) cout << pow((1-(double)abs((double)nowtracker->PBoxWH[i][0] - (double)nowtracker->ObjectBoxW)/(double)nowtracker->ObjectBoxW) * (1-(double)abs((double)nowtracker->PBoxWH[i][1] - (double)nowtracker->ObjectBoxH)/(double)nowtracker->ObjectBoxH), 4) << endl;
					//exp(-(Distance/(2*VarWU)))/(2.50663*StdWU);
				//system("pause")	;
				SumofWeight += nowtracker->PWeight[i];
				//if(nowtracker->PWeight[i] < 0)nowtracker->PWeight[i] = 0;

				if(debugfout == 1) fouttest << "\t\t\tX: "<<nowtracker->PPostion[i][0] << " Y: " << nowtracker->PPostion[i][1] << " Width: " << nowtracker->PBoxWH[i][0]*2 << " Height: " << nowtracker->PBoxWH[i][1]*2 <<endl;
				if(debugfout == 1) fouttest << "\t\t\t\tWeight: " << nowtracker->PWeight[i] << endl;
				if(debugfout == 1) fouttest << "\t\t\t\tEMD: " << Distance << endl;

				
 	  			//SumofWeight += nowtracker->PWeight[i];
				
	
				
					
			}
			nowtracker->GaussianKernel = nowtracker->GaussianKernel_temp/NumParticleonObject/5;

			
			TempSumofWeight = 0;
			//if(SumofWeight == 0) SumofWeight = 1;
 	  		for(i=0;i<NumParticleonObject;i++){
 	  			nowtracker->PWeight[i] = nowtracker->PWeight[i]/SumofWeight + apha*maxcountseg[i]/nowtracker->PBoxWH[i][0] / nowtracker->PBoxWH[i][1]/4;
				//nowtracker->confidence += maxcountseg[i]/nowtracker->PBoxWH[i][0] / nowtracker->PBoxWH[i][1]/NumHistBin/4;
				
				TempSumofWeight = nowtracker->PWeight[i] + TempSumofWeight;
				
 	  		}
			if(debugcout == 1) cout << "\t\tSum of Weight:\t" << TempSumofWeight << "\tBefore:\t" << SumofWeight<< endl;
			if(debugfout == 1) fouttest << "\t\tSum of Weight:\t" << TempSumofWeight << "\tBefore:\t" << SumofWeight<< endl;
			if(debugcout == 1) cout << "Total Distance:\t" << nowtracker->GaussianKernel_temp / nowtracker->ObjectBoxW / nowtracker->ObjectBoxH << endl;
			if(nowtracker->ObjectBoxW != 0 && nowtracker->ObjectBoxH != 0){
				if(Choose == 0){
					if(debugcout == 1) cout <<"\tThreshold:\t" << (float)WeightThresholdEMD/nowtracker->ObjectBoxW/nowtracker->ObjectBoxH/4 << "\t" << (float)WeightThresholdEMD << endl;
					if (SumofWeight <= WeightThresholdEMD/nowtracker->ObjectBoxW/nowtracker->ObjectBoxH/4) {
						if(debugcout == 1) cout << "Delete Tracker Because of the Color!!!" << endl;
						if(debugfout == 1) fouttest << "Delete Tracker Because of the Color!!!" << endl;

						nowtracker->deleteTracker = true;
					}
				}
				else if(Choose == 1){
					if(debugcout == 1) cout <<"\tThreshold:\t" << (float)WeightThresholdDD << endl;
					//if (nowtracker->GaussianKernel_temp / nowtracker->ObjectBoxW / nowtracker->ObjectBoxH > WeightThresholdDD) {
						//if(debugcout == 1) cout << "Delete Tracker Because of the Color!!!" << endl;
						//if(debugfout == 1) fouttest << "Delete Tracker Because of the Color!!!" << endl;

						//nowtracker->deleteTracker = true;
					//}
				}
				else{
					if(debugcout == 1) cout <<"\tThreshold:\t" << (float)WeightThresholdBD/nowtracker->ObjectBoxW/nowtracker->ObjectBoxH/4 << "\t" << (float)WeightThresholdBD << endl;
					if (SumofWeight <= WeightThresholdBD/nowtracker->ObjectBoxW/nowtracker->ObjectBoxH/4) {
						if(debugcout == 1) cout << "Delete Tracker Because of the Color!!!" << endl;
						if(debugfout == 1) fouttest << "Delete Tracker Because of the Color!!!" << endl;

						nowtracker->deleteTracker = true;
					}
				}
			}
 	  		
			//nowtracker->confidence = nowtracker->confidence/NumParticleonObject;

			for(i=0;i<NumParticleonObject;++i){
 	  			nowtracker->PWeight[i] = nowtracker->PWeight[i]/TempSumofWeight;
				
				
 	  		}

			
 	  		//Estimation of object current state
			nowtracker->pre_previousX = nowtracker->previousX;
			nowtracker->pre_previousY = nowtracker->previousY;
			nowtracker->previousX = nowtracker->ObjectPX;
			nowtracker->previousY = nowtracker->ObjectPY;
			//if(debugcout == 1) cout << "Pre:\t" << nowtracker->previousX << "\t" << nowtracker->previousY << endl;


// 	  		clock1 = clock();
//			time1 = clock();
 	  		nowtracker->ObjectPX_f	=	0;
 	  		nowtracker->ObjectPY_f	=	0;
 	  		nowtracker->ObjectBoxW_f	=	0;
 	  		nowtracker->ObjectBoxH_f	=	0;
			
			for(j = 0; j < ChooseNumofParticle; j++){
				maxweight[j] = 0;
				maxx[j] = 0;
				maxy[j] = 0;
				//maxh[j] = 0;
				//maxw[j] = 0;
			}
			//maxx = 0;
			//maxy = 0;
			//maxw = 0;
			//maxh = 0;
	 	  
 	  		for(i=0;i<NumParticleonObject;++i){
 	  			//nowtracker->ObjectPX_f	+=	nowtracker->PWeight[i]*nowtracker->PPostion[i][0];
 	  			//nowtracker->ObjectPY_f	+=	nowtracker->PWeight[i]*nowtracker->PPostion[i][1];
 	  			nowtracker->ObjectBoxW_f	+=	nowtracker->PWeight[i]*nowtracker->PBoxWH[i][0];
	 	  		nowtracker->ObjectBoxH_f	+=	nowtracker->PWeight[i]*nowtracker->PBoxWH[i][1];
				for(j = ChooseNumofParticle-1; j >= 0; j--){
					
					if(nowtracker->PWeight[i] >=maxweight[j] ){
						for(k = j-1; k >=0; k--){
							maxweight[k] = maxweight[k+1];
							maxx[k] = maxx[k+1];
							maxy[k] = maxy[k+1];
						}//end for k
						maxweight[j] = nowtracker->PWeight[i];
						maxx[j] = nowtracker->PPostion[i][0];
						maxy[j] = nowtracker->PPostion[i][1];
						break;

					}
					
					
				
				}

 	  		}

			for(j = NoTopOnes; j < ChooseNumofParticle; j++){
				nowtracker->ObjectPX_f +=maxx[j];
				nowtracker->ObjectPY_f +=maxy[j];
			}
			nowtracker->ObjectPX_f	/=	(ChooseNumofParticle - NoTopOnes);
 	  		nowtracker->ObjectPY_f	/=	(ChooseNumofParticle - NoTopOnes);
 	  		//nowtracker->ObjectBoxW_f	=	maxw;
	 	  	//nowtracker->ObjectBoxH_f	=	maxh;

			tempA = (nowtracker->ObjectPY_f - nowtracker->ObjectBoxH_f);
			tempB = (nowtracker->ObjectPY_f + nowtracker->ObjectBoxH_f);
 	  		k = max(0,tempA);
			l = min(FrameH - 1,tempB);
			
			
 	  		nowtracker->ObjectPY = (k + l + 1) / 2;
 	  		nowtracker->ObjectBoxH = (l - k) / 2;

			k = max(0,tempA-nowtracker->ObjectBoxH/3);
			l = min(FrameH - 1,tempB+nowtracker->ObjectBoxH/3);
			
			//nowtracker->ObjectPY_B = (k + l) / 2;
 	  		nowtracker->ObjectBoxH_B = (l - k) / 2;
			
			

			tempA = (nowtracker->ObjectPX_f - nowtracker->ObjectBoxW_f);
			tempB = (nowtracker->ObjectPX_f + nowtracker->ObjectBoxW_f);
			
			k = max(0,tempA);
			
			l = min(FrameW - 1,tempB);

			nowtracker->ObjectPX = (k + l+1) / 2;
			nowtracker->ObjectBoxW = (l - k) / 2;

			k = max(0,tempA-nowtracker->ObjectBoxW/3);
			
			l = min(FrameW - 1,tempB+nowtracker->ObjectBoxW/3);

			//nowtracker->ObjectPX_B = (k + l) / 2;
			nowtracker->ObjectBoxW_B = (l - k) / 2;


			/*********************/
			for(i=0;i<NumParticleonObject;++i){
 	  			//Sampling
 	  			

				//tempPBoxW2 = max((double)0-20,tempPBoxW1);
				//tempPBoxH2 = max((double)0-20,tempPBoxH1);
				
				//tempE = (double)nowtracker->PPostion[i][0];// + tempPBoxW1  * max(1,vX);//min(tempPBoxW2, (double)20);//80*(float)rand()/(float)RAND_MAX - 40;
				
				//tempF = (double)nowtracker->PPostion[i][1];// + tempPBoxH1  * max(1,vY);//min(tempPBoxH2, (double)20);//80*(float)rand()/(float)RAND_MAX - 40;
	
				tempG = (double)nowtracker->PBoxWH[i][0]   * ((double)1 + (double)(rand()%9 - 4)/35) ;//(((double)nowtracker->PBoxWH[i][0]*grandom()));
				
				tempH = (double)nowtracker->PBoxWH[i][1] * ((double)1 + (double)(rand()%9 - 4)/35 );//(((double)nowtracker->PBoxWH[i][1]*grandom()));
				//if(debugcout == 1) cout << ((double)1 + (double)(rand()%7 - 3)/35 + 0.0235) << endl;
				if(nowtracker->ratio > 1){
					if(tempG < 10) tempG = 10;
					if(tempH < 10*nowtracker->ratio) tempH = 10*nowtracker->ratio;
				}
				else if(nowtracker->ratio >= 0.25){
					if(tempG < 10/nowtracker->ratio) tempG = 10/nowtracker->ratio;
					if(tempH < 10) tempH = 10;
				}

				while(tempG > 3 * tempH){
				   //tempG = (double)nowtracker->PBoxWH[i][0]   + rand()%3 - 1 ;//(((double)nowtracker->PBoxWH[i][0]*grandom()));
				
				   //tempH = (double)nowtracker->PBoxWH[i][1]  + (double)(rand()%6 - 2)/2 + 1;//(((double)nowtracker->PBoxWH[i][1]*grandom()));
				   tempG--;
				}
				while(tempH > 3 * tempG){
				   //tempG = (double)nowtracker->PBoxWH[i][0]   + rand()%3 - 1 ;//(((double)nowtracker->PBoxWH[i][0]*grandom()));
				
				   //tempH = (double)nowtracker->PBoxWH[i][1]  + (double)(rand()%6 - 2)/2 + 1;//(((double)nowtracker->PBoxWH[i][1]*grandom()));
				   tempH--;
				}
				if(nowtracker->ratio > 1){
					if(tempG < 10) tempG = 10;
					if(tempH < 10*nowtracker->ratio) tempH = 10*nowtracker->ratio;
				}
				else if(nowtracker->ratio >= 0.25){
					if(tempG < 10/nowtracker->ratio) tempG = 10/nowtracker->ratio;
					if(tempH < 10) tempH = 10;
				}

				//if(debugcout == 1) cout << nowtracker->ratio << endl;


				//tempI = (tempE > 0)?tempE:0;
				//tempJ = (tempF > 0)?tempF:0;
				tempK = (tempG > 4)?tempG:4;
				tempL = (tempH > 4)?tempH:4;
 				
				nowtracker->PPostion[i][0]	=	nowtracker->ObjectPX;
 	  			nowtracker->PPostion[i][1]	=	nowtracker->ObjectPY;
				nowtracker->PBoxWH[i][0]	=	(tempK < 250)?tempK+0.5:250;
 	  			nowtracker->PBoxWH[i][1]	=	(tempL < 150)?tempL+0.5:150;
 	            maxcountseg[i] = 0;  

				tempM = max(0, nowtracker->PPostion[i][0] - nowtracker->PBoxWH[i][0]);
				tempN = min(FrameW - 1, nowtracker->PPostion[i][0] + nowtracker->PBoxWH[i][0]);

				nowtracker->PPostion[i][0]	=	(tempM + tempN + 1) / 2;
				nowtracker->PBoxWH[i][0]	=	(tempN - tempM + 1) / 2;

				tempM = max(0, nowtracker->PPostion[i][1] - nowtracker->PBoxWH[i][1]);
				tempN = min(FrameH - 1, nowtracker->PPostion[i][1] + nowtracker->PBoxWH[i][1]);

				nowtracker->PPostion[i][1]	=	(tempM + tempN + 1) / 2;
				nowtracker->PBoxWH[i][1]	=	(tempN - tempM + 1) / 2;
 	  			
				for(k = 0; k < counter; k++)
 					countseg[k][i] = 0;

				
 	  
 	  			//Importance 1(Weight update)

/*******************************/
//    BACKGROUND HISTOGRAM 		
/*******************************/
                TotalHistogramValue = 0;//histogram
 	  			diag = (float)sqrt((float)(nowtracker->PBoxWH[i][0]*nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1]*nowtracker->PBoxWH[i][1]));
/* 	  			for(j=0;j<NumHistBin;++j){
 	  				HistogramCandidate[j] = 0;
				}*/
				centroid[0] = (max(0,nowtracker->PPostion[i][1]-nowtracker->PBoxWH[i][1]) + min(FrameH-1, nowtracker->PPostion[i][1] + nowtracker->PBoxWH[i][1])) / 2;
				centroid[1] = (max(0, nowtracker->PPostion[i][0]-nowtracker->PBoxWH[i][0]) + min(FrameW-1, nowtracker->PPostion[i][0] + nowtracker->PBoxWH[i][0])) / 2;
            for(k = 0; k < 128; k++){
               BackgroundHistogram_Y_O[k] = 0;
               BackgroundHistogram_U_O[k] = 0;
               BackgroundHistogram_V_O[k] = 0;
               BackgroundHistogram_Y_E[k] = 0;
               BackgroundHistogram_U_E[k] = 0;
               BackgroundHistogram_V_E[k] = 0;
            }//end for k
            for(k = 0; k < 256; k++){
				   flag_Y_w[k] =0;
               flag_U_w[k] =0;
               flag_V_w[k] =0;

            }
 	  			for(k=max(0,nowtracker->PPostion[i][1]-nowtracker->PBoxWH[i][1]); k<= min(FrameH-1, nowtracker->PPostion[i][1] + nowtracker->PBoxWH[i][1]); ++k){
 	  				for(l=max(0, nowtracker->PPostion[i][0]-nowtracker->PBoxWH[i][0]); l< min(FrameW-1, nowtracker->PPostion[i][0] + nowtracker->PBoxWH[i][0]); l+=2){
 	  						//if(k<0) k=0;
 	  					//if(k>=FrameH) k=FrameH-1;
 	  					//if(l<0) l=0;
 	  					//if(l>=FrameW) l=FrameW-1;
 	  					//TempBinIdx = (int)(framebufferY[k*FrameW + l]*NumYBin/256) * NumUSubBin * NumVSubBin + (int)(framebufferU[k*FrameW2 + l]*NumUSubBin/256) * NumVSubBin + (int)(framebufferV[k*FrameW2 + l]*NumVSubBin/256) ;
						//TempBinIdx = (int)(framebufferY[k*FrameW + l] * NumUSubBin * NumVSubBin) + (int)(framebufferU[k*FrameW2 + l]) * NumVSubBin + (int)(framebufferV[k*FrameW2 + l]) ;
						
 	  					//TempHistValue = EpanechnikovKenerlConst*(1 - ( sqrt((float)( (k - nowtracker->PPostion[i][1])*(k - nowtracker->PPostion[i][1]) +   (l - nowtracker->PPostion[i][0])*(l - nowtracker->PPostion[i][0])) )/diag ));
						//TempHistValue = 1;
						if(CENTER)
							TempHistValue = diag - ( sqrt((float)( (k - centroid[0])*(k - centroid[0]) +   (l - centroid[1])*(l - centroid[1])))) + 1;
						else
							TempHistValue = 1;

						TotalHistogramValue+=2*TempHistValue;
	 	  				
						BU(bg_Y[k*FrameW + l], bg_Y[k*FrameW + l + 1], bg_U[k/2*FrameW2+ l/2], bg_U[k/2*FrameW2+ (l+1)/2], bg_V[k/2*FrameW2+ l/2] , bg_V[k/2*FrameW2+ (l+1)/2], 
						TempHistValue, TempHistValue, TempHistValue, TempHistValue, TempHistValue, TempHistValue, flag_Y_w, flag_U_w, flag_V_w, BackgroundHistogram_Y_E, BackgroundHistogram_Y_O, BackgroundHistogram_U_E, BackgroundHistogram_U_O, BackgroundHistogram_V_E, BackgroundHistogram_V_O, 1, 1);
							
 	  					
						if(segbufferY[k*FrameW+l] != 0){
							maxcountseg[i]++;
							
							
						}//end if
							

 	  				}
 	  			}
 	  			
 				
 	  			BhaCoef = 0;
				NCi = 0;
				NBCi = 0;
				totalweight = 0;
				
					
 	  				//BhaCoef += sqrt(HistogramCandidate[j]*nowtracker->HistogramTarget[j]); //calculating Bhattacharyya Coefficient
					//if(i >= 35) if(debugcout == 1) cout << "BhaCoef: " << BhaCoef << " HistogramCaondidate " << HistogramCandidate[j] << " HistogramTarget " << nowtracker->HistogramTarget[j] << endl;
					NCi = 1;
					NBCi = 0;

/*******************************/
//  BACKGROUND HISTOGRAM  END		
/*******************************/

 	  			TotalHistogramValueY = 0;//histogram
				TotalHistogramValueU = 0;//histogram
				TotalHistogramValueV = 0;//histogram
 	  			diag = (float)sqrt((float)(nowtracker->PBoxWH[i][0]*nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1]*nowtracker->PBoxWH[i][1]));
/* 	  			for(j=0;j<NumHistBin;++j){
 	  				HistogramCandidate[j] = 0;
				}*/
				centroid[0] = (max(0,nowtracker->PPostion[i][1]-nowtracker->PBoxWH[i][1]) + min(FrameH-1, nowtracker->PPostion[i][1] + nowtracker->PBoxWH[i][1])) / 2;
				centroid[1] = (max(0, nowtracker->PPostion[i][0]-nowtracker->PBoxWH[i][0]) + min(FrameW-1, nowtracker->PPostion[i][0] + nowtracker->PBoxWH[i][0])) / 2;




				 for(k = 0; k < 128; k++){
               HistogramCandidate_Y_O[k] = 0;
               HistogramCandidate_U_O[k] = 0;
               HistogramCandidate_V_O[k] = 0;
               HistogramCandidate_Y_E[k] = 0;
               HistogramCandidate_U_E[k] = 0;
               HistogramCandidate_V_E[k] = 0;
            }//end for k
            for(k = 0; k < 256; k++){
				   flag_Y_w[k] =0;
               flag_U_w[k] =0;
               flag_V_w[k] =0;

            }
 	  			for(k=max(0,nowtracker->PPostion[i][1]-nowtracker->PBoxWH[i][1]); k<= min(FrameH-1, nowtracker->PPostion[i][1] + nowtracker->PBoxWH[i][1]); ++k){
 	  				for(l=max(0, nowtracker->PPostion[i][0]-nowtracker->PBoxWH[i][0]); l< min(FrameW-1, nowtracker->PPostion[i][0] + nowtracker->PBoxWH[i][0]); l+=2){
 	  					
						if(CENTER){
							TempHistValuey1 = diag - ( sqrt((float)( (k - centroid[0])*(k - centroid[0]) +   (l - centroid[1])*(l - centroid[1])))) + 1;
						    TempHistValuey2 = diag - ( sqrt((float)( (k - centroid[0])*(k - centroid[0]) +   (l+1 - centroid[1])*(l+1 - centroid[1])))) + 1;
							TempHistValueu1 = diag - ( sqrt((float)( (k - centroid[0])*(k - centroid[0]) +   (l - centroid[1])*(l - centroid[1])))) + 1;
						    TempHistValueu2 = diag - ( sqrt((float)( (k - centroid[0])*(k - centroid[0]) +   (l+1 - centroid[1])*(l+1 - centroid[1])))) + 1;
							TempHistValuev1 = diag - ( sqrt((float)( (k - centroid[0])*(k - centroid[0]) +   (l - centroid[1])*(l - centroid[1])))) + 1;
						    TempHistValuev2 = diag - ( sqrt((float)( (k - centroid[0])*(k - centroid[0]) +   (l+1 - centroid[1])*(l+1 - centroid[1])))) + 1;
						}
						else{
							TempHistValuey1 = 1;
						    TempHistValuey2 = 1;
							TempHistValueu1 = 1;
						    TempHistValueu2 = 1;
							TempHistValuev1 = 1;
						    TempHistValuev2 = 1;
						}
						if(Bguse == 1){
							if(bg_Y[k*FrameW + l]%2 == 0){
								TempHistValuey1 = (BackgroundHistogram_Y_E[bg_Y[k*FrameW + l]] > 10) ? 0 : TempHistValuey1;
							}
							else{
								TempHistValuey1 = (BackgroundHistogram_Y_O[bg_Y[k*FrameW + l]] > 10) ? 0 : TempHistValuey1;
							}
							if(bg_Y[k*FrameW + l + 1]%2 == 0){
								TempHistValuey2 = (BackgroundHistogram_Y_E[bg_Y[k*FrameW + l + 1]] > 10) ? 0 : TempHistValuey2;
							}
							else{
								TempHistValuey2 = (BackgroundHistogram_Y_O[bg_Y[k*FrameW + l + 1]] > 10) ? 0 : TempHistValuey2;
							}
							if(bg_U[k/2*FrameW2+ l/2]%2 == 0){
								TempHistValueu1 = (BackgroundHistogram_U_E[bg_U[k/2*FrameW2+ l/2]] > 10) ? 0 : TempHistValueu1;
							}
							else{
								TempHistValueu1 = (BackgroundHistogram_U_O[bg_U[k/2*FrameW2+ l/2]] > 10) ? 0 : TempHistValueu1;
							}
							if(bg_U[k/2*FrameW2+ (l+1)/2]%2 == 0){
								TempHistValueu2 = (BackgroundHistogram_U_E[bg_U[k/2*FrameW2+ (l+1)/2]] > 10) ? 0 : TempHistValueu2;
							}
							else{
								TempHistValueu2 = (BackgroundHistogram_U_O[bg_U[k/2*FrameW2+ (l+1)/2]] > 10) ? 0 : TempHistValueu2;
							}
							if(bg_V[k/2*FrameW2+ l/2]%2 == 0){
								TempHistValuev1 = (BackgroundHistogram_V_E[bg_V[k/2*FrameW2+ l/2]] > 10) ? 0 : TempHistValuev1;
							}
							else{
								TempHistValuev1 = (BackgroundHistogram_V_O[bg_V[k/2*FrameW2+ l/2]] > 10) ? 0 : TempHistValuev1;
							}
							if(bg_V[k/2*FrameW2+ (l+1)/2]%2 == 0){
								TempHistValuev2 = (BackgroundHistogram_V_E[bg_V[k/2*FrameW2+ (l+1)/2]] > 10) ? 0 : TempHistValuev2;
							}
							else{
								TempHistValuev2 = (BackgroundHistogram_V_O[bg_V[k/2*FrameW2+ (l+1)/2]] > 10) ? 0 : TempHistValuev2;
							}
						}
						else{
							TempHistValuey1 = 1;
							TempHistValuey2 = 1;
							TempHistValuey1 = 1;
							TempHistValueu2 = 1;
							TempHistValuev1 = 1;
							TempHistValuev2 = 1;
							
						}

						TotalHistogramValueY+=TempHistValuey1 + TempHistValuey2;
						TotalHistogramValueU+=TempHistValueu1 + TempHistValueu2;
						TotalHistogramValueV+=TempHistValuev1 + TempHistValuev2;
	 	  				
						BU(framebufferY[k*FrameW + l], framebufferY[k*FrameW + l + 1], framebufferU[k/2*FrameW2+ l/2], framebufferU[k/2*FrameW2+ (l+1)/2], framebufferV[k/2*FrameW2+ l/2] , framebufferV[k/2*FrameW2+ (l+1)/2], 
						TempHistValuey1, TempHistValuey2, TempHistValueu1, TempHistValueu2, TempHistValuev1, TempHistValuev2, flag_Y_w, flag_U_w, flag_V_w, HistogramCandidate_Y_E, HistogramCandidate_Y_O, HistogramCandidate_U_E, HistogramCandidate_U_O, HistogramCandidate_V_E, HistogramCandidate_V_O, 1, 1);
							
 	  					
						if(segbufferY[k*FrameW+l] != 0){
							maxcountseg[i]++;
							
							
						}//end if
							

 	  				}
 	  			}
 	  			
 				
 	  			BhaCoef = 0;
				
					
 	  				
//				time1 = clock();
//            fouttest3 << "frame: " << f << endl;
				if(TotalHistogramValueY == 1 || TotalHistogramValueU == 1 || TotalHistogramValueV == 1)
					Distance = 99999999999999999;
				else{
					DistanceY = 0;
					DistanceU = 0;
					DistanceV = 0;
               if(Choose == 1){
					distance_compute(HistogramCandidate_Y_E, HistogramCandidate_Y_O, nowtracker->HistogramTarget_Y_E, nowtracker->HistogramTarget_Y_O, DistanceY, 4, TotalHistogramValueY, nowtracker->totalhistogram );
						//cout << DistanceY << endl;
						//if(f == 653)system("pause")	;
					distance_compute(HistogramCandidate_U_E, HistogramCandidate_U_O, nowtracker->HistogramTarget_U_E, nowtracker->HistogramTarget_U_O, DistanceU, 4, TotalHistogramValueU, nowtracker->totalhistogram );
						//system("pause")	;
						//system("pause")	;
					distance_compute(HistogramCandidate_V_E, HistogramCandidate_V_O, nowtracker->HistogramTarget_V_E, nowtracker->HistogramTarget_V_O, DistanceV, 4, TotalHistogramValueV, nowtracker->totalhistogram );
					Distance = (DistanceY*DistanceY / TotalHistogramValueY/ TotalHistogramValueY + DistanceU*DistanceU/ TotalHistogramValueU/ TotalHistogramValueU + DistanceV*DistanceV/ TotalHistogramValueV/ TotalHistogramValueV)  / nowtracker->totalhistogram / nowtracker->totalhistogram*10000;// * 10000 * 1024 * 21.5;
				}
				else if(Choose ==2){
					s1.Features = f1;
					s2.Features = f2;
					s1.n = 256;
					s2.n = 256;
					for(k = 0; k < 256; k++){
						if(k%2 == 0){
							weight1[k] = (float)HistogramCandidate_Y_E[k/2]/(float)TotalHistogramValueY;
							weight2[k] = (float)nowtracker->HistogramTarget_Y_E[k/2]/(float)nowtracker->totalhistogram;
						}
						else{
							weight1[k] = (float)HistogramCandidate_Y_O[(k-1)/2]/(float)TotalHistogramValueY;
							weight2[k] = (float)nowtracker->HistogramTarget_Y_O[(k-1)/2]/(float)nowtracker->totalhistogram;
						}

					}
					s1.Weights = weight1;
					s2.Weights = weight2;
					DistanceY = BDdist(&s1, &s2);
					for(k = 0; k < 256; k++){
						if(k%2 == 0){
							weight1[k] = (float)HistogramCandidate_U_E[k/2]/(float)TotalHistogramValueU;
							weight2[k] = (float)nowtracker->HistogramTarget_U_E[k/2]/(float)nowtracker->totalhistogram;
						}
						else{
							weight1[k] = (float)HistogramCandidate_U_O[(k-1)/2]/(float)TotalHistogramValueU;
							weight2[k] = (float)nowtracker->HistogramTarget_U_O[(k-1)/2]/(float)nowtracker->totalhistogram;
						}

					}
					s1.Weights = weight1;
					s2.Weights = weight2;
					DistanceU = BDdist(&s1, &s2);
					for(k = 0; k < 256; k++){
						if(k%2 == 0){
							weight1[k] = (float)HistogramCandidate_V_E[k/2]/(float)TotalHistogramValueV;
							weight2[k] = (float)nowtracker->HistogramTarget_V_E[k/2]/(float)nowtracker->totalhistogram;
						}
						else{
							weight1[k] = (float)HistogramCandidate_V_O[(k-1)/2]/(float)TotalHistogramValueV;
							weight2[k] = (float)nowtracker->HistogramTarget_V_O[(k-1)/2]/(float)nowtracker->totalhistogram;
						}

					}
					s1.Weights = weight1;
					s2.Weights = weight2;
					DistanceV = BDdist(&s1, &s2);
					Distance = (DistanceY*DistanceY  + DistanceU*DistanceU + DistanceV*DistanceV)*10000;// * 10000 * 1024 * 21.5;
				
				
				}
				else if(Choose ==0){
					s1.Features = f1;
					s2.Features = f2;
					s1.n = 256;
					s2.n = 256;
					for(k = 0; k < 256; k++){
						if(k%2 == 0){
							weight1[k] = (float)HistogramCandidate_Y_E[k/2]/(float)TotalHistogramValueY;
							weight2[k] = (float)nowtracker->HistogramTarget_Y_E[k/2]/(float)nowtracker->totalhistogram;
						}
						else{
							weight1[k] = (float)HistogramCandidate_Y_O[(k-1)/2]/(float)TotalHistogramValueY;
							weight2[k] = (float)nowtracker->HistogramTarget_Y_O[(k-1)/2]/(float)nowtracker->totalhistogram;
						}

					}
					s1.Weights = weight1;
					s2.Weights = weight2;
					DistanceY = emd(&s1, &s2, dist, 0, 0);
					for(k = 0; k < 256; k++){
						if(k%2 == 0){
							weight1[k] = (float)HistogramCandidate_U_E[k/2]/(float)TotalHistogramValueU;
							weight2[k] = (float)nowtracker->HistogramTarget_U_E[k/2]/(float)nowtracker->totalhistogram;
						}
						else{
							weight1[k] = (float)HistogramCandidate_U_O[(k-1)/2]/(float)TotalHistogramValueU;
							weight2[k] = (float)nowtracker->HistogramTarget_U_O[(k-1)/2]/(float)nowtracker->totalhistogram;
						}

					}
					s1.Weights = weight1;
					s2.Weights = weight2;
					DistanceU = emd(&s1, &s2, dist, 0, 0);
					for(k = 0; k < 256; k++){
						if(k%2 == 0){
							weight1[k] = (float)HistogramCandidate_V_E[k/2]/(float)TotalHistogramValueV;
							weight2[k] = (float)nowtracker->HistogramTarget_V_E[k/2]/(float)nowtracker->totalhistogram;
						}
						else{
							weight1[k] = (float)HistogramCandidate_V_O[(k-1)/2]/(float)TotalHistogramValueV;
							weight2[k] = (float)nowtracker->HistogramTarget_V_O[(k-1)/2]/(float)nowtracker->totalhistogram;
						}

					}
					s1.Weights = weight1;
					s2.Weights = weight2;
					DistanceV = emd(&s1, &s2, dist, 0, 0);
					Distance = (DistanceY*DistanceY  + DistanceU*DistanceU + DistanceV*DistanceV);// * 10000 * 1024 * 21.5;
				
				
				}
               //Distance = (DistanceY*DistanceY / TotalHistogramValueY / TotalHistogramValueY + DistanceU*DistanceU / TotalHistogramValueU / TotalHistogramValueU + DistanceV*DistanceV / TotalHistogramValueV / TotalHistogramValueV) / nowtracker->totalhistogram / nowtracker->totalhistogram*10000 ;
				}
            
				//time2 = clock();
				//timeDistance += time2-time1;
				//nowtracker->PWeight[i] = Distance;
				//EMDtotal+=Distance;
				//nowtracker->PWeight[i] = emd(&s1, &s2, dist, 0, 0);//exp(-(Distance/(2*VarWU)))/(2.50663*StdWU);//weight update
				nowtracker->GaussianKernel_temp += Distance;
				if(Distance == 0) nowtracker->PWeight[i] = 0.0000001;
				else if(Distance < 0) {
					if(debugcout == 1) cout << "Frame: " << f << endl;
					system("pause");}
				//else if(Choose == 1)nowtracker->PWeight[i] = 1/(Distance-100)*(Distance-100)*(Distance-100)*nowtracker->PBoxWH[i][0]*nowtracker->PBoxWH[i][1];//exp(0-(Distance-50)*(Distance-50)/2/StdWU/StdWU) / StdWU / 2.50663;
				//else nowtracker->PWeight[i] = 1/Distance;//*sqrt((double)(nowtracker->PBoxWH[i][0]*nowtracker->PBoxWH[i][1]));//exp(0-(Distance-50)*(Distance-50)/2/StdWU/StdWU) / StdWU / 2.50663;
				else if(Choose == 1 || Choose == 0) nowtracker->PWeight[i] = exp(0-Distance/nowtracker->GaussianKernel*1)* /*pow((1-(double)abs((double)nowtracker->PBoxWH[i][0] - (double)nowtracker->ObjectBoxW)/(double)max(nowtracker->PBoxWH[i][0], nowtracker->ObjectBoxW)) * (1-(double)abs((double)nowtracker->PBoxWH[i][1] - (double)nowtracker->ObjectBoxH)/(double)max(nowtracker->PBoxWH[i][1], nowtracker->ObjectBoxH)), 4) * */pow(1.00, (nowtracker->PBoxWH[i][1]- nowtracker->ObjectBoxH)) * pow(1.00, (nowtracker->PBoxWH[i][0]- nowtracker->ObjectBoxW));//pow((double)(nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][0]),2);// * nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][0];
				else if(Choose == 2) nowtracker->PWeight[i] = exp(0-Distance/nowtracker->GaussianKernel*2)* pow(2.01, (0-nowtracker->PBoxWH[i][1]+ nowtracker->ObjectBoxH)) * pow(2.01, (0-nowtracker->PBoxWH[i][0]+ nowtracker->ObjectBoxW));
				//else if(Choose == 0) nowtracker->PWeight[i] = exp(0-Distance/nowtracker->GaussianKernel*pow((1-(double)abs((double)nowtracker->PBoxWH[i][0] - (double)nowtracker->ObjectBoxW)/(double)max(nowtracker->PBoxWH[i][0], nowtracker->ObjectBoxW)) * (1-(double)abs((double)nowtracker->PBoxWH[i][1] - (double)nowtracker->ObjectBoxH)/(double)max(nowtracker->PBoxWH[i][1], nowtracker->ObjectBoxH)), 0.25));
				else nowtracker->PWeight[i] = 1/Distance*pow((1-(double)abs((double)nowtracker->PBoxWH[i][0] - (double)nowtracker->ObjectBoxW)/(double)nowtracker->ObjectBoxW) * (1-(double)abs((double)nowtracker->PBoxWH[i][1] - (double)nowtracker->ObjectBoxH)/(double)nowtracker->ObjectBoxH), 4);
				if(nowtracker->PWeight[i] < 0) nowtracker->PWeight[i] = 0;
				//if(debugcout == 1) cout << pow((1-(double)abs((double)nowtracker->PBoxWH[i][0] - (double)nowtracker->ObjectBoxW)/(double)nowtracker->ObjectBoxW) * (1-(double)abs((double)nowtracker->PBoxWH[i][1] - (double)nowtracker->ObjectBoxH)/(double)nowtracker->ObjectBoxH), 4) << endl;
					//exp(-(Distance/(2*VarWU)))/(2.50663*StdWU);
				
				SumofWeight += nowtracker->PWeight[i];

				if(debugfout == 1) fouttest << "\t\t\tX: "<<nowtracker->PPostion[i][0] << " Y: " << nowtracker->PPostion[i][1] << " Width: " << nowtracker->PBoxWH[i][0]*2 << " Height: " << nowtracker->PBoxWH[i][1]*2 <<endl;
				if(debugfout == 1) fouttest << "\t\t\t\tWeight: " << nowtracker->PWeight[i] << endl;
				if(debugfout == 1) fouttest << "\t\t\t\tEMD: " << Distance << endl;
					
 	  			//SumofWeight += nowtracker->PWeight[i];
				
				
				
					
			}
			nowtracker->GaussianKernel = nowtracker->GaussianKernel_temp/NumParticleonObject/5;

			timeWeightUpdate/=NumParticleonObject/2;
			timeDistance /= NumParticleonObject/2;
			
			TempSumofWeight = 0;
			//if(SumofWeight == 0) SumofWeight = 1;
 	  		for(i=0;i<NumParticleonObject;i++){
 	  			nowtracker->PWeight[i] = nowtracker->PWeight[i]/SumofWeight + apha*maxcountseg[i]/nowtracker->PBoxWH[i][0] / nowtracker->PBoxWH[i][1]/4;
				//nowtracker->confidence += maxcountseg[i]/nowtracker->PBoxWH[i][0] / nowtracker->PBoxWH[i][1]/NumHistBin/4;
				
				TempSumofWeight = nowtracker->PWeight[i] + TempSumofWeight;
				
 	  		}
			if(debugcout == 1) cout << "\t\tSum of Weight:\t" << TempSumofWeight << "\tBefore:\t" << SumofWeight<< endl;
			if(debugfout == 1) fouttest << "\t\tSum of Weight:\t" << TempSumofWeight << "\tBefore:\t" << SumofWeight<< endl;
			if(debugcout == 1) cout << "Total Distance:\t" << nowtracker->GaussianKernel_temp / nowtracker->ObjectBoxW / nowtracker->ObjectBoxH << endl;
			if(nowtracker->ObjectBoxW != 0 && nowtracker->ObjectBoxH != 0){
				if(Choose == 0){
					if(debugcout == 1) cout <<"\tThreshold:\t" << (float)WeightThresholdEMD/nowtracker->ObjectBoxW/nowtracker->ObjectBoxH/4 << "\t" << (float)WeightThresholdEMD << endl;
					if (SumofWeight <= WeightThresholdEMD/nowtracker->ObjectBoxW/nowtracker->ObjectBoxH/4) {
						if(debugcout == 1) cout << "Delete Tracker Because of the Color!!!" << endl;
						if(debugfout == 1) fouttest << "Delete Tracker Because of the Color!!!" << endl;

						nowtracker->deleteTracker = true;
					}
				}
				else if(Choose == 1){
					if(debugcout == 1) cout <<"\tThreshold:\t" << (float)WeightThresholdDD << endl;
					//if (nowtracker->GaussianKernel_temp / nowtracker->ObjectBoxW / nowtracker->ObjectBoxH > WeightThresholdDD) {
						//if(debugcout == 1) cout << "Delete Tracker Because of the Color!!!" << endl;
						//if(debugfout == 1) fouttest << "Delete Tracker Because of the Color!!!" << endl;

						//nowtracker->deleteTracker = true;
					//}
				}
				else{
					if(debugcout == 1) cout <<"\tThreshold:\t" << (float)WeightThresholdBD/nowtracker->ObjectBoxW/nowtracker->ObjectBoxH/4 << "\t" << (float)WeightThresholdBD << endl;
					if (SumofWeight <= WeightThresholdBD/nowtracker->ObjectBoxW/nowtracker->ObjectBoxH/4) {
						if(debugcout == 1) cout << "Delete Tracker Because of the Color!!!" << endl;
						if(debugfout == 1) fouttest << "Delete Tracker Because of the Color!!!" << endl;

						nowtracker->deleteTracker = true;
					}
				}
			}
 	  		
			//nowtracker->confidence = nowtracker->confidence/NumParticleonObject;

			for(i=0;i<NumParticleonObject;++i){
 	  			nowtracker->PWeight[i] = nowtracker->PWeight[i]/TempSumofWeight;
				
				
 	  		}

			
 	  		//Estimation of object current state
		
			//if(debugcout == 1) cout << "Pre:\t" << nowtracker->previousX << "\t" << nowtracker->previousY << endl;


// 	  		clock1 = clock();
//			time1 = clock();
 	  		
 	  		nowtracker->ObjectBoxW_f	=	0;
 	  		nowtracker->ObjectBoxH_f	=	0;
//			maxweight = 0;
			//maxx = 0;
			//maxy = 0;
			//maxw = 0;
			//maxh = 0;
			
	 	  
 	  		for(i=0;i<NumParticleonObject;++i){
 	  			//nowtracker->ObjectPX_f	+=	nowtracker->PWeight[i]*nowtracker->PPostion[i][0];
 	  			//nowtracker->ObjectPY_f	+=	nowtracker->PWeight[i]*nowtracker->PPostion[i][1];
 	  			nowtracker->ObjectBoxW_f	+=	nowtracker->PWeight[i]*nowtracker->PBoxWH[i][0];
	 	  		nowtracker->ObjectBoxH_f	+=	nowtracker->PWeight[i]*nowtracker->PBoxWH[i][1];
			
				

 	  		}
			nowtracker->ratio = nowtracker->ObjectBoxH_f/nowtracker->ObjectBoxW_f;
			if(nowtracker->ratio < 1)nowtracker->ratio = 1;





























			/*********************/






			//nowtracker->ObjectPX_f	=	maxx;
 	  		//nowtracker->ObjectPY_f	=	maxy;
 	  		//nowtracker->ObjectBoxW_f	=	(maxw1 ) /1;
	 	  	//nowtracker->ObjectBoxH_f	=	(maxh1 ) / 1;


			tempA = (nowtracker->ObjectPY_f - nowtracker->ObjectBoxH_f);
			tempB = (nowtracker->ObjectPY_f + nowtracker->ObjectBoxH_f);
 	  		k = max(0,tempA);
			l = min(FrameH - 1,tempB);
			
			
 	  		nowtracker->ObjectPY = (k + l + 1) / 2;
 	  		nowtracker->ObjectBoxH = (l - k) / 2;

			k = max(0,tempA-nowtracker->ObjectBoxH/3);
			l = min(FrameH - 1,tempB+nowtracker->ObjectBoxH/3);
			
			//nowtracker->ObjectPY_B = (k + l) / 2;
 	  		nowtracker->ObjectBoxH_B = (l - k) / 2;
			
			

			tempA = (nowtracker->ObjectPX_f - nowtracker->ObjectBoxW_f);
			tempB = (nowtracker->ObjectPX_f + nowtracker->ObjectBoxW_f);
			
			k = max(0,tempA);
			
			l = min(FrameW - 1,tempB);

			nowtracker->ObjectPX = (k + l+1) / 2;
			nowtracker->ObjectBoxW = (l - k) / 2;

			k = max(0,tempA-nowtracker->ObjectBoxW/3);
			
			l = min(FrameW - 1,tempB+nowtracker->ObjectBoxW/3);

			//nowtracker->ObjectPX_B = (k + l) / 2;
			nowtracker->ObjectBoxW_B = (l - k) / 2;

            
			if(nowtracker->NoParticle){
				mindist = 9999;
                nownode = root->right;
				whichone = 0;
				whichonecount = 0;
				temptempy = nowtracker->ObjectPY;
				temptempx = nowtracker->ObjectPX;
				tempboxh = nowtracker->ObjectBoxH;
				tempboxw = nowtracker->ObjectBoxW;
					
					
				if(debugcout == 1) cout << "No Particle!!!!!!!!!!" << endl;
				while(nownode != end){
					if(mindist >= abs(nownode->downbound + nownode->upbound - 2 * temptempy) + abs(nownode->rightbound + nownode->leftbound - 2 * temptempx) 
						//&& abs(nownode->downbound - nownode->upbound - 2 * tempy) + abs(nownode->rightbound - nownode->leftbound - 2 * tempx) < 20
						&& (nownode->leftbound <= NOPARTICLE ||
							nownode->rightbound >= FrameW - NOPARTICLE ||
							nownode->upbound <= NOPARTICLE ||
							nownode->downbound >= FrameH - NOPARTICLE)

						){
					   whichone = whichonecount;
					   //if(debugcout == 1) cout << temptempx << " " << temptempy << " " << (nownode->rightbound - nownode->leftbound)/2 <<" "<< (nownode->downbound - nownode->upbound)/2<< endl;
					   mindist = abs(nownode->downbound + nownode->upbound - 2 * temptempy) + abs(nownode->rightbound + nownode->leftbound - 2 * temptempx);
					   tempy = (nownode->downbound + nownode->upbound)/2;
					   tempboxh = (nownode->downbound - nownode->upbound)/2;
					   tempx = (nownode->rightbound + nownode->leftbound)/2;
					   tempboxw = (nownode->rightbound - nownode->leftbound)/2;
					   //tempboxh_B = tempboxh * 1.3;
					   //tempboxw_B = tempboxw * 1.3;

					   tempE = tempx - tempboxw;
						tempF = tempx + tempboxw;
						tempG = tempy - tempboxh;
						tempH = tempy + tempboxh;

						

						if(tempE <= 15){
							tempboxh = tempboxh*Shrink;
							tempy = tempy;
							
							tempF = tempF - tempboxw*(1-Shrink)/2;

							tempboxw = (tempF - tempE) / 2;
							tempx = (tempF + tempE) / 2;

							
							
						}
						else if(tempF >= FrameW - 15){
							tempboxh = tempboxh*Shrink;
							tempy = tempy;
							
							tempE = tempE + tempboxw*(1-Shrink)/2;
							tempboxw = (tempF - tempE) / 2;
							tempx = (tempF + tempE) / 2;
							
						}
						else if(tempG <= 15){
							
							tempH = tempH - tempboxh*(1-Shrink)/2;
							tempboxh = (tempH - tempG) / 2;
							tempy = (tempH + tempG) / 2;
							
							
							tempboxw = tempboxw*Shrink;
							tempx = tempx;
							
						}
						else if(tempH >= FrameH - 15){
							tempG = tempG + tempboxh*(1-Shrink)/2;
							tempboxh = (tempH - tempG) / 2;
							tempy = (tempH + tempG) / 2;
							
							tempboxw = tempboxw*Shrink;
							tempx = tempx;
							
						}
						else{
							tempboxh = tempboxh*Shrink;
							tempy = tempy;
							tempboxw = tempboxw*Shrink;
							tempx = tempx;
						}


					}
					
					
					nownode = nownode->right;
					whichonecount++;
				}//end while

				if(mindist < 50){
					nowtracker->ObjectPX = tempx;
					nowtracker->ObjectPY = tempy;
					nowtracker->ObjectBoxW = tempboxw/1.7;
					nowtracker->ObjectBoxH = tempboxh/1.7;
					nowtracker->ObjectBoxH_B = tempboxh * 1.3/1.7;
					nowtracker->ObjectBoxW_B = tempboxw * 1.3/1.7;
					if(debugcout == 1) cout << "Minidist : " << mindist<< endl;
					nowtracker->ratio = tempboxh/tempboxw;

					nownode = root->right;
					while(whichone >=0){
						nownode = nownode->right;
						whichone--;
					}
					nownode->newtracker = false;
					

				}
				else{
					nowtracker->NoParticle = false;
				}

				

			}//end if

			nowtracker->velocityX = (nowtracker->ObjectPX - nowtracker->pre_previousX)/2;
			nowtracker->velocityY = (nowtracker->ObjectPY - nowtracker->pre_previousY)/2;
			




 	  		
			tempA = (nowtracker->ObjectPX - nowtracker->ObjectBoxW*MoreSpace);
			tempB = (nowtracker->ObjectPX + nowtracker->ObjectBoxW*MoreSpace);
			tempC = (nowtracker->ObjectPY - nowtracker->ObjectBoxH*MoreSpace);
			tempD = (nowtracker->ObjectPY + nowtracker->ObjectBoxH*MoreSpace);
			
			tempA = max(0,tempA);
			tempB = min(FrameW-1, tempB);
			tempC = max(0,tempC); 
			tempD = min(FrameH-1,tempD);
			
			//if(nowtracker->ObjectPX < 0) system("pause");
			
			for(k = tempC; k <= tempD; k++){
				for(l = tempA; l <= tempB; l++){
					if(segbufferY[k*FrameW + l] != 0)
						nowtracker->confidence += 1;

				}
			}

			nownode = root->right;
					
					

			while(nownode != end){
					
				if((nownode->downbound >= tempC && tempC >= nownode->upbound && nownode->leftbound <= tempA && tempA<= nownode->rightbound) ||
					(nownode->downbound >= tempC && tempC >= nownode->upbound && nownode->leftbound <= tempB && tempB<= nownode->rightbound) ||
					(nownode->downbound >= tempD && tempD >= nownode->upbound && nownode->leftbound <= tempA && tempA<= nownode->rightbound) ||
					(nownode->downbound >= tempD && tempD>= nownode->upbound && nownode->leftbound <= tempB && tempB<= nownode->rightbound) ||
					(nownode->downbound >= tempD && tempC >= nownode->upbound && tempA <= nownode->leftbound && tempB >= nownode->rightbound)
					){
					nownode->newtracker = false;
					
					nownode->countpass++;
				}//end if
				else if((tempC <= nownode->upbound && nownode->upbound <= tempD && tempA <= nownode->leftbound && nownode->leftbound <= tempB) ||
					(tempC <= nownode->upbound && nownode->upbound <= tempD && tempA <= nownode->rightbound && nownode->rightbound <= tempB) ||
					(tempC <= nownode->downbound && nownode->downbound <= tempD && tempA <= nownode->leftbound && nownode->leftbound <= tempB) ||
					(tempC <= nownode->downbound && nownode->downbound <= tempD && tempA <= nownode->rightbound && nownode->rightbound <= tempB) ||
					(tempC <= nownode->upbound && nownode->downbound <= tempD && nownode->leftbound <= tempA && nownode->rightbound >= tempB)
					){
					nownode->newtracker = false;
					
					nownode->countpass++;
				}
				
				nownode = nownode->right;
			}//end while

			

/****/
					nownode = root->right;
					
					if(debugcout == 1) cout << "Center: (" << nowtracker->ObjectPX << " , " << nowtracker->ObjectPY << ") Width: " << nowtracker->ObjectBoxW *2<< " Height: " << nowtracker->ObjectBoxH*2 << endl;
					if(debugfout == 1) fouttest << "Center: (" << nowtracker->ObjectPX << " , " << nowtracker->ObjectPY << ") Width: " << nowtracker->ObjectBoxW *2<< " Height: " << nowtracker->ObjectBoxH*2 << endl;
                    fposttracker << nowtracker->ObjectPX << "\t" << nowtracker->ObjectPY << "\t" << nowtracker->ObjectBoxW *2<< "\t" << nowtracker->ObjectBoxH*2 << "\t\t";

					nownode = root->right;
					while(nownode != end){
						if(debugcout == 1) cout << "Up:\t" << nownode->upbound << "\tDown:\t" << nownode->downbound << "\tLeft:\t" << nownode->leftbound << "\tRight:\t" << nownode->rightbound << endl;
						if(debugfout == 1) fouttest << "Up:\t" << nownode->upbound << "\tDown:\t" << nownode->downbound << "\tLeft:\t" << nownode->leftbound << "\tRight:\t" << nownode->rightbound << endl;
								if(nownode->newtracker == false){
							
									if(debugcout == 1) cout << "IN" << endl;
									if(debugfout == 1) fouttest << "IN" << endl;
									
									//nownode->countpass++;
								}//end if
						
						nownode = nownode->right;
					}//end while

/****/

			nowtracker->confidence = nowtracker->confidence/nowtracker->ObjectBoxH / nowtracker->ObjectBoxW / 4;


			//time2 = clock();
			//timeEO += time2 - time1;
 	 		
 		  		//Produce the Result Video
			if(nowtracker->confidence >ConfidenceThreshold && !nowtracker->deleteTracker){//||( (nowtracker->ObjectPX > LeftThreshold && nowtracker->ObjectPX < RightThreshold) && (nowtracker->ObjectPY > TopThreshold && nowtracker->ObjectPY < BottomThreshold))){	
				if(debugcout == 1) cout << "\t\tCenter: (" << nowtracker->ObjectPX << " , " << nowtracker->ObjectPY << ") Width: " << nowtracker->ObjectBoxW *2<< " Height: " << nowtracker->ObjectBoxH*2 << endl;
				if(debugfout == 1) fouttest << "\t\tCenter: (" << nowtracker->ObjectPX << " , " << nowtracker->ObjectPY << ") Width: " << nowtracker->ObjectBoxW *2<< " Height: " << nowtracker->ObjectBoxH*2 << endl;

				if(debugcout == 1) cout << "\t\tDisplaying Object......" << endl;
				if(debugfout == 1) fouttest << "\t\tDisplaying Object......" << endl;
				tempA = max((int)0, (int)(nowtracker->ObjectPY-(double)1.7*(double)nowtracker->ObjectBoxH));
				tempC = max((int)0, (int)(nowtracker->ObjectPX-1.7*(double)nowtracker->ObjectBoxW));
				tempB = min((int)FrameH-1, (int)(nowtracker->ObjectPY + 1.7*(double)nowtracker->ObjectBoxH));
				tempD = min((int)FrameW-1, (int)(nowtracker->ObjectPX + 1.7*(double)nowtracker->ObjectBoxW));
 	  			for(k=(tempA);k<=(tempB); ++k){
					if((tempC)%2 == 0){
						FrameDisplayY[k*FrameW + tempC] = nowtracker->colory;
						FrameDisplayY[k*FrameW + tempC + 1] = nowtracker->colory;
					}
					else{
						FrameDisplayY[k*FrameW + tempC] = nowtracker->colory;
						FrameDisplayY[k*FrameW + tempC - 1] = nowtracker->colory;
					}
					if((tempD)%2 == 0){
	 	  				FrameDisplayY[k*FrameW + tempD] = nowtracker->colory;
						FrameDisplayY[k*FrameW + tempD + 1] = nowtracker->colory;
					}
					else{
	 	  				FrameDisplayY[k*FrameW + tempD] = nowtracker->colory;
						FrameDisplayY[k*FrameW + tempD - 1] = nowtracker->colory;
					}
					FrameDisplayU[k/2*FrameW2 + (tempC)/2 ] = nowtracker->coloru;
	 	  			FrameDisplayU[k/2*FrameW2 + (tempD)/2] = nowtracker->coloru;
					FrameDisplayV[k/2*FrameW2 + (tempC)/2 ] = nowtracker->colorv;
	 	  			FrameDisplayV[k/2*FrameW2 + (tempD)/2] = nowtracker->colorv;

 	  			}
 	  			for(l=(tempC);l<=(tempD); ++l){
					if((tempA)%2 == 0){
						FrameDisplayY[(tempA)*FrameW + l] = nowtracker->colory;
						FrameDisplayY[(tempA + 1)*FrameW + l ] = nowtracker->colory;
					}
					else{
						FrameDisplayY[(tempA)*FrameW + l] = nowtracker->colory;
						FrameDisplayY[(tempA - 1)*FrameW + l] = nowtracker->colory;
					}
					if(((tempB))%2 == 0){
 	  					FrameDisplayY[(tempB)*FrameW + l] = nowtracker->colory;
						FrameDisplayY[(tempB + 1)*FrameW + l ] = nowtracker->colory;
					}
					else{
						FrameDisplayY[(tempB)*FrameW + l] = nowtracker->colory;
						FrameDisplayY[(tempB - 1)*FrameW + l] = nowtracker->colory;
					}
					FrameDisplayU[(tempA)/2*FrameW2 + (l)/2] = nowtracker->coloru;
 	  				FrameDisplayU[(tempB)/2*FrameW2 + (l)/2] = nowtracker->coloru;
					FrameDisplayV[(tempA)/2*FrameW2 + (l)/2] = nowtracker->colorv;
 	  				FrameDisplayV[(tempB)/2*FrameW2 + (l)/2] = nowtracker->colorv;
 		  		}
 				
 	  		
 	  
 	  		
	 	  
 	  			//Update Target Model
//				time1 = 0;
	 	  		
 	  			TotalHistogramValue = 0;//2. Target Model : color histogram
				TotalHistogramValuet = 0;
 	  			diag = (float)sqrt((float) (nowtracker->ObjectBoxW*nowtracker->ObjectBoxW + nowtracker->ObjectBoxH*nowtracker->ObjectBoxH) );
 	  			TempHistValue = 1;
				/*for(j= 0; j < nowtracker->HistogramTarget.size(); j+=4){
				
					nowtracker->HistogramTarget[j+3] = 0;;
				
				
				}*/
            for(k = 0; k < 128; k++){
               LearningHistogram_Y_E[k] = 0;
               LearningHistogram_U_E[k] = 0;
               LearningHistogram_V_E[k] = 0;
               LearningHistogram_Y_O[k] = 0;
               LearningHistogram_U_O[k] = 0;
               LearningHistogram_V_O[k] = 0;
            
            }//end for k
            for(k = 0; k < 256; k++){
				   flag_Y_w[k] =0;
               flag_U_w[k] =0;
               flag_V_w[k] =0;

            }
				//LearningHistogram_B.clear();
				//if(debugcout == 1) cout << nowtracker->ObjectPY << " " << nowtracker->ObjectBoxH_B << " " << nowtracker->ObjectPX << " " << nowtracker->ObjectBoxW_B << endl;
				centroid[0] = (max(0,nowtracker->ObjectPY-nowtracker->ObjectBoxH) + min(FrameH-1, nowtracker->ObjectPY + nowtracker->ObjectBoxH)) / 2;
				centroid[1] = (max(0,nowtracker->ObjectPX-nowtracker->ObjectBoxW) + min(FrameW-1, nowtracker->ObjectPX + nowtracker->ObjectBoxW)) / 2;
 	  			for(k=max(0,nowtracker->ObjectPY-nowtracker->ObjectBoxH); k<= min(FrameH-1, nowtracker->ObjectPY + nowtracker->ObjectBoxH); ++k){
 	  				for(l=max(0,nowtracker->ObjectPX-nowtracker->ObjectBoxW); l< min(FrameW-1, nowtracker->ObjectPX + nowtracker->ObjectBoxW); l+=2){
 	  					//if(k<0) k=0;
 	  					//if(k>=FrameH) k=FrameH-1;
 	  					//if(l<0) l=0;
 	  					//if(l>=FrameW) l=FrameW-1;
						if(CENTER)
							TempHistValue = diag - ( sqrt((float)( (k - centroid[0])*(k - centroid[0]) +   (l - centroid[1])*(l - centroid[1])))) + 1;
						else
							TempHistValue = 1;
						TotalHistogramValue+=2*TempHistValue;
						BU(framebufferY[k*FrameW + l], framebufferY[k*FrameW + l + 1], framebufferU[k/2*FrameW2+ l/2], framebufferU[k/2*FrameW2+ (l+1)/2], framebufferV[k/2*FrameW2+ l/2] , framebufferV[k/2*FrameW2+ (l+1)/2], 
						TempHistValue, TempHistValue, TempHistValue, TempHistValue, TempHistValue, TempHistValue, flag_Y_w, flag_U_w, flag_V_w, LearningHistogram_Y_E, LearningHistogram_Y_O, LearningHistogram_U_E, LearningHistogram_U_O, LearningHistogram_V_E, LearningHistogram_V_O, segbufferY[k*FrameW + l],segbufferY[k*FrameW + l + 1]);
 	  					
						
						
 	  				}
 	  				
 	  			}
			
				nowtracker->totalhistogram = 0;
				for(k = 0; k < 128; k++){

				
					if(!nowtracker->NoParticle){
						nowtracker->HistogramTarget_Y_E[k] = (double)LearningRatio * (double)LearningHistogram_Y_E[k] + (double)nowtracker->HistogramTarget_Y_E[k] * (double)(1-LearningRatio) + 0.5;//LearningHistogram_Y_E[k];
						nowtracker->HistogramTarget_Y_O[k] = (double)LearningRatio * (double)LearningHistogram_Y_O[k] + (double)nowtracker->HistogramTarget_Y_O[k] * (double)(1-LearningRatio) + 0.5;//LearningHistogram_Y_O[k];
						nowtracker->HistogramTarget_U_E[k] = (double)LearningRatio * (double)LearningHistogram_U_E[k] + (double)nowtracker->HistogramTarget_U_E[k] * (double)(1-LearningRatio) + 0.5;//LearningHistogram_U_E[k];
						nowtracker->HistogramTarget_U_O[k] = (double)LearningRatio * (double)LearningHistogram_U_O[k] + (double)nowtracker->HistogramTarget_U_O[k] * (double)(1-LearningRatio) + 0.5;//LearningHistogram_U_O[k];
						nowtracker->HistogramTarget_V_E[k] = (double)LearningRatio * (double)LearningHistogram_V_E[k] + (double)nowtracker->HistogramTarget_V_E[k] * (double)(1-LearningRatio) + 0.5;//LearningHistogram_V_E[k];
						nowtracker->HistogramTarget_V_O[k] = (double)LearningRatio * (double)LearningHistogram_V_O[k] + (double)nowtracker->HistogramTarget_V_O[k] * (double)(1-LearningRatio) + 0.5;//LearningHistogram_V_O[k];
	                  
					}
					else{
						nowtracker->HistogramTarget_Y_E[k] = LearningHistogram_Y_E[k];
						nowtracker->HistogramTarget_Y_O[k] = LearningHistogram_Y_O[k];
						nowtracker->HistogramTarget_U_E[k] = LearningHistogram_U_E[k];
						nowtracker->HistogramTarget_U_O[k] = LearningHistogram_U_O[k];
						nowtracker->HistogramTarget_V_E[k] = LearningHistogram_V_E[k];
						nowtracker->HistogramTarget_V_O[k] = LearningHistogram_V_O[k];
						//nowtracker->totalhistogram+= (LearningHistogram_Y_E[k] + LearningHistogram_Y_O[k]);
					}
					nowtracker->totalhistogram+= (nowtracker->HistogramTarget_Y_E[k] + nowtracker->HistogramTarget_Y_O[k]);
						

				}//end for k



				totalweight = 0;
				//if(debugcout == 1) cout << "\t\tTarget Size: " << nowtracker->HistogramTarget.size()/4 << endl;
				//nowtracker->s1.n = nowtracker->HistogramTarget.size()/4;
				//nowtracker->f1 = new feature_t[nowtracker->HistogramTarget.size()/4];
				//nowtracker->WeightT = new float [nowtracker->HistogramTarget.size()/4];
 	  			
				//for(j = 0; j < nowtracker->HistogramTarget.size()/4; j++){
				
					//WeightT[j] = WeightT[j] / totalweight;
				//}//end for j
				
 	  
 	  		    //time2 = clock();
				//timeUTM += time2 - time1;
 	  
 	  
 	  
 	  
 	  
 	  
 	  			
	 	  		
				if(nowtracker->ObjectPX - nowtracker->ObjectBoxW <= NOPARTICLE ||
					nowtracker->ObjectPX + nowtracker->ObjectBoxW >= FrameW - NOPARTICLE ||
					nowtracker->ObjectPY - nowtracker->ObjectBoxH <= NOPARTICLE ||
					nowtracker->ObjectPY + nowtracker->ObjectBoxH >= FrameH - NOPARTICLE
					)
					nowtracker->NoParticle = true;
				else
					nowtracker->NoParticle = false;
				for(i=0;i<NumParticleonObject;++i){//set the particle for next iteration
					nowtracker->PPostion[i][0]		=	nowtracker->ObjectPX;//ResPPostion[i][0];
					nowtracker->PPostion[i][1]		=	nowtracker->ObjectPY;//ResPPostion[i][1];
					nowtracker->PBoxWH[i][0]		=	nowtracker->ObjectBoxW;//ResPBoxWH[i][0];
					nowtracker->PBoxWH[i][1]		=	nowtracker->ObjectBoxH;//ResPBoxWH[i][1];
 		  			nowtracker->PWeight[i]			=	0;//ResPWeight[i];
 	  			}
	 	  		/*Debug*/
 	  			//printf("Number of Particle = %d \n", k);
// 	  			fprintf(fpParticleStatus,"&&&&&&&&&After Resampling2&&&&&&&&&\n");
 //	  			fprintf(fpParticleStatus,"Number of Particle after resampling = %d \n", k);//check if particle number correct (for deterministic/ random resampling ? )Initial Number of Particle = %d
 //	  			for(i=0;i<NumParticleonObject;++i){//display the particle state before resampling
//	 	  			fprintf(fpParticleStatus, "After %d: Postion(%d,%d), Box(%d,%d), weight= %f\n",i,nowtracker->PPostion[i][0],nowtracker->PPostion[i][1],nowtracker->PBoxWH[i][0],nowtracker->PBoxWH[i][1],nowtracker->PWeight[i]);
 //	  			}
 	  		
 	  			//printf("%d\n",f);
/*
				for(k=0;k<FrameH;++k){
 	  				for(l=0;l<FrameW;++l){
 	  					FrameDisplayY[k*FrameW+l] =  framebufferY[k*FrameW+l];
	 	  			}
 	  			}
 	  			for(k=0;k<FrameH2;++k){
 	  				for(l=0;l<FrameW2;++l){
 	  					FrameDisplayU[k*FrameW2+l] =  framebufferU[k*FrameW2+l];
 	  					FrameDisplayV[k*FrameW2+l] =  framebufferV[k*FrameW2+l];
 	  				}
 	  			}
	
 	  			//Display Particle
 	  			for(i=0;i<NumParticleonObject;++i){
 	  				for(k=nowtracker->PPostion[i][1]-nowtracker->PBoxWH[i][1];k<=nowtracker->PPostion[i][1] + nowtracker->PBoxWH[i][1]; ++k){
 	  					FrameDisplayY[k*FrameW + nowtracker->PPostion[i][0]-nowtracker->PBoxWH[i][0]] = 0;
	 	  				FrameDisplayY[k*FrameW + nowtracker->PPostion[i][0]+nowtracker->PBoxWH[i][0]] = 0;
 	  				}
 	  				for(l=nowtracker->PPostion[i][0]-nowtracker->PBoxWH[i][0];l<=nowtracker->PPostion[i][0] + nowtracker->PBoxWH[i][0]; ++l){
 	  					FrameDisplayY[(nowtracker->PPostion[i][1] - nowtracker->PBoxWH[i][1])*FrameW + l] = 0;
 	  					FrameDisplayY[(nowtracker->PPostion[i][1] + nowtracker->PBoxWH[i][1])*FrameW + l] = 0;
	 	  			}
 	  			}*/
				nowtracker = nowtracker->right;
			}//end if confidence
			else{
				
//				time1 = clock();

				tempA = (nowtracker->ObjectPX_f - nowtracker->ObjectBoxW*MoreSpace);
				tempB = (nowtracker->ObjectPX_f + nowtracker->ObjectBoxW*MoreSpace);
				tempC = (nowtracker->ObjectPY_f - nowtracker->ObjectBoxH*MoreSpace);
				tempD = (nowtracker->ObjectPY_f + nowtracker->ObjectBoxH*MoreSpace);
				tempA = max(0,tempA);
				tempB = min(FrameW-1, tempB);
				tempC = max(0,tempC); 
				tempD = min(FrameH-1,tempD);
			
			
			
			//if(nowtracker->ObjectPX < 0) system("pause");
			
				for(k = tempC; k <= tempD; k++){
					for(l = tempA; l <= tempB; l++){
						if(segbufferY[k*FrameW + l] != 0)
							nowtracker->confidence += 1;
						
					}
				}
				nownode = root->right;
				while(nownode != end){
					
					
					
				if((nownode->downbound >= tempC && tempC >= nownode->upbound && nownode->leftbound <= tempA && tempA<= nownode->rightbound) ||
					(nownode->downbound >= tempC && tempC >= nownode->upbound && nownode->leftbound <= tempB && tempB<= nownode->rightbound) ||
					(nownode->downbound >= tempD && tempD >= nownode->upbound && nownode->leftbound <= tempA && tempA<= nownode->rightbound) ||
					(nownode->downbound >= tempD && tempD>= nownode->upbound && nownode->leftbound <= tempB && tempB<= nownode->rightbound) ||
					(nownode->downbound >= tempD && tempC >= nownode->upbound && tempA <= nownode->leftbound && tempB >= nownode->rightbound)
					){
					//nownode->newtracker = false;
					
					nownode->countpass--;
				}//end if
				else if((tempC <= nownode->upbound && nownode->upbound <= tempD && tempA <= nownode->leftbound && nownode->leftbound <= tempB) ||
					(tempC <= nownode->upbound && nownode->upbound <= tempD && tempA <= nownode->rightbound && nownode->rightbound <= tempB) ||
					(tempC <= nownode->downbound && nownode->downbound <= tempD && tempA <= nownode->leftbound && nownode->leftbound <= tempB) ||
					(tempC <= nownode->downbound && nownode->downbound <= tempD && tempA <= nownode->rightbound && nownode->rightbound <= tempB) ||
					(tempC <= nownode->upbound && nownode->downbound <= tempD && nownode->leftbound <= tempA && nownode->rightbound >= tempB)
					){
					//nownode->newtracker = false;
					
					nownode->countpass--;
				}
				if(nownode->countpass <= 0)
					nownode->newtracker = true;
				
				nownode = nownode->right;
			}//end while
				
				
				
				if(debugcout == 1) cout << "Delete Tracker...................." << endl;
				if(debugfout == 1) fouttest << "Delete Tracker...................." << endl;
				nowtracker->right->left = nowtracker->left;
				nowtracker->left->right = nowtracker->right;
				
				tracker* temptracker = nowtracker->right;
				delete nowtracker;
				nowtracker = temptracker;
				numoftracker--;
				//time2 = clock();
				//timeDT += time2 - time1;


			
			}//end else


			


			
			
	
		}
	    //fwrite ( FrameDisplayY, 1, FrameH*FrameW, fpout1);			
 	  	//fwrite ( FrameDisplayU, 1, FrameH2*FrameW2, fpout1);			
 	  	//fwrite ( FrameDisplayV, 1, FrameH2*FrameW2, fpout1);
		timeWeightUpdate /= numoftracker;
		timeDistance /= numoftracker;
		timeEO /= numoftracker;
		timeUTM /= numoftracker;
		timeDT /= numoftracker;
		nownode = root->right;
		doneadd = false;


		//f1 = new feature_t [countk];
		
/*
		for(i = 0; i < countk; i++){
			f1[i].X = f2[i].X;
			f1[i].Y = f2[i].Y;
			f1[i].Z = f2[i].Z;
		}
*/		//s1.n = countk;
		//s1.Features = f1;
		double timeAT = 0;
		double timeSF = 0;
//		time1 = clock();

		while(nownode != end){
			nownode->countpass = 0;
			
			if(nownode->newtracker && !doneadd && numoftracker < MAX_TRACKER
				//&& nownode->leftbound >= 5 &&  nownode->rightbound <= FrameW - 5 && nownode->upbound >= 5 && nownode->downbound <= FrameH - 5
				){// && (((nownode->leftbound + nownode->rightbound)/2 < AddLeftThreshold)||((nownode->leftbound + nownode->rightbound)/2 > AddRightThreshold)||((nownode->leftbound + nownode->rightbound)/2 < AddTopThreshold)||((nownode->leftbound + nownode->rightbound)/2 > AddBottomThreshold))){
				//if(nownode->leftbound >= 5 &&  nownode->rightbound <= FrameW - 5 && nownode->upbound >= 5 && nownode->downbound <= FrameH - 5){
					tracker* newtrackernode = new tracker;
					newtrackernode->left = trackerend->left;
					newtrackernode->right = trackerend;
					trackerend->left->right = newtrackernode;
					trackerend->left = newtrackernode;
					newtrackernode->deleteTracker = false;
					newtrackernode->colory = gcolor;
					gcolor = (rand() +gcolor + 25)%256;
					newtrackernode->coloru = gcolor;
					gcolor = (rand() +gcolor + 25)%256;
					newtrackernode->colorv = gcolor;
					gcolor = (rand() +gcolor + 25)%256;
					//if(gcolor > 255) gcolor = 0;

					newtrackernode->IniPx = (nownode->leftbound + nownode->rightbound)/2;
					newtrackernode->IniPy = (nownode->upbound + nownode->downbound)/2;
					newtrackernode->IniHalfW = (nownode->rightbound - nownode->leftbound)/2;
					newtrackernode->IniHalfH = (nownode->downbound - nownode->upbound)/2;
					newtrackernode->IniHalfW_B = newtrackernode->IniHalfW*1.3;
					newtrackernode->IniHalfH_B = newtrackernode->IniHalfH*1.3;

					tempE = newtrackernode->IniPx - newtrackernode->IniHalfW;
					tempF = newtrackernode->IniPx + newtrackernode->IniHalfW;
					tempG = newtrackernode->IniPy - newtrackernode->IniHalfH;
					tempH = newtrackernode->IniPy + newtrackernode->IniHalfH;

					

					if(tempE <= 15){
						newtrackernode->ObjectBoxH = newtrackernode->IniHalfH*Shrink;
						newtrackernode->ObjectPY = newtrackernode->IniPy;
						
						tempF = tempF - newtrackernode->IniHalfW*(1-Shrink)/2;

						newtrackernode->ObjectBoxW = (tempF - tempE) / 2;
						newtrackernode->ObjectPX = (tempF + tempE) / 2;

						
						
					}
					else if(tempF >= FrameW - 15){
						newtrackernode->ObjectBoxH = newtrackernode->IniHalfH*Shrink;
						newtrackernode->ObjectPY = newtrackernode->IniPy;
						
						tempE = tempE + newtrackernode->IniHalfW*(1-Shrink)/2;
						newtrackernode->ObjectBoxW = (tempF - tempE) / 2;
						newtrackernode->ObjectPX = (tempF + tempE) / 2;
						
					}
					else if(tempG <= 15){
						
						tempH = tempH - newtrackernode->IniHalfH*(1-Shrink)/2;
						newtrackernode->ObjectBoxH = (tempH - tempG) / 2;
						newtrackernode->ObjectPY = (tempH + tempG) / 2;
						
						
						newtrackernode->ObjectBoxW = newtrackernode->IniHalfW*Shrink;
						newtrackernode->ObjectPX = newtrackernode->IniPx;
						
					}
					else if(tempH >= FrameH - 15){
						tempG = tempG + newtrackernode->IniHalfH*(1-Shrink)/2;
						newtrackernode->ObjectBoxH = (tempH - tempG) / 2;
						newtrackernode->ObjectPY = (tempH + tempG) / 2;
						
						newtrackernode->ObjectBoxW = newtrackernode->IniHalfW*Shrink;
						newtrackernode->ObjectPX = newtrackernode->IniPx;
						
					}
					else{
						newtrackernode->ObjectBoxH = newtrackernode->IniHalfH*Shrink;
						newtrackernode->ObjectPY = newtrackernode->IniPy;
						newtrackernode->ObjectBoxW = newtrackernode->IniHalfW*Shrink;
						newtrackernode->ObjectPX = newtrackernode->IniPx;
					}
					newtrackernode ->IniHalfH = newtrackernode->ObjectBoxH;
					newtrackernode ->IniHalfW = newtrackernode->ObjectBoxW;
					newtrackernode->IniPx = newtrackernode->ObjectPX;
					newtrackernode->IniPy = newtrackernode->ObjectPY;

					newtrackernode->ratio = newtrackernode->IniHalfH / newtrackernode->IniHalfW;
					if(newtrackernode->ratio < 1) newtrackernode->ratio = 1;

					if(newtrackernode->IniPx - newtrackernode->IniHalfW <= NOPARTICLE ||
						newtrackernode->IniPx + newtrackernode->IniHalfW >= FrameW - NOPARTICLE ||
						newtrackernode->IniPy - newtrackernode->IniHalfH <= NOPARTICLE ||
						newtrackernode->IniPy + newtrackernode->IniHalfH >= FrameH - NOPARTICLE
						
						){
						newtrackernode->NoParticle = true;
					}else{
						newtrackernode->NoParticle = false;
					}
					


					for(i=0;i<NumParticleonObject;++i){//1. particle initialization
						tempE = (double)newtrackernode->IniPx;// + (((double)newtrackernode->IniHalfW*0.5) - ((double)newtrackernode->IniHalfW*rand()/RAND_MAX));
						tempF = (double)newtrackernode->IniPy;// + (((double)newtrackernode->IniHalfH*0.5) -((double)newtrackernode->IniHalfH*rand()/RAND_MAX));
						tempG = (double)newtrackernode->IniHalfW;//   + (((double)IniSampleRangeHalfW) -((double)IniSampleRangeHalfW*2*rand()/RAND_MAX));
						tempH = (double)newtrackernode->IniHalfH;//  + (((double)IniSampleRangeHalfH) -((double)IniSampleRangeHalfH*2*rand()/RAND_MAX));
		
						tempI = (tempE > 0)?tempE:0;
						tempJ = (tempF > 0)?tempF:0;
						tempK = (tempG > 5)?tempG:5;
						tempL = (tempH > 5)?tempH:5;
	 				
						newtrackernode->PPostion[i][0]	=	(tempI < FrameW-1)?tempI:FrameW-1;
 	  					newtrackernode->PPostion[i][1]	=	(tempJ < FrameH-1)?tempJ:FrameH-1;
						newtrackernode->PBoxWH[i][0]	=	(tempK < 200)?tempK:200;
 	  					newtrackernode->PBoxWH[i][1]	=	(tempL < 150)?tempL:150;
						//newtrackernode->PPostion[i][0]	=	min(FrameW-1, max(0,newtrackernode->IniPx + ((newtrackernode->IniHalfW) - (newtrackernode->IniHalfW*2*rand()/RAND_MAX))));
						//newtrackernode->PPostion[i][1]	=	min(FrameH-1, max(0,newtrackernode->IniPy + ((newtrackernode->IniHalfH) -(newtrackernode->IniHalfH*2*rand()/RAND_MAX))));
						//newtrackernode->PBoxWH[i][0]	=	min(200, max(5,newtrackernode->IniHalfW   + ((IniSampleRangeHalfW) -(IniSampleRangeHalfW*2*rand()/RAND_MAX))));
						//newtrackernode->PBoxWH[i][1]	=	min(150, max(5,newtrackernode->IniHalfH  + ((IniSampleRangeHalfH) -(IniSampleRangeHalfH*2*rand()/RAND_MAX))));
						//newtrackernode->PWeight[i]		=	1/NumParticleonObject;
					}

					TotalHistogramValue = 0;//2. Target Model : color histogram
					TotalHistogramValuet = 0;
					diag = (float)sqrt((float)(newtrackernode->IniHalfW*newtrackernode->IniHalfW + newtrackernode->IniHalfH*newtrackernode->IniHalfH));
               newtrackernode->totalhistogram = 0;
					
					
					centroid[0] = (max(0,newtrackernode->IniPy-newtrackernode->IniHalfH_B) + min(FrameH-1, newtrackernode->IniPy + newtrackernode->IniHalfH_B)) / 2;
					centroid[1] = (max(0,newtrackernode->IniPx-newtrackernode->IniHalfW_B) + min(FrameW-1, newtrackernode->IniPx + newtrackernode->IniHalfW_B)) / 2;
					
					TempHistValue = 1;
					for(k = 0; k < 128; k++){
                  newtrackernode->HistogramTarget_Y_O[k] = 0;
                  newtrackernode->HistogramTarget_Y_E[k] = 0;
                  newtrackernode->HistogramTarget_U_O[k] = 0;
                  newtrackernode->HistogramTarget_U_E[k] = 0;
                  newtrackernode->HistogramTarget_V_O[k] = 0;
                  newtrackernode->HistogramTarget_V_E[k] = 0;
               }//end for k
               for(k = 0; k < 256; k++){
					   flag_Y_w[k] =0;
                  flag_U_w[k] =0;
                  flag_V_w[k] =0;

               }
					
					for(k=max(0,newtrackernode->IniPy-newtrackernode->IniHalfH); k<= min(FrameH-1, newtrackernode->IniPy + newtrackernode->IniHalfH); ++k){
 	  					for(l=max(0,newtrackernode->IniPx-newtrackernode->IniHalfW); l< min(FrameW-1, newtrackernode->IniPx + newtrackernode->IniHalfW-1); l+=2){
 	  						//if(k<0) k=0;
 	  						//if(k>=FrameH) k=FrameH-1;
 	  						//if(l<0) l=0;
 	  						//if(l>=FrameW) l=FrameW-1;
                     //newtrackernode->totalhistogram+= (segbufferY[k*FrameW + l] !=0 ? 1 : 0) + ( segbufferY[k*FrameW + l + 1] != 0 ? 1 : 0);
 	  						if(CENTER)
								TempHistValue = diag - ( sqrt((float)( (k - centroid[0])*(k - centroid[0]) +   (l - centroid[1])*(l - centroid[1])))) + 1;
							else
								TempHistValue = 1;
							TotalHistogramValue+=2*TempHistValue;
							BU(framebufferY[k*FrameW + l], framebufferY[k*FrameW + l + 1], framebufferU[k/2*FrameW2+ l/2], framebufferU[k/2*FrameW2+ (l+1)/2], framebufferV[k/2*FrameW2+ l/2] , framebufferV[k/2*FrameW2+ (l+1)/2], 
								
							TempHistValue, TempHistValue, TempHistValue, TempHistValue, TempHistValue, TempHistValue, flag_Y_w, flag_U_w, flag_V_w, newtrackernode->HistogramTarget_Y_E, newtrackernode->HistogramTarget_Y_O, newtrackernode->HistogramTarget_U_E, newtrackernode->HistogramTarget_U_O, newtrackernode->HistogramTarget_V_E, newtrackernode->HistogramTarget_V_O,  segbufferY[k*FrameW + l],segbufferY[k*FrameW + l + 1]);
 	  						}
	 	  				
 	  				}

               for(k = 0; k < 128; k++){
                  newtrackernode->totalhistogram += newtrackernode->HistogramTarget_Y_E[k] + newtrackernode->HistogramTarget_Y_O[k] ;
               }
					totalweight = 0;
//					time3 = clock();
					for(k=(newtrackernode->IniPy-newtrackernode->IniHalfH);k<=(newtrackernode->IniPy + newtrackernode->IniHalfH); ++k){
						FrameDisplayY[k*FrameW + newtrackernode->IniPx - newtrackernode->IniHalfW] = newtrackernode->colory;
	 	  				FrameDisplayY[k*FrameW + newtrackernode->IniPx + newtrackernode->IniHalfW] = newtrackernode->colory;
						FrameDisplayU[k/2*FrameW2 + (newtrackernode->IniPx - newtrackernode->IniHalfW)/2 ] = newtrackernode->coloru;
	 	  				FrameDisplayU[k/2*FrameW2 + (newtrackernode->IniPx + newtrackernode->IniHalfW)/2] = newtrackernode->coloru;
						FrameDisplayV[k/2*FrameW2 + (newtrackernode->IniPx - newtrackernode->IniHalfW)/2 ] = newtrackernode->colorv;
	 	  				FrameDisplayV[k/2*FrameW2 + (newtrackernode->IniPx + newtrackernode->IniHalfW)/2] = newtrackernode->colorv;

 	  				}
 	  				for(l=(newtrackernode->IniPx-newtrackernode->IniHalfW);l<=(newtrackernode->IniPx + newtrackernode->IniHalfW); ++l){
 	  					FrameDisplayY[(newtrackernode->IniPy - newtrackernode->IniHalfH)*FrameW + l] = newtrackernode->colory;
 	  					FrameDisplayY[(newtrackernode->IniPy + newtrackernode->IniHalfH)*FrameW + l] = newtrackernode->colory;
						FrameDisplayU[(newtrackernode->IniPy - newtrackernode->IniHalfH)/2*FrameW2 + (l)/2] = newtrackernode->coloru;
 	  					FrameDisplayU[(newtrackernode->IniPy + newtrackernode->IniHalfH)/2*FrameW2 + (l)/2] = newtrackernode->coloru;
						FrameDisplayV[(newtrackernode->IniPy - newtrackernode->IniHalfH)/2*FrameW2 + (l)/2] = newtrackernode->colorv;
 	  					FrameDisplayV[(newtrackernode->IniPy + newtrackernode->IniHalfH)/2*FrameW2 + (l)/2] = newtrackernode->colorv;
 		  			}
					//time4 = clock();
					//timeSF += time4 - time3;



					numoftracker++;
					doneadd = true;
				//}
				
			}//end if
		
			nownode = nownode->right;
			delete nownode->left;
			



		}//end while
		//time2 = clock();
		//timeAT += time2 - time1 - timeSF;
//		delete nownode->left;
		root->right = end;
		end->left = root;


/*************************************************************************************************************/
		if(debugfout == 1) ftime << "Frame:\t" << f << endl;
		if(debugfout == 1) ftime << "\t\tConnecting Component Analysis:\t" << timeCCA << endl;
		if(debugfout == 1) ftime << "\t\tSampling + Importance:\t" << timeWeightUpdate << endl;
		if(debugfout == 1) ftime << "\t\tDistance:\t" << timeDistance << endl;
		if(debugfout == 1) ftime << "\t\tEstimation of object current state:\t" << timeEO << endl;
		if(debugfout == 1) ftime << "\t\tUpdate Target Model:\t" << timeUTM << endl;
		if(debugfout == 1) ftime << "\t\tDelete Tracker:\t" << timeDT << endl;
		if(debugfout == 1) ftime << "\t\tAdd Tracker:\t" << timeAT << endl;
		

		fwrite ( FrameDisplayY, 1, FrameH*FrameW, fpout1);			
		fwrite ( FrameDisplayU, 1, FrameH2*FrameW2, fpout1);			
		fwrite ( FrameDisplayV, 1, FrameH2*FrameW2, fpout1);
		

		for(i = 0; i < counter; i++){
			delete [] countseg[i];
		}//end for i
		delete [] countseg;
		
		//if(f == 182) system("pause");
	}
	time2 = clock();

	double timing = (double)(time2 - time1) / (double) (SeqSize-1) / CLOCKS_PER_SEC;

	return 0;


	
}




float grandom(){
	float x1, x2, y1;//, y2, w;
	

	x1 = (float)rand()/(float)RAND_MAX;
	x2 = (float)rand()/(float)RAND_MAX;
	y1 = sqrt( - 2 * log(x1) ) * cos( 2 * 3.1415926 * x2);
	return y1;

}

