#include "BD.h"
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <cmath>
#include <vector>
#include "emd.h"

#define L 4
#define t 12
#define pi 3.1415926
#define WindowSize 2
#define ColorThreshold 1



using namespace std;


float BDdist(signature_t *Signature1, signature_t* Signature2){
	//vector<distance_t> d0, d1, d2;
	
	int i, j, k, m, n, o, iteration, z, size;
	int amount;
	float a, b;
	vector< int > index;
	//vector<int> index;
	float answer;
	feature_t *p1, *p2;
	bool donefind;
	float totaldistance = 0.0001;
	
	//ofstream fcout("test3.txt", ios::app);
	
	


	
	
	for(i = 0, p1 = Signature1->Features; i < Signature1->n; i++, p1++){
		
		

		
		for(j = 0, p2 = Signature2->Features; j < Signature2->n; j++, p2++){
			
			if(p2->X >= p1->X - ColorThreshold && p2->X <= p1->X + ColorThreshold && 
				p2->Y >= p1->Y - ColorThreshold && p2->Y <= p1->Y + ColorThreshold && 
				p2->Z >= p1->Z - ColorThreshold && p2->Z <= p1->Z + ColorThreshold){
				totaldistance += sqrt(Signature1->Weights[i] * Signature2->Weights[j]);
				
				
				

			}//end if
		}//end for j
		
	}//end for i


	
	

	
	return 1/totaldistance/totaldistance;	
}//end dist()

