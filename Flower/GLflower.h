///////////////////////////////////
//	Title: GLflower 			 //
//	Team: Luminous Moss Boss	 //
//	Last Updated: 10/30/2014	 //
///////////////////////////////////

#ifndef __GLFLOWER__

#ifdef __APPLE__
  #include <GLUT/glut.h>
#else
  #include <GL/gl.h>
  #include <GL/glut.h>
#endif

struct glwindow {
	double asp;
	double dim;
	double x;
	double y;
	double z;
	unsigned int width;
	unsigned int height;
	glwindow(){asp = 1;dim = 1;x = 0;y = 0;z = 1;width = 500;height = 500;}
};

struct identified {
	double x;
	double y;
	double radius;
	identified(){};
	identified(double X, double Y, double Radius){x = X; y = Y; radius = Radius;};

	//	For displaying in openGL
	double getX(int width, double asp_src){
		return ((double)x/width*(2*asp_src)-asp_src);}
	double getY(int height, double asp_src){
		return (-(double)y/height*2+1);}
	double getRadius(int width, int height, double asp_src){
		return (radius/(width+height)*4*((asp_src+1)/2));}
};

//	OpenGL Window
void project();
void reshape(int width, int height);
void keyboard(unsigned char key, int kx, int ky);
void mouse(int button, int state, int mx, int my);
void mouse_move(int mx, int my);
void display();

//	OpenGL Draw
void box(double x1, double x2, double y1, double y2);
void circle(double x, double y, double z, double r, unsigned int sides);
void plain( double x,double y,double z, double dx,double dy,double dz);

//	Terminal
void showProgress(int i, int total);

//	OpenCV
int detectObj(unsigned int increment);

#endif