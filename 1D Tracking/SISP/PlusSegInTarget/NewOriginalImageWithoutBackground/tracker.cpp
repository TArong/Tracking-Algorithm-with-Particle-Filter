#include "CnvntnlPFTrial.h"
#include "tracker.h"
#include <vector>

using namespace std;

tracker::tracker(){
	left = 0;
	right = 0;
	colory = 0;
	coloru = 0;
	colorv = 0;
	NoParticle = false;
	GaussianKernel = 20000;
	GaussianKernel_temp = 0;
	velocityX = 0;
	velocityY = 0;
	previousX = 0;
	previousY = 0;
	pre_previousX = 0;
	pre_previousY = 0;
	ratio = 1;
   totalhistogram = 0;
	
	int i;

	for(i = 0; i < NumParticleonObject; i++){
		PPostion[i][0] = 0;
		PPostion[i][1] = 0;
		PBoxWH[i][0] = 0;
		PBoxWH[i][1] = 0;
		
		PWeight[i] = 0;
		

	}
/*
	for(i = 0; i < NumHistBin; i++){
		HistogramTarget[i] = 0;
	}//end for i
*/	
	//HistogramTarget.clear();
	//HistogramTarget_B.clear();
   HistogramTarget_Y_O = new long long int [128];
   HistogramTarget_Y_E = new long long int [128];

   HistogramTarget_U_O = new long long int [128];
   HistogramTarget_U_E = new long long int [128];

   HistogramTarget_V_O = new long long int [128];
   HistogramTarget_V_E = new long long int [128];
   for(i = 0; i < 128; i++){
      HistogramTarget_Y_O[i] = 0;
      HistogramTarget_Y_E[i] = 0;
      HistogramTarget_U_O[i] = 0;
      HistogramTarget_U_E[i] = 0;
      HistogramTarget_V_O[i] = 0;
      HistogramTarget_V_E[i] = 0;
   }//end for i

	ObjectPX_f = 0;
	ObjectPY_f = 0;
	ObjectBoxW_f = 0;
	ObjectBoxH_f = 0;
	ObjectPX = 0;
	ObjectPY = 0;
	ObjectBoxW = 0;
	ObjectBoxH = 0;
//	ObjectPX_B = 0;
//	ObjectPY_B = 0;
	ObjectBoxW_B = 0;
	ObjectBoxH_B = 0;

	IniPx = 0;
	IniPy = 0;
	IniHalfW = 0;
	IniHalfH = 0;
//	IniPx_B = 0;
//	IniPy_B = 0;
	IniHalfW_B = 0;
	IniHalfH_B = 0;
	confidence = 0;
	deleteTracker = false;
}

tracker::~tracker(){
	left = 0;
	right = 0;
	
	int i;

	confidence = 0;
	for(i = 0; i < NumParticleonObject; i++){
		PPostion[i][0] = 0;
		PPostion[i][1] = 0;
		PBoxWH[i][0] = 0;
		PBoxWH[i][1] = 0;
		
		PWeight[i] = 0;
		

	}
	

	ObjectPX_f = 0;
	ObjectPY_f = 0;
	ObjectBoxW_f = 0;
	ObjectBoxH_f = 0;
	ObjectPX = 0;
	ObjectPY = 0;
	ObjectBoxW = 0;
	ObjectBoxH = 0;
//	ObjectPX_B = 0;
//	ObjectPY_B = 0;
	ObjectBoxW_B = 0;
	ObjectBoxH_B = 0;

	IniPx = 0;
	IniPy = 0;
	IniHalfW = 0;
	IniHalfH = 0;
//	IniPx_B = 0;
//	IniPy_B = 0;
	IniHalfW_B = 0;
	IniHalfH_B = 0;
	colory = 0;
	coloru = 0;
	colorv = 0;

	/*
	for(i = 0; i < NumHistBin; i++){
		HistogramTarget[i] = 0;
	}//end for i
*/	
	delete HistogramTarget_Y_O;
   delete HistogramTarget_Y_E;

   delete HistogramTarget_U_O;
   delete HistogramTarget_U_E;

   delete HistogramTarget_V_O;
   delete HistogramTarget_V_E;
	deleteTracker = false;

}