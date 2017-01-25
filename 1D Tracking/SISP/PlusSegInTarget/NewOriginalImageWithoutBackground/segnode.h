#ifndef SEGNODE_H
#define SEGNODE_H

class segnode{
	public:
		segnode();
		~segnode();
		
		segnode* left;
		segnode* right;

		int leftbound;
		int rightbound;
		int upbound;
		int downbound;
		int countpass;
		int ID;

		bool newtracker;
	private:

	
};//end class node






#endif