#include <opencv/cv.h>
#include <opencv2/core/core.hpp>
#include <opencv2/objdetect/objdetect.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#include <iostream>
#include <string>
#include <stdio.h>
#include <math.h>
#include <fstream>

#include "main.h"
#include "identified.h"
#include "glshapes.h"

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

//  Identified Plants
vector<identified> id;
vector<unsigned int> selected;
identified userId(false);

//  OpenGL Window
glwindow view;

//  Mouse
mousePos m;
int mouseMove = 0;
int mouseAdd = 0;
//int m.prex, m.prey;

void read(char* filename){
  string s;
  ifstream infile;
  infile.open (filename);
  while(!infile.eof())
  {
    getline(infile,s);
    cout << s << "\n";
  }
  infile.close();
}

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
  //double speed = 0.1*view.dim;
  double scale = 0.05;
  switch(key)
  {
    case 27:
      exit(0);
    case 'w':
      if(view.dim > scale)
      view.dim-=scale;
      project();
      break;
    case 's':
      view.dim+=scale;
      project();
      break;
    case 'a':
      mouseAdd = 1;
      mouseMove = 0;
      break;
    //  Mark for being a false positive
    case 'd':
      for(size_t i = 0; i < selected.size(); i++){
        if(id[selected[i]].byOpenCV()){
        id[selected[i]].select = false;
        id[selected[i]].falsePositive = true;
        }
        else
        {
          id.erase(id.begin()+selected[i]);
        }
      }
      selected.clear();
      break;
    //  Mark for being true positive
    case 'e':
      for(size_t i = 0; i < selected.size(); i++){
        id[selected[i]].select = false;
        id[selected[i]].falsePositive = false;
      }
      selected.clear();
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
  if (button == GLUT_LEFT_BUTTON)
  {
    if (!mouseAdd)
      mouseMove = 1;
    if (mouseAdd && state == GLUT_DOWN){
      m.prex = mx;
      m.prey = my;
      double mousex = -view.x+m.getX(view.width,view.dim,view.asp);
      double mousey = -view.y+m.getY(view.height,view.dim,1.0);
      userId.set_gl(mousex,mousey,0,image.cols,image.rows,asp_src);
    }
    if (mouseAdd && state == GLUT_UP){
      mouseMove = 1;
      mouseAdd = 0;
      id.push_back(userId);
    }
  }
  else if (button == GLUT_RIGHT_BUTTON)
  {
    for(size_t i = 0; i < selected.size(); i++){
      id[selected[i]].select = 0;
    }
    selected.clear();
    double mousex = -view.x+m.getX(view.width,view.dim,view.asp);
    double mousey = -view.y+m.getY(view.height,view.dim,1.0);
    for(size_t i = 0; i < id.size(); i++){
      if ( abs(mousex-id[i].get_glx())< id[i].get_glr() && 
           abs(mousey-id[i].get_gly())< id[i].get_glr() && !mouseMove){
        selected.push_back(i);
        id[i].select = true;
      }
    }
    mouseMove = 0;
  }
  if (state == GLUT_DOWN)
  {
    m.prex = mx;
    m.prey = my;
  }
  if(!mouseMove)
    glutPostRedisplay();
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
  if(mouseMove){
    view.x -= (double)(m.prex-mx)/w*view.dim*view.asp*2;
    view.y += (double)(m.prey-my)/h*view.dim*2;
  }
  if(mouseAdd){
    double mousex = -view.x+m.getX(view.width,view.dim,view.asp);
    userId.set_glr(abs(mousex-userId.get_glx()),image.cols,image.rows,asp_src);
  }
  m.prex = mx;
  m.prey = my;
  glutPostRedisplay();
}

/*
 *  display
 *  Renders all openGL instances 
 */
void display()
{
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  glEnable(GL_DEPTH_TEST);
  glLineWidth(4);

  glLoadIdentity();
  //  Camera/View Orientation
  glPushMatrix();
  //view.dim*view.asp
  
  glTranslated(view.x,view.y,0);


//((mx-x)<radius && (my-y)<radius);
//  Draw Circle
//if (!mouseMove && !mouseAdd)
//  circle(-view.x+m.getX(view.width,view.dim,view.asp),-view.y+m.getY(view.height,view.dim,1.0),0,0.005,36);
if (mouseAdd)
  circle(userId.get_glx(),userId.get_gly(),0,userId.get_glr(),36);
for(size_t i = 0; i < id.size(); i++){
    glColor3f(1,0,0);
    if(id[i].falsePositive)
      glColor3f(0.1,0,0);
    if(id[i].select)
      glColor3f(1,1,0);
    circle(id[i].get_glx(),id[i].get_gly(),0,id[i].get_glr(),36);     
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
          if( radius/2 >= abs( location.x-id[j].get_cvx() ) && 
              radius/2 >= abs( location.y-id[j].get_cvy() ) ){
            num_found--;
            inlist = 1;
            break;
          }
        }
      }
      if (!inlist)
      {
        identified tempid(location.x, location.y, radius, true, image.cols, image.rows, asp_src);
        id.push_back(tempid);
        //circle(image, location, radius, Scalar(20, 0, 255), 4);
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
  read("testcase.tc");

  //  Image Processing
  asp_src = (double)image.size().width/image.size().height;
  int num_found = detectObj(increment);

  //  Results of object detection
  if(num_found > 1)
    printf("\nFound %d flowers.\n",num_found);
  else if(num_found == 1)
    printf("Found 1 flower.\n");
  else if(num_found <= 0)
    printf("Found Nothing\n");

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
