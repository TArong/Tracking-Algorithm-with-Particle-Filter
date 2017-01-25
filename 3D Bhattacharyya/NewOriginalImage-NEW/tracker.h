#include "CnvntnlPFTrial.h"
#include <vector>
#include "emd.h"
#ifndef TRACKER_H
#define TRACKER_H
using namespace std;

class tracker{
	public:
		tracker();
		~tracker();
		
		feature_t* f1;
		signature_t s1;
		float* WeightT;
		tracker* left;
		tracker* right;
		double ratio;
		double GaussianKernel;
		double GaussianKernel_temp;

		int PPostion[NumParticleonObject][2];
		int PBoxWH[NumParticleonObject][2];
//		float HistogramTarget[NumHistBin];
//		float HistogramTarget_B[NumHistBin];
		vector<float> HistogramTarget;
		vector<float> HistogramTarget_B;
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