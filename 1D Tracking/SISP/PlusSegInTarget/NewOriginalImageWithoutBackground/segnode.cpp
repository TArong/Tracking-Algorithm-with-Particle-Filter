#include "segnode.h"

segnode::segnode(){
	left = 0;
	right = 0;
	leftbound = 0;
	rightbound = 0;
	upbound = 0;
	downbound = 0;
	newtracker = true;
	countpass = 0;
	ID = 0;
}

segnode::~segnode(){
	left = 0;
	right = 0;
	leftbound = 0;
	rightbound = 0;
	upbound = 0;
	downbound = 0;
	newtracker = true;
	countpass = 0;
	ID = 0;


}