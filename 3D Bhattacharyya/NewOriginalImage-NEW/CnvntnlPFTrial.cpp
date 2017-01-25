#include "CnvntnlPFTrial.h"
#include <ctime>
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <cmath>
#include <map>
#include "segnode.h"
#include "tracker.h"
#include <vector>
#include "emd.h"
#include "BD.h"
#include "diffusion.h"

#define ColorThreshold 0
#define HistogramThreshold 0
//#define StartFrame 340
#define AreaThreshold FrameH * FrameW * 0.005
#define apha 0
#define ConfidenceThreshold -0.001
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

#define WeightThresholdDD 2500000000//500
#define WeightThresholdBD 50
#define WeightThresholdEMD 50
#define MAX_TRACKER 1

#define BlockSize 1
#define Percent BlockSize*BlockSize*0.9

#define Space 0

#define G 100

#define CENTER 0  //CENTER: 1 CENTER

#define NOPARTICLE 10
#define BHistogramThreshold 0
#define BColorThreshold 0
#define Bguse 0





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
	//ofstream if(debugfout == 1) fouttest3("test3.txt", ios::app);
	
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

	map<int,int> area;
    map<int,int>::iterator iter;
    map<int,int>::iterator itersort;
	float TotalHistgramValuet, TotalHistogramValue1, TotalHistogramValue2;
	float* WeightC;
	//float* WeightT;
	float totalweight;
	int centroid[2];
	tracker* nowtracker;
	segnode* nownode;
	float Distance;
	float EMDtotal;
	double tempPBoxW1, tempPBoxH1;
	double temptempy, temptempx;
	double tempPBoxW2, tempPBoxH2;
	int temphistogramb;
	double maxweight, maxx, maxy, maxw, maxh;
	double maxweight1, maxx1, maxy1, maxw1, maxh1;
	double maxweight2, maxx2, maxy2, maxw2, maxh2;
	double maxweight3, maxx3, maxy3, maxw3, maxh3;
	double maxweight4, maxx4, maxy4, maxw4, maxh4;
	double maxweight5, maxx5, maxy5, maxw5, maxh5;
	double maxweight6, maxx6, maxy6, maxw6, maxh6;
	double maxweight7, maxx7, maxy7, maxw7, maxh7;
	double maxweight8, maxx8, maxy8, maxw8, maxh8;
	double maxweight9, maxx9, maxy9, maxw9, maxh9;
	double maxweight10, maxx10, maxy10, maxw10, maxh10;

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
	strncat(filename, "_bg_3D.yuv", strlen("_bg_3D.yuv"));
	fbg = fopen(filename,"wb");


	ofstream fouttest;
	ofstream ftime;
	ofstream fposttracker, fpostseg;

	if(Choose == 0){
		strcpy(filename, argv[1]);
		strncat(filename, "_bonding_NO_EMD_3D.y", strlen("_bonding_NO_EMD_3D.y"));
		fbonding = fopen(filename,"wb");
		//fpout0 = fopen(filename,"wb");
		strcpy(filename, argv[1]);
		strncat(filename, "_object_NO_EMD_3D.yuv", strlen("_object_NO_EMD_3D.yuv"));
		fpout1 = fopen(filename,"wb");

		

		strcpy(filename, argv[1]);
		strncat(filename, "_test_NO_EMD_3D.txt", strlen("_test_NO_EMD_3D.txt"));
		if(debugfout == 1) fouttest.open(filename);

		strcpy(filename, argv[1]);
		strncat(filename, "_time_NO_EMD_3D.txt", strlen("_time_NO_EMD_3D.txt"));
		if(debugfout == 1) ftime.open(filename);
		//nowtracker->GaussianKernel = 1;
	}
	else if(Choose == 1){
		strcpy(filename, argv[1]);
		strncat(filename, "_bonding_NO_DD_3D.y", strlen("_bonding_NO_DD_3D.y"));
		fbonding = fopen(filename,"wb");
		//fpout0 = fopen(filename,"wb");
		strcpy(filename, argv[1]);
		strncat(filename, "_object_NO_DD_3D.yuv", strlen("_object_NO_DD_3D.yuv"));
		fpout1 = fopen(filename,"wb");

		strcpy(filename, argv[1]);
		strncat(filename, "_test_NO_DD_3D.txt", strlen("_test_NO_DD_3D.txt"));
		if(debugfout == 1) fouttest.open(filename);

		strcpy(filename, argv[1]);
		strncat(filename, "_time_NO_DD_3D.txt", strlen("_time_NO_DD_3D.txt"));
		if(debugfout == 1) ftime.open(filename);
		//nowtracker->GaussianKernel = 20000;
	}

	else if(Choose == 2){
		strcpy(filename, argv[1]);
		strncat(filename, "_bonding_NO_BD_3D.y", strlen("_bonding_NO_BD_3D.y"));
		fbonding = fopen(filename,"wb");
		//fpout0 = fopen(filename,"wb");
		strcpy(filename, argv[1]);
		strncat(filename, "_object_NO_BD_3D.yuv", strlen("_object_NO_BD_3D.yuv"));
		fpout1 = fopen(filename,"wb");

		strcpy(filename, argv[1]);
		strncat(filename, "_test_NO_BD_3D.txt", strlen("_test_NO_BD_3D.txt"));
		if(debugfout == 1) fouttest.open(filename);

		strcpy(filename, argv[1]);
		strncat(filename, "_time_NO_BD_3D.txt", strlen("_time_NO_BD_3D.txt"));
		if(debugfout == 1) ftime.open(filename);
		//nowtracker->GaussianKernel = 160000;

		strcpy(filename, argv[1]);
		strncat(filename, "_position_NO_BD_3D.txt", strlen("_position_NO_BD_3D.txt"));
		fposttracker.open(filename);

		strcpy(filename, argv[1]);
		strncat(filename, "_answer_NO_BD_3D.txt", strlen("_answer_NO_BD_3D.txt"));
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


	framebufferY = new unsigned char [FrameH*FrameW];
	framebufferU = new unsigned char [FrameH2*FrameW2];
	framebufferV = new unsigned char [FrameH2*FrameW2];

	bg_Y = new unsigned char [FrameH*FrameW];
	bg_U = new unsigned char [FrameH2*FrameW2];
	bg_V = new unsigned char [FrameH2*FrameW2];

	segbufferY = new unsigned int [FrameH*FrameW];
	//float HistogramTarget[NumHistBin];
	//float HistogramCandidate[NumHistBin];
	vector<float> HistogramCandidate;
	vector<float> HistogramBackground;

	vector<float> LearningHistogram;
	vector<float> LearningHistogram_B;
	float TotalHistgramValue;
	float diag;
//	int TempBinIdx;
	float TempHistValue;
	float SumofWeight;
	float BhaCoef;
//	float BhaDist2;
	int NumRes;
	int ResPPostion[NumParticleonObject][2];// 0 =x, 1 =y
	int ResPBoxWH[NumParticleonObject][2]; // 0 = width, 1= height
	float ResPWeight[NumParticleonObject];
	bool donehistogram;
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
	map<int,int> sort;
	float VarWU, StdWU;
	float mindist;

	segnode* tempnode1;
	segnode* tempnode2;
	

	
	
	
	feature_t* f2;

	signature_t s2;
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
/*	
	

	for(k=0;k<FrameH;++k){//display the object initial position
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
*//*	for(k=IniPy-IniHalfH;k<=IniPy + IniHalfH; ++k){
		FrameDisplayY[k*FrameW + IniPx-IniHalfW] = 0;
		FrameDisplayY[k*FrameW + IniPx+IniHalfW] = 0;
	}
	for(l=IniPx-IniHalfW;l<=IniPx + IniHalfW; ++l){
		FrameDisplayY[(IniPy - IniHalfH)*FrameW + l] = 0;
		FrameDisplayY[(IniPy + IniHalfH)*FrameW + l] = 0;
	}
*/
	/*
	fwrite ( FrameDisplayY, 1, FrameH*FrameW, fpout0);			
	fwrite ( FrameDisplayU, 1, FrameH2*FrameW2, fpout0);			
	fwrite ( FrameDisplayV, 1, FrameH2*FrameW2, fpout0);
	fclose(fpout0);
	*/
/*
	clock2 = clock();
	timing = (double)(clock2-clock1);
	if(debugcout == 1) cout << "Display the objeckt initial position: \t"<< timing<<endl;

	clock1 = clock();
	for(i=0;i<NumParticleonObject;++i){//1. particle initialization
		PPostion[i][0]	=	IniPx + ((IniSampleRangePx/2) - (IniSampleRangePx*rand()/RAND_MAX));
		PPostion[i][1]	=	IniPy + ((IniSampleRangePy/2) -(IniSampleRangePy*rand()/RAND_MAX));
		PBoxWH[i][0]	=	IniHalfW   + ((IniSampleRangeHalfW/2) -(IniSampleRangeHalfW*rand()/RAND_MAX));
		PBoxWH[i][1]	=	IniHalfH  + ((IniSampleRangeHalfH/2) -(IniSampleRangeHalfH*rand()/RAND_MAX));
		PWeight[i]		=	1/NumParticleonObject;
	}
	clock2 = clock();
	timing = (double)(clock2-clock1);
	if(debugcout == 1) cout << "Particle Initialization: \t"<< timing<<endl;

    clock1 = clock();

	TotalHistgramValue = 0;//2. Target Model : color histogram
	diag = (float)sqrt((float)(IniHalfW*IniHalfW + IniHalfH*IniHalfH));
	for(j=0;j<NumHistBin;++j){
		HistogramTarget[j] = 0;
		for(k=IniPy-IniHalfH; k<= IniPy + IniHalfH; ++k){
			for(l=IniPx-IniHalfW; l<= IniPx + IniHalfW; ++l){
				if(k<0) k=0;
				if(k>=FrameH) k=FrameH-1;
				if(l<0) l=0;
				if(l>=FrameW) l=FrameW-1;
				TempBinIdx = (int)(framebufferY[k*FrameW + l]/NumYBin) * NumUSubBin * NumVSubBin + (int)(framebufferU[k*FrameW2 + l]/NumUSubBin) * NumVSubBin + (int)(framebufferV[k*FrameW2 + l]/NumVSubBin) ;
				if(TempBinIdx == j){
					 TempHistValue = EpanechnikovKenerlConst*(1 - ( (float)sqrt((float)( (k - IniPy)*(k - IniPy) +   (l - IniPx)*(l - IniPx)) )/diag) );
					HistogramTarget[j] += TempHistValue;
					TotalHistgramValue += TempHistValue;
				}
			}
		}
	}
	for(j=0;j<NumHistBin;++j){// histogram normalization
		HistogramTarget[j] = HistogramTarget[j]/TotalHistgramValue;
	}

	clock2 = clock();
	timing = (double)(clock2-clock1);
	if(debugcout == 1) cout << "Target Model : clock histogram: \t"<< timing<<endl;
*/
    

	//int countk;
	
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
			cout << "here" << endl;
			fwrite (bg_Y, 1, FrameH*FrameW, fbg);
			fwrite (bg_U, 1, FrameH2*FrameW2, fbg);
			fwrite (bg_V, 1, FrameH2*FrameW2, fbg);
		}
		
/*		countk = fgetc(fcolor);
		for(i = 0; i < countk*4; i++){
			fgetc(fcolor);
		}*/
		//if(debugcout == 1) cout << "countk: " << countk << endl;
		
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
		
		//system("pause");
		if(debugcout == 1) cout << "frame: " << f << endl;
		if(debugfout == 1) fouttest << "frame: " << f << endl;
		//if(debugfout == 1) fouttest3 << "frame: " << f << endl;
		//if(f == StartFrame){
		fposttracker << endl;
		fpostseg << endl;

		fread ( framebufferY, 1, FrameH*FrameW, fpin);			

		fread ( framebufferU, 1, FrameH2*FrameW2, fpin);			

		fread ( framebufferV, 1, FrameH2*FrameW2, fpin);


		//}
//		countk = fgetc(fcolor);
		//if(debugcout == 1) cout << "countk: " << countk << endl;
//		f2 = new feature_t [countk];
		
/*
		for(i = 0; i < countk; i++){
			f2[i].X = fgetc(fcolor);
			f2[i].Y = fgetc(fcolor);
			f2[i].Z = fgetc(fcolor);
			fgetc(fcolor);
		}
		s2.n = countk;
		s2.Features = f2;
*/	
	
	
		position = 0;
	


		IDcount = 0;
		//if(f == StartFrame)
		for(j = 0; j < FrameH*FrameW; j++)
			segbufferY[j] = fgetc(fseg);
		time1 = clock();
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
/*    
	   		   if(segbufferY[(j-1)*FrameW + max(0,i - 1)] != 0){
                     smallest = temp_img[(j-1)*FrameW + max(0,i - 1)];
                     position = max(0,i - 1);
                     while((position >= 0) && (segbufferY[j*FrameW + position] != 0) && ((temp_img[j*FrameW + position] > smallest)||(temp_img[j*FrameW + position] == 0))){                   
                        temp_img[j*FrameW + position] = smallest;
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
  /*  
	   		if((temp_img[j*FrameW + i] != 0) && (temp_img[min((j+1)*FrameW + i + 1, FrameW * FrameH - 1)] != 0) && (temp_img[(j+1)*FrameW + i] < (temp_img[j*FrameW + i]))){
                  position = min(i+1, FrameH-1);
                  smallest = temp_img[min((j+1)*FrameW + i + 1, FrameW * FrameH - 1)];
                  while((position <= FrameW -1) && (temp_img[j*FrameW + position] != 0) && (temp_img[j*FrameW + position] > smallest)){                   
                     temp_img[j*FrameW + position] = smallest;
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
/*    
	   		if((temp_img[j*FrameW + i] != 0) && (temp_img[(j-1)*FrameW + max(0, i-1)] != 0) && (temp_img[(j-1)*FrameW + i] < (temp_img[j*FrameW + i]))){
                  position = max(0, i-1);
                  smallest = temp_img[(j-1)*FrameW + max(0, i-1)];
                  while((position > 0) && (temp_img[j*FrameW + position] != 0) && (temp_img[j*FrameW + position] > smallest)){                   
                     temp_img[j*FrameW + position] = smallest;
                     position--;
                  }//end while
               }//end if
  */  
            }//end j < 511
            
            
         }//end inner for i
      }//end outer for j
    
    
    
/******************************************************************/
/*                                      Area > AreaThreshold                                       */
/******************************************************************/
      area.clear();
	  iter = area.begin();
	  sort.clear();
	  itersort = sort.begin();
      
      for(j = 0; j <  FrameH; j++){
         for(i = 0; i <  FrameW; i++){
			iter = area.begin();
            if(temp_img[j*FrameW + i] != 0){
               iter = area.find(temp_img[j*FrameW + i]);
               if(iter == area.end()){
                  //area[(temp_img[j*FrameW + i])] = 1;
				   area.insert(make_pair(temp_img[j*FrameW + i], 1));
               }//end if iter == area.end
               else{
                  iter->second++;
               }//end else
            }//end if temp_img[j*FrameW + i] != 0
         }//end for i
      }//end for j
    
      counter = 1;
      
      for(j = 0; j <  FrameH; j++){
         for(i = 0; i <  FrameW; i++){
            iter = area.find(temp_img[j*FrameW + i]);
            if(iter != area.end()){
               if(iter->second < AreaThreshold ){
                  temp_img[j*FrameW + i] = 0; 
               }//end if iter->second < 500
               else{
                  itersort = sort.find(temp_img[j*FrameW + i]);
                  if(itersort == sort.end()){
                     if(temp_img[j*FrameW + i] != 0){
                        sort[(temp_img[j*FrameW + i])] = counter;
                        temp_img[j*FrameW + i] = counter;
                        counter++;
                     }// end if itersort->second != 0
                  }//end if itersort == sort.end()
                  else{
                     temp_img[j*FrameW + i] = itersort->second;
                  }//end if itersort != sort.end()
               }//end if iter->second >= 500
            }//end if iter == area.end
			else{
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


      for(sk = 1; sk <= sort.size(); sk++){
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

	time2 = clock();
	timeCCA = time2 - time1;

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
			time1 = clock();
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
				
				while(tempPBoxW1 >=10 || tempPBoxW1 <= -10) tempPBoxW1 = ((5*grandom())) + 0.5;
				tempPBoxH1 = ((5*grandom())) + 0.5;			

                while(tempPBoxH1 >=10 || tempPBoxH1 <= -10) tempPBoxH1 = ((5*grandom())) + 0.5;

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

				
 	  
 	  			//Importance 1(Weight update)
 	  			TotalHistgramValue = 0;//histogram
 	  			diag = (float)sqrt((float)(nowtracker->PBoxWH[i][0]*nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1]*nowtracker->PBoxWH[i][1]));
/* 	  			for(j=0;j<NumHistBin;++j){
 	  				HistogramCandidate[j] = 0;
				}*/
				centroid[0] = (max(0,nowtracker->PPostion[i][1]-nowtracker->PBoxWH[i][1]) + min(FrameH-1, nowtracker->PPostion[i][1] + nowtracker->PBoxWH[i][1])) / 2;
				centroid[1] = (max(0, nowtracker->PPostion[i][0]-nowtracker->PBoxWH[i][0]) + min(FrameW-1, nowtracker->PPostion[i][0] + nowtracker->PBoxWH[i][0])) / 2;
				HistogramCandidate.clear();
				HistogramBackground.clear();
 	  			for(k=max(0,nowtracker->PPostion[i][1]-nowtracker->PBoxWH[i][1]); k<= min(FrameH-1, nowtracker->PPostion[i][1] + nowtracker->PBoxWH[i][1]); ++k){
 	  				for(l=max(0, nowtracker->PPostion[i][0]-nowtracker->PBoxWH[i][0]); l<= min(FrameW-1, nowtracker->PPostion[i][0] + nowtracker->PBoxWH[i][0]); ++l){
 	  					//if(k<0) k=0;
 	  					//if(k>=FrameH) k=FrameH-1;
 	  					//if(l<0) l=0;
 	  					//if(l>=FrameW) l=FrameW-1;
 	  					//TempBinIdx = (int)(framebufferY[k*FrameW + l]*NumYBin/256) * NumUSubBin * NumVSubBin + (int)(framebufferU[k*FrameW2 + l]*NumUSubBin/256) * NumVSubBin + (int)(framebufferV[k*FrameW2 + l]*NumVSubBin/256) ;
						//TempBinIdx = (int)(framebufferY[k*FrameW + l] * NumUSubBin * NumVSubBin) + (int)(framebufferU[k*FrameW2 + l]) * NumVSubBin + (int)(framebufferV[k*FrameW2 + l]) ;
						
 	  					//TempHistValue = EpanechnikovKenerlConst*(1 - ( sqrt((float)( (k - nowtracker->PPostion[i][1])*(k - nowtracker->PPostion[i][1]) +   (l - nowtracker->PPostion[i][0])*(l - nowtracker->PPostion[i][0])) )/diag ));
						TempHistValue = 1;
 	  					donehistogram = false;
						for(j= 0; j < HistogramCandidate.size(); j+=4){
								if(//segbufferY[k*FrameW + l] != 0 &&
									(HistogramCandidate[j] >= framebufferY[k*FrameW + l] - HistogramThreshold && HistogramCandidate[j] <= framebufferY[k*FrameW + l] + HistogramThreshold) && 
									(HistogramCandidate[j+1] >= framebufferU[k/2*FrameW2 + l/2] - HistogramThreshold && HistogramCandidate[j+1] <= framebufferU[k/2*FrameW2 + l/2] + HistogramThreshold) &&
									(HistogramCandidate[j+2] >= framebufferV[k/2*FrameW2 + l/2] - HistogramThreshold && HistogramCandidate[j+2] <= framebufferV[k/2*FrameW2 + l/2] + HistogramThreshold) 	){
									donehistogram = true;
									if(CENTER == 1){
										HistogramCandidate[j+3] += (255 - sqrt((float)(k-centroid[0]) * (k-centroid[0]) + (l - centroid[1]) * (l - centroid[1])) / sqrt((float)nowtracker->PBoxWH[i][0] * nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][1]) * 255);
										
										TotalHistgramValue+= (255 - sqrt((float)(k-centroid[0]) * (k-centroid[0]) + (l - centroid[1]) * (l - centroid[1])) / sqrt((float)nowtracker->PBoxWH[i][0] * nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][1]) * 255);
									}
									else{
										HistogramCandidate[j+3] += 1;
										TotalHistgramValue++;
										
									}
									//TotalHistgramValue+= HistogramCandidate[j+3];
									break;
								}//end if
						}
						if(!donehistogram/* && segbufferY[k*FrameW + l] != 0*/){
							HistogramCandidate.push_back(framebufferY[k*FrameW + l]);
							HistogramCandidate.push_back(framebufferU[k/2*FrameW2 + l/2]);
							HistogramCandidate.push_back(framebufferV[k/2*FrameW2 + l/2]);
							if(CENTER == 1){
								HistogramCandidate.push_back(255 - sqrt((float)(k-centroid[0]) * (k-centroid[0]) + (l - centroid[1]) * (l - centroid[1])) / sqrt((float)nowtracker->PBoxWH[i][0] * nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][1]) * 255);
								TotalHistgramValue +=  (255 - sqrt((float)(k-centroid[0]) * (k-centroid[0]) + (l - centroid[1]) * (l - centroid[1])) / sqrt((float)nowtracker->PBoxWH[i][0] * nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][1]) * 255);
							}
							else{
								HistogramCandidate.push_back(1);
								TotalHistgramValue ++;
							
							}
						}//end if


						temphistogramb = 1;
 	  					donehistogram = false;
						for(j= 0; j < HistogramBackground.size(); j+=4){
								if((HistogramBackground[j] >= bg_Y[k*FrameW + l] - BHistogramThreshold && HistogramBackground[j] <= bg_Y[k*FrameW + l] + BHistogramThreshold) && 
									(HistogramBackground[j+1] >= bg_U[k/2*FrameW2 + l/2] - BHistogramThreshold && HistogramBackground[j+1] <= bg_U[k/2*FrameW2 + l/2] + BHistogramThreshold) &&
									(HistogramBackground[j+2] >= bg_V[k/2*FrameW2 + l/2] - BHistogramThreshold && HistogramBackground[j+2] <= bg_V[k/2*FrameW2 + l/2] + BHistogramThreshold) 	){
									donehistogram = true;
									if(CENTER == 1){
										HistogramBackground[j+3] += (255 - sqrt((float)(k-centroid[0]) * (k-centroid[0]) + (l - centroid[1]) * (l - centroid[1])) / sqrt((float)nowtracker->PBoxWH[i][0] * nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][1]) * 255);
										temphistogramb += (255 - sqrt((float)(k-centroid[0]) * (k-centroid[0]) + (l - centroid[1]) * (l - centroid[1])) / sqrt((float)nowtracker->PBoxWH[i][0] * nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][1]) * 255);
									}
									else{
										HistogramBackground[j+3] += 1;
										temphistogramb ++;
										
									}
									//temphistogramb+= HistogramBackground[j+3];
									break;
								}//end if
						}
						if(!donehistogram){
							HistogramBackground.push_back(bg_Y[k*FrameW + l]);
							HistogramBackground.push_back(bg_U[k/2*FrameW2 + l/2]);
							HistogramBackground.push_back(bg_V[k/2*FrameW2 + l/2]);
							if(CENTER == 1){
								HistogramBackground.push_back(255 - sqrt((float)(k-centroid[0]) * (k-centroid[0]) + (l - centroid[1]) * (l - centroid[1])) / sqrt((float)nowtracker->PBoxWH[i][0] * nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][1]) * 255);
								temphistogramb +=  (255 - sqrt((float)(k-centroid[0]) * (k-centroid[0]) + (l - centroid[1]) * (l - centroid[1])) / sqrt((float)nowtracker->PBoxWH[i][0] * nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][1]) * 255);
							}
							else{
								HistogramBackground.push_back(1);
								temphistogramb ++;
							
							}
						}//end if


						//HistogramCandidate[j] +=int (TempHistValue*128)/128;
 	  					//TotalHistgramValue += TempHistValue;

							
							
 	  					
						if(segbufferY[k*FrameW+l] != 0){
							maxcountseg[i]++;
							
/*
							while(nownode != end){
								if(k >= nownode->upbound && k <= nownode->downbound && l >= nownode->leftbound && l <= nownode->rightbound){
									//countseg[nownode->ID][i]++;
									//if(countseg[nownode->ID][i] > maxcountseg[i])maxcountseg[i] = countseg[nownode->ID][i];
									//nownode->newtracker = false;
									nownode->countpass++;
								}//end if
								nownode = nownode->right;
							}//end while
*/								
						}//end if
							

 	  				}
 	  			}
 	  			
 				
 	  			BhaCoef = 0;
				NCi = 0;
				NBCi = 0;
				f2 = new feature_t[HistogramCandidate.size()/4];
				//if(debugcout == 1) cout << "\t\tCandidate Size: " << HistogramCandidate.size()/4 << endl;
				s2.n = HistogramCandidate.size()/4;
				WeightC = new float[HistogramCandidate.size()/4];
				totalweight = 0;
				for(j=3;j<HistogramBackground.size();j+=4)// histogram normalization
 	  				HistogramBackground[j] = HistogramBackground[j]*100/temphistogramb;
 	  			for(j=3;j<HistogramCandidate.size();j+=4){// histogram normalization
 	  				HistogramCandidate[j] = HistogramCandidate[j]*100/TotalHistgramValue;
					
 	  				//BhaCoef += sqrt(HistogramCandidate[j]*nowtracker->HistogramTarget[j]); //calculating Bhattacharyya Coefficient
					//if(i >= 35) if(debugcout == 1) cout << "BhaCoef: " << BhaCoef << " HistogramCaondidate " << HistogramCandidate[j] << " HistogramTarget " << nowtracker->HistogramTarget[j] << endl;
					NCi = 1;
					NBCi = 0;
					for(k = 3; k < nowtracker->HistogramTarget.size(); k+=4){
						if((HistogramCandidate[j-3] >=  nowtracker->HistogramTarget[k-3] - ColorThreshold && HistogramCandidate[j-3] <=  nowtracker->HistogramTarget[k-3] + ColorThreshold) &&
						   (HistogramCandidate[j-2] >=  nowtracker->HistogramTarget[k-2] - ColorThreshold && HistogramCandidate[j-2] <=  nowtracker->HistogramTarget[k-2] + ColorThreshold) &&
						   (HistogramCandidate[j-1] >=  nowtracker->HistogramTarget[k-1] - ColorThreshold && HistogramCandidate[j-1] <=  nowtracker->HistogramTarget[k-1] + ColorThreshold)){
							NCi += (nowtracker->HistogramTarget[k]) ;/// 100*  nowtracker->HistogramTarget[k] / 100;
							//if(HistogramCandidate[j]	*  nowtracker->HistogramTarget[k] < 0) if(debugcout == 1) cout <<"WRONG" << endl;
							//if(debugcout == 1) cout <<NCi << "\t" << HistogramCandidate[j] << "\t" << nowtracker->HistogramTarget[k] << endl;
						}//end if
						

					}//end for k
					for(k = 3; k < HistogramBackground.size(); k+=4){
						
						if((HistogramCandidate[j-3] >=  HistogramBackground[k-3] - BColorThreshold &&HistogramCandidate[j-3] <=  HistogramBackground[k-3] + BColorThreshold) &&
							(HistogramCandidate[j-2] >=  HistogramBackground[k-2] - BColorThreshold && HistogramCandidate[j-2] <=  HistogramBackground[k-2] + BColorThreshold) &&
							(HistogramCandidate[j-1] >=  HistogramBackground[k-1] - BColorThreshold && HistogramCandidate[j-1] <=  HistogramBackground[k-1] + BColorThreshold)){
							NBCi += (HistogramBackground[k]);//
							//if(f>=105) if(debugcout == 1) cout << NBCi<<"\t" << HistogramCandidate[j] <<"\t" << HistogramBackground[k] << endl;
						}//end if

					}//end for k
					f2[(j-3)/4].X = HistogramCandidate[j-3];
					f2[(j-3)/4].Y = HistogramCandidate[j-2];
					f2[(j-3)/4].Z = HistogramCandidate[j-1];
					if(Bguse == 1) WeightC[(j-3)/4] = HistogramCandidate[j] * (NBCi > 10 ? 0.000001 : 1);// *  ((100 + NBCi) / (100));//max((float)0, (float)(NCi - NBCi));//////HistogramCandidate[j];//*(NCi / 1);//;
					else WeightC[(j-3)/4] = HistogramCandidate[j];
					//if(debugcout == 1) cout << "NBCi: " << NBCi << endl;
					//
 	  				totalweight += WeightC[(j-3)/4];
				}
//				nowtracker->PWeight[i] = NCi / (G + NBCi);
				if(totalweight <= 0) {
					if(debugcout == 1) cout << "WEIGHT = 0" << endl;
					if(debugfout == 1) fouttest << "WEIGHT = 0" << endl;
					totalweight = 1;
				}
				for(k = 0; k < HistogramCandidate.size()/4; k++){
					
					WeightC[k] = WeightC[k] *100 / totalweight;
					//if(debugcout == 1) cout << WeightC[k] << endl;
				}//end for k
				s2.Features = f2;
				s2.Weights = WeightC;
				time2 = clock();
				timeWeightUpdate += time2-time1;

 	  			//BhaDist2 = 1-BhaCoef;//calculating Bhattacharyya Distance
				
 	  			//nowtracker->PWeight[i] = exp(-(BhaDist2/(2*VarWU)))/(2.50663*StdWU);//weight update

				//s2.Weights = HistogramCandidate;
				//s1.Weights = nowtracker->HistogramTarget;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
				time1 = clock();
				if(totalweight == 1)
					Distance = 99999999999999999;
				else{
					if(Choose == 0)
						Distance = emd(&nowtracker->s1, &s2, dist, 0, 0);
					else if(Choose == 1)
						Distance = DFdist(&nowtracker->s1, &s2);
					else if(Choose == 2)
						Distance = BDdist(&nowtracker->s1, &s2);
				}
				time2 = clock();
				timeDistance += time2-time1;
				//nowtracker->PWeight[i] = Distance;
				//EMDtotal+=Distance;
				//nowtracker->PWeight[i] = emd(&s1, &s2, dist, 0, 0);//exp(-(Distance/(2*VarWU)))/(2.50663*StdWU);//weight update
				nowtracker->GaussianKernel_temp += Distance;
				if(Distance == 0) nowtracker->PWeight[i] = 0.00001;
				else if(Distance < 0) {
					if(debugcout == 1) cout << "Frame: " << f << endl;
					system("pause");}
				//else if(Choose == 1)nowtracker->PWeight[i] = 1/(Distance-100)*(Distance-100)*(Distance-100)*nowtracker->PBoxWH[i][0]*nowtracker->PBoxWH[i][1];//exp(0-(Distance-50)*(Distance-50)/2/StdWU/StdWU) / StdWU / 2.50663;
				//else nowtracker->PWeight[i] = 1/Distance;//*sqrt((double)(nowtracker->PBoxWH[i][0]*nowtracker->PBoxWH[i][1]));//exp(0-(Distance-50)*(Distance-50)/2/StdWU/StdWU) / StdWU / 2.50663;
				else if(Choose == 1) nowtracker->PWeight[i] = exp(0-Distance/nowtracker->GaussianKernel*1);//*pow((1-(double)abs((double)nowtracker->PBoxWH[i][0] - (double)nowtracker->ObjectBoxW)/(double)max(nowtracker->PBoxWH[i][0], nowtracker->ObjectBoxW)) ;//* (1-(double)abs((double)nowtracker->PBoxWH[i][1] - (double)nowtracker->ObjectBoxH)/(double)max(nowtracker->PBoxWH[i][1], nowtracker->ObjectBoxH)), 1) * pow((double)(nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][0]),5);// * nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][0];
				else if(Choose == 2) nowtracker->PWeight[i] = exp(0-Distance/nowtracker->GaussianKernel*3)*pow((1-(double)abs((double)nowtracker->PBoxWH[i][0] - (double)nowtracker->ObjectBoxW)/(double)max(nowtracker->PBoxWH[i][0], nowtracker->ObjectBoxW)) * (1-(double)abs((double)nowtracker->PBoxWH[i][1] - (double)nowtracker->ObjectBoxH)/(double)max(nowtracker->PBoxWH[i][1], nowtracker->ObjectBoxH)), 1);
				else if(Choose == 0) nowtracker->PWeight[i] = exp(0-Distance/nowtracker->GaussianKernel*pow((1-(double)abs((double)nowtracker->PBoxWH[i][0] - (double)nowtracker->ObjectBoxW)/(double)max(nowtracker->PBoxWH[i][0], nowtracker->ObjectBoxW)) * (1-(double)abs((double)nowtracker->PBoxWH[i][1] - (double)nowtracker->ObjectBoxH)/(double)max(nowtracker->PBoxWH[i][1], nowtracker->ObjectBoxH)), 0.25));
				else nowtracker->PWeight[i] = 1/Distance*pow((1-(double)abs((double)nowtracker->PBoxWH[i][0] - (double)nowtracker->ObjectBoxW)/(double)nowtracker->ObjectBoxW) * (1-(double)abs((double)nowtracker->PBoxWH[i][1] - (double)nowtracker->ObjectBoxH)/(double)nowtracker->ObjectBoxH), 4);
				if(nowtracker->PWeight[i] < 0) nowtracker->PWeight[i] = 0;
				//if(debugcout == 1) cout << pow((1-(double)abs((double)nowtracker->PBoxWH[i][0] - (double)nowtracker->ObjectBoxW)/(double)nowtracker->ObjectBoxW) * (1-(double)abs((double)nowtracker->PBoxWH[i][1] - (double)nowtracker->ObjectBoxH)/(double)nowtracker->ObjectBoxH), 4) << endl;
					//exp(-(Distance/(2*VarWU)))/(2.50663*StdWU);
				
				SumofWeight += nowtracker->PWeight[i];

				if(debugfout == 1) fouttest << "\t\t\tX: "<<nowtracker->PPostion[i][0] << " Y: " << nowtracker->PPostion[i][1] << " Width: " << nowtracker->PBoxWH[i][0]*2 << " Height: " << nowtracker->PBoxWH[i][1]*2 <<endl;
				if(debugfout == 1) fouttest << "\t\t\t\tWeight: " << nowtracker->PWeight[i] << endl;
				if(debugfout == 1) fouttest << "\t\t\t\tEMD: " << Distance << endl;
					
 	  			//SumofWeight += nowtracker->PWeight[i];
				delete [] WeightC;
				delete [] f2;
				
					
			}
			nowtracker->GaussianKernel = nowtracker->GaussianKernel_temp/NumParticleonObject/5;

			//timeWeightUpdate/=NumParticleonObject;
			//timeDistance /= NumParticleonObject;
			/*EMDtotal/=NumParticleonObject;
			VarWU = 0;
			StdWU = 0;
			for(i=0;i<NumParticleonObject;i++){
				//if(nowtracker->PWeight[i]-EMDtotal+1.75*StdWU >= 0) nowtracker->PWeight[i] = exp(0-(nowtracker->PWeight[i]-EMDtotal+1.75*StdWU)*(nowtracker->PWeight[i]-EMDtotal+1.75*StdWU)/2/StdWU/StdWU) / StdWU / 2.50663;
				//else nowtracker->PWeight[i] = 0;
				VarWU += (nowtracker->PWeight[i] - EMDtotal) * (nowtracker->PWeight[i] - EMDtotal);
				//nowtracker->PWeight[i] = nowtracker->PWeight[i]/SumofWeight + apha*maxcountseg[i]/nowtracker->PBoxWH[i][0] / nowtracker->PBoxWH[i][1]/4;
				//nowtracker->confidence += maxcountseg[i]/nowtracker->PBoxWH[i][0] / nowtracker->PBoxWH[i][1]/NumHistBin/4;
				
				//SumofWeight += nowtracker->PWeight[i];
				
 	  		}
			VarWU/=NumParticleonObject;
			StdWU = sqrt(VarWU);
			if(debugcout == 1) cout << "Standard Deviation: " << StdWU << endl;
			if(debugfout == 1) fouttest << "Standard Deviation: " << StdWU << endl;
			
			for(i=0;i<NumParticleonObject;i++){
				if(debugfout == 1) fouttest << "Before" << endl;
				if(debugfout == 1) fouttest << "\t\t\tX: "<<nowtracker->PPostion[i][0] << " Y: " << nowtracker->PPostion[i][1] << " Width: " << nowtracker->PBoxWH[i][0] << " Height: " << nowtracker->PBoxWH[i][1] <<endl;
				if(debugfout == 1) fouttest << "\t\t\t\tWeight: " << nowtracker->PWeight[i] << endl;
				if(nowtracker->PWeight[i]-0 > 0) //nowtracker->PWeight[i] = exp(0-(nowtracker->PWeight[i]-EMDtotal+1.5*StdWU)*(nowtracker->PWeight[i]-EMDtotal+1.5*StdWU)/2/StdWU/StdWU) / StdWU / 2.50663;
					nowtracker->PWeight[i] = 1/nowtracker->PWeight[i];
				else nowtracker->PWeight[i] = 0;
				if(debugfout == 1) fouttest << "After" << endl;
				if(debugfout == 1) fouttest << "\t\t\tX: "<<nowtracker->PPostion[i][0] << " Y: " << nowtracker->PPostion[i][1] << " Width: " << nowtracker->PBoxWH[i][0] << " Height: " << nowtracker->PBoxWH[i][1] <<endl;
				if(debugfout == 1) fouttest << "\t\t\t\tWeight: " << nowtracker->PWeight[i] << endl;
				//nowtracker->PWeight[i] = nowtracker->PWeight[i]/SumofWeight + apha*maxcountseg[i]/nowtracker->PBoxWH[i][0] / nowtracker->PBoxWH[i][1]/4;
				//nowtracker->confidence += maxcountseg[i]/nowtracker->PBoxWH[i][0] / nowtracker->PBoxWH[i][1]/NumHistBin/4;
				
				SumofWeight += nowtracker->PWeight[i];
				
 	  		}
 	  		*/

 	  		//Importance 2(Weight normalization)
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
					if (nowtracker->GaussianKernel_temp / nowtracker->ObjectBoxW / nowtracker->ObjectBoxH > WeightThresholdDD) {
						if(debugcout == 1) cout << "Delete Tracker Because of the Color!!!" << endl;
						if(debugfout == 1) fouttest << "Delete Tracker Because of the Color!!!" << endl;

						nowtracker->deleteTracker = true;
					}
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
			time1 = clock();
 	  		nowtracker->ObjectPX_f	=	0;
 	  		nowtracker->ObjectPY_f	=	0;
 	  		nowtracker->ObjectBoxW_f	=	0;
 	  		nowtracker->ObjectBoxH_f	=	0;
			maxweight = 0;
			maxx = 0;
			maxy = 0;
			maxw = 0;
			maxh = 0;
	 	  
 	  		for(i=0;i<NumParticleonObject;++i){
 	  			nowtracker->ObjectPX_f	+=	nowtracker->PWeight[i]*nowtracker->PPostion[i][0];
 	  			nowtracker->ObjectPY_f	+=	nowtracker->PWeight[i]*nowtracker->PPostion[i][1];
 	  			nowtracker->ObjectBoxW_f	+=	nowtracker->PWeight[i]*nowtracker->PBoxWH[i][0];
	 	  		nowtracker->ObjectBoxH_f	+=	nowtracker->PWeight[i]*nowtracker->PBoxWH[i][1];
				/*if(nowtracker->PWeight[i] >= maxweight){
					maxx = nowtracker->PPostion[i][0];
					maxy = nowtracker->PPostion[i][1];
					maxw = nowtracker->PBoxWH[i][0];
					maxh = nowtracker->PBoxWH[i][1];
					maxweight = nowtracker->PWeight[i];

				
				}//end if

				*/

 	  		}

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
					if(tempG < 13) tempG = 13;
					if(tempH < 13*nowtracker->ratio) tempH = 13*nowtracker->ratio;
				}
				else{
					if(tempG < 13*nowtracker->ratio) tempG = 13*nowtracker->ratio;
					if(tempH < 13) tempH = 13;
				}

				while(tempG > 2.5 * tempH){
				   //tempG = (double)nowtracker->PBoxWH[i][0]   + rand()%3 - 1 ;//(((double)nowtracker->PBoxWH[i][0]*grandom()));
				
				   //tempH = (double)nowtracker->PBoxWH[i][1]  + (double)(rand()%6 - 2)/2 + 1;//(((double)nowtracker->PBoxWH[i][1]*grandom()));
				   tempG--;
				}
				while(tempH > 2.5 * tempG){
				   //tempG = (double)nowtracker->PBoxWH[i][0]   + rand()%3 - 1 ;//(((double)nowtracker->PBoxWH[i][0]*grandom()));
				
				   //tempH = (double)nowtracker->PBoxWH[i][1]  + (double)(rand()%6 - 2)/2 + 1;//(((double)nowtracker->PBoxWH[i][1]*grandom()));
				   tempH--;
				}
				if(nowtracker->ratio > 1){
					if(tempG < 13) tempG = 13;
					if(tempH < 13*nowtracker->ratio) tempH = 13*nowtracker->ratio;
				}
				else{
					if(tempG < 13*nowtracker->ratio) tempG = 13*nowtracker->ratio;
					if(tempH < 13) tempH = 13;
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
 	  			TotalHistgramValue = 0;//histogram
 	  			diag = (float)sqrt((float)(nowtracker->PBoxWH[i][0]*nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1]*nowtracker->PBoxWH[i][1]));
/* 	  			for(j=0;j<NumHistBin;++j){
 	  				HistogramCandidate[j] = 0;
				}*/
				centroid[0] = (max(0,nowtracker->PPostion[i][1]-nowtracker->PBoxWH[i][1]) + min(FrameH-1, nowtracker->PPostion[i][1] + nowtracker->PBoxWH[i][1])) / 2;
				centroid[1] = (max(0, nowtracker->PPostion[i][0]-nowtracker->PBoxWH[i][0]) + min(FrameW-1, nowtracker->PPostion[i][0] + nowtracker->PBoxWH[i][0])) / 2;
				HistogramCandidate.clear();
				HistogramBackground.clear();
 	  			for(k=max(0,nowtracker->PPostion[i][1]-nowtracker->PBoxWH[i][1]); k<= min(FrameH-1, nowtracker->PPostion[i][1] + nowtracker->PBoxWH[i][1]); ++k){
 	  				for(l=max(0, nowtracker->PPostion[i][0]-nowtracker->PBoxWH[i][0]); l<= min(FrameW-1, nowtracker->PPostion[i][0] + nowtracker->PBoxWH[i][0]); ++l){
 	  					//if(k<0) k=0;
 	  					//if(k>=FrameH) k=FrameH-1;
 	  					//if(l<0) l=0;
 	  					//if(l>=FrameW) l=FrameW-1;
 	  					//TempBinIdx = (int)(framebufferY[k*FrameW + l]*NumYBin/256) * NumUSubBin * NumVSubBin + (int)(framebufferU[k*FrameW2 + l]*NumUSubBin/256) * NumVSubBin + (int)(framebufferV[k*FrameW2 + l]*NumVSubBin/256) ;
						//TempBinIdx = (int)(framebufferY[k*FrameW + l] * NumUSubBin * NumVSubBin) + (int)(framebufferU[k*FrameW2 + l]) * NumVSubBin + (int)(framebufferV[k*FrameW2 + l]) ;
						
 	  					//TempHistValue = EpanechnikovKenerlConst*(1 - ( sqrt((float)( (k - nowtracker->PPostion[i][1])*(k - nowtracker->PPostion[i][1]) +   (l - nowtracker->PPostion[i][0])*(l - nowtracker->PPostion[i][0])) )/diag ));
						TempHistValue = 1;
 	  					donehistogram = false;
						for(j= 0; j < HistogramCandidate.size(); j+=4){
								if(//segbufferY[k*FrameW + l] != 0 &&
									(HistogramCandidate[j] >= framebufferY[k*FrameW + l] - HistogramThreshold && HistogramCandidate[j] <= framebufferY[k*FrameW + l] + HistogramThreshold) && 
									(HistogramCandidate[j+1] >= framebufferU[k/2*FrameW2 + l/2] - HistogramThreshold && HistogramCandidate[j+1] <= framebufferU[k/2*FrameW2 + l/2] + HistogramThreshold) &&
									(HistogramCandidate[j+2] >= framebufferV[k/2*FrameW2 + l/2] - HistogramThreshold && HistogramCandidate[j+2] <= framebufferV[k/2*FrameW2 + l/2] + HistogramThreshold) 	){
									donehistogram = true;
									if(CENTER == 1){
										HistogramCandidate[j+3] += (255 - sqrt((float)(k-centroid[0]) * (k-centroid[0]) + (l - centroid[1]) * (l - centroid[1])) / sqrt((float)nowtracker->PBoxWH[i][0] * nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][1]) * 255);
										
										TotalHistgramValue+= (255 - sqrt((float)(k-centroid[0]) * (k-centroid[0]) + (l - centroid[1]) * (l - centroid[1])) / sqrt((float)nowtracker->PBoxWH[i][0] * nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][1]) * 255);
									}
									else{
										HistogramCandidate[j+3] += 1;
										TotalHistgramValue++;
										
									}
									//TotalHistgramValue+= HistogramCandidate[j+3];
									break;
								}//end if
						}
						if(!donehistogram/* && segbufferY[k*FrameW + l] != 0*/){
							HistogramCandidate.push_back(framebufferY[k*FrameW + l]);
							HistogramCandidate.push_back(framebufferU[k/2*FrameW2 + l/2]);
							HistogramCandidate.push_back(framebufferV[k/2*FrameW2 + l/2]);
							if(CENTER == 1){
								HistogramCandidate.push_back(255 - sqrt((float)(k-centroid[0]) * (k-centroid[0]) + (l - centroid[1]) * (l - centroid[1])) / sqrt((float)nowtracker->PBoxWH[i][0] * nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][1]) * 255);
								TotalHistgramValue +=  (255 - sqrt((float)(k-centroid[0]) * (k-centroid[0]) + (l - centroid[1]) * (l - centroid[1])) / sqrt((float)nowtracker->PBoxWH[i][0] * nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][1]) * 255);
							}
							else{
								HistogramCandidate.push_back(1);
								TotalHistgramValue ++;
							
							}
						}//end if


						temphistogramb = 1;
 	  					donehistogram = false;
						for(j= 0; j < HistogramBackground.size(); j+=4){
								if((HistogramBackground[j] >= bg_Y[k*FrameW + l] - BHistogramThreshold && HistogramBackground[j] <= bg_Y[k*FrameW + l] + BHistogramThreshold) && 
									(HistogramBackground[j+1] >= bg_U[k/2*FrameW2 + l/2] - BHistogramThreshold && HistogramBackground[j+1] <= bg_U[k/2*FrameW2 + l/2] + BHistogramThreshold) &&
									(HistogramBackground[j+2] >= bg_V[k/2*FrameW2 + l/2] - BHistogramThreshold && HistogramBackground[j+2] <= bg_V[k/2*FrameW2 + l/2] + BHistogramThreshold) 	){
									donehistogram = true;
									if(CENTER == 1){
										HistogramBackground[j+3] += (255 - sqrt((float)(k-centroid[0]) * (k-centroid[0]) + (l - centroid[1]) * (l - centroid[1])) / sqrt((float)nowtracker->PBoxWH[i][0] * nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][1]) * 255);
										temphistogramb += (255 - sqrt((float)(k-centroid[0]) * (k-centroid[0]) + (l - centroid[1]) * (l - centroid[1])) / sqrt((float)nowtracker->PBoxWH[i][0] * nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][1]) * 255);
									}
									else{
										HistogramBackground[j+3] += 1;
										temphistogramb ++;
										
									}
									//temphistogramb+= HistogramBackground[j+3];
									break;
								}//end if
						}
						if(!donehistogram){
							HistogramBackground.push_back(bg_Y[k*FrameW + l]);
							HistogramBackground.push_back(bg_U[k/2*FrameW2 + l/2]);
							HistogramBackground.push_back(bg_V[k/2*FrameW2 + l/2]);
							if(CENTER == 1){
								HistogramBackground.push_back(255 - sqrt((float)(k-centroid[0]) * (k-centroid[0]) + (l - centroid[1]) * (l - centroid[1])) / sqrt((float)nowtracker->PBoxWH[i][0] * nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][1]) * 255);
								temphistogramb +=  (255 - sqrt((float)(k-centroid[0]) * (k-centroid[0]) + (l - centroid[1]) * (l - centroid[1])) / sqrt((float)nowtracker->PBoxWH[i][0] * nowtracker->PBoxWH[i][0] + nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][1]) * 255);
							}
							else{
								HistogramBackground.push_back(1);
								temphistogramb ++;
							
							}
						}//end if


						//HistogramCandidate[j] +=int (TempHistValue*128)/128;
 	  					//TotalHistgramValue += TempHistValue;

							
							
 	  					
						if(segbufferY[k*FrameW+l] != 0){
							maxcountseg[i]++;
							
/*
							while(nownode != end){
								if(k >= nownode->upbound && k <= nownode->downbound && l >= nownode->leftbound && l <= nownode->rightbound){
									//countseg[nownode->ID][i]++;
									//if(countseg[nownode->ID][i] > maxcountseg[i])maxcountseg[i] = countseg[nownode->ID][i];
									//nownode->newtracker = false;
									nownode->countpass++;
								}//end if
								nownode = nownode->right;
							}//end while
*/								
						}//end if
							

 	  				}
 	  			}
 	  			
 				
 	  			BhaCoef = 0;
				NCi = 0;
				NBCi = 0;
				f2 = new feature_t[HistogramCandidate.size()/4];
				//if(debugcout == 1) cout << "\t\tCandidate Size: " << HistogramCandidate.size()/4 << endl;
				s2.n = HistogramCandidate.size()/4;
				WeightC = new float[HistogramCandidate.size()/4];
				totalweight = 0;
				for(j=3;j<HistogramBackground.size();j+=4)// histogram normalization
 	  				HistogramBackground[j] = HistogramBackground[j]*100/temphistogramb;
 	  			for(j=3;j<HistogramCandidate.size();j+=4){// histogram normalization
 	  				HistogramCandidate[j] = HistogramCandidate[j]*100/TotalHistgramValue;
					
 	  				//BhaCoef += sqrt(HistogramCandidate[j]*nowtracker->HistogramTarget[j]); //calculating Bhattacharyya Coefficient
					//if(i >= 35) if(debugcout == 1) cout << "BhaCoef: " << BhaCoef << " HistogramCaondidate " << HistogramCandidate[j] << " HistogramTarget " << nowtracker->HistogramTarget[j] << endl;
					NCi = 1;
					NBCi = 0;
					for(k = 3; k < nowtracker->HistogramTarget.size(); k+=4){
						if((HistogramCandidate[j-3] >=  nowtracker->HistogramTarget[k-3] - ColorThreshold && HistogramCandidate[j-3] <=  nowtracker->HistogramTarget[k-3] + ColorThreshold) &&
						   (HistogramCandidate[j-2] >=  nowtracker->HistogramTarget[k-2] - ColorThreshold && HistogramCandidate[j-2] <=  nowtracker->HistogramTarget[k-2] + ColorThreshold) &&
						   (HistogramCandidate[j-1] >=  nowtracker->HistogramTarget[k-1] - ColorThreshold && HistogramCandidate[j-1] <=  nowtracker->HistogramTarget[k-1] + ColorThreshold)){
							NCi += (nowtracker->HistogramTarget[k]) ;/// 100*  nowtracker->HistogramTarget[k] / 100;
							//if(HistogramCandidate[j]	*  nowtracker->HistogramTarget[k] < 0) if(debugcout == 1) cout <<"WRONG" << endl;
							//if(debugcout == 1) cout <<NCi << "\t" << HistogramCandidate[j] << "\t" << nowtracker->HistogramTarget[k] << endl;
						}//end if
						

					}//end for k
					for(k = 3; k < HistogramBackground.size(); k+=4){
						
						if((HistogramCandidate[j-3] >=  HistogramBackground[k-3] - 0 &&HistogramCandidate[j-3] <=  HistogramBackground[k-3] + 1) &&
							(HistogramCandidate[j-2] >=  HistogramBackground[k-2] - 0 && HistogramCandidate[j-2] <=  HistogramBackground[k-2] + 1) &&
							(HistogramCandidate[j-1] >=  HistogramBackground[k-1] - 0 && HistogramCandidate[j-1] <=  HistogramBackground[k-1] + 1)){
							NBCi += (HistogramBackground[k]);//
							//if(f>=105) if(debugcout == 1) cout << NBCi<<"\t" << HistogramCandidate[j] <<"\t" << HistogramBackground[k] << endl;
						}//end if

					}//end for k
					f2[(j-3)/4].X = HistogramCandidate[j-3];
					f2[(j-3)/4].Y = HistogramCandidate[j-2];
					f2[(j-3)/4].Z = HistogramCandidate[j-1];
					if(Bguse == 1) WeightC[(j-3)/4] = HistogramCandidate[j] * (NBCi > 10 ? 0.0001 : 1);// *  ((100 + NBCi) / (100));//max((float)0, (float)(NCi - NBCi));//////HistogramCandidate[j];//*(NCi / 1);//;
					else WeightC[(j-3)/4] = HistogramCandidate[j];
					//if(debugcout == 1) cout << "NBCi: " << NBCi << endl;
					//
 	  				totalweight += WeightC[(j-3)/4];
				}
//				nowtracker->PWeight[i] = NCi / (G + NBCi);
				if(totalweight <= 0) {
					if(debugcout == 1) cout << "WEIGHT = 0" << endl;
					if(debugfout == 1) fouttest << "WEIGHT = 0" << endl;
					totalweight = 1;
				}
				for(k = 0; k < HistogramCandidate.size()/4; k++){
					
					WeightC[k] = WeightC[k] *100 / totalweight;
					//if(debugcout == 1) cout << WeightC[k] << endl;
				}//end for k
				s2.Features = f2;
				s2.Weights = WeightC;
				time2 = clock();
				timeWeightUpdate += time2-time1;

 	  			//BhaDist2 = 1-BhaCoef;//calculating Bhattacharyya Distance
				
 	  			//nowtracker->PWeight[i] = exp(-(BhaDist2/(2*VarWU)))/(2.50663*StdWU);//weight update

				//s2.Weights = HistogramCandidate;
				//s1.Weights = nowtracker->HistogramTarget;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
				time1 = clock();
				if(totalweight == 1)
					Distance = 99999999999999999;
				else{
					if(Choose == 0)
						Distance = emd(&nowtracker->s1, &s2, dist, 0, 0);
					else if(Choose == 1)
						Distance = DFdist(&nowtracker->s1, &s2);
					else if(Choose == 2)
						Distance = BDdist(&nowtracker->s1, &s2);
				}
				time2 = clock();
				timeDistance += time2-time1;
				//nowtracker->PWeight[i] = Distance;
				//EMDtotal+=Distance;
				//nowtracker->PWeight[i] = emd(&s1, &s2, dist, 0, 0);//exp(-(Distance/(2*VarWU)))/(2.50663*StdWU);//weight update
				nowtracker->GaussianKernel_temp += Distance;
				if(Distance == 0) nowtracker->PWeight[i] = 0.00001;
				else if(Distance < 0) {
					if(debugcout == 1) cout << "Frame: " << f << endl;
					system("pause");}
				//else if(Choose == 1)nowtracker->PWeight[i] = 1/(Distance-100)*(Distance-100)*(Distance-100)*nowtracker->PBoxWH[i][0]*nowtracker->PBoxWH[i][1];//exp(0-(Distance-50)*(Distance-50)/2/StdWU/StdWU) / StdWU / 2.50663;
				//else nowtracker->PWeight[i] = 1/Distance;//*sqrt((double)(nowtracker->PBoxWH[i][0]*nowtracker->PBoxWH[i][1]));//exp(0-(Distance-50)*(Distance-50)/2/StdWU/StdWU) / StdWU / 2.50663;
				else if(Choose == 1) nowtracker->PWeight[i] = exp(0-Distance/nowtracker->GaussianKernel*1)*/*pow((1-(double)abs((double)nowtracker->PBoxWH[i][0] - (double)nowtracker->ObjectBoxW)/(double)max(nowtracker->PBoxWH[i][0], nowtracker->ObjectBoxW)) * (1-(double)abs((double)nowtracker->PBoxWH[i][1] - (double)nowtracker->ObjectBoxH)/(double)max(nowtracker->PBoxWH[i][1], nowtracker->ObjectBoxH)), 4) * */pow(1.01, (nowtracker->PBoxWH[i][1]- nowtracker->ObjectBoxH)) * pow(1.01, (nowtracker->PBoxWH[i][0]- nowtracker->ObjectBoxW));//pow((double)(nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][0]),2);// * nowtracker->PBoxWH[i][1] * nowtracker->PBoxWH[i][0];
				else if(Choose == 2) nowtracker->PWeight[i] = exp(0-Distance/nowtracker->GaussianKernel*3)*pow((1-(double)abs((double)nowtracker->PBoxWH[i][0] - (double)nowtracker->ObjectBoxW)/(double)max(nowtracker->PBoxWH[i][0], nowtracker->ObjectBoxW)) * (1-(double)abs((double)nowtracker->PBoxWH[i][1] - (double)nowtracker->ObjectBoxH)/(double)max(nowtracker->PBoxWH[i][1], nowtracker->ObjectBoxH)), 1);
				else if(Choose == 0) nowtracker->PWeight[i] = exp(0-Distance/nowtracker->GaussianKernel*pow((1-(double)abs((double)nowtracker->PBoxWH[i][0] - (double)nowtracker->ObjectBoxW)/(double)max(nowtracker->PBoxWH[i][0], nowtracker->ObjectBoxW)) * (1-(double)abs((double)nowtracker->PBoxWH[i][1] - (double)nowtracker->ObjectBoxH)/(double)max(nowtracker->PBoxWH[i][1], nowtracker->ObjectBoxH)), 0.25));
				else nowtracker->PWeight[i] = 1/Distance*pow((1-(double)abs((double)nowtracker->PBoxWH[i][0] - (double)nowtracker->ObjectBoxW)/(double)nowtracker->ObjectBoxW) * (1-(double)abs((double)nowtracker->PBoxWH[i][1] - (double)nowtracker->ObjectBoxH)/(double)nowtracker->ObjectBoxH), 4);
				if(nowtracker->PWeight[i] < 0) nowtracker->PWeight[i] = 0;
				//if(debugcout == 1) cout << pow((1-(double)abs((double)nowtracker->PBoxWH[i][0] - (double)nowtracker->ObjectBoxW)/(double)nowtracker->ObjectBoxW) * (1-(double)abs((double)nowtracker->PBoxWH[i][1] - (double)nowtracker->ObjectBoxH)/(double)nowtracker->ObjectBoxH), 4) << endl;
					//exp(-(Distance/(2*VarWU)))/(2.50663*StdWU);
				
				SumofWeight += nowtracker->PWeight[i];

				if(debugfout == 1) fouttest << "\t\t\tX: "<<nowtracker->PPostion[i][0] << " Y: " << nowtracker->PPostion[i][1] << " Width: " << nowtracker->PBoxWH[i][0]*2 << " Height: " << nowtracker->PBoxWH[i][1]*2 <<endl;
				if(debugfout == 1) fouttest << "\t\t\t\tWeight: " << nowtracker->PWeight[i] << endl;
				if(debugfout == 1) fouttest << "\t\t\t\tEMD: " << Distance << endl;
					
 	  			//SumofWeight += nowtracker->PWeight[i];
				delete [] WeightC;
				delete [] f2;
				
					
			}
			nowtracker->GaussianKernel = nowtracker->GaussianKernel_temp/NumParticleonObject/5;

			timeWeightUpdate/=NumParticleonObject/2;
			timeDistance /= NumParticleonObject/2;
			/*EMDtotal/=NumParticleonObject;
			VarWU = 0;
			StdWU = 0;
			for(i=0;i<NumParticleonObject;i++){
				//if(nowtracker->PWeight[i]-EMDtotal+1.75*StdWU >= 0) nowtracker->PWeight[i] = exp(0-(nowtracker->PWeight[i]-EMDtotal+1.75*StdWU)*(nowtracker->PWeight[i]-EMDtotal+1.75*StdWU)/2/StdWU/StdWU) / StdWU / 2.50663;
				//else nowtracker->PWeight[i] = 0;
				VarWU += (nowtracker->PWeight[i] - EMDtotal) * (nowtracker->PWeight[i] - EMDtotal);
				//nowtracker->PWeight[i] = nowtracker->PWeight[i]/SumofWeight + apha*maxcountseg[i]/nowtracker->PBoxWH[i][0] / nowtracker->PBoxWH[i][1]/4;
				//nowtracker->confidence += maxcountseg[i]/nowtracker->PBoxWH[i][0] / nowtracker->PBoxWH[i][1]/NumHistBin/4;
				
				//SumofWeight += nowtracker->PWeight[i];
				
 	  		}
			VarWU/=NumParticleonObject;
			StdWU = sqrt(VarWU);
			if(debugcout == 1) cout << "Standard Deviation: " << StdWU << endl;
			if(debugfout == 1) fouttest << "Standard Deviation: " << StdWU << endl;
			
			for(i=0;i<NumParticleonObject;i++){
				if(debugfout == 1) fouttest << "Before" << endl;
				if(debugfout == 1) fouttest << "\t\t\tX: "<<nowtracker->PPostion[i][0] << " Y: " << nowtracker->PPostion[i][1] << " Width: " << nowtracker->PBoxWH[i][0] << " Height: " << nowtracker->PBoxWH[i][1] <<endl;
				if(debugfout == 1) fouttest << "\t\t\t\tWeight: " << nowtracker->PWeight[i] << endl;
				if(nowtracker->PWeight[i]-0 > 0) //nowtracker->PWeight[i] = exp(0-(nowtracker->PWeight[i]-EMDtotal+1.5*StdWU)*(nowtracker->PWeight[i]-EMDtotal+1.5*StdWU)/2/StdWU/StdWU) / StdWU / 2.50663;
					nowtracker->PWeight[i] = 1/nowtracker->PWeight[i];
				else nowtracker->PWeight[i] = 0;
				if(debugfout == 1) fouttest << "After" << endl;
				if(debugfout == 1) fouttest << "\t\t\tX: "<<nowtracker->PPostion[i][0] << " Y: " << nowtracker->PPostion[i][1] << " Width: " << nowtracker->PBoxWH[i][0] << " Height: " << nowtracker->PBoxWH[i][1] <<endl;
				if(debugfout == 1) fouttest << "\t\t\t\tWeight: " << nowtracker->PWeight[i] << endl;
				//nowtracker->PWeight[i] = nowtracker->PWeight[i]/SumofWeight + apha*maxcountseg[i]/nowtracker->PBoxWH[i][0] / nowtracker->PBoxWH[i][1]/4;
				//nowtracker->confidence += maxcountseg[i]/nowtracker->PBoxWH[i][0] / nowtracker->PBoxWH[i][1]/NumHistBin/4;
				
				SumofWeight += nowtracker->PWeight[i];
				
 	  		}
 	  		*/

 	  		//Importance 2(Weight normalization)
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
					if (nowtracker->GaussianKernel_temp / nowtracker->ObjectBoxW / nowtracker->ObjectBoxH > WeightThresholdDD) {
						if(debugcout == 1) cout << "Delete Tracker Because of the Color!!!" << endl;
						if(debugfout == 1) fouttest << "Delete Tracker Because of the Color!!!" << endl;

						nowtracker->deleteTracker = true;
					}
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
			time1 = clock();

 	  		
 	  		nowtracker->ObjectBoxW_f	=	0;
 	  		nowtracker->ObjectBoxH_f	=	0;
			maxweight = 0;
			maxx = 0;
			maxy = 0;
			maxw = 0;
			maxh = 0;
			maxweight1 = 0;
			maxx1 = 0;
			maxy1 = 0;
			maxw1 = 0;
			maxh1 = 0;
			maxweight2 = 0;
			maxx2 = 0;
			maxy2 = 0;
			maxw2 = 0;
			maxh2 = 0;
			maxweight3 = 0;
			maxx3 = 0;
			maxy3 = 0;
			maxw3 = 0;
			maxh3 = 0;
			maxweight4 = 0;
			maxx4 = 0;
			maxy4 = 0;
			maxw4 = 0;
			maxh4 = 0;
			maxweight5 = 0;
			maxx5 = 0;
			maxy5 = 0;
			maxw5 = 0;
			maxh5 = 0;
	 	  
 	  		for(i=0;i<NumParticleonObject;++i){
 	  			//nowtracker->ObjectPX_f	+=	nowtracker->PWeight[i]*nowtracker->PPostion[i][0];
 	  			//nowtracker->ObjectPY_f	+=	nowtracker->PWeight[i]*nowtracker->PPostion[i][1];
 	  			nowtracker->ObjectBoxW_f	+=	nowtracker->PWeight[i]*nowtracker->PBoxWH[i][0];
	 	  		nowtracker->ObjectBoxH_f	+=	nowtracker->PWeight[i]*nowtracker->PBoxWH[i][1];
			/*	if(nowtracker->PWeight[i] > maxweight1){
				//	maxx = nowtracker->PPostion[i][0];
				//	maxy = nowtracker->PPostion[i][1];
					maxw1 = nowtracker->PBoxWH[i][0];
					maxh1 = nowtracker->PBoxWH[i][1];
					maxweight1 = nowtracker->PWeight[i];
					if(debugcout == 1) cout << "MAXX: " << maxw1 << " MAXY: " << maxh1 << " WEIGHT: " << maxweight1<<endl ;

				
				}//end if
				else if(nowtracker->PWeight[i] > maxweight2){
				//	maxx = nowtracker->PPostion[i][0];
				//	maxy = nowtracker->PPostion[i][1];
					maxw2 = nowtracker->PBoxWH[i][0];
					maxh2 = nowtracker->PBoxWH[i][1];
					maxweight2 = nowtracker->PWeight[i];

				
				}//end if
				else if(nowtracker->PWeight[i] > maxweight3){
				//	maxx = nowtracker->PPostion[i][0];
				//	maxy = nowtracker->PPostion[i][1];
					maxw3 = nowtracker->PBoxWH[i][0];
					maxh3 = nowtracker->PBoxWH[i][1];
					maxweight3 = nowtracker->PWeight[i];

				
				}//end if
			*//*	else if(nowtracker->PWeight[i] >= maxweight4){
				//	maxx = nowtracker->PPostion[i][0];
				//	maxy = nowtracker->PPostion[i][1];
					maxw4 = nowtracker->PBoxWH[i][0];
					maxh4 = nowtracker->PBoxWH[i][1];
					maxweight4 = nowtracker->PWeight[i];

				
				}//end if
				else if(nowtracker->PWeight[i] >= maxweight5){
				//	maxx = nowtracker->PPostion[i][0];
				//	maxy = nowtracker->PPostion[i][1];
					maxw5 = nowtracker->PBoxWH[i][0];
					maxh5 = nowtracker->PBoxWH[i][1];
					maxweight5 = nowtracker->PWeight[i];

				
				}//end if
*/
				

 	  		}





























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
							tempboxh = tempboxh*0.9;
							tempy = tempy;
							
							tempF = tempF - tempboxw*0.05;

							tempboxw = (tempF - tempE) / 2;
							tempx = (tempF + tempE) / 2;

							
							
						}
						else if(tempF >= FrameW - 15){
							tempboxh = tempboxh*0.9;
							tempy = tempy;
							
							tempE = tempE + tempboxw*0.05;
							tempboxw = (tempF - tempE) / 2;
							tempx = (tempF + tempE) / 2;
							
						}
						else if(tempG <= 15){
							
							tempH = tempH - tempboxh*0.05;
							tempboxh = (tempH - tempG) / 2;
							tempy = (tempH + tempG) / 2;
							
							
							tempboxw = tempboxw*0.9;
							tempx = tempx;
							
						}
						else if(tempH >= FrameH - 15){
							tempG = tempG + tempboxh*0.05;
							tempboxh = (tempH - tempG) / 2;
							tempy = (tempH + tempG) / 2;
							
							tempboxw = tempboxw*0.9;
							tempx = tempx;
							
						}
						else{
							tempboxh = tempboxh*0.9;
							tempy = tempy;
							tempboxw = tempboxw*0.9;
							tempx = tempx;
						}


					}
					
					
					nownode = nownode->right;
					whichonecount++;
				}//end while

				if(mindist < 50){
					nowtracker->ObjectPX = tempx;
					nowtracker->ObjectPY = tempy;
					nowtracker->ObjectBoxW = tempboxw/1.15;
					nowtracker->ObjectBoxH = tempboxh/1.15;
					nowtracker->ObjectBoxH_B = tempboxh * 1.3/1.15;
					nowtracker->ObjectBoxW_B = tempboxw * 1.3/1.15;
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
/*
					nownode = root->right;
					
					

					while(nownode != end){
						
						if(k >= nownode->upbound-Space && k <= nownode->downbound+Space && l >= nownode->leftbound-Space && l <= nownode->rightbound+Space){
							nownode->newtracker = false;
							
							nownode->countpass++;
						}//end if
						nownode = nownode->right;
					}//end while
*/
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


			time2 = clock();
			timeEO += time2 - time1;
 	 		
 		  		//Produce the Result Video
			if(nowtracker->confidence >ConfidenceThreshold && !nowtracker->deleteTracker){//||( (nowtracker->ObjectPX > LeftThreshold && nowtracker->ObjectPX < RightThreshold) && (nowtracker->ObjectPY > TopThreshold && nowtracker->ObjectPY < BottomThreshold))){	
				if(debugcout == 1) cout << "\t\tCenter: (" << nowtracker->ObjectPX << " , " << nowtracker->ObjectPY << ") Width: " << nowtracker->ObjectBoxW *2<< " Height: " << nowtracker->ObjectBoxH*2 << endl;
				if(debugfout == 1) fouttest << "\t\tCenter: (" << nowtracker->ObjectPX << " , " << nowtracker->ObjectPY << ") Width: " << nowtracker->ObjectBoxW *2<< " Height: " << nowtracker->ObjectBoxH*2 << endl;
/*				for(k=0;k<FrameH;++k){
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
*/	 	  		
 	  			//Display Object
				if(debugcout == 1) cout << "\t\tDisplaying Object......" << endl;
				if(debugfout == 1) fouttest << "\t\tDisplaying Object......" << endl;
				tempA = max((int)0, (int)(nowtracker->ObjectPY-1.2*nowtracker->ObjectBoxH));
				tempC = max((int)0, (int)(nowtracker->ObjectPX-1.2*nowtracker->ObjectBoxW));
				tempB = min((int)FrameH-1, (int)(nowtracker->ObjectPY + 1.2*nowtracker->ObjectBoxH));
				tempD = min((int)FrameW-1, (int)(nowtracker->ObjectPX + 1.2*nowtracker->ObjectBoxW));
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
				time1 = 0;
	 	  		
 	  			TotalHistgramValue = 0;//2. Target Model : color histogram
				TotalHistgramValuet = 0;
 	  			diag = (float)sqrt((float) (nowtracker->ObjectBoxW*nowtracker->ObjectBoxW + nowtracker->ObjectBoxH*nowtracker->ObjectBoxH) );
 	  			TempHistValue = 1;
				/*for(j= 0; j < nowtracker->HistogramTarget.size(); j+=4){
				
					nowtracker->HistogramTarget[j+3] = 0;;
				
				
				}*/
				LearningHistogram.clear();
				LearningHistogram_B.clear();
				//if(debugcout == 1) cout << nowtracker->ObjectPY << " " << nowtracker->ObjectBoxH_B << " " << nowtracker->ObjectPX << " " << nowtracker->ObjectBoxW_B << endl;
				centroid[0] = (max(0,nowtracker->ObjectPY-nowtracker->ObjectBoxH) + min(FrameH-1, nowtracker->ObjectPY + nowtracker->ObjectBoxH)) / 2;
				centroid[1] = (max(0,nowtracker->ObjectPX-nowtracker->ObjectBoxW) + min(FrameW-1, nowtracker->ObjectPX + nowtracker->ObjectBoxW)) / 2;
 	  			for(k=max(0,nowtracker->ObjectPY-nowtracker->ObjectBoxH_B); k<= min(FrameH-1, nowtracker->ObjectPY + nowtracker->ObjectBoxH_B); ++k){
 	  				for(l=max(0,nowtracker->ObjectPX-nowtracker->ObjectBoxW_B); l<= min(FrameW-1, nowtracker->ObjectPX + nowtracker->ObjectBoxW_B); ++l){
 	  					//if(k<0) k=0;
 	  					//if(k>=FrameH) k=FrameH-1;
 	  					//if(l<0) l=0;
 	  					//if(l>=FrameW) l=FrameW-1;
 	  					if(k >= max(0,nowtracker->ObjectPY-nowtracker->ObjectBoxH) && k <= min(FrameH-1, nowtracker->ObjectPY + nowtracker->ObjectBoxH) &&
							l >= max(0,nowtracker->ObjectPX-nowtracker->ObjectBoxW) && l<= min(FrameW-1, nowtracker->ObjectPX + nowtracker->ObjectBoxW) ){
							
							donehistogram = false;
							for(j= 0; j < LearningHistogram.size(); j+=4){
									if((segbufferY[k*FrameW + l ] != 0) && 
										(LearningHistogram[j] >= framebufferY[k*FrameW + l] - HistogramThreshold && LearningHistogram[j] <= framebufferY[k*FrameW + l] + HistogramThreshold) && 
										(LearningHistogram[j+1] >= framebufferU[k/2*FrameW2 + l/2]  - HistogramThreshold && LearningHistogram[j+1] <= framebufferU[k/2*FrameW2 + l/2]  + HistogramThreshold)&&
										(LearningHistogram[j+2] >= framebufferV[k/2*FrameW2 + l/2] - HistogramThreshold && LearningHistogram[j+2] <= framebufferV[k/2*FrameW2 + l/2] + HistogramThreshold) 	){
										donehistogram = true;
										if(CENTER == 1){
											LearningHistogram[j+3]+=(255 - sqrt((float)(k - centroid[0]) * (k - centroid[0]) + (l - centroid[1]) * (l - centroid[1])) / sqrt((float)nowtracker->ObjectBoxH * nowtracker->ObjectBoxH + nowtracker->ObjectBoxW * nowtracker->ObjectBoxW) * 255);
											TotalHistgramValue+=(255 - sqrt((float)(k - centroid[0]) * (k - centroid[0]) + (l - centroid[1]) * (l - centroid[1])) / sqrt((float)nowtracker->ObjectBoxH * nowtracker->ObjectBoxH + nowtracker->ObjectBoxW * nowtracker->ObjectBoxW) * 255);
										}
										else{
											LearningHistogram[j+3]++;
											TotalHistgramValue++;
											
										}
										//TotalHistgramValue+=LearningHistogram[j+3];
										break;
									}//end if
							}
						if((segbufferY[k*FrameW + l ] != 0) && !donehistogram){
								LearningHistogram.push_back(framebufferY[k*FrameW + l]);
								LearningHistogram.push_back(framebufferU[k/2*FrameW2 + l/2]);
								LearningHistogram.push_back(framebufferV[k/2*FrameW2 + l/2]);
								if(CENTER == 1){
									LearningHistogram.push_back(255 - sqrt((float)(k - centroid[0]) * (k - centroid[0]) + (l - centroid[1]) * (l - centroid[1])) / sqrt((float)nowtracker->ObjectBoxH * nowtracker->ObjectBoxH + nowtracker->ObjectBoxW * nowtracker->ObjectBoxW) * 255);
									TotalHistgramValue+=(255 - sqrt((float)(k - centroid[0]) * (k - centroid[0]) + (l - centroid[1]) * (l - centroid[1])) / sqrt((float)nowtracker->ObjectBoxH *nowtracker-> ObjectBoxH + nowtracker->ObjectBoxW * nowtracker->ObjectBoxW) * 255);
								}
								else{
									LearningHistogram.push_back(1);
									TotalHistgramValue++;
								}
							}//end if
							//LearningHistogram[j] +=int (TempHistValue*128)/128;
// 	  						TotalHistgramValue += TempHistValue;
						}//end if
						else{
							donehistogram = false;
							for(j= 0; j < LearningHistogram_B.size(); j+=4){
									if((LearningHistogram_B[j] >= framebufferY[k*FrameW + l] - HistogramThreshold && LearningHistogram_B[j] <= framebufferY[k*FrameW + l] + HistogramThreshold) && 
										(LearningHistogram_B[j+1] >= framebufferU[k/2*FrameW2 + l/2] - HistogramThreshold && LearningHistogram_B[j+1] <= framebufferU[k/2*FrameW2 + l/2] + HistogramThreshold) &&
										(LearningHistogram_B[j+2] >= framebufferV[k/2*FrameW2 + l/2] - HistogramThreshold && LearningHistogram_B[j+2] <= framebufferV[k/2*FrameW2 + l/2] + HistogramThreshold) 	){
										donehistogram = true;
										LearningHistogram_B[j+3]++;
										TotalHistgramValuet++;
										break;
									}//end if
							}
							if(!donehistogram){
								LearningHistogram_B.push_back(framebufferY[k*FrameW + l]);
								LearningHistogram_B.push_back(framebufferU[k/2*FrameW2 + l/2]);
								LearningHistogram_B.push_back(framebufferV[k/2*FrameW2 + l/2]);
								LearningHistogram_B.push_back(1);
								TotalHistgramValuet++;
							}//end if

							//LearningHistogram[j] +=int (TempHistValue*128)/128;
 	  						//TotalHistgramValuet += TempHistValue;
						
						
						}
 	  				}
 	  				
 	  			}

				for(j=3;j<LearningHistogram.size();j+=4){// histogram normalization
	 	  			LearningHistogram[j] = LearningHistogram[j]*100/TotalHistgramValue;
					
 	  			}
				if(debugcout == 1) cout << "\t\tForeground Color:\t" <<LearningHistogram.size()/4 << endl;
				if(debugfout == 1) fouttest << "\t\tForeground Color:\t" <<LearningHistogram.size()/4 << endl;
				for(j=3;j<LearningHistogram_B.size();j+=4){// histogram normalization
	 	  			
					LearningHistogram_B[j] = LearningHistogram_B[j]*100/TotalHistgramValuet;
					
 	  			}
				if(debugcout == 1) cout << "\t\tBackground Color:\t" <<LearningHistogram_B.size()/4 << endl;
				if(debugfout == 1) fouttest << "\t\tBackground Color:\t" <<LearningHistogram_B.size()/4 << endl;
				//if(debugcout == 1) cout << "here1" << endl;
				//if(debugfout == 1) fouttest2 << "here1"<< endl;
				for(k = 0; k < nowtracker->HistogramTarget.size(); k+=4){
					donehistogram = false;
					//if(debugfout == 1) fouttest2 << nowtracker->HistogramTarget[k] << "\t" << nowtracker->HistogramTarget[k+3] << endl;
					for(j = 0; j < LearningHistogram.size(); j+=4){
						
						
						if((LearningHistogram[j] >= nowtracker->HistogramTarget[k] - ColorThreshold && LearningHistogram[j] <= nowtracker->HistogramTarget[k] + ColorThreshold) &&
							(LearningHistogram[j+1] >= nowtracker->HistogramTarget[k+1] - ColorThreshold && LearningHistogram[j+1] <= nowtracker->HistogramTarget[k+1] + ColorThreshold) &&
							(LearningHistogram[j+2] >= nowtracker->HistogramTarget[k+2] - ColorThreshold && LearningHistogram[j+2] <= nowtracker->HistogramTarget[k+2] + ColorThreshold)
							){
							//LearningHistogram[j] = nowtracker->HistogramTarget[k] * (1 - LearningRatio) + LearningHistogram[j] * LearningRatio;
							//LearningHistogram[j+1] = nowtracker->HistogramTarget[k+1] * (1 - LearningRatio) + LearningHistogram[j+1] * LearningRatio;
							//LearningHistogram[j+2] = nowtracker->HistogramTarget[k+2] * (1 - LearningRatio) + LearningHistogram[j+2] * LearningRatio;
							
							if(!nowtracker->NoParticle){
								LearningHistogram[j+3] = nowtracker->HistogramTarget[k+3] * (1 - LearningRatio) + LearningHistogram[j+3] * LearningRatio;
				

							}//end if
							
							donehistogram = true;
						}//end if
						
					}//end for j
					if(!donehistogram && !nowtracker->NoParticle
						){
						LearningHistogram.push_back(nowtracker->HistogramTarget[k]);
						LearningHistogram.push_back(nowtracker->HistogramTarget[k+1]);
						LearningHistogram.push_back(nowtracker->HistogramTarget[k+2]);
						LearningHistogram.push_back(nowtracker->HistogramTarget[k+3]*(1-LearningRatio));
					}
				}//end k
/****/		
				for(j = 0; j < LearningHistogram.size(); j+=4){
				
					donehistogram = false;
					//if(debugfout == 1) fouttest2 << nowtracker->HistogramTarget[k] << "\t" << nowtracker->HistogramTarget[k+3] << endl;
					for(k = 0; k < nowtracker->HistogramTarget.size(); k+=4){	
						
						
						if((LearningHistogram[j] >= nowtracker->HistogramTarget[k] - ColorThreshold && LearningHistogram[j] <= nowtracker->HistogramTarget[k] + ColorThreshold) &&
							(LearningHistogram[j+1] >= nowtracker->HistogramTarget[k+1] - ColorThreshold && LearningHistogram[j+1] <= nowtracker->HistogramTarget[k+1] + ColorThreshold) &&
							(LearningHistogram[j+2] >= nowtracker->HistogramTarget[k+2] - ColorThreshold && LearningHistogram[j+2] <= nowtracker->HistogramTarget[k+2] + ColorThreshold)
							){
							
							donehistogram = true;
							break;
						}//end if
						
					}//end for k
					if(!donehistogram && !nowtracker->NoParticle){
						LearningHistogram[j+3] *= LearningRatio;
					}
				}//end j
/****/				
				TotalHistgramValue = 0;
				//if(debugfout == 1) fouttest2 << "here3 " << endl;
				for(j = 0; j < LearningHistogram.size(); j+=4){
					//if(debugfout == 1) fouttest2 << LearningHistogram[j] << "\t" << LearningHistogram[j+3] << endl;
					TotalHistgramValue += LearningHistogram[j+3];
				}//end fork j
				//if(debugfout == 1) fouttest2 << endl;
				//if(debugfout == 1) fouttest2 << endl << "Total: "<< TotalHistgramValue << endl;
				//if(debugcout == 1) cout << "Total " << endl;
				//for(j = 0; j < LearningHistogram.size(); j+=4){
				//	LearningHistogram[j+3] = LearningHistogram[j+3]/TotalHistgramValue;
				//}//end fork j

				//if(debugfout == 1) fouttest2<< endl;
				nowtracker->HistogramTarget.clear();
				//if(debugcout == 1) cout << TotalHistgramValue << endl;
//				if(debugfout == 1) fouttest2 <<"here" << endl;
				TotalHistogramValue1 = 0;
				for(k = 0; k < LearningHistogram.size(); k+=4){
//					if(debugfout == 1) fouttest2 << LearningHistogram[k] << "\t" << LearningHistogram[k+3] << "\t";
					LearningHistogram[k+3] = LearningHistogram[k+3]*100/TotalHistgramValue;
					//if(debugfout == 1) fouttest2 << LearningHistogram[k+3] << "\t"<< TotalHistgramValue << endl;
					if(LearningHistogram[k+3] > 0.01){
						//nowtracker->HistogramTarget.erase(nowtracker->HistogramTarget.begin()+k, nowtracker->HistogramTarget.begin()+k+3);

						nowtracker->HistogramTarget.push_back(LearningHistogram[k]);
						nowtracker->HistogramTarget.push_back(LearningHistogram[k+1]);
						nowtracker->HistogramTarget.push_back(LearningHistogram[k+2]);
						nowtracker->HistogramTarget.push_back(LearningHistogram[k+3]);
//						if(debugfout == 1) fouttest2 << LearningHistogram[k] << "\t" << LearningHistogram[k+3] << endl;
						TotalHistogramValue1 += LearningHistogram[k+3];

					}//end if
					
					//else{
						//if(debugcout == 1) cout << "Delete Color in Foreground" << endl;
						
					//}
				}//end for k
				if(debugfout == 1) fouttest << "\t\tAfter Foreground Color:\t" <<LearningHistogram.size()/4 << endl;
//				if(debugfout == 1) fouttest2 << endl;
				if(nowtracker->HistogramTarget.size() == 0) {
					if(debugcout == 1) cout << "Empty Foreground" << endl;
					if(debugfout == 1) fouttest << "Empty Foreground" << endl;
				}

				for(k = 0; k < nowtracker->HistogramTarget_B.size(); k+=4){	
					donehistogram = false;
					for(j = 0; j < LearningHistogram_B.size(); j+=4){
					
						
						if((LearningHistogram_B[j] >= nowtracker->HistogramTarget_B[k] - ColorThreshold && LearningHistogram_B[j] <= nowtracker->HistogramTarget_B[k] +ColorThreshold) &&
							(LearningHistogram_B[j+1] >= nowtracker->HistogramTarget_B[k+1] - ColorThreshold && LearningHistogram_B[j+1] <= nowtracker->HistogramTarget_B[k+1] + ColorThreshold) &&
							(LearningHistogram_B[j+2] >= nowtracker->HistogramTarget_B[k+2] - ColorThreshold && LearningHistogram_B[j+2] <= nowtracker->HistogramTarget_B[k+2] + ColorThreshold)
							){
							//LearningHistogram_B[j] = nowtracker->HistogramTarget_B[k] * (1 - LearningRatio) + LearningHistogram_B[j] * LearningRatio;
							//LearningHistogram_B[j+1] = nowtracker->HistogramTarget_B[k+1] * (1 - LearningRatio) + LearningHistogram_B[j+1] * LearningRatio;
							//LearningHistogram_B[j+2] = nowtracker->HistogramTarget_B[k+2] * (1 - LearningRatio) + LearningHistogram_B[j+2] * LearningRatio;
							if(!nowtracker->NoParticle)
								LearningHistogram_B[j+3] = nowtracker->HistogramTarget_B[k+3] * (1 - LearningRatio) + LearningHistogram_B[j+3] * LearningRatio;
							donehistogram = true;
						}//end if 
						
					}//end for k
					if(!donehistogram && !nowtracker->NoParticle){
						LearningHistogram_B.push_back(nowtracker->HistogramTarget_B[k]);
						LearningHistogram_B.push_back(nowtracker->HistogramTarget_B[k+1]);
						LearningHistogram_B.push_back(nowtracker->HistogramTarget_B[k+2]);
						LearningHistogram_B.push_back(nowtracker->HistogramTarget_B[k+3]*(1-LearningRatio));
						//nowtracker->HistogramTarget_B.push_back(LearningHistogram_B[j]);
						//nowtracker->HistogramTarget_B.push_back(LearningHistogram_B[j+1]);
						//nowtracker->HistogramTarget_B.push_back(LearningHistogram_B[j+2]);
						//nowtracker->HistogramTarget_B.push_back(LearningHistogram_B[j+3]);
					}
				}//end j
/****/
				for(j = 0; j < LearningHistogram_B.size(); j+=4){
				
					donehistogram = false;
					for(k = 0; k < nowtracker->HistogramTarget_B.size(); k+=4){		
					
						
						if((LearningHistogram_B[j] >= nowtracker->HistogramTarget_B[k] - ColorThreshold && LearningHistogram_B[j] <= nowtracker->HistogramTarget_B[k] +ColorThreshold) &&
							(LearningHistogram_B[j+1] >= nowtracker->HistogramTarget_B[k+1] - ColorThreshold && LearningHistogram_B[j+1] <= nowtracker->HistogramTarget_B[k+1] + ColorThreshold) &&
							(LearningHistogram_B[j+2] >= nowtracker->HistogramTarget_B[k+2] - ColorThreshold && LearningHistogram_B[j+2] <= nowtracker->HistogramTarget_B[k+2] + ColorThreshold)
							){
							
							donehistogram = true;
							break;
						}//end if 
						
					}//end for k
					if(!donehistogram && !nowtracker->NoParticle){
						LearningHistogram_B[j+3] *= LearningRatio;
						
					}
				}//end j
/****/
				TotalHistgramValuet = 0;
				for(j = 0; j < LearningHistogram_B.size(); j+=4){
					TotalHistgramValuet += LearningHistogram_B[j+3];
				}//end fork j
/*				for(j = 0; j < LearningHistogram_B.size(); j+=4){
					LearningHistogram_B[j+3] = LearningHistogram_B[j+3]/TotalHistgramValuet;
				}//end fork j
*/				TotalHistogramValue2 = 0;
				nowtracker->HistogramTarget_B.clear();
				for(k = 0; k < LearningHistogram_B.size(); k+=4){
					LearningHistogram_B[k+3] = LearningHistogram_B[k+3]*100/TotalHistgramValuet;
					if(LearningHistogram_B[k+3]> 0.01){
						nowtracker->HistogramTarget_B.push_back(LearningHistogram_B[k]);
						nowtracker->HistogramTarget_B.push_back(LearningHistogram_B[k+1]);
						nowtracker->HistogramTarget_B.push_back(LearningHistogram_B[k+2]);
						nowtracker->HistogramTarget_B.push_back(LearningHistogram_B[k+3]);
						TotalHistogramValue2 += LearningHistogram_B[k+3];
						
					}//end if
					
					//else
						//if(debugcout == 1) cout << "Delete Color in Background" << endl;
						
				}//end for k
				if(debugfout == 1) fouttest << "\t\tAfter Background Color:\t" <<LearningHistogram_B.size()/4 << endl;
				if(nowtracker->HistogramTarget_B.size() == 0) {
					if(debugcout == 1) cout << "Empty Background" << endl;
					if(debugfout == 1) fouttest << "Empty Background" << endl;
				}


				delete [] nowtracker->f1;
				delete [] nowtracker->WeightT;
				totalweight = 0;
				if(debugcout == 1) cout << "\t\tTarget Size: " << nowtracker->HistogramTarget.size()/4 << endl;
				nowtracker->s1.n = nowtracker->HistogramTarget.size()/4;
				nowtracker->f1 = new feature_t[nowtracker->HistogramTarget.size()/4];
				nowtracker->WeightT = new float [nowtracker->HistogramTarget.size()/4];
 	  			for(j=3;j<nowtracker->HistogramTarget.size();j+=4){// histogram normalization
	 	  			nowtracker->HistogramTarget[j] = nowtracker->HistogramTarget[j]*100/TotalHistogramValue1;
					nowtracker->WeightT[(j-3) / 4] = nowtracker->HistogramTarget[j];
					totalweight += nowtracker->HistogramTarget[j];
					nowtracker->f1[(j-3) / 4].X = nowtracker->HistogramTarget[j-3];
					nowtracker->f1[(j-3) / 4].Y = nowtracker->HistogramTarget[j-2];
					nowtracker->f1[(j-3) / 4].Z = nowtracker->HistogramTarget[j-1];
 	  			}
				
				for(j=3;j<nowtracker->HistogramTarget_B.size();j+=4){// histogram normalization
	 	  			//if(f>= 104 ) if(debugcout == 1) cout << nowtracker->HistogramTarget_B[j] << "\t";
					nowtracker->HistogramTarget_B[j] = nowtracker->HistogramTarget_B[j]*100/TotalHistogramValue2;
					//if(f>= 104 ) if(debugcout == 1) cout << nowtracker->HistogramTarget_B[j] << endl; 
 	  			}
				
				//for(j = 0; j < nowtracker->HistogramTarget.size()/4; j++){
				
					//WeightT[j] = WeightT[j] / totalweight;
				//}//end for j
				nowtracker->s1.Weights = nowtracker->WeightT;
				nowtracker->s1.Features = nowtracker->f1;

 	  
 	  		    time2 = clock();
				timeUTM += time2 - time1;
 	  
 	  
 	  
 	  
 	  
 	  
 	  			/*Debug*/
// 	  			fprintf(fpParticleStatus,"***********************************Frame idx = %d*****************************************\n",f);
//	 	  		fprintf(fpParticleStatus,"&&&&&&&&&Before Resampling&&&&&&&&&\n");
 //	  			for(i=0;i<NumParticleonObject;++i){//display the particle state before resampling
//	 	  			fprintf(fpParticleStatus, "BeforeRes %d: Postion(%d,%d), Box(%d,%d), weight= %f\n",i,nowtracker->PPostion[i][0],nowtracker->PPostion[i][1],nowtracker->PBoxWH[i][0],nowtracker->PBoxWH[i][1],nowtracker->PWeight[i]);
 //	  			}
 //	  			fprintf(fpParticleStatus, "Object State (BeforeRes) Postion(%d,%d), Box(%d,%d), \n",nowtracker->ObjectPX,nowtracker->ObjectPY,nowtracker->ObjectBoxW,nowtracker->ObjectBoxH);
 	  			//Resampling
 	  			/*k = 0;
 	  			for(i=0;i<NumParticleonObject;++i){
 	  				NumRes = (int)(nowtracker->PWeight[i]*NumParticleonObject);
 	  				for(j=0;j<NumRes;++j){
 	  					ResPPostion[k][0]	=	nowtracker->PPostion[i][0];
 	  					ResPPostion[k][1]	=	nowtracker->PPostion[i][1];
 	  					ResPBoxWH[k][0]		=	nowtracker->PBoxWH[i][0];
 	  					ResPBoxWH[k][1]		=	nowtracker->PBoxWH[i][1];
 	  					ResPWeight[k]		=	nowtracker->PWeight[i];
 	  					++k;
 	  				}
 	  			}
	 	  		*/
	 	  		
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
				/*for(i=0;i<NumParticleonObject;++i){
					for(k=max(0,nowtracker->PPostion[i][1]-nowtracker->PBoxWH[i][1]); k<= min(FrameH-1, nowtracker->PPostion[i][1] + nowtracker->PBoxWH[i][1]); ++k){
 	  					for(l=max(0, nowtracker->PPostion[i][0]-nowtracker->PBoxWH[i][0]); l<= min(FrameW-1, nowtracker->PPostion[i][0] + nowtracker->PBoxWH[i][0]); ++l){
 	  						//if(temp_img[k*FrameW+l] != 0){
								nownode = root->right;
								while(nownode != end){
									if(k >= nownode->upbound && k <= nownode->downbound && l >= nownode->leftbound && l <= nownode->rightbound){
										nownode->countpass--;
										if(nownode->countpass <= 0 )
											nownode->newtracker = true;
									}//end if
									nownode = nownode->right;
								}//end while
							//}//end if

 	  					}
 	  				}
				}
*/ 
				time1 = clock();
/*				nowtracker->ObjectBoxH_f	=	0; 
				nowtracker->ObjectPX_f	=	0;
	 	  		nowtracker->ObjectPY_f	=	0;
 		  		nowtracker->ObjectBoxW_f	=	0;

				for(i=0;i<NumParticleonObject;++i){
 	  				nowtracker->ObjectPX_f	+=	nowtracker->PWeight[i]*nowtracker->PPostion[i][0];
	 	  			nowtracker->ObjectPY_f	+=	nowtracker->PWeight[i]*nowtracker->PPostion[i][1];
 	  				nowtracker->ObjectBoxW_f	+=	nowtracker->PWeight[i]*nowtracker->PBoxWH[i][0];
	 	  			nowtracker->ObjectBoxH_f	+=	nowtracker->PWeight[i]*nowtracker->PBoxWH[i][1];
	
				

 		  		}
 	  			
				

				tempA = (nowtracker->ObjectPY_f - nowtracker->ObjectBoxH_f);
				tempB = (nowtracker->ObjectPY_f + nowtracker->ObjectBoxH_f);
 	  			k = max(0,tempA);
				l = min(FrameH - 1,tempB);
			
			
 	  			nowtracker->ObjectPY = (k + l) / 2;
 	  			nowtracker->ObjectBoxH = (l - k) / 2;

				tempA = (nowtracker->ObjectPX_f - nowtracker->ObjectBoxW_f);
				tempB = (nowtracker->ObjectPX_f + nowtracker->ObjectBoxW_f);
			
				k = max(0,tempA);

			
				l = min(FrameW - 1,tempB);

				nowtracker->ObjectPX = (k + l) / 2;
				nowtracker->ObjectBoxW = (l - k) / 2;
*/
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
						/*
						nownode = root->right;
						while(nownode != end){
							if(k >= nownode->upbound-Space && k <= nownode->downbound+Space && l >= nownode->leftbound-Space && l <= nownode->rightbound+Space){
								nownode->countpass--;
								if(nownode->countpass <= 0)
									nownode->newtracker = true;
							}//end if
							nownode = nownode->right;

						}//end while
						*/
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
				time2 = clock();
				timeDT += time2 - time1;


			
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
		time1 = clock();

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
						newtrackernode->ObjectBoxH = newtrackernode->IniHalfH*0.9;
						newtrackernode->ObjectPY = newtrackernode->IniPy;
						
						tempF = tempF - newtrackernode->IniHalfW*0.05;

						newtrackernode->ObjectBoxW = (tempF - tempE) / 2;
						newtrackernode->ObjectPX = (tempF + tempE) / 2;

						
						
					}
					else if(tempF >= FrameW - 15){
						newtrackernode->ObjectBoxH = newtrackernode->IniHalfH*0.9;
						newtrackernode->ObjectPY = newtrackernode->IniPy;
						
						tempE = tempE + newtrackernode->IniHalfW*0.05;
						newtrackernode->ObjectBoxW = (tempF - tempE) / 2;
						newtrackernode->ObjectPX = (tempF + tempE) / 2;
						
					}
					else if(tempG <= 15){
						
						tempH = tempH - newtrackernode->IniHalfH*0.05;
						newtrackernode->ObjectBoxH = (tempH - tempG) / 2;
						newtrackernode->ObjectPY = (tempH + tempG) / 2;
						
						
						newtrackernode->ObjectBoxW = newtrackernode->IniHalfW*0.9;
						newtrackernode->ObjectPX = newtrackernode->IniPx;
						
					}
					else if(tempH >= FrameH - 15){
						tempG = tempG + newtrackernode->IniHalfH*0.05;
						newtrackernode->ObjectBoxH = (tempH - tempG) / 2;
						newtrackernode->ObjectPY = (tempH + tempG) / 2;
						
						newtrackernode->ObjectBoxW = newtrackernode->IniHalfW*0.9;
						newtrackernode->ObjectPX = newtrackernode->IniPx;
						
					}
					else{
						newtrackernode->ObjectBoxH = newtrackernode->IniHalfH*0.9;
						newtrackernode->ObjectPY = newtrackernode->IniPy;
						newtrackernode->ObjectBoxW = newtrackernode->IniHalfW*0.9;
						newtrackernode->ObjectPX = newtrackernode->IniPx;
					}
					newtrackernode ->IniHalfH = newtrackernode->ObjectBoxH;
					newtrackernode ->IniHalfW = newtrackernode->ObjectBoxW;
					newtrackernode->IniPx = newtrackernode->ObjectPX;
					newtrackernode->IniPy = newtrackernode->ObjectPY;

					newtrackernode->ratio = newtrackernode->IniHalfH / newtrackernode->IniHalfW;

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

					TotalHistgramValue = 0;//2. Target Model : color histogram
					TotalHistgramValuet = 0;
					diag = (float)sqrt((float)(newtrackernode->IniHalfW*newtrackernode->IniHalfW + newtrackernode->IniHalfH*newtrackernode->IniHalfH));
					
					for(j= 0; j < newtrackernode->HistogramTarget.size(); j+=4){
					
						newtrackernode->HistogramTarget[j+3] = 0;;


					}
					centroid[0] = (max(0,newtrackernode->IniPy-newtrackernode->IniHalfH_B) + min(FrameH-1, newtrackernode->IniPy + newtrackernode->IniHalfH_B)) / 2;
					centroid[1] = (max(0,newtrackernode->IniPx-newtrackernode->IniHalfW_B) + min(FrameW-1, newtrackernode->IniPx + newtrackernode->IniHalfW_B)) / 2;
					
					TempHistValue = 1;
					newtrackernode->HistogramTarget.clear();
					newtrackernode->HistogramTarget_B.clear();
					for(k=max(0,newtrackernode->IniPy-newtrackernode->IniHalfH_B); k<= min(FrameH-1, newtrackernode->IniPy + newtrackernode->IniHalfH_B); ++k){
 	  					for(l=max(0,newtrackernode->IniPx-newtrackernode->IniHalfW_B); l<= min(FrameW-1, newtrackernode->IniPx + newtrackernode->IniHalfW_B); ++l){
 	  						//if(k<0) k=0;
 	  						//if(k>=FrameH) k=FrameH-1;
 	  						//if(l<0) l=0;
 	  						//if(l>=FrameW) l=FrameW-1;
 	  						if(k >= max(0,newtrackernode->IniPy-newtrackernode->IniHalfH) && k <= min(FrameH-1, newtrackernode->IniPy + newtrackernode->IniHalfH) &&
								l >= max(0,newtrackernode->IniPx-newtrackernode->IniHalfW) && l<= min(FrameW-1, newtrackernode->IniPx + newtrackernode->IniHalfW) ){
								
								donehistogram = false;
								for(j= 0; j < newtrackernode->HistogramTarget.size(); j+=4){
										if((segbufferY[k*FrameW + l ] != 0) && 
											(newtrackernode->HistogramTarget[j] >= framebufferY[k*FrameW + l] - HistogramThreshold && newtrackernode->HistogramTarget[j] <= framebufferY[k*FrameW + l]+ HistogramThreshold) && 
											(newtrackernode->HistogramTarget[j+1] >= framebufferU[k/2*FrameW2 + l/2] - HistogramThreshold && newtrackernode->HistogramTarget[j+1] <= framebufferU[k/2*FrameW2 + l/2] + HistogramThreshold) &&
											(newtrackernode->HistogramTarget[j+2] >= framebufferV[k/2*FrameW2 + l/2] - HistogramThreshold && newtrackernode->HistogramTarget[j+2] <= framebufferV[k/2*FrameW2 + l/2] + HistogramThreshold) 	){
											donehistogram = true;
											if(CENTER == 1){

												newtrackernode->HistogramTarget[j+3] += (255 - sqrt((float)((k - centroid[0]) * (k - centroid[0]) + (l - centroid[1]) * (l - centroid[1]))) / sqrt(float(newtrackernode->IniHalfH * newtrackernode->IniHalfH + newtrackernode->IniHalfW * newtrackernode->IniHalfW)));
											}
											else{
												newtrackernode->HistogramTarget[j+3] ++;
											}
											break;
										}//end if
								}
								if((segbufferY[k*FrameW + l ] != 0) && !donehistogram){
									newtrackernode->HistogramTarget.push_back(framebufferY[k*FrameW + l]);
									newtrackernode->HistogramTarget.push_back(framebufferU[k/2*FrameW2 + l/2]);
									newtrackernode->HistogramTarget.push_back(framebufferV[k/2*FrameW2 + l/2]);
									if(CENTER == 1){
										newtrackernode->HistogramTarget.push_back(255 - sqrt((float)((k - centroid[0]) * (k - centroid[0]) + (l - centroid[1]) * (l - centroid[1]))) / sqrt(float(newtrackernode->IniHalfH * newtrackernode->IniHalfH + newtrackernode->IniHalfW * newtrackernode->IniHalfW)));

									}
									else{
										newtrackernode->HistogramTarget.push_back(1);
									}
								}//end if

								//newtrackernode->HistogramTarget[j] +=int (TempHistValue*128)/128;
								if(CENTER == 1){
									TotalHistgramValue += (255 - sqrt((float)((k - centroid[0]) * (k - centroid[0]) + (l - centroid[1]) * (l - centroid[1]))) / sqrt(float(newtrackernode->IniHalfH * newtrackernode->IniHalfH + newtrackernode->IniHalfW * newtrackernode->IniHalfW)));//TempHistValue;
								}
								else{
									TotalHistgramValue ++;
								}
							}//end if
							else{
								donehistogram = false;
								for(j= 0; j < newtrackernode->HistogramTarget_B.size(); j+=4){
										if((newtrackernode->HistogramTarget_B[j] >= framebufferY[k*FrameW + l] - HistogramThreshold && newtrackernode->HistogramTarget_B[j] <= framebufferY[k*FrameW + l] + HistogramThreshold) && 
											(newtrackernode->HistogramTarget_B[j+1] >= framebufferU[k/2*FrameW2 + l/2] - HistogramThreshold && newtrackernode->HistogramTarget_B[j+1] <= framebufferU[k/2*FrameW2 + l/2] + HistogramThreshold ) &&
											(newtrackernode->HistogramTarget_B[j+2] >= framebufferV[k/2*FrameW2 + l/2] - HistogramThreshold && newtrackernode->HistogramTarget_B[j+2] <= framebufferV[k/2*FrameW2 + l/2] + HistogramThreshold) 	){
											donehistogram = true;
											newtrackernode->HistogramTarget_B[j+3]++;
											break;
										}//end if
								}
								if(!donehistogram){
									newtrackernode->HistogramTarget_B.push_back(framebufferY[k*FrameW + l]);
									
									newtrackernode->HistogramTarget_B.push_back(framebufferU[k/2*FrameW2 + l/2]);
									newtrackernode->HistogramTarget_B.push_back(framebufferV[k/2*FrameW2 + l/2]);
									newtrackernode->HistogramTarget_B.push_back(1);
								}//end if

								//newtrackernode->HistogramTarget[j] +=int (TempHistValue*128)/128;
 	  							TotalHistgramValuet += 1;//TempHistValue;
							
							
							}//end else
 	  					}
	 	  				
 	  				}

					totalweight = 0;
					if(debugcout == 1) cout << "\t\tNew Target Size: " << newtrackernode->HistogramTarget.size()/4 << endl;
					if(debugfout == 1) fouttest << "\t\tNew Target Size: " << newtrackernode->HistogramTarget.size()/4 << endl;
					newtrackernode->s1.n = newtrackernode->HistogramTarget.size()/4;
					newtrackernode->f1 = new feature_t[newtrackernode->HistogramTarget.size()/4];
					newtrackernode->WeightT = new float [newtrackernode->HistogramTarget.size()/4];

 	  				for(j=3;j<newtrackernode->HistogramTarget.size();j+=4){// histogram normalization
	 	  				newtrackernode->HistogramTarget[j] = newtrackernode->HistogramTarget[j]*100/TotalHistgramValue;
						newtrackernode->WeightT[(j-3) / 4] = newtrackernode->HistogramTarget[j];
						//totalweight += newtrackernode->HistogramTarget[j];
						newtrackernode->f1[(j-3) / 4].X = newtrackernode->HistogramTarget[j-3];
						newtrackernode->f1[(j-3) / 4].Y = newtrackernode->HistogramTarget[j-2];
						newtrackernode->f1[(j-3) / 4].Z = newtrackernode->HistogramTarget[j-1];
						
 	  				}
					//if(f >= 104 ) if(debugcout == 1) cout << "TotalHistogramValuet\t" <<  TotalHistgramValuet<< endl;
					for(j=3;j<newtrackernode->HistogramTarget_B.size();j+=4){// histogram normalization
	 	  				//if(f >= 104) if(debugcout == 1) cout << "NEW" << newtrackernode->HistogramTarget_B[j] << "\t";
						newtrackernode->HistogramTarget_B[j] = newtrackernode->HistogramTarget_B[j]*100/TotalHistgramValuet;
						//if(f >= 104) if(debugcout == 1) cout << newtrackernode->HistogramTarget_B[j] << endl;
 	  				}

					/*for(j = 0; j < newtrackernode->s1.n; j++){
						newtrackernode->WeightT[j] = newtrackernode->WeightT[j] *100 / totalweight;
						
					}//end for j
					*/newtrackernode->s1.Features = newtrackernode->f1;
					newtrackernode->s1.Weights = newtrackernode->WeightT;
					time3 = clock();
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
					time4 = clock();
					timeSF += time4 - time3;



					numoftracker++;
					doneadd = true;
				//}
				
			}//end if
		
			nownode = nownode->right;
			delete nownode->left;
			



		}//end while
		time2 = clock();
		timeAT += time2 - time1 - timeSF;
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
		
/*
		for(j = 0; j < FrameH; j++){
			for(i = 0; i < FrameW; i++){
				if(j%40 == 0 || i % 40 == 0){
					FrameDisplayY[j*FrameW+i] = 0;
					FrameDisplayU[(j/2*FrameW+i)/2] = 0;
					FrameDisplayV[(j/2*FrameW+i)/2] = 0;
				}
			}
		}*/
		fwrite ( FrameDisplayY, 1, FrameH*FrameW, fpout1);			
		fwrite ( FrameDisplayU, 1, FrameH2*FrameW2, fpout1);			
		fwrite ( FrameDisplayV, 1, FrameH2*FrameW2, fpout1);
		

		for(i = 0; i < counter; i++){
			delete [] countseg[i];
		}//end for i
		delete [] countseg;
		
		//if(f == 182) system("pause");
	}
//	double timeSamplingImportance, timeSample, timeImportance, timeWeightNormalization, timeEstimationofObjCurrentState, timeProduct, timeDisplay, timeUpdate;
//	if(debugcout == 1) cout<<"Sampling + Importance 1(Weight update): "<<timeSamplingImportance<<endl;
//	if(debugcout == 1) cout<<"Sampling: \t"<<timeSample<<endl;
//	if(debugcout == 1) cout<<"Importance: \t"<<timeImportance<<endl;
//	if(debugcout == 1) cout<<"Weight Normalization: \t"<<timeWeightNormalization<<endl;
//	if(debugcout == 1) cout<<"Estimation of Objecti Current State: \t"<<timeEstimationofObjCurrentState<<endl;
//	if(debugcout == 1) cout<<"Produce Result: \t"<<timeProduct<<endl;
//	if(debugcout == 1) cout<<"Display Obj: \t"<<timeDisplay<<endl;
//	if(debugcout == 1) cout<<"Update: \t"<<timeUpdate<<endl;

	//system("pause");
//	return 0;
	
	//system("pause");
	return 0;


	
}




float grandom(){
	float x1, x2, w, y1, y2;
	/*
	do{
			x1 = 2*(float)rand()/(float)RAND_MAX - 1;
			x2 = 2*(float)rand()/(float)RAND_MAX - 1;
			w = x1 * x1 + x2 * x2;
	}while(w >= 1.0 || w <= 0);
				
	w = sqrt((-2*log(w)) / w);
				
	y1 = x1 * w;
	y2 = x2 * w;
	*/

	x1 = (float)rand()/(float)RAND_MAX;
	x2 = (float)rand()/(float)RAND_MAX;
	y1 = sqrt( - 2 * log(x1) ) * cos( 2 * 3.1415926 * x2);
	return y1;

}
