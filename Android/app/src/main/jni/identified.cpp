#include "identified.h"

/*
 *	Convert gl coordinates to cv
 */
int convertToCVx(double glx, unsigned int width, double asp_src){
	return (glx+asp_src)*(width/2/asp_src);
}
int convertToCVy(double gly, unsigned int height){
	return (gly-1)*(height/2);
}
int convertToCVr(double glr, unsigned int width, unsigned int height, double asp_src)
{
	return glr*(width/height)/4/((asp_src+1)/2);
}

/*
 *	Convert cv coordinates to gl
 */
double convertToGLx(unsigned int x, unsigned int width, double asp_src)
{
	return ((double)x/width*(2*asp_src)-asp_src);
}
double convertToGLy(unsigned int y, unsigned int height)
{
	return (-(double)y/height*2+1);;
}
double convertToGLr(unsigned int r, unsigned int width, unsigned int height, double asp_src)
{
	return ((double)r/(width+height)*4*((asp_src+1)/2));
}

/*
 *	Constructors
 */
 identified::identified(bool state)
{
	OpenCV = state;
	falsePositive = false;
	select = false;
}
 identified::identified(double _x, double _y, double _r, bool state, int width, int height, double asp_src)
 {
 	if (state){
 		x = _x; 
 		y = _y; 
 		r = _r; 
 		glx = convertToGLx(x, width, asp_src);
 		gly = convertToGLy(y, height);
 		glr = convertToGLr(r, width, height, asp_src);
 		/*glx = ((double)x/width*(2*asp_src)-asp_src);
 		gly = (-(double)y/height*2+1);
 		glr = ((double)r/(width+height)*4*((asp_src+1)/2));*/
 	}
 	else if (!state){
 		glx = _x;
 		gly = _y;
 		glr = _r;
 		x = convertToCVx(glx, width, asp_src);
 		y = convertToCVy(y, height);
 		r = convertToCVr(r, width, height, asp_src);
 		/*x = (glx+asp_src)*(width/2/asp_src);
 		y = (gly-1)*(height/2);
 		r = glr*(width/height)/4/((asp_src+1)/2);*/
 	}
 	OpenCV = state; 
 	falsePositive = false; 
 	select = false;
}
 identified::identified(double _x, double _y, double _r, double _glx, double _gly, double _glr, bool state, bool fp)
 {
	x = _x; 
	y = _y; 
	r = _r; 
	glx = _glx;
	gly = _gly;
	glr = _glr;
 	OpenCV = state; 
 	falsePositive = fp; 
 	select = false;
}

/*
 *	Copy Constructor
 */
identified::identified(const identified& id)
{
	x = id.x;
	y = id.y;
	r = id.r;
	glx = id.glx;
	gly = id.gly;
	glr = id.glr;
	OpenCV = id.OpenCV;
	falsePositive = id.falsePositive;
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
	x = convertToCVx(glx, width, asp_src);
 	y = convertToCVy(y, height);
 	r = convertToCVr(r, width, height, asp_src);
}

/*
 *	set_glx
 */
void identified::set_glx(double n, int width, double asp_src){
	glx = n; 
	x = convertToCVx(glx, width, asp_src);
}

/*
 *	set_glx
 */
void identified::set_gly(double n, int height, double asp_src){
	gly = n; 
	y = convertToCVy(gly, height);
}

/*
 *	set_glx
 */
void identified::set_glr(double n, int width, int height, double asp_src){
	glr = n; 
	r = convertToCVr(glr, width, height, asp_src); 
}

/*
 *	set_cv
 */
void identified::set_cv(double _x, double _y, double _r, int width, int height, double asp_src){
	x = _x; 
	y = _y; 
	r = _r;
	glx = convertToGLx(x, width, asp_src);
 	gly = convertToGLy(y, height);
 	glr = convertToGLr(r, width, height, asp_src);
}

/*
 *	set_cvx
 */
void identified::set_cvx(double n, int width, double asp_src){
	x = n; 
	glx = convertToGLx(glx, width, asp_src);
}

/*
 *	set_cvx
 */
void identified::set_cvy(double n, int height, double asp_src){
	y = n; 
	gly = convertToGLy(y, height);
}

/*
 *	set_cvx
 */
void identified::set_cvr(double n, int width, int height, double asp_src){
	r = n; 
	glr = convertToGLr(r, width, height, asp_src); 
}

/*
 *	Operator ==
 */
bool identified::operator==(const identified& id) const
{
	return (x == id.x && y == id.y && r == id.r && 
			glx == id.glx && gly == id.gly && r == id.glr &&
			OpenCV == id.OpenCV && falsePositive == id.falsePositive);
}
