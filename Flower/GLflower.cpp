#include <opencv/cv.h>
#include <opencv2/core/core.hpp>
#include <opencv2/objdetect/objdetect.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#include <iostream>
#include <stdio.h>
#include <math.h>

#include "GLflower.h"

using namespace cv;
using namespace std;

//  OpenCV Image Processing
String flower_cascade_name = "flower.xml";
CascadeClassifier flower_cascade;

//  OpenCV images and OpenGL textures
Mat image;
Mat dst;
GLuint texture;
double asp_src = 1;     // image aspect ratio
vector<identified> id;

//  OpenGL Window
glwindow view;

//  Mouse
int prex, prey;

/*
 *  Project
 *  Handles the projection matrix for openGL
 */
void project()
{
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(-view.asp*view.dim,view.asp*view.dim,-view.dim,+view.dim,-view.dim,+view.dim);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
}

/*
 *  reshape
 *  Keeps consistent aspect Ratio for openGL window
 */
void reshape(int width, int height)
{
  view.width = width;
  view.height = height;
  view.asp = (height>0) ? (double)width/height :1;
  glViewport(0,0,width,height);
  project();
}

/*
 *  keyboard
 *  keyboard input to manipulate the view for openGL window
 */
void keyboard(unsigned char key, int kx, int ky)
{
  double speed = 0.1*view.dim;
  double scale = 0.05;
  switch(key)
  {
    case 27:
      exit(0);
    case '-':
      view.dim+=scale;
      project();
      break;
    case '=':
      if(view.dim > scale)
        view.dim-=scale;
      project();
      break;
    case 'w':
      view.y += speed;
      break;
    case 's':
      view.y -= speed;
      break;
    case 'a':
      view.x -= speed;
      break;
    case 'd':
      view.x += speed;
      break;
  }
  glutPostRedisplay();
}

/*
 *  mouse
 *  Gets mouse input for opengl Window
 */
void mouse(int button, int state, int mx, int my)
{
  if (state == GLUT_DOWN && button == GLUT_LEFT_BUTTON)
  {
    prex = mx;
    prey = my;
  }
}

/*
 *  mouse_movement
 *  Handles mouse displacement, this is used to move image around during 
 *  a mouse button down instance
 */
void mouse_move(int mx, int my)
{
  int w = glutGet(GLUT_WINDOW_WIDTH);
  int h = glutGet(GLUT_WINDOW_HEIGHT);
  view.x -= (double)(prex-mx)/w*view.dim*view.asp*2;
  view.y += (double)(prey-my)/h*view.dim*2;
  prex = mx;
  prey = my;
  glutPostRedisplay();
}

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

/*
 *  display
 *  Renders all openGL instances 
 */
void display()
{
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  glEnable(GL_DEPTH_TEST);
  glLineWidth(2);

  glLoadIdentity();
  //  Camera/View Orientation
  glPushMatrix();
  glTranslated(view.x,view.y,0);

  //  Draw Circles
  for(size_t i = 0; i < id.size(); i++){
    glColor3f(1,0,0);
    circle(id[i].getX(image.cols,asp_src),id[i].getY(image.rows,asp_src),0,id[i].getRadius(image.cols,image.rows,asp_src),36);
  }

  //  Draw Processed Image
  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D, texture);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); 
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR); 
  glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S , GL_REPEAT );
  glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT );
  glTexImage2D(GL_TEXTURE_2D, 0, 3, dst.cols, dst.rows, 0, 0x80E0, GL_UNSIGNED_BYTE, dst.data);
    plain(0,0,0,asp_src,1,1);
  glDisable(GL_TEXTURE_2D);
  glPopMatrix();

  glFlush();
  glutSwapBuffers();
}

/*
 * Show Progress
 * Displays the percentage of a current running process
 */
void showProgress(int i, int total)
{
  int percent = floor((float)i/total*100);
  int amount = percent/10;
  cout << "\r" << percent << "% complete [";
  cout << string(amount, '|') << string(10-amount,'-') << "]";
  cout.flush();
}

/*
 * detectObj
 * Object Detection using openCV
 */
int detectObj(unsigned int increment)
{
  cout << "Processing\n";

  int num_found = 0;
  Mat rotated, temp, rotated_gray;
  //int line_thickness = 4;
  
  double centerx = image.cols/2.0;
  double centery = image.rows/2.0;
  Point2f center(centerx, centery);
  
  for (int theta=0; theta<360; theta+=increment) {
    showProgress(theta, 360);
    // Rotate image
    temp = getRotationMatrix2D(center, -double(theta), 1.0);
    warpAffine(image, rotated, temp, image.size());
  
    // Convert to greyscale
    Mat image_gray;
    cvtColor(rotated, rotated_gray, CV_BGR2GRAY);
    equalizeHist(rotated_gray, rotated_gray);
    
    // Run detection
    vector<Rect> flowers;
    flower_cascade.detectMultiScale(rotated_gray, flowers);
    num_found += flowers.size();

    //  Draws Circles
    for(size_t i = 0; i < flowers.size(); i++) {
      double rotated_locationx = flowers[i].x + flowers[i].width*0.5;
      double rotated_locationy = flowers[i].y + flowers[i].height*0.5;
      Point rotated_location(rotated_locationx, rotated_locationy);
      double dx = rotated_locationx - centerx;
      double dy = rotated_locationy - centery;
      double alpha = theta * M_PI/180.0;
      double beta = atan2(dy, dx);
      double distance = sqrt(dx*dx + dy*dy);
      
      //  Checks if flower was already found
      int radius = max(flowers[i].width*0.5, flowers[i].height*0.5);
      Point location(centerx + distance * cos(beta - alpha),
                     centery + distance * sin(beta - alpha));
      int inlist = 0;
      if (!id.empty()){
        for(size_t j = 0; j < id.size(); j++){
          if( radius/2 >= abs(location.x-id[j].x) && radius/2 >= abs(location.y-id[j].y)){
            num_found--;
            inlist = 1;
            break;
          }
        }
      }
      if (!inlist)
      {
        //Point3f tpoint(location.x, location.y, radius);
        identified tempid(location.x, location.y, radius);
        id.push_back(tempid);
        //circle(image, location, radius, Scalar(0, 0, 255), line_thickness);
      }
    }
  }
  showProgress(100,100);
  return num_found;
}


/*
 *  Main
 */
int main(int argc, char** argv) {
  //  User Input
  if (argc < 2) {
    printf("Usage: display_image ImageToLoadAndDisplay\n");
    return -1;
  }

  if (!flower_cascade.load(flower_cascade_name)) {
    printf("Error loading cascafe file.\n");
    return -1;
  };
  image = imread(argv[1], CV_LOAD_IMAGE_COLOR);

  if (!image.data) {
    printf("Could not open or find the image\n");
    return -1;
  }

  unsigned int increment = (argc == 3)?atoi(argv[2]):10;

  //  Image Processing
  int num_found = detectObj(increment);

  //  Results of object detection
  if(num_found > 1)
    printf("\nFound %d flowers.\n",num_found);
  else if(num_found == 1)
    printf("Found 1 flower.\n");
  else if(num_found <= 0)
    printf("Found Nothing\n");

  asp_src = (double)image.size().width/image.size().height;
  image.copyTo(dst);
  
  //  Create openGL window
  glutInit(&argc, argv);
  glutInitDisplayMode( GLUT_RGBA );
  glutInitWindowSize(view.width, view.height);
  glutCreateWindow("Preview");
  glClearColor(0.5f,0.5f,0.5f,1.0f);

  glutDisplayFunc(display);
  glutReshapeFunc(reshape);
  glutMouseFunc(mouse);
  glutMotionFunc(mouse_move);
  glutKeyboardFunc(keyboard);

  glutMainLoop();

  return 0;
}
