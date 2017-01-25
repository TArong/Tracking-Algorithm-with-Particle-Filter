#include "emd.h"
#ifndef BD_H
#define BD_H
#define StandDev 5

/*
class feature_t{
public:
	int X, Y, Z;
};//end class feature_t
*/
class distance_t{
public:
	int X, Y, Z;
	float difference;
};
/*
class signature_t{
public:
	int n;
	feature_t *Features;
	float *Weights;
};//end class signature_t
*/
float BDdist(signature_t *Signature1, signature_t* Signature2);
		


#endif