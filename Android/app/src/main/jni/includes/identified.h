/*
 *	Title: Identified.h	
 *	Written by: Brian Bauer
 *	Team: Luminous Moss Boss
 *	------------------------
 *	Description: A simple bag class for storing information about identified objects
 */

#ifndef __IDENTIFIED__
//	Functions to convert between coordinate systems
int convertToCVx(double glx, unsigned int width, double asp_src);
int convertToCVy(double gly, unsigned int height);
int convertToCVr(double glr, unsigned int width, unsigned int height, double asp_src);
double convertToGLx(unsigned int x, unsigned int width, double asp_src);
double convertToGLy(unsigned int x, unsigned int height);
double convertToGLr(unsigned int x, unsigned int width, unsigned int height, double asp_src);

class identified {
	//	Variables
	private:
		bool OpenCV;		//	if it was identified by opencv or human input
		int x;				//	x coordinate
		int y;				//	y coordinate
		int r;				//	radius
		double glx;			//	x coordinate in gl
		double gly;			//	y coordinate in gl
		double glr;			//	radius in gl
	public:
		//	Constructors
		identified(){};
		identified(bool state);
		identified(double _x, double _y, double _r, bool state, int width, int height, double asp_src);
		identified(double _x, double _y, double _r, double _glx, double _gly, double _glr, bool state, bool fp);
		//	Copy Constructor
		identified(const identified &id);
		//	For coordinates in openGL
		double get_glx();
		double get_gly();
		double get_glr();
		//	For coordinates in openCV
		int get_cvx();
		int get_cvy();
		int get_cvr();
		//	Set openGL coordinates
		void set_gl(double _x, double _y, double _r, int width, int height, double asp_src);
		void set_glx(double n, int width, double asp_src);
		void set_gly(double n, int height, double asp_src);
		void set_glr(double n, int width, int height, double asp_src);
		//	Set openCV coordinates
		void set_cv(double _x, double _y, double _r, int width, int height, double asp_src);
		void set_cvx(double n, int width, double asp_src);
		void set_cvy(double n, int height, double asp_src);
		void set_cvr(double n, int width, int height, double asp_src);
		//	Boolean variables and functions
		bool byOpenCV(){return OpenCV;};
		bool select;
		bool falsePositive;	//	if it was a false positive
		//	operators
		bool operator==(const identified& id) const;
};

#endif