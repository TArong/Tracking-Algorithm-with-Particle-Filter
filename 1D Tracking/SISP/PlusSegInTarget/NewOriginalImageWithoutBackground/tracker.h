#include "CnvntnlPFTrial.h"
#include <cstdio>
#include <iostream>
#include <cstdlib>
#include "emd.h"
#ifndef TRACKER_H
#define TRACKER_H
using namespace std;

class tracker{
	public:
		tracker();
		~tracker();
		
		
		
		
		tracker* left;
		tracker* right;
		double ratio;
		double GaussianKernel;
		double GaussianKernel_temp;

		int PPostion[NumParticleonObject][2];
		int PBoxWH[NumParticleonObject][2];
//		float HistogramTarget[NumHistBin];
//		float HistogramTarget_B[NumHistBin];
		//vector<float> HistogramTarget;
		//vector<float> HistogramTarget_B;
      long long int* HistogramTarget_Y_O;
      long long int* HistogramTarget_Y_E;

      long long int* HistogramTarget_U_O;
      long long int* HistogramTarget_U_E;

      long long int* HistogramTarget_V_O;
      long long int* HistogramTarget_V_E;
      int totalhistogram;

      


		//float TotalHistgramValue;
		//float diag;
		//int TempBinIdx;
		//float TempHistValue;
		//float SumofWeight;
		//float BhaCoef;
		//float BhaDist2;
		int colory, coloru, colorv;
		int previousX, previousY;
		int pre_previousX, pre_previousY;
		int velocityX, velocityY;
		

		float confidence;

		float PWeight[NumParticleonObject];

		float ObjectPX_f;
		float ObjectPY_f;
		float ObjectBoxW_f;
		float ObjectBoxH_f;
		int ObjectPX;
		int ObjectPY;
		int ObjectBoxW;
		int ObjectBoxH;

		//int ObjectPX_B;
		//int ObjectPY_B;
		int ObjectBoxW_B;
		int ObjectBoxH_B;

		int IniPx, IniPy, IniHalfW, IniHalfH;
		int IniHalfW_B, IniHalfH_B;
		bool deleteTracker;

		bool NoParticle;

};


#endif