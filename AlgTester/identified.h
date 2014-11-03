/*
 *	Title: Identified.h	
 *	Team: Luminous Moss Boss
 *	Last Updated: 11/01/2014
 */

#ifndef __IDENTIFIED__

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
		//void set_cvx(double n);
		//void set_cvy(double n);
		//void set_cvr(double n);
		bool byOpenCV(){return OpenCV;};
		bool select;
		bool falsePositive;	//	if it was a false positive
};

#endif