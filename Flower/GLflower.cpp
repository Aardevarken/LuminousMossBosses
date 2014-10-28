#include <opencv/cv.h>
#include <opencv2/core/core.hpp>
#include <opencv2/objdetect/objdetect.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#include <iostream>
#include <stdio.h>
#include <math.h>

#ifdef __APPLE__
  #include <GLUT/glut.h>
#else
  #include <GL/gl.h>
  #include <GL/glut.h>
#endif

using namespace cv;
using namespace std;

//  OpenCV Image Processing
String flower_cascade_name = "flower.xml";
CascadeClassifier flower_cascade;

//  OpenCV images and OpenGL textures
Mat image;
Mat dst;
GLuint texture;
double asp_src = 1;

//  OpenGL Window
double asp = 1;
double dim = 1;
double cx = 0;
double cy = 0;
double cz = 1;

//  Mouse
int px, py;

/*
 *  Project
 *  Handles the projection matrix for openGL
 */
void Project()
{
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(-asp*dim,asp*dim,-dim,+dim,-dim,+dim);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
}

/*
 *  reshape
 *  Keeps consistent aspect Ratio for openGL window
 */
void reshape(int width, int height)
{
  asp = (height>0) ? (double)width/height :1;
  glViewport(0,0,width,height);
  Project();
}

/*
 *  keyboard
 *  keyboard input to manipulate the view for openGL window
 */
void keyboard(unsigned char key, int kx, int ky)
{
  double speed = 0.1*dim;
  double scale = 0.05;
  switch(key)
  {
    case 27:
      exit(0);
    case '-':
      dim+=scale;
      Project();
      break;
    case '=':
      if(dim > scale)
        dim-=scale;
      Project();
      break;
    case 'w':
      cy += speed;
      break;
    case 's':
      cy -= speed;
      break;
    case 'a':
      cx -= speed;
      break;
    case 'd':
      cx += speed;
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
    px = mx;
    py = my;
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
  cx -= (double)(px-mx)/w*dim*asp*2;
  cy += (double)(py-my)/h*dim*2;
  px = mx;
  py = my;
  glutPostRedisplay();
}

/*
 *  box
 *  Draws a box 
 */
void box(double x, double y, double z, 
        double dx, double dy, double dz)
{
  glPushMatrix();
  glTranslated(x,y,z);
  glScaled(dx,dy,dz);

  glColor3f(0,1,0);
  glBegin(GL_LINE_LOOP);
  glVertex3f(-1,+1,0);
  glVertex3f(+1,+1,0);
  glVertex3f(+1,-1,0);
  glVertex3f(-1,-1,0);
  glEnd();
  glPopMatrix();
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

  glColor3f(1,0,0);
  glBegin(GL_LINE_LOOP);
  for(unsigned int i = 0; i<sides; i++)
  {
    glVertex3f(cos(deg*i),sin(deg*i),0);
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
  glLineWidth(10);
  //glLoadIdentity();
  glPushMatrix();
  glTranslated(cx,cy,0);
  /*for(size_t i = 0; i < locations.size(); i++){
    //double lx = (double)locations[i].x/image.cols;
    //double ly = -(double)locations[i].y/image.rows+asp_src;
    //box(lx,ly,0,.0125,.0125,1);
    box(locations[i].x,locations[i].y,0,radiuses[i],radiuses[i],1);
  }*/

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
void showProgress(int i, int total){
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
int detectObj(unsigned int increment){
  cout << "Processing\n";
  
  vector<Point> locations;

  int num_found = 0;
  Mat rotated, temp, rotated_gray;
  int line_thickness = 4;
  
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
      if (!locations.empty()){
        for(size_t j = 0; j < locations.size(); j++){
          if( radius/2 >= abs(location.x-locations[j].x) && radius/2 >= abs(location.y-locations[j].y)){
            num_found--;
            inlist = 1;
            break;
          }
        }
      }
      if (!inlist)
      {
        locations.push_back(location);
        circle(image, location, radius, Scalar(0, 0, 255), line_thickness);
      }
      
      //circle(rotated, rotated_location, radius, Scalar(255, 0, 0), line_thickness);
      
    }
    //imshow("Flower Detection", rotated);
    //waitKey(0);
    
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

  image.copyTo(dst);
  
  //  Create openGL window
  glutInit(&argc, argv);
  glutInitDisplayMode( GLUT_RGBA );
  glutInitWindowSize(500, 500);
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
