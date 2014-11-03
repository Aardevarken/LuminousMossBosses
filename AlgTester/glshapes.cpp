#include "glshapes.h"

/*
 *  box
 *  Draws a box 
 */
void box(double x1, double x2, 
        double y1, double y2)
{
  glBegin(GL_QUADS);
  glVertex3f(x1,y2,0);
  glVertex3f(x2,y2,0);
  glVertex3f(x2,y1,0);
  glVertex3f(x1,y1,0);
  glEnd();
}

/*
 *  circle
 *  Draws a circle
 */
void circle(double x, double y, double z, double r, unsigned int sides)
{
  //double rad = M_PI/180.0;
  double deg = 360/sides*M_PI/180.0;
  glPushMatrix();
  glTranslated(x,y,z);
  glBegin(GL_LINE_LOOP);
  for(unsigned int i = 0; i<sides; i++)
  {
    glVertex3f(cos(deg*i)*r,sin(deg*i)*r,0);
  }
  glEnd();
  glPopMatrix();
}

/*
 *  plain
 *  Draws a rectangle that a texture can be projected upon
 */
void plain( double x,double y,double z,
          double dx,double dy,double dz)
{
  //  Save transformation
  glPushMatrix();
  //  Offset
  glTranslated(x,y,z);
  glScaled(dx,dy,dz);
  glColor3f(1,1,1);
  glBegin(GL_QUADS);
  glTexCoord2f(0,0);  glVertex3f(-1,+1, 0);
  glTexCoord2f(1,0);  glVertex3f(+1,+1, 0);
  glTexCoord2f(1,1);  glVertex3f(+1,-1, 0);
  glTexCoord2f(0,1);  glVertex3f(-1,-1, 0);
  glEnd();

  //  Undo transformations
  glPopMatrix();
}