#include "identified.h"

/*
 *	Constructors
 */
 identified::identified(double _x, double _y, double _r, bool state, int width, int height, double asp_src)
 {
 	if (state){
 		x = _x; 
 		y = _y; 
 		r = _r; 
 		glx = ((double)x/width*(2*asp_src)-asp_src);
 		gly = (-(double)y/height*2+1);
 		glr = ((double)r/(width+height)*4*((asp_src+1)/2));
 	}
 	else if (!state){
 		glx = _x;
 		gly = _y;
 		glr = _r;
 		x = (glx+asp_src)*(width/2/asp_src);
 		y = (gly+asp_src)*(height/2);
 		r = glr*(width/height)/4/((asp_src+1)/2); 
 	}
 	OpenCV = state; 
 	falsePositive = false; 
 	select = false;
}
identified::identified(bool state){
	OpenCV = state;
	falsePositive = false;
	select = false;
}

/*
 *	get_glx
 */
double identified::get_glx() { return glx; }

/*
 *	get_gly
 */
double identified::get_gly() { return gly; }

/*
 *	get_glr
 */
double identified::get_glr() { return glr; }

/*
 *	get_cvx
 */
int identified::get_cvx(){ return x; }

/*
 *	get_cvy
 */
int identified::get_cvy(){ return y; }

/*
 *	get_cvr
 */
int identified::get_cvr(){ return r; }

/*
 *	set_gl
 */
void identified::set_gl(double _x, double _y, double _r, int width, int height, double asp_src){
	glx = _x; 
	gly = _y; 
	glr = _r;
	x = (glx+asp_src)*(width/2/asp_src);
	y = (gly+asp_src)*(height/2);
	r = glr*(width/height)/4/((asp_src+1)/2); 
}

/*
 *	set_glx
 */
void identified::set_glx(double n, int width, double asp_src){
	glx = n; 
	x = (glx+asp_src)*(width/2/asp_src);
}

/*
 *	set_glx
 */
void identified::set_gly(double n, int height, double asp_src){
	gly = n; 
	y = (gly+asp_src)*(height/2);
}

/*
 *	set_glx
 */
void identified::set_glr(double n, int width, int height, double asp_src){
	glr = n; 
	r = glr*(width/height)/4/((asp_src+1)/2); 
}

/*
 *	set_cv
 */
void identified::set_cv(double _x, double _y, double _r, int width, int height, double asp_src){
	x = _x; 
	y = _y; 
	r = _r;
	glx = ((double)x/width*(2*asp_src)-asp_src);
	gly = (-(double)y/height*2+1);
	glr = ((double)r/(width+height)*4*((asp_src+1)/2));
}

