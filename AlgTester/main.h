/*
 *	Title: main.h	
 *	Team: Luminous Moss Boss
 *	Last Updated: 11/01/2014
 */
 
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

struct mousePos {
	double prex;
	double prey;
	double getX(int width, double dim, double asp){
		return ((prex/width*2) - 1)*dim*asp;}
	double getY(int height, double dim, double asp){
		return (-(prey/height*2) + 1)*dim*asp;}
};

//	OpenGL Window
void project();
void reshape(int width, int height);
void keyboard(unsigned char key, int kx, int ky);
void mouse(int button, int state, int mx, int my);
void mouse_move(int mx, int my);
void display();

//	Terminal
void showProgress(int i, int total);

//	OpenCV
int detectObj(unsigned int increment);

#endif