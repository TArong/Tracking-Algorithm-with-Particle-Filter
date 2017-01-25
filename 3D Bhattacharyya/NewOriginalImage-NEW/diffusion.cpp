#include "diffusion.h"
#include "BD.h"
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <cmath>
#include <vector>
#include "emd.h"

#define L 5
#define t 12
#define pi 3.1415926
#define WindowSize 2

#define D 1


using namespace std;


float DFdist(signature_t *Signature1, signature_t* Signature2){
	//vector<distance_t> d0, d1, d2;
	
	int i, j, k, m, n, o, iteration, z, size;
	int amount;
	float aX, bX, aYZ, bYZ;//, aZ, bZ;
	float aY, bY, aZ, bZ;
	vector< int > index;
	//vector<int> index;
	float answerX, answerYZ;//, answerZ;
	float answerY, answerZ;
	feature_t *p1, *p2;
	bool donefind;
	float totaldistanceX = 0;
	float totaldistanceYZ = 0;
	float totaldistanceY = 0;
	float totaldistanceZ = 0;

	float total1 = 0;
	float total2 = 0;
	//ofstream fcout("test3.txt", ios::app);
	
	


	float * d0_X = new float  [256];
	float * d1_X = new float  [256];
	float * d2_X = new float  [256];
	float * d0_Y = new float  [256];
	float * d1_Y = new float  [256];
	float * d2_Y = new float  [256];
	float * d0_Z = new float  [256];
	float * d1_Z = new float  [256];
	float * d2_Z = new float  [256];

	float* d0_YZ_ptr = new float [256*256];
	float* d1_YZ_ptr = new float [256*256];
	float* d2_YZ_ptr = new float [256*256];

	float** d0_YZ = new float* [256];
	float** d1_YZ = new float* [256];
	float** d2_YZ = new float* [256];

	totaldistanceX = 0;
	totaldistanceY = 0;
	totaldistanceZ = 0;



	

	for(i = 0; i < 256; i++){
		d0_YZ[i] = &d0_YZ_ptr[256*i];
		d1_YZ[i] = &d1_YZ_ptr[256*i];
		d2_YZ[i] = &d2_YZ_ptr[256*i];

		d0_X[i] = 0;
		d1_X[i] = 0;
		d2_X[i] = 0;
		d0_Y[i] = 0;
		d1_Y[i] = 0;
		d2_Y[i] = 0;
		d0_Z[i] = 0;
		d1_Z[i] = 0;
		d2_Z[i] = 0;
		if(D == 2){
			for(j = 0; j < 256; j++){

				d0_YZ[i][j] = 0;
				d1_YZ[i][j] = 0;
				d2_YZ[i][j] = 0;
			
			}
		}
	
	}//end for i



	//if(index.size() != 0)
	index.clear();
	
	
	//fcout << "1" << endl;
	for(i = 0, p1 = Signature1->Features; i < Signature1->n; i++, p1++){
		d0_X[p1->X] += Signature1->Weights[i];
		d0_Y[p1->Y] += Signature1->Weights[i];
		d0_Z[p1->Z] += Signature1->Weights[i];
		d0_YZ[p1->Y][p1->Z] += Signature1->Weights[i];
		//fcout << p1->X <<" "<< p1->Y <<" " << p1->Z << " " <<Signature1->Weights[i] << endl;;

		
	}//end for i
	//fcout << "2" << endl;
		
	for(j = 0, p2 = Signature2->Features; j < Signature2->n; j++, p2++){
		d0_X[p2->X] -= Signature2->Weights[j];
		d0_Y[p2->Y] -= Signature2->Weights[j];
		d0_Z[p2->Z] -= Signature2->Weights[j];
		d0_YZ[p2->Y][p2->Z] -= Signature2->Weights[j];
		//fcout << p2->X <<" "<< p2->Y <<" " << p2->Z << " " <<Signature2->Weights[j] << endl;
			
		
	
	}//end for j
	



	
	
	
	for(i = 0; i < 256; i++){
		d2_X[i] = d0_X[i];
		if(D == 2){
			for(j = 0; j < 256; j++){
				d2_YZ[i][j] = d0_YZ[i][j];
				totaldistanceYZ+=abs(d2_YZ[i][j]);
			
			}
		}
		totaldistanceX+=abs(d2_X[i]);
		totaldistanceY+=abs(d2_Y[i]);
		totaldistanceZ+=abs(d2_Z[i]);
		
		

	}//end for i
	
	amount = 256;

	for(iteration = 2; iteration <= L; iteration++){
		
			
		for(i = 0; i < 256; i++){
			
						
			answerX = 0;
			answerY = 0;
			answerZ = 0;
			answerYZ = 0;
			
			for(m = 0-WindowSize; m <= WindowSize; m++){
						
				if(i + m < 0 || i + m > amount-1 ){
					aX = 0;
					bX = 0;
					aY = 0;
					bY = 0;
					aZ = 0;
					bZ = 0;
					

				}
				else{
					aX = d2_X[i + m];
					bX = (float)1 / pow(2*pi,0.5) / (float)iteration * exp((float)(-(((float)m) * ((float)m)) / 2 / (float)iteration / (float)iteration));
					aY = d2_Y[i + m];
					bY = (float)1 / pow(2*pi,0.5) / (float)iteration * exp(float(-(((float)m) * ((float)m)) / 2 / (float)iteration / (float)iteration));
					aZ = d2_Z[i + m];
					bZ = (float)1 / pow(2*pi,0.5) / (float)iteration * exp(float(-(((float)m) * ((float)m)) / 2 / (float)iteration / (float)iteration));
					
									
				}//end else
				answerX += aX * bX;
				answerY += aY * bY;
				answerZ += aZ * bZ;
				

				
		
			}//end for m
			d1_X[i] = answerX;
			d1_Y[i] = answerY;
			d1_Z[i] = answerZ;
			
			totaldistanceX += abs(answerX);
			totaldistanceY += abs(answerY);
			totaldistanceZ += abs(answerZ);
			

			if(D == 2){
				for(j = 0; j < 256; j++){
					for(m = 0-WindowSize; m <= WindowSize; m++){
						for(n = 0-WindowSize; n <= WindowSize; n++){
							
							if(i + m < 0 || i + m > amount-1 ){
								aYZ = 0;
								bYZ = 0;
							}
							else if(j + n < 0 || j + n > amount-1 ){
								aYZ = 0;
								bYZ = 0;
							}
							else{
								aYZ = d2_YZ[i + m][j + n];
								bYZ = (float)1 / pow(2*pi,1) / (float)iteration * exp(float(-(((float)m) * ((float)m) + ((float)n) * ((float)n)) / 2 / (float)iteration / (float)iteration));
							
										
							}//end else
							answerYZ += aYZ * bYZ;
					
	
						}//end for n
			
					}//end for m

					d1_YZ[i][j] = answerYZ;
			
					totaldistanceYZ += abs(answerYZ);
			
			
				}//end for j
			}//end if D
		
		}//end for i

	
		//cout << "amount: " << amount << endl;
		//cout << "totaldistance: " << totaldistance << endl;
		amount/=2;
		

		for(i = 0; i < amount; i++){
			
			
			d2_X[i] = (d1_X[2*i]+ d1_X[2*i+1])/2;
			d2_Y[i] = (d1_Y[2*i]+ d1_Y[2*i+1])/2;
			d2_Z[i] = (d1_Z[2*i]+ d1_Z[2*i+1])/2;
			
			
			//d1[i][j][k] = 0;
			d1_X[2*i] = 0;
			d1_X[2*i+1] = 0;
			d1_Y[2*i] = 0;
			d1_Y[2*i+1] = 0;
			d1_Z[2*i] = 0;
			d1_Z[2*i+1] = 0;
			if(D == 2){
				for(j = 0; j < amount; j++){
					d2_YZ[i][j] = (d1_YZ[2*i][2*j]+ d1_YZ[2*i+1][2*j]+d1_YZ[2*i][2*j+1]+ d1_YZ[2*i+1][2*j+1])/4;
	
					d1_YZ[2*i][2*j] = 0;
					d1_YZ[2*i+1][2*j] = 0;	
					d1_YZ[2*i][2*j+1] = 0;
					d1_YZ[2*i+1][2*j+1] = 0;	
			
				}//end for j
			}
			
			
			
			
		}//end for i
		//cout << "iteration: " << iteration << endl;

		
	}//end for iteration
	
	

	
	delete [] d0_X;
	delete [] d1_X;
	delete [] d2_X;
	delete [] d0_Y;
	delete [] d1_Y;
	delete [] d2_Y;
	delete [] d0_Z;
	delete [] d1_Z;
	delete [] d2_Z;
	delete [] d0_YZ_ptr;
	delete [] d1_YZ_ptr;
	delete [] d2_YZ_ptr;
	delete [] d0_YZ;
	delete [] d1_YZ;
	delete [] d2_YZ;

//	cout << "Return" << endl;
//	system("pause");
	if(D == 1)
		return pow((double)(totaldistanceX*totaldistanceX + totaldistanceY*totaldistanceY + totaldistanceZ*totaldistanceZ),1);//*(totaldistanceX*totaldistanceX + totaldistanceY*totaldistanceY + totaldistanceZ * totaldistanceZ);//*(totaldistanceX*totaldistanceX + totaldistanceY*totaldistanceY + totaldistanceZ * totaldistanceZ);
	else
		return(totaldistanceX*totaldistanceX + totaldistanceYZ*totaldistanceYZ)*(totaldistanceX*totaldistanceX + totaldistanceYZ*totaldistanceYZ);
	
}//end dist()

