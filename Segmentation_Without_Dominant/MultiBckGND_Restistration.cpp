#include <stdio.h>
#include <fstream>
#include <iostream>
#include "MultiBckGND_Registration.h"
#include "math.h"
#include <vector>

using namespace std;

void dilation (unsigned char **, unsigned char **, int, int);
void erosion (unsigned char **, unsigned char **, int, int);

void main(int argc, char *argv[]){
/******  input / output file declaration  ******/

	int size_sequence = atoi(argv[2]);
	int img_width = atoi(argv[3]);
	int img_height = atoi(argv[4]);
	int opendominant = atoi(argv[7]);   //1: turn on dominant
	int img_width_2 = img_width/2;
	int img_height_2 = img_height/2;
	int ratio;
	int countbackground;
	char filename [500];
	int GTth;
	FILE* fp_in, *fp_objmsk, *fp_bg;// *fp_bckgnd0, *fp_built0, *fp_occupied0, *fp_bckgnd1, *fp_built1, *fp_occupied1, *fp_bckgnd2, *fp_built2, *fp_occupied2, *fp_bckgnd3, *fp_built3, *fp_occupied3/*, *fp_bckgnd4, *fp_built4, *fp_occupied4, *fp_bckgnd5, *fp_built5, *fp_occupied5*/, *fp_GTResult, *fp_FDGTResult, *fp_NoiLvlRpt;
	GTth = atoi(argv[5]);
	ratio = atoi(argv[6]);
	strcpy(filename, argv[1]);
	strncat(filename, ".yuv", strlen(".yuv"));
	cout << "Read " << filename << "......." << endl;
	fp_in = fopen(filename,"rb");
	strcpy(filename, argv[1]);
	strncat(filename, "_ObjMsk.y", strlen("_ObjMsk.y"));
	fp_objmsk = fopen(filename,"wb");
	strcpy(filename, argv[1]);
	strncat(filename, "_background.yuv", strlen("_background.yuv"));
	fp_bg = fopen(filename,"wb");

	/*strcpy(filename, argv[1]);
	strncat(filename, "_BckGnd0.yuv", strlen("_BckGnd0.yuv"));
	fp_bckgnd0 = fopen(filename,"wb");
	strcpy(filename, argv[1]);
	strncat(filename, "_BckGnd1.yuv", strlen("_BckGnd1.yuv"));
	fp_bckgnd1 = fopen(filename,"wb");
	strcpy(filename, argv[1]);
	strncat(filename, "_BckGnd2.yuv", strlen("_BckGnd2.yuv"));
	fp_bckgnd2 = fopen(filename,"wb");
	strcpy(filename, argv[1]);
	strncat(filename, "_T0GT1000_NV3(6)FDT3_GTResult.yuv", strlen("_T0GT1000_NV3(6)FDT3_GTResult.yuv"));
	fp_GTResult = fopen(filename,"wb");
	strcpy(filename, argv[1]);
	strncat(filename, "_T0GT1000_NV3(6)FDT3_FDGTResult.yuv", strlen("_T0GT1000_NV3(6)FDT3_FDGTResult.yuv"));
	fp_FDGTResult = fopen(filename,"wb");
	strcpy(filename, argv[1]);
	strncat(filename, "_T0GT1000_NV3(6)FDT3_NoiLvlRpt.txt", strlen("_T0GT1000_NV3(6)FDT3_NoiLvlRpt.txt"));
	fp_NoiLvlRpt = fopen(filename,"w");
*//*
	FILE* fcolor;
	strcpy(filename, argv[1]);
	strncat(filename, "_domain_color.clr", strlen("_domain_color.clr"));
	fcolor = fopen(filename, "wb");
*/
	FILE* foutimg;
	strcpy(filename, argv[1]);
	strncat(filename, "_new_img.yuv", strlen("_new_img.yuv"));
	foutimg = fopen(filename, "wb");

	//ofstream fout("test.txt");
	//ofstream fout2("test2.txt");

	double abs_y, abs_u, abs_v;
	double abs_y_t, abs_u_t, abs_v_t;

	int amount1, amount2;
	int i, j, k, l, m, n;
	float I1, I2, I3, I4, H_GT;
	unsigned int BDmin, Tmp_BDk;
	bool shadowcancel;
	int BckgndBlckNum;
	float BckgndBDminSqrtAvg, BckgndFDSqrtAvg, BDminNoiseVar, FDNoiseVar;

/******  current images ******/
	unsigned int FD, Tmp_FDk;
	//unsigned char **cur_frame_Y_ori = new unsigned char *[img_height];
	unsigned char *cur_frame_Y_ori_ptr = new unsigned char [img_height*img_width];
	unsigned char **cur_frame_Y_ori = new unsigned char* [img_height];
	
	
	//unsigned char **cur_frame_Y = new unsigned char *[img_height];
	unsigned char *cur_frame_Y_ptr = new unsigned char [img_height*img_width];
	unsigned char **cur_frame_Y = new unsigned char* [img_height];
	

	//unsigned char **cur_frame_U = new unsigned char *[img_height];
	unsigned char *cur_frame_U_ptr = new unsigned char [img_height_2*img_width_2];
	unsigned char **cur_frame_U = new unsigned char* [img_height_2];
	

	//unsigned char **cur_frame_V = new unsigned char *[img_height];
	unsigned char *cur_frame_V_ptr = new unsigned char [img_height_2*img_width_2];
	unsigned char **cur_frame_V = new unsigned char* [img_height_2];
	

	//unsigned char **color_Y = new unsigned char *[img_height];
	unsigned char *color_Y_ptr = new unsigned char [img_height*img_width];
	unsigned char **color_Y = new unsigned char* [img_height];
	
	//unsigned char **color_U = new unsigned char *[img_height];
	unsigned char *color_U_ptr = new unsigned char [img_height_2*img_width_2];
	unsigned char **color_U = new unsigned char* [img_height_2];
	
	//unsigned char **color_V = new unsigned char *[img_height];
	unsigned char *color_V_ptr = new unsigned char [img_height_2*img_width_2];
	unsigned char **color_V = new unsigned char* [img_height_2];

	unsigned char *bg_Y_ptr = new unsigned char [img_height*img_width];
	unsigned char **bg_Y = new unsigned char* [img_height];
	
	//unsigned char **bg_U = new unsigned char *[img_height];
	unsigned char *bg_U_ptr = new unsigned char [img_height_2*img_width_2];
	unsigned char **bg_U = new unsigned char* [img_height_2];
	
	//unsigned char **bg_V = new unsigned char *[img_height];
	unsigned char *bg_V_ptr = new unsigned char [img_height_2*img_width_2];
	unsigned char **bg_V = new unsigned char* [img_height_2];

	unsigned int *bg_temp_Y_ptr = new unsigned int [img_height*img_width];
	unsigned int **bg_temp_Y = new unsigned int* [img_height];
	
	//unsigned int **bg_temp_U = new unsigned int *[img_height];
	unsigned int *bg_temp_U_ptr = new unsigned int [img_height_2*img_width_2];
	unsigned int **bg_temp_U = new unsigned int* [img_height_2];
	
	//unsigned int **bg_temp_V = new unsigned int *[img_height];
	unsigned int *bg_temp_V_ptr = new unsigned int [img_height_2*img_width_2];
	unsigned int **bg_temp_V = new unsigned int* [img_height_2];
	
	
	//unsigned char **Pre_frame_Y = new unsigned char *[img_height];
	//unsigned char **Pre_frame_U = new unsigned char *[img_height];
	//unsigned char **Pre_frame_V = new unsigned char *[img_height];
	unsigned char *Pre_frame_Y_ptr = new unsigned char [img_height*img_width];
	unsigned char **Pre_frame_Y = new unsigned char* [img_height];
	
	unsigned char *Pre_frame_U_ptr = new unsigned char [img_height_2*img_width_2];
	unsigned char **Pre_frame_U = new unsigned char* [img_height_2];
	
	unsigned char *Pre_frame_V_ptr = new unsigned char [img_height_2*img_width_2];
	unsigned char **Pre_frame_V = new unsigned char* [img_height_2];
	

	//unsigned char **objmsk = new unsigned char *[img_height];
	unsigned char *objmsk_ptr = new unsigned char [img_height*img_width];
	unsigned char **objmsk = new unsigned char* [img_height];
	

	//unsigned char **GT_BResult = new unsigned char *[img_height];
	unsigned char *GT_BResult_ptr = new unsigned char [img_height*img_width];
	unsigned char **GT_BResult = new unsigned char* [img_height];
	
	
	//unsigned char **GT_Result_Y = new unsigned char *[img_height];
	//unsigned char **GT_Result_U = new unsigned char *[img_height];
	//unsigned char **GT_Result_V = new unsigned char *[img_height];
	unsigned char *GT_Result_Y_ptr = new unsigned char [img_height*img_width];
	unsigned char **GT_Result_Y = new unsigned char* [img_height];
	
	unsigned char *GT_Result_U_ptr = new unsigned char [img_height_2*img_width_2];
	unsigned char **GT_Result_U = new unsigned char* [img_height_2];
	
	unsigned char *GT_Result_V_ptr = new unsigned char [img_height_2*img_width_2];
	unsigned char **GT_Result_V = new unsigned char* [img_height_2];
	

	//unsigned char **FDGT_BResult = new unsigned char *[img_height];
	unsigned char *FDGT_BResult_ptr = new unsigned char [img_height*img_width];
	unsigned char **FDGT_BResult = new unsigned char* [img_height];
	
	
	//unsigned char **FDGT_Result_Y = new unsigned char *[img_height];
	//unsigned char **FDGT_Result_U = new unsigned char *[img_height];
	//unsigned char **FDGT_Result_V = new unsigned char *[img_height];
	unsigned char *FDGT_Result_Y_ptr = new unsigned char [img_height*img_width];
	unsigned char **FDGT_Result_Y = new unsigned char* [img_height];
	
	unsigned char *FDGT_Result_U_ptr = new unsigned char [img_height_2*img_width_2];
	unsigned char **FDGT_Result_U = new unsigned char* [img_height_2];
	
	unsigned char *FDGT_Result_V_ptr = new unsigned char [img_height_2*img_width_2];
	unsigned char **FDGT_Result_V = new unsigned char* [img_height_2];
	

	//unsigned char **temp_img = new unsigned char* [img_height];
	unsigned char *temp_img_ptr = new unsigned char [img_height*img_width];
	unsigned char **temp_img = new unsigned char* [img_height];
	
	//unsigned char **temp_img2 = new unsigned char* [img_height];
	unsigned char *temp_img2_ptr = new unsigned char [img_height*img_width];
	unsigned char **temp_img2 = new unsigned char* [img_height];
	




	for(i = 0; i < img_height; i++){
		cur_frame_Y_ori[i] = & cur_frame_Y_ori_ptr[img_width * i];
		temp_img2[i] = & temp_img2_ptr[img_width * i];
		temp_img[i] = & temp_img_ptr[img_width * i];
		FDGT_Result_Y[i] = & FDGT_Result_Y_ptr[img_width * i];
		FDGT_BResult[i] = & FDGT_BResult_ptr[img_width * i];
		GT_BResult[i] = & GT_BResult_ptr[img_width * i];
		GT_Result_Y[i] = & GT_Result_Y_ptr[img_width * i];
		objmsk[i] = & objmsk_ptr[img_width * i];
		Pre_frame_Y[i] = & Pre_frame_Y_ptr[img_width * i];
		color_Y[i] = & color_Y_ptr[img_width * i];
		bg_Y[i] = & bg_Y_ptr[img_width * i];
		bg_temp_Y[i] = & bg_temp_Y_ptr[img_width * i];
		cur_frame_Y[i] = & cur_frame_Y_ptr[img_width * i];
		if(i < img_height_2){
			FDGT_Result_V[i] = & FDGT_Result_V_ptr[img_width_2 * i];
			FDGT_Result_U[i] = & FDGT_Result_U_ptr[img_width_2 * i];
			GT_Result_V[i] = & GT_Result_V_ptr[img_width_2 * i];
			GT_Result_U[i] = & GT_Result_U_ptr[img_width_2 * i];
			Pre_frame_V[i] = & Pre_frame_V_ptr[img_width_2 * i];
			Pre_frame_U[i] = & Pre_frame_U_ptr[img_width_2 * i];
			color_V[i] = & color_V_ptr[img_width_2 * i];
			color_U[i] = & color_U_ptr[img_width_2 * i];
			bg_V[i] = & bg_V_ptr[img_width_2 * i];
			bg_U[i] = & bg_U_ptr[img_width_2 * i];
			bg_temp_V[i] = & bg_temp_V_ptr[img_width_2 * i];
			bg_temp_U[i] = & bg_temp_U_ptr[img_width_2 * i];
			cur_frame_V[i] = & cur_frame_V_ptr[img_width_2 * i];
			cur_frame_U[i] = & cur_frame_U_ptr[img_width_2 * i];
			

		}
	}//end for i
/*
	for(i=0;i<img_height;++i){
			//cur_frame_Y_ori[i] = new unsigned char [img_width];
			cur_frame_Y[i] = new unsigned char [img_width];
			cur_frame_U[i] = new unsigned char [img_width];
			cur_frame_V[i] = new unsigned char [img_width];
			color_Y[i] = new unsigned char [img_width];
			color_U[i] = new unsigned char [img_width];
			color_V[i] = new unsigned char [img_width];
			
			Pre_frame_Y[i] = new unsigned char [img_width];
			Pre_frame_U[i] = new unsigned char [img_width];
			Pre_frame_V[i] = new unsigned char [img_width];
			objmsk[i] = new unsigned char [img_width];
			GT_BResult[i] = new unsigned char [img_width];
			GT_Result_Y[i] = new unsigned char [img_width];
			GT_Result_U[i] = new unsigned char [img_width];
			GT_Result_V[i] = new unsigned char [img_width];
			FDGT_BResult[i] = new unsigned char [img_width];
			FDGT_Result_Y[i] = new unsigned char [img_width];
			FDGT_Result_U[i] = new unsigned char [img_width];
			FDGT_Result_V[i] = new unsigned char [img_width];

			temp_img[i] = new unsigned char [img_width];
			temp_img2[i] = new unsigned char [img_width];
	}
	*/
	vector<unsigned int> colormapping;
	vector<unsigned int>::iterator coloriter;

	for(i = 0; i < img_height; ++i){
			for(j = 0; j < img_width; ++j){
				
				if(i < img_height_2 && j < img_width_2){
					bg_temp_U[i][j] = 0;
					bg_temp_V[i][j] = 0;
				}
				
				
			}//end for j
		
		}//end for i

	
/******  bckgnd images ******/
	/*
	unsigned char *bckgnd_Y_ptr = new unsigned char [numbckgndinuse*img_height*img_width];
	unsigned char *bckgnd_U_ptr = new unsigned char [numbckgndinuse*img_height_2*img_width_2];
	unsigned char *bckgnd_V_ptr = new unsigned char [numbckgndinuse*img_height_2*img_width_2];
	unsigned char *FDth_bckgnd_Y_ptr = new unsigned char [numbckgndinuse*img_height*img_width];
	unsigned char *FDth_bckgnd_U_ptr = new unsigned char [numbckgndinuse*img_height_2*img_width_2];
	unsigned char *FDth_bckgnd_V_ptr = new unsigned char [numbckgndinuse*img_height_2*img_width_2];
	int *Wgt_bckgnd_ptr = new int [numbckgndinuse*img_height*img_width];
	unsigned char *Count_BckgndSeqlyNotOB_ptr = new unsigned char [numbckgndinuse*img_height*img_width];
	unsigned char *BckgndUpd_thrshd_ptr = new unsigned char [numbckgndinuse*img_height*img_width];
	unsigned char *BckgndRej_thrshd_ptr = new unsigned char [numbckgndinuse*img_height*img_width];
	unsigned char *FBDSp_ptr = new unsigned char [numbckgndinuse*img_height*img_width];
	bool *bckgnd_ocuppied_ptr = new bool [numbckgndinuse*img_height*img_width];
	bool *bckgnd_built_ptr = new bool [numbckgndinuse*img_height*img_width];

	unsigned char ***bckgnd_Y = new unsigned char **[numbckgndinuse];
	unsigned char ***bckgnd_U = new unsigned char **[numbckgndinuse];
	unsigned char ***bckgnd_V = new unsigned char **[numbckgndinuse];
	unsigned char ***FDth_bckgnd_Y = new unsigned char **[numbckgndinuse];
	unsigned char ***FDth_bckgnd_U = new unsigned char **[numbckgndinuse];
	unsigned char ***FDth_bckgnd_V = new unsigned char **[numbckgndinuse];
	int ***Wgt_bckgnd = new int **[numbckgndinuse];
	unsigned char ***Count_BckgndSeqlyNotOB = new unsigned char **[numbckgndinuse];
	unsigned char ***BckgndUpd_thrshd = new unsigned char **[numbckgndinuse];
	unsigned char ***BckgndRej_thrshd = new unsigned char **[numbckgndinuse];
	unsigned char ***FBDSp = new unsigned char **[numbckgndinuse];
	bool ***bckgnd_ocuppied = new bool **[numbckgndinuse];
	bool ***bckgnd_built = new bool **[numbckgndinuse];

	for(i=0;i<numbckgndinuse;++i){
			bckgnd_Y[i] = new unsigned char *[img_height];
			bckgnd_U[i] = new unsigned char *[img_height_2];
			bckgnd_V[i] = new unsigned char *[img_height_2];
			FDth_bckgnd_Y[i] = new unsigned char *[img_height];
			FDth_bckgnd_U[i] = new unsigned char *[img_height_2];
			FDth_bckgnd_V[i] = new unsigned char *[img_height_2];
			Wgt_bckgnd[i] = new int *[img_height];
			Count_BckgndSeqlyNotOB[i] = new unsigned char *[img_height];
			BckgndUpd_thrshd[i] = new unsigned char *[img_height];
			BckgndRej_thrshd[i] = new unsigned char *[img_height];
			FBDSp[i] = new unsigned char *[img_height];
			bckgnd_ocuppied[i] = new bool *[img_height];
			bckgnd_built[i] = new bool *[img_height];
			for(j=0;j<img_height;++j) {
				bckgnd_Y[i][j] = & bckgnd_Y_ptr[i*img_height*img_width + j*img_width];
				
				FDth_bckgnd_Y[i][j] = & FDth_bckgnd_Y_ptr[i*img_height*img_width + j*img_width];
				
				Wgt_bckgnd[i][j] = & Wgt_bckgnd_ptr[i*img_height*img_width + j*img_width];
				Count_BckgndSeqlyNotOB[i][j] = & Count_BckgndSeqlyNotOB_ptr[i*img_height*img_width + j*img_width];
				BckgndUpd_thrshd[i][j] = & BckgndUpd_thrshd_ptr[i*img_height*img_width + j*img_width];
				BckgndRej_thrshd[i][j] = & BckgndRej_thrshd_ptr[i*img_height*img_width + j*img_width];
				FBDSp[i][j] = & FBDSp_ptr[i*img_height*img_width + j*img_width];
				bckgnd_ocuppied[i][j] = & bckgnd_ocuppied_ptr[i*img_height*img_width + j*img_width];
				bckgnd_built[i][j] = & bckgnd_built_ptr[i*img_height*img_width + j*img_width];
				if(j < img_height_2){
					bckgnd_U[i][j] = & bckgnd_U_ptr[i*img_height_2*img_width_2 + j*img_width_2];
					bckgnd_V[i][j] = & bckgnd_V_ptr[i*img_height_2*img_width_2 + j*img_width_2];
					FDth_bckgnd_U[i][j] = & FDth_bckgnd_U_ptr[i*img_height_2*img_width_2 + j*img_width_2];
					FDth_bckgnd_V[i][j] = & FDth_bckgnd_V_ptr[i*img_height_2*img_width_2 + j*img_width_2];
				
				}
			}
	}


*/

	unsigned char ***bckgnd_Y = new unsigned char **[numbckgndinuse];
	unsigned char ***bckgnd_U = new unsigned char **[numbckgndinuse];
	unsigned char ***bckgnd_V = new unsigned char **[numbckgndinuse];
	unsigned char ***FDth_bckgnd_Y = new unsigned char **[numbckgndinuse];
	unsigned char ***FDth_bckgnd_U = new unsigned char **[numbckgndinuse];
	unsigned char ***FDth_bckgnd_V = new unsigned char **[numbckgndinuse];
	int ***Wgt_bckgnd = new int **[numbckgndinuse];
	unsigned char ***Count_BckgndSeqlyNotOB = new unsigned char **[numbckgndinuse];
	unsigned char ***BckgndUpd_thrshd = new unsigned char **[numbckgndinuse];
	unsigned char ***BckgndRej_thrshd = new unsigned char **[numbckgndinuse];
	unsigned char ***FBDSp = new unsigned char **[numbckgndinuse];
	bool ***bckgnd_ocuppied = new bool **[numbckgndinuse];
	bool ***bckgnd_built = new bool **[numbckgndinuse];
	
	countbackground = 0;
	
	for(i=0;i<numbckgndinuse;++i){
			bckgnd_Y[i] = new unsigned char *[img_height];
			bckgnd_U[i] = new unsigned char *[img_height_2];
			bckgnd_V[i] = new unsigned char *[img_height_2];
			FDth_bckgnd_Y[i] = new unsigned char *[img_height];
			FDth_bckgnd_U[i] = new unsigned char *[img_height_2];
			FDth_bckgnd_V[i] = new unsigned char *[img_height_2];
			Wgt_bckgnd[i] = new int *[img_height];
			Count_BckgndSeqlyNotOB[i] = new unsigned char *[img_height];
			BckgndUpd_thrshd[i] = new unsigned char *[img_height];
			BckgndRej_thrshd[i] = new unsigned char *[img_height];
			FBDSp[i] = new unsigned char *[img_height];
			bckgnd_ocuppied[i] = new bool *[img_height];
			bckgnd_built[i] = new bool *[img_height];
			for(j=0;j<img_height;++j) {
				bckgnd_Y[i][j] = new unsigned char [img_width];
				
				FDth_bckgnd_Y[i][j] = new unsigned char [img_width];
				
				Wgt_bckgnd[i][j] = new int [img_width];
				Count_BckgndSeqlyNotOB[i][j] = new unsigned char [img_width];
				BckgndUpd_thrshd[i][j] = new unsigned char [img_width];
				BckgndRej_thrshd[i][j] = new unsigned char [img_width];
				FBDSp[i][j] = new unsigned char [img_width];
				bckgnd_ocuppied[i][j] = new bool [img_width];
				bckgnd_built[i][j] = new bool [img_width];
				if(j < img_height_2){
					bckgnd_U[i][j] = new unsigned char [img_width_2];
					bckgnd_V[i][j] = new unsigned char [img_width_2];
					FDth_bckgnd_U[i][j] = new unsigned char [img_width_2];
					FDth_bckgnd_V[i][j] = new unsigned char [img_width_2];
				}//end if
			}
	}
	


	



/******	 parameter initialization  ******/
	
	for(i=0;i<img_height;++i){
		for(j=0;j<img_width;++j){
			for(k=0;k<numbckgndinuse;++k){

					BckgndRej_thrshd[k][i][j]		= IniBckgndRej_thrshd; //weight < BckgndRej_thrshd => bckgnd rejected
					FBDSp[k][i][j]					= IniFBDSp; // 1' number of frame that bckgnd sequetially not observed => reduce weight by 1 (if Count_BckgndSeqlyNotOB reseted when observed)   2' = update speed/reject speed (if Count_BckgndSeqlyNotOB NOT reseted when observed)
					BckgndUpd_thrshd[k][i][j]		= IniBckgndUpd_thrshd;  //weight > BckgndUpd_thrshd => bckgnd built

					FDth_bckgnd_Y[k][i][j] = 26;
					if(i < img_height_2 && j < img_width_2){
						FDth_bckgnd_U[k][i][j] = 26;
						FDth_bckgnd_V[k][i][j] = 26;
					}
					
					bckgnd_built[k][i][j]  = 0;//initialization because bool => =1, after declaration?
					bckgnd_ocuppied[k][i][j] = 0;
					Count_BckgndSeqlyNotOB[k][i][j] = 0;//initialization => int = 206, after declaration?

			}

		}
	}





/******  background build, maintain and video segmentation   ******/
	int frame_idx;
	
	int bckgnd_idx;
	bool mtchbckgndfound, mtchbckgndUCfound;
	unsigned int Max_Y, Min_Y;
	float FDT;
	shadowcancel = ShadowCancellation;

	for(i=0;i<img_height;++i){
		for(j=0;j<img_width;++j){
			for(k=0;k<numbckgndinuse;++k){
				bckgnd_Y[k][i][j] = 0;
				bckgnd_U[k][int(i/2)][int(j/2)] = 0;
				bckgnd_V[k][int(i/2)][int(j/2)] = 0;
			}
		}
	}

	for(frame_idx = 0; frame_idx < size_sequence; ++frame_idx ) {
		cout << "Frame: " << frame_idx << endl;
/*
		erosion(objmsk, temp_img, img_height, img_width);

		dilation(temp_img, temp_img2, img_height, img_width);
		erosion(temp_img2, temp_img, img_height, img_width);

		dilation(temp_img, temp_img2, img_height, img_width);
		dilation(temp_img2, temp_img, img_height, img_width);
		erosion(temp_img2, temp_img, img_height, img_width);
		erosion(temp_img, temp_img2, img_height, img_width);
		erosion(temp_img2, temp_img, img_height, img_width);
		erosion(temp_img, temp_img2, img_height, img_width);
		erosion(temp_img2, temp_img, img_height, img_width);
		erosion(temp_img, temp_img2, img_height, img_width);
		erosion(temp_img2, temp_img, img_height, img_width);
		erosion(temp_img, temp_img2, img_height, img_width);
		erosion(temp_img2, temp_img, img_height, img_width);
		erosion(temp_img, temp_img2, img_height, img_width);
		erosion(temp_img2, temp_img, img_height, img_width);
		erosion(temp_img, temp_img2, img_height, img_width);
		erosion(temp_img2, temp_img, img_height, img_width);
		erosion(temp_img, temp_img2, img_height, img_width);
		erosion(temp_img2, temp_img, img_height, img_width);
		erosion(temp_img, temp_img2, img_height, img_width);
		erosion(temp_img2, temp_img, img_height, img_width);
		erosion(temp_img, temp_img2, img_height, img_width);
		erosion(temp_img2, temp_img, img_height, img_width);
		erosion(temp_img, temp_img2, img_height, img_width);
		erosion(temp_img2, temp_img, img_height, img_width);
		erosion(temp_img, temp_img2, img_height, img_width);
		erosion(temp_img2, temp_img, img_height, img_width);

		dilation(temp_img, temp_img2, img_height, img_width);
		dilation(temp_img2, temp_img, img_height, img_width);
		erosion(temp_img, objmsk, img_height, img_width);
*/
		/*for(i=0;i<img_height;++i){
			
			//fread ( cur_frame_Y_ori[i], 1, img_width, fp_in);
			fwrite( temp_img[i],      1, img_width, fp_objmsk);
			//fwrite( bckgnd_Y[0][i],      1, img_width, fp_bckgnd0);
			//fwrite( bckgnd_Y[1][i],      1, img_width, fp_bckgnd1);
			//fwrite( bckgnd_Y[2][i],      1, img_width, fp_bckgnd2);
		}*/
		//for(i = 0; i < img_height*img_width; ++i){
		
		fread ( cur_frame_Y_ori_ptr, 1, img_width*img_height, fp_in);
		
		fwrite( objmsk_ptr, 1, img_width*img_height, fp_objmsk);
		//cout << "End Read" << endl;
		//}
/*
		for(i=0;i<img_height_2;++i){
			fread ( cur_frame_U[i], 1, img_width_2, fp_in);
			//fwrite( bckgnd_U[0][i],      1, img_width_2, fp_bckgnd0);
			//fwrite( bckgnd_U[1][i],      1, img_width_2, fp_bckgnd1);
			//fwrite( bckgnd_U[2][i],      1, img_width_2, fp_bckgnd2);
		}
*/
		fread ( cur_frame_U_ptr, 1, img_width_2*img_height_2, fp_in);
/*
		for(i=0;i<img_height_2;++i){
			fread ( cur_frame_V[i], 1, img_width_2, fp_in);
			//fwrite( bckgnd_V[0][i],      1, img_width_2, fp_bckgnd0);
			//fwrite( bckgnd_V[1][i],      1, img_width_2, fp_bckgnd1);
			//fwrite( bckgnd_V[2][i],      1, img_width_2, fp_bckgnd2);
		}
*/
		fread ( cur_frame_V_ptr, 1, img_width_2*img_height_2, fp_in);

		if(shadowcancel == 1){
			for(i=0;i<img_height;++i){
				for(j=0;j<img_width;++j){

					Max_Y = 0;
					Min_Y = 256;
					for(m=-(Gradient_M-1);m<Gradient_M;m++){
						for(n=-(Gradient_N-1);n<Gradient_N;n++){
							if( ((i+m)<img_height) && ((j+n)<img_width) && ((i+m)>0) && ((j+n)>0) ){
								if(cur_frame_Y_ori [i+m][j+n] > Max_Y )
									Max_Y = cur_frame_Y_ori [i+m][j+n];

								if(cur_frame_Y_ori [i+m][j+n] < Min_Y)
									Min_Y = cur_frame_Y_ori [i+m][j+n];
							}
						}
					}

					cur_frame_Y[i][j] = Max_Y - Min_Y;
				}
			}
		}
		else{
			for(i=0;i<img_height;++i){
				for(j=0;j<img_width;++j){
					cur_frame_Y[i][j] = cur_frame_Y_ori[i][j] ;
				}
			}
		}

		

		for(i=0;i<img_height;++i){
			for(j=0;j<img_width;++j){


				//start processing
				mtchbckgndfound = 0;
				mtchbckgndUCfound  = 0;
				for(bckgnd_idx=0; bckgnd_idx<numbckgndinuse; ++bckgnd_idx){//finding "bckgnd" or "bckgnd under construction" matched to current pixel of current frame
					
					if((bckgnd_built[bckgnd_idx][i][j])&&(abs(cur_frame_Y[i][j] - bckgnd_Y[bckgnd_idx][i][j]) < FDth_bckgnd_Y[bckgnd_idx][i][j])/*&&(abs(cur_frame_U[int(i/2)][int(j/2)] - bckgnd_U[bckgnd_idx][int(i/2)][int(j/2)]) < FDth_bckgnd_U[bckgnd_idx][int(i/2)][int(j/2)])&&(abs(cur_frame_V[int(i/2)][int(j/2)] - bckgnd_V[bckgnd_idx][int(i/2)][int(j/2)]) < FDth_bckgnd_V[bckgnd_idx][int(i/2)][int(j/2)])*/){//finding "bckgnd" matched to current pixel of current frame
						mtchbckgndfound = 1;
						break;
					}

					
					if((bckgnd_ocuppied[bckgnd_idx][i][j])&&(abs(cur_frame_Y[i][j] - bckgnd_Y[bckgnd_idx][i][j]) < FDth_bckgnd_Y[bckgnd_idx][i][j])/*&&(abs(cur_frame_U[int(i/2)][int(j/2)] - bckgnd_U[bckgnd_idx][int(i/2)][int(j/2)]) < FDth_bckgnd_U[bckgnd_idx][int(i/2)][int(j/2)])&&(abs(cur_frame_V[int(i/2)][int(j/2)] - bckgnd_V[bckgnd_idx][int(i/2)][int(j/2)]) < FDth_bckgnd_V[bckgnd_idx][int(i/2)][int(j/2)])*/){//finding "bckgnd under construction" matched to current pixel of current frame
						mtchbckgndUCfound = 1;
						break;
					}
				}
				
				if(mtchbckgndfound){ /* deal with CASE1: matched "bckgnd" found */
					objmsk[i][j] = 0;
					bckgnd_Y[bckgnd_idx][i][j] = (Wgt_bckgnd[bckgnd_idx][i][j] * bckgnd_Y[bckgnd_idx][i][j] + cur_frame_Y[i][j])/(Wgt_bckgnd[bckgnd_idx][i][j] + 1);//bckgnd update
					Wgt_bckgnd[bckgnd_idx][i][j] ++;

					Count_BckgndSeqlyNotOB[bckgnd_idx][i][j] = 0; //reset when observed !! => 1' of FBDSp

					for(k=0;k<numbckgndinuse;k++){
						if(k != bckgnd_idx){
							Count_BckgndSeqlyNotOB[k][i][j] ++ ;
							if(Count_BckgndSeqlyNotOB[k][i][j] > FBDSp[k][i][j]){
								if(Wgt_bckgnd[k][i][j]!=0) Wgt_bckgnd[k][i][j] --;
								Count_BckgndSeqlyNotOB[k][i][j] = 0;
							}
							if(((bckgnd_built[k][i][j])&&(Wgt_bckgnd[k][i][j] < BckgndRej_thrshd[k][i][j])) || ((bckgnd_ocuppied[k][i][j])&&(Wgt_bckgnd[k][i][j] == 0))){// two cases to release the background occupation
								bckgnd_built[k][i][j] = 0;
								bckgnd_ocuppied[k][i][j] = 0;
								Wgt_bckgnd[k][i][j] = 0;
								Count_BckgndSeqlyNotOB[k][i][j] = 0;
								bckgnd_Y[k][i][j] = 0;
								bckgnd_U[k][int(i/2)][int(j/2)] = 0;
								bckgnd_V[k][int(i/2)][int(j/2)] = 0;
							}
						}	
					}
				}	
				else if(mtchbckgndUCfound){
					objmsk[i][j] = 255;
					bckgnd_Y[bckgnd_idx][i][j] = (Wgt_bckgnd[bckgnd_idx][i][j] * bckgnd_Y[bckgnd_idx][i][j] + cur_frame_Y[i][j])/(Wgt_bckgnd[bckgnd_idx][i][j] + 1);//bckgnd update
					Wgt_bckgnd[bckgnd_idx][i][j] ++;
					if(Wgt_bckgnd[bckgnd_idx][i][j] > BckgndUpd_thrshd[bckgnd_idx][i][j])// judgegment of bckgnd built or not
						bckgnd_built[bckgnd_idx][i][j] = 1; 

					Count_BckgndSeqlyNotOB[bckgnd_idx][i][j] = 0; //reset when observed !! => 1' of FBDSp
					
					for(k=0;k<numbckgndinuse;k++){//weighting adjustment for bckgnd not appear in current frame (with factor of background decay (FBD) speed ) & old bckgnd rejection
						if(k != bckgnd_idx){
							Count_BckgndSeqlyNotOB[k][i][j] ++ ;
							if(Count_BckgndSeqlyNotOB[k][i][j] > FBDSp[k][i][j]){
								if(Wgt_bckgnd[k][i][j]!=0) Wgt_bckgnd[k][i][j] --;
								Count_BckgndSeqlyNotOB[k][i][j] = 0;
							}
							if(((bckgnd_built[k][i][j])&&(Wgt_bckgnd[k][i][j] < BckgndRej_thrshd[k][i][j])) || ((bckgnd_ocuppied[k][i][j])&&(Wgt_bckgnd[k][i][j] == 0))){// two cases to release the background occupation
								bckgnd_built[k][i][j] = 0;
								bckgnd_ocuppied[k][i][j] = 0;
								Wgt_bckgnd[k][i][j] = 0;
								Count_BckgndSeqlyNotOB[k][i][j] = 0;
								bckgnd_Y[k][i][j] = 0;
								bckgnd_U[k][int(i/2)][int(j/2)] = 0;
								bckgnd_V[k][int(i/2)][int(j/2)] = 0;
							}
						}	
					}
				}
				else{//deal with CASE3: Neight matched "bckgnd" nor "bckgnd under construction" found
					objmsk[i][j] = 255;
					for(l=0;l<numbckgndinuse;l++){//find any bckgnd not occupied to occupy
						if(bckgnd_ocuppied[l][i][j] == 0){
							bckgnd_Y[l][i][j] = cur_frame_Y[i][j];
							bckgnd_U[l][int(i/2)][int(j/2)] = cur_frame_U[int(i/2)][int(j/2)];
							bckgnd_V[l][int(i/2)][int(j/2)] = cur_frame_V[int(i/2)][int(j/2)];
							bckgnd_ocuppied[l][i][j] = 1;
							Wgt_bckgnd[l][i][j] = 0;
							break;
						}
					}

					for(k=0;k<numbckgndinuse;k++){//weighting adjustment for bckgnd not appear in current frame (with factor of background decay (FBD) speed ) & old bckgnd rejection
						if(k != l){
							Count_BckgndSeqlyNotOB[k][i][j] ++ ;
							if(Count_BckgndSeqlyNotOB[k][i][j] > FBDSp[k][i][j]){
								if(Wgt_bckgnd[k][i][j]!=0) Wgt_bckgnd[k][i][j] --;
								Count_BckgndSeqlyNotOB[k][i][j] = 0;
							}
							if(((bckgnd_built[k][i][j])&&(Wgt_bckgnd[k][i][j] < BckgndRej_thrshd[k][i][j])) || ((bckgnd_ocuppied[k][i][j])&&(Wgt_bckgnd[k][i][j] == 0))){// two cases to release the background occupation
								bckgnd_built[k][i][j] = 0;
								bckgnd_ocuppied[k][i][j] = 0;
								Wgt_bckgnd[k][i][j] = 0;
								Count_BckgndSeqlyNotOB[k][i][j] = 0;
								bckgnd_Y[k][i][j] = 0;
								bckgnd_U[k][int(i/2)][int(j/2)] = 0;
								bckgnd_V[k][int(i/2)][int(j/2)] = 0;

							}
						}	
					}
				}




			
			}
		}

	




		/*adaptive threshold decision*/
		//Gaussian Test
//cout << "here" << endl;
		BckgndBlckNum = 0 ;
		BckgndBDminSqrtAvg = 0;

		for(i=0;i<img_height;i=i+GT_M){
			for(j=0;j<img_width;j=j+GT_N){
				
				I1 = 0;
				I2 = 0;
				I3 = 0;
				I4 = 0;

				for(m=0;m<GT_M;m++){
					for(n=0;n<GT_N;n++){

						BDmin = 256;
						for(k = 0; k < numbckgndinuse; k ++)
							if(abs(cur_frame_Y[i+m][j+n] - bckgnd_Y[k][i+m][j+n]) < BDmin)
								BDmin = abs(cur_frame_Y[i+m][j+n] - bckgnd_Y[k][i+m][j+n]);
					 

						Tmp_BDk = BDmin;
						I1 += Tmp_BDk;
						Tmp_BDk = Tmp_BDk*BDmin;
						I2 += Tmp_BDk;
						Tmp_BDk = Tmp_BDk*BDmin;
						I3 += Tmp_BDk;
						Tmp_BDk = Tmp_BDk*BDmin;
						I4 += Tmp_BDk;
					}
				}

				I1 = I1/(GT_M*GT_N);
				I2 = I2/(GT_M*GT_N);
				I3 = I3/(GT_M*GT_N);
				I4 = I4/(GT_M*GT_N);

				H_GT = I3 + I4 - 3*I1*(I2 - I1*I1)- 3*I2*I2 - I1*I1*I1 - 2*I1*I1*I1*I1;

				
				if(H_GT < GTth){
					
					BckgndBlckNum ++ ;
					BckgndBDminSqrtAvg = ((BckgndBlckNum - 1)*BckgndBDminSqrtAvg + I2)/BckgndBlckNum; 

					for(m=0;m<GT_M;m++){
						for(n=0;n<GT_N;n++){
							GT_BResult[i+m][j+n] =  255 ;
							GT_Result_Y[i+m][j+n]  =  cur_frame_Y_ori[i+m][j+n] ;
							GT_Result_U[(i+m)/2][(j+n)/2]  =  cur_frame_U[(i+m)/2][(j+n)/2] ;
							GT_Result_V[(i+m)/2][(j+n)/2]  =  cur_frame_V[(i+m)/2][(j+n)/2] ;
//cout <<"\t" << i+m << "\t" << j+n << endl;

						}
					}

				}
				else{

					for(m=0;m<GT_M;m++){
						for(n=0;n<GT_N;n++){
							GT_BResult[i+m][j+n] =  0 ;
							GT_Result_Y[i+m][j+n]  =  0 ;
							GT_Result_U[(i+m)/2][(j+n)/2]  =  0 ;
							GT_Result_V[(i+m)/2][(j+n)/2]  =  0 ;
						}
					}

				}




//cout << i <<" \t " <<j << endl;
					
			}
		}
		//cout << "here" << endl;

		
		//print the Gaussian Test Result
	/*	for(i=0;i<img_height;++i){
			
			fwrite( GT_Result_Y[i],      1, img_width, fp_GTResult);
			
		}

		for(i=0;i<img_height_2;++i){
			
			fwrite( GT_Result_U[i],      1, img_width_2, fp_GTResult);
		
		}

		for(i=0;i<img_height_2;++i){
			
			fwrite( GT_Result_V[i],      1, img_width_2, fp_GTResult);
		
		}
*/





		//FD Gaussian Test 
		BckgndBlckNum = 0;
		BckgndFDSqrtAvg=0;
		for(i=0;i<img_height;i=i+GT_M){
			for(j=0;j<img_width;j=j+GT_N){
				
				I1 = 0;
				I2 = 0;
				I3 = 0;
				I4 = 0;

				for(m=0;m<GT_M;m++){
					for(n=0;n<GT_N;n++){

						
						FD = abs(cur_frame_Y[i+m][j+n] - Pre_frame_Y[i+m][j+n]);
					 

						Tmp_FDk = FD;
						I1 += Tmp_FDk;
						Tmp_FDk = Tmp_FDk*FD;
						I2 += Tmp_FDk;
						Tmp_FDk = Tmp_FDk*FD;
						I3 += Tmp_FDk;
						Tmp_FDk = Tmp_FDk*FD;
						I4 += Tmp_FDk;
					}
				}

				I1 = I1/(GT_M*GT_N);
				I2 = I2/(GT_M*GT_N);
				I3 = I3/(GT_M*GT_N);
				I4 = I4/(GT_M*GT_N);

				H_GT = I3 + I4 - 3*I1*(I2 - I1*I1)- 3*I2*I2 - I1*I1*I1 - 2*I1*I1*I1*I1;

				
				if(H_GT < GTth){

					BckgndBlckNum ++ ;
					BckgndFDSqrtAvg = ((BckgndBlckNum - 1)*BckgndFDSqrtAvg + I2)/BckgndBlckNum; 
					
					for(m=0;m<GT_M;m++){
						for(n=0;n<GT_N;n++){
							FDGT_BResult[i+m][j+n] =  255 ;
							FDGT_Result_Y[i+m][j+n]  =  cur_frame_Y_ori[i+m][j+n] ;
							FDGT_Result_U[(i+m)/2][(j+n)/2]  =  cur_frame_U[(i+m)/2][(j+n)/2] ;
							FDGT_Result_V[(i+m)/2][(j+n)/2]  =  cur_frame_V[(i+m)/2][(j+n)/2] ;
						}
					}


				}
				else{

					for(m=0;m<GT_M;m++){
						for(n=0;n<GT_N;n++){
							FDGT_BResult[i+m][j+n] =  0 ;
							FDGT_Result_Y[i+m][j+n]  =  0 ;
							FDGT_Result_U[(i+m)/2][(j+n)/2]  =  0 ;
							FDGT_Result_V[(i+m)/2][(j+n)/2]  =  0 ;
						}
					}

				}
				
					
			}
		}
		
		//store previous frame for FD Gaussian Test
		for(i=0;i<img_height;i++){
			for(j=0;j<img_width;j++){
				Pre_frame_Y[i][j] = cur_frame_Y[i][j];
				Pre_frame_U[i/2][j/2] = cur_frame_U[i/2][j/2];
				Pre_frame_V[i/2][j/2] = cur_frame_V[i/2][j/2];
			}
		}
		
		//print the FD Gaussian Test Result
/*		for(i=0;i<img_height;++i){
			
			fwrite( FDGT_Result_Y[i],      1, img_width, fp_FDGTResult);
			
		}

		for(i=0;i<img_height_2;++i){
			
			fwrite( FDGT_Result_U[i],      1, img_width_2, fp_FDGTResult);
		
		}

		for(i=0;i<img_height_2;++i){
			
			fwrite( FDGT_Result_V[i],      1, img_width_2, fp_FDGTResult);
		
		}
*/


		//Gaussian Noise Variance Estimation
		//fprintf(fp_NoiLvlRpt,"FD,     BDmin");
		

		FDNoiseVar = sqrt(BckgndFDSqrtAvg);

		BDminNoiseVar = sqrt(BckgndBDminSqrtAvg);

//		fprintf(fp_NoiLvlRpt, "FD = %.3f,  BDmin = %.3f\n",FDNoiseVar,  BDminNoiseVar);


		

		//threshold adjustment
		
		//if(frame_idx > BckgndUpd_thrshd[0][0][0] * FBDSp[0][0][0]){
		if(frame_idx > FDBDminSwitchTiming){
			for(i=0;i<img_height;++i){
				for(j=0;j<img_width;++j){				
					for(k=0;k<numbckgndinuse;++k){

						// FDT = factor for darkness noise tuning
						//FDT =  FDTmax*((128 - (int)bckgnd_Y[k][i][j])/128); //.............................................(1)
						//FDT =  FDTmax*(1 - (bckgnd_Y[k][i][j]/255));//.....................................................(2)
						//FDT =  FDTmax*(0.5 - ( ( (int)bckgnd_Y[k][i][j] - 128 )/255)  );//.................................(3)
						//FDT = FDTmax* (abs( (int)bckgnd_Y[k][i][j] - 128 )/128);//.........................................(4)
						//FDT = 0;//.........................................................................................(5)
						FDT = FDTmax*(1 - (abs( (int)bckgnd_Y[k][i][j] - 128 )/128));//....................................(6)

						//BckgndRej_thrshd[k][i][j] = 10; //weight < BckgndRej_thrshd => bckgnd rejected
						//FBDSp[k][i][j] = 5; // 1' number of frame that bckgnd sequetially not observed => reduce weight by 1 (if Count_BckgndSeqlyNotOB reseted when observed)   2' = update speed/reject speed (if Count_BckgndSeqlyNotOB NOT reseted when observed)
						//BckgndUpd_thrshd[k][i][j] = 15;  //weight > BckgndUpd_thrshd => bckgnd built
						
						FDth_bckgnd_Y[k][i][j] = (int)	(float) (NumVar)*(BDminNoiseVar + FDT);
						if(i < img_height_2 && j < img_width_2){
							FDth_bckgnd_U[k][i][j] = (int)	(float) (NumVar)*(BDminNoiseVar + FDT);
							FDth_bckgnd_V[k][i][j] = (int)	(float) (NumVar)*(BDminNoiseVar + FDT);
						}
					
					}
				}
			}
		}
		else{
			for(i=0;i<img_height;++i){
				for(j=0;j<img_width;++j){
					for(k=0;k<numbckgndinuse;++k){

						// factor for darkness noise tuning
						//FDT =  FDTmax*((128 - (int)bckgnd_Y[k][i][j])/128); //.............................................(1)
						//FDT =  FDTmax*(1 - (bckgnd_Y[k][i][j]/255));//.....................................................(2)
						//FDT =  FDTmax*(0.5 - ( ( (int)bckgnd_Y[k][i][j] - 128 )/255)  );//.................................(3)
						//FDT = FDTmax* (abs( (int)bckgnd_Y[k][i][j] - 128 )/128);//.........................................(4)
						//FDT = 0;//.........................................................................................(5)
						FDT = FDTmax*(1 - (abs( (int)bckgnd_Y[k][i][j] - 128 )/128));//....................................(6)

						//BckgndRej_thrshd[k][i][j] = 10; //weight < BckgndRej_thrshd => bckgnd rejected
						//FBDSp[k][i][j] = 5; // 1' number of frame that bckgnd sequetially not observed => reduce weight by 1 (if Count_BckgndSeqlyNotOB reseted when observed)   2' = update speed/reject speed (if Count_BckgndSeqlyNotOB NOT reseted when observed)
						//BckgndUpd_thrshd[k][i][j] = 15;  //weight > BckgndUpd_thrshd => bckgnd built
						
						FDth_bckgnd_Y[k][i][j] = (int)	(float) (NumVar)*(FDNoiseVar + FDT);
						if(i < img_height_2 && j < img_width_2){
							FDth_bckgnd_U[k][i][j] = (int)	(float) (NumVar)*(FDNoiseVar + FDT);
							FDth_bckgnd_V[k][i][j] = (int)	(float) (NumVar)*(FDNoiseVar + FDT);
						}

					}
				}
			}
		}
		
		
		

		if(opendominant == 1){
			if(frame_idx % 20 == 0)colormapping.clear();
			unsigned int tempdata[4];
			unsigned int readdata[4];
			bool done;
			done = false;
			cout << "FDth_bckgnd_Y: " << (int)FDth_bckgnd_Y[0][20][20]  <<" " << (int)FDth_bckgnd_U[0][10][10] << endl;
			//if(frame_idx > 10)system("pause");
			for(i = 0; i < img_height; ++i){
				for(j = 0; j < img_width; ++j){
					
					done = false;
					for(k = 0; k < colormapping.size(); k+=4){
						readdata[0] = colormapping[k];
						readdata[1] = colormapping[k+1];
						readdata[2] = colormapping[k+2];
						readdata[3] = colormapping[k+3];
						
						if(((int)cur_frame_Y_ori[i][j] > (int)readdata[0] - (int)FDth_bckgnd_Y[0][i][j]*ratio/2 && (int)cur_frame_Y_ori[i][j] < (int)readdata[0] + (int)FDth_bckgnd_Y[0][i][j]*ratio/2) && 
						   ((int)cur_frame_U[i/2][j/2] > (int)readdata[1] - (int)FDth_bckgnd_U[0][i/2][j/2]*ratio/2 && (int)cur_frame_U[i/2][j/2] < (int)readdata[1] + (int)FDth_bckgnd_U[0][i/2][j/2]*ratio/2) && 
						   ((int)cur_frame_V[i/2][j/2] > (int)readdata[2] - (int)FDth_bckgnd_V[0][i/2][j/2]*ratio/2 && (int)cur_frame_V[i/2][j/2] < (int)readdata[2] + (int)FDth_bckgnd_V[0][i/2][j/2]*ratio/2)
						//if(((int)cur_frame_Y[i][j] > (int)readdata[0] - 15 && (int)cur_frame_Y[i][j] < (int)readdata[0] + 15) && 
						   //((int)cur_frame_U[i/2][j/2] > (int)readdata[1] - 15 && (int)cur_frame_U[i/2][j/2] < (int)readdata[1] + 15) && 
						   //((int)cur_frame_V[i/2][j/2] > (int)readdata[2] - 15 && (int)cur_frame_V[i/2][j/2] < (int)readdata[2] + 15) &&
						   //!done
						   ){
							tempdata[3] = readdata[3];
							tempdata[0] = (int)(((float)readdata[0] * (float)tempdata[3] + (float)cur_frame_Y_ori[i][j])/((float)tempdata[3]+1) + 0.5);
							tempdata[1] = (int)(((float)readdata[1] * (float)tempdata[3] + (float)cur_frame_U[i/2][j/2])/((float)tempdata[3]+1) + 0.5);
							tempdata[2] = (int)(((float)readdata[2] * (float)tempdata[3] + (float)cur_frame_V[i/2][j/2])/((float)tempdata[3]+1) + 0.5);

							//cout << (int)tempdata[0] << " "  << (int)readdata[0] << " " << (int)tempdata[3] << " " << (int)cur_frame_Y[i][j] << " " << (int)FDth_bckgnd_Y[0][i][j] <<endl;
							/*if( frame_idx == 10){
								fout << j << " " << i << endl;
								fout << (int)tempdata[0] << " "  << (int)readdata[0] << " " << (int)tempdata[3] << " " << (int)cur_frame_Y[i][j] << " " <<endl;
								fout << (int)tempdata[1] << " "  << (int)readdata[1] << " " << (int)tempdata[3] << " " << (int)cur_frame_U[i/2][j/2] << " " <<endl;
								fout << (int)tempdata[2] << " "  << (int)readdata[2] << " " << (int)tempdata[3] << " " << (int)cur_frame_V[i/2][j/2] << " " <<endl;
								
							}
							*/
							

							tempdata[3]++;
							colormapping[k] = tempdata[0];
							colormapping[k+1] = tempdata[1];
							colormapping[k+2] = tempdata[2];
							colormapping[k+3] = tempdata[3];
							
							
							done = true;
							break;
								
						}//end if 
							
					}//end for k
					
					if(!done){
						tempdata[0] = cur_frame_Y_ori[i][j];
						tempdata[1] = cur_frame_U[i/2][j/2];
						tempdata[2] = cur_frame_V[i/2][j/2];
						tempdata[3] = 1;

	/*					if( frame_idx == 10){
								fout << j << " " << i << endl;
								fout << (int)tempdata[0] << " "  << (int)tempdata[3] << " " << (int)cur_frame_Y[i][j] << " " <<endl;
								fout << (int)tempdata[1] << " "  << (int)tempdata[3] << " " << (int)cur_frame_U[i/2][j/2] << " " <<endl;
								fout << (int)tempdata[2] << " "  << (int)tempdata[3] << " " << (int)cur_frame_V[i/2][j/2] << " " <<endl;
								
							}
	*/					
						colormapping.push_back(tempdata[0]);
						colormapping.push_back(tempdata[1]);
						colormapping.push_back(tempdata[2]);
						colormapping.push_back(tempdata[3]);
						
						
					}
					//cout <<"COLOR Y " <<color_Y[i][j] << endl;
				}//end for j
			
			}//end for i
			abs_y_t = 0;
			abs_u_t = 0;
			abs_v_t = 0;
			for(i = 0; i < img_height; ++i){
				for(j = 0; j < img_width; ++j){
					
					done = false;
					for(k = 0; k < colormapping.size(); k+=4){
						readdata[0] = colormapping[k];
						readdata[1] = colormapping[k+1];
						readdata[2] = colormapping[k+2];
						readdata[3] = colormapping[k+3];
						
						if(((int)cur_frame_Y_ori[i][j] > (int)readdata[0] - (int)FDth_bckgnd_Y[0][i][j]*ratio/2 && (int)cur_frame_Y_ori[i][j] < (int)readdata[0] + (int)FDth_bckgnd_Y[0][i][j])*ratio/2 && 
						   ((int)cur_frame_U[i/2][j/2] > (int)readdata[1] - (int)FDth_bckgnd_U[0][i/2][j/2]*ratio/2 && (int)cur_frame_U[i/2][j/2] < (int)readdata[1] + (int)FDth_bckgnd_U[0][i/2][j/2]*ratio/2) && 
						   ((int)cur_frame_V[i/2][j/2] > (int)readdata[2] - (int)FDth_bckgnd_V[0][i/2][j/2]*ratio/2 && (int)cur_frame_V[i/2][j/2] < (int)readdata[2] + (int)FDth_bckgnd_V[0][i/2][j/2]*ratio/2)){
							color_Y[i][j] = readdata[0];
							color_U[i/2][j/2] = readdata[1];
							color_V[i/2][j/2] = readdata[2];
	/*					if( frame_idx == 10){
								fout2 << j << " " << i << endl;
								fout2 << (int)color_Y[i][j] << " "  << (int)readdata[0] << " " << (int)cur_frame_Y[i][j] << " " <<endl;
								fout2 << (int)color_U[i/2][j/2] << " "  << (int)readdata[1] << " " << (int)cur_frame_U[i/2][j/2] << " " <<endl;
								fout2 << (int)color_V[i/2][j/2] << " "  << (int)readdata[2] << " " << (int)cur_frame_V[i/2][j/2] << " " <<endl;
								
							}
	*/						
							done = true;
							break;
								
						}//end if 
							
					}//end for k
					
					if(!done){
						//cout << j << "\t" << i << endl;
						color_Y[i][j] = cur_frame_Y_ori[i][j];
						color_U[i/2][j/2] = cur_frame_U[i/2][j/2];
						color_V[i/2][j/2] = cur_frame_V[i/2][j/2];
						
	/*					if( frame_idx == 10){
								fout2 << j << " " << i << endl;
								fout2 << (int)color_Y[i][j] << " "  << (int)cur_frame_Y[i][j] << " " <<endl;
								fout2 << (int)color_U[i/2][j/2] << " "  << (int)cur_frame_U[i/2][j/2] << " " <<endl;
								fout2 << (int)color_V[i/2][j/2] << " "  << (int)cur_frame_V[i/2][j/2] << " " <<endl;
								
							}
	*/					
					}
					/*abs_y = abs((double)color_Y[i][j] - (double)cur_frame_Y[i][j]);
					abs_u = abs((double)color_U[i/2][j/2] - (double)cur_frame_U[i/2][j/2]);
					abs_v = abs((double)color_V[i/2][j/2] - (double)cur_frame_V[i/2][j/2]);
					abs_y_t += abs_y;
					abs_u_t += abs_u;
					abs_v_t += abs_v;*/
					
					//cout <<"COLOR Y " <<color_Y[i][j] << endl;
				}//end for j
			
			}//end for i
			/*
			cout << "\tDifference in Y\t" << abs_y_t/img_height/img_width << endl;
			cout << "\tDifference in U\t" << abs_u_t/img_height/img_width << endl;
			cout << "\tDifference in V\t" << abs_v_t/img_height/img_width << endl;
	*/
			
			amount1 = colormapping.size()/4/256;
			amount2 = ((int)colormapping.size()/4)%256;
			
			//fputc(amount1, fcolor);
			//fputc(amount2, fcolor);
	/*		for(k = 0; k < colormapping.size(); k+=4){
				readdata[0] = colormapping[k];
				readdata[1] = colormapping[k+1];
				readdata[2] = colormapping[k+2];
				readdata[3] = colormapping[k+3];
				fputc(readdata[0], fcolor);
				fputc(readdata[1], fcolor);
				fputc(readdata[2], fcolor);
				fputc(readdata[3], fcolor);
				//cout << k/4 << " "<< (int)readdata[0] << " " << (int)readdata[1] << " " << (int)readdata[2] << " " <<(int)readdata[3] << endl;
			}//end for k
	*/		cout << colormapping.size()/4 << " " << amount1 * 256 + amount2 << endl;
			/*for(i = 0; i < img_height; ++i){
				for(j = 0; j < img_width; ++j){
					//cout << colormapping.size() << " " << (int)(color_Y[i][j]) << endl;
					//readdata[0] = colormapping[(int)(color_Y[i][j])];
					//readdata[1] = colormapping[(int)(color_Y[i][j])+1];
					//readdata[2] = colormapping[(int)(color_Y[i][j])+2];
					//readdata[3] = colormapping[(int)(color_Y[i][j])+3];
					
					//fputc(readdata[0],foutimg);
					//fputc(color_Y[i][j],foutimg);
					//fputc((color_Y[i][j]),foutimg);
					abs_y = ((double)color_Y[i][j] - (double)cur_frame_Y_ori[i][j]) * ((double)color_Y[i][j] - (double)cur_frame_Y[i][j]);
					abs_y_t += abs_y;
					

					//if(i%2 == 0 && j%2 == 0){
						//fputc(readdata[1],foutimg);
						//fputc(readdata[2],foutimg);
					//}//end if
				
				}//end for j
			
			}//end for i

			for(i = 0; i < img_height; i+=2){
				for(j = 0; j < img_width; j+=2){
					//cout << colormapping.size() << " " << (int)(color_Y[i][j]) << endl;
					//readdata[0] = colormapping[(int)(color_Y[i][j])];
					//readdata[1] = colormapping[(int)(color_Y[i][j])+1];
					//readdata[2] = colormapping[(int)(color_Y[i][j])+2];
					//readdata[3] = colormapping[(int)(color_Y[i][j])+3];
					
					//fputc(color_Y[i][j]+1,foutimg);
					//fputc((color_U[i/2][j/2]),foutimg);
						
					abs_u = ((double)color_U[i/2][j/2] - (double)cur_frame_U[i/2][j/2]) * ((double)color_U[i/2][j/2] - (double)cur_frame_U[i/2][j/2]);
					
					
					abs_u_t += abs_u;
					
					//if(i%2 == 0 && j%2 == 0){
						//fputc(readdata[1],foutimg);
						//fputc(readdata[2],foutimg);
					//}//end if
					
				}//end for j
			
			}//end for i
	
			for(i = 0; i < img_height; i+=2){
				for(j = 0; j < img_width; j+=2){
					//cout << colormapping.size() << " " << (int)(color_Y[i][j]) << endl;
					//readdata[0] = colormapping[(int)(color_Y[i][j])];
					//readdata[1] = colormapping[(int)(color_Y[i][j])+1];
					//readdata[2] = colormapping[(int)(color_Y[i][j])+2];
					//readdata[3] = colormapping[(int)(color_Y[i][j])+3];
					
				//fputc(color_Y[i][j]+2,foutimg);
					//fputc((color_V[i/2][j/2]),foutimg);
					abs_v = ((double)color_V[i/2][j/2] - (double)cur_frame_V[i/2][j/2]) * ((double)color_V[i/2][j/2] - (double)cur_frame_V[i/2][j/2]);
					abs_v_t += abs_v;
					//if(i%2 == 0 && j%2 == 0){
						//fputc(readdata[1],foutimg);
						//fputc(readdata[2],foutimg);
					//}//end if
					
				}//end for j
			
			}//end for i
			*/
			fwrite(color_Y_ptr,1,img_height*img_width,foutimg);
			fwrite(color_U_ptr,1,img_height_2*img_width_2,foutimg);
			fwrite(color_V_ptr,1,img_height_2*img_width_2,foutimg);


			//cout << "\tDifference in Y\t" << 20 * log10(255 / sqrt(abs_y_t/img_height/img_width)) << endl;
			//cout << "\tDifference in U\t" << 20 * log10(255 / sqrt(abs_u_t/img_height_2/img_width_2)) << endl;
			//cout << "\tDifference in V\t" << 20 * log10(255 / sqrt(abs_v_t/img_height_2/img_width_2)) << endl;


		
		}
		for(i = 0; i < img_height; ++i){
			for(j = 0; j < img_width; ++j){
				/*
				
				for(k = 0; k < numbckgndinuse; ++k){
					bg_temp_Y[i][j] += (unsigned int)bckgnd_Y[k][i][j] * ((bckgnd_built[k][i][j])?1:0);
					countbackground+=(bckgnd_built[k][i][j])?1:0;

					if(i < img_height_2 && j < img_width_2){
						bg_temp_U[i][j]+= (unsigned int)bckgnd_U[k][i][j] * ((bckgnd_built[k][i][j])?1:0);
						bg_temp_V[i][j]+= (unsigned int)bckgnd_V[k][i][j] * ((bckgnd_built[k][i][j])?1:0);
					}
				}//end for k
				*/
				bg_temp_Y[i][j] += (unsigned int)bckgnd_Y[0][i][j];
					countbackground+=1;

					if(i < img_height_2 && j < img_width_2){
						bg_temp_U[i][j]+= (unsigned int)bckgnd_U[0][i][j];
						bg_temp_V[i][j]+= (unsigned int)bckgnd_V[0][i][j];
					}

			}//end for j
		
		}//end for i
		
	}

	for(i = 0; i < img_height; ++i){
			for(j = 0; j < img_width; ++j){
				
				bg_Y[i][j] = ((unsigned int)bckgnd_Y[0][i][j] + (unsigned int)bckgnd_Y[0][i][j] + (unsigned int)bckgnd_Y[0][i][j]+ (unsigned int)bckgnd_Y[0][i][j])/4;
				if(i < img_height_2 && j < img_width_2){
					bg_U[i][j] = ((unsigned int)bckgnd_U[0][i][j] + (unsigned int)bckgnd_U[0][i][j] + (unsigned int)bckgnd_U[0][i][j]+ (unsigned int)bckgnd_U[0][i][j])/4;
					bg_V[i][j] = ((unsigned int)bckgnd_V[0][i][j] + (unsigned int)bckgnd_V[0][i][j] + (unsigned int)bckgnd_V[0][i][j]+ (unsigned int)bckgnd_V[0][i][j])/4;
				}
			}//end for j
		
		}//end for i

		fwrite(bg_Y_ptr,1,img_height*img_width,fp_bg);
		fwrite(bg_U_ptr,1,img_height_2*img_width_2,fp_bg);
		fwrite(bg_V_ptr,1,img_height_2*img_width_2,fp_bg);


}


void dilation (unsigned char ** i_img, unsigned char ** o_img, int Height, int Width){
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
				o_img[j][min(0,i+1)] = 255;
				o_img[j][min(0,i+2)] = 255;
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
		  else o_img[j][i] = i_img[j][i];
		 
      }//end for i
   }//end for j
}
void erosion (unsigned char ** img, unsigned char ** o_img, int Height, int Width){
   int i;
   int j;
   
   for(j = 0; j < Height; j++){
      for(i = 0; i < Width; i++){
         o_img[j][i] = 0;
      }//end for i
   }//end for j

   for(j = 0; j < Height; j++){
      for(i = 0; i < Width; i++){
		 // cout << j << " " << i << endl;
		  //cout << (int) img[j][i] << endl;
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
               ((int)img[j+2][i+1] == 255))o_img[j][i] = 255;
             else o_img[j][i] = 0;
          }
          else o_img[j][i] = img[j][i];
      }//end for i
   }//end for j

}