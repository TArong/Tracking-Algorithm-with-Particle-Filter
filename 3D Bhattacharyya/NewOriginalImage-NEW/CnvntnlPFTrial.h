#include <stdio.h>
#include <stdlib.h>
#include "math.h"
//#define RandMax 32767

//Frame size
//#define SeqSize 870
//#define FrameH 240
//#define FrameW 320
//#define FrameH2 120
//#define FrameW2 160
/*
//initialization of the object
#define IniPx 230
#define IniPy 190
#define IniHalfW 10
#define IniHalfH 10
*/
//kernel
#define EpanechnikovKenerlConst 2

//Weight update constant
//#define VarWU 25
//#define StdWU 5

//Particle Number
#define NumParticleonObject  25

//Histogram Bin Number
/*
#define NumHistBin NumYBin*NumUSubBin*NumVSubBin
#define NumYBin  256
#define NumUSubBin 256
#define NumVSubBin 256
*//*
#define NumHistBin 65536
#define NumYBin  64
#define NumUSubBin 32
#define NumVSubBin 32
*/


//sampling range 
//#define IniSampleRangePx (IniHalfW/2)
//#define IniSampleRangePy (IniHalfH/2)  
#define IniSampleRangeHalfW 5//10
#define IniSampleRangeHalfH 5//10






