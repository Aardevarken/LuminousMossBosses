/*
 *	Title: GLSHAPES.h	
 *	Team: Luminous Moss Boss
 *	Last Updated: 11/02/2014
 */

#ifndef __GLSHAPES__

#include <math.h>

#ifdef __APPLE__
  #include <GLUT/glut.h>
#else
  #include <GL/gl.h>
  #include <GL/glut.h>
#endif

void box(double x1, double x2, double y1, double y2);
void circle(double x, double y, double z, double r, unsigned int sides);
void plain( double x,double y,double z, double dx,double dy,double dz);

#endif