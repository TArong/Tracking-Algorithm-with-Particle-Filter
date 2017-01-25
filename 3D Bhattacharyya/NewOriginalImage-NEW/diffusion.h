#include "emd.h"
#include "BD.h"
#ifndef DIFFUSION_H
#define DIFFUSION_H
#define StandDev 5

/*
class feature_t{
public:
	int X, Y, Z;
};//end class feature_t

class distance_t{
public:
	int X, Y, Z;
	float difference;
};

class signature_t{
public:
	int n;
	feature_t *Features;
	float *Weights;
};//end class signature_t
*/
float DFdist(signature_t *Signature1, signature_t* Signature2);
		


#endif