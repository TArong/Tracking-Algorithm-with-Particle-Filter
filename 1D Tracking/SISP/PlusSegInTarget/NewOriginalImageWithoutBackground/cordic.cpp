#include <cstdlib>
#include <cmath>
#include <iostream>
#include <cstdio>
#include "cordic.h"

using namespace std;





void cordic(long int x0, long int y0, long int z0, long int a0, long int& xn, long int& yn, long int& zn, long int& an, long int choose, int i){
	long int d;
	//long int x1, x2, x3, x4;
	//long int y1, y2, y3, y4;
	//long int z1, z2, z3, z4;
	
	if(choose == 0)
		d = (z0 >= 0)?1:(-1);
	else if(choose == 1)
		d = (y0 < 0)?1:(-1);

	xn = x0 - y0*d/pow((double)2,i);
	yn = y0 + x0*d/pow((double)2,i);
	zn = z0 - d * atantable(i);//atan(pow((long int)2, -i));
	an = a0*sqrt(1+pow((double)2,-2*i));

}//end cordic()
double atantable(int i){
	double truncat;
	truncat = atan(pow((double)2, -i)) * pow((double)2,16);
	
	return (double)truncat;// / pow((double)2,16);

}//end atantable