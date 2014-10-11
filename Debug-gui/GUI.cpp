#include <opencv/cv.h>
#include <opencv/highgui.h>

#ifdef __APPLE__
	#include <GLUT/glut.h>
	#else
	#include <GL/gl.h>
	#include <GL/glut.h>
#endif

#include <cstdio>

using namespace cv;

//	OpenCV images and OpenGL textures
Mat src1;
Mat src2;
Mat dst;
GLuint texture;
double asp_src = 1;

//	Trackbar global variables
const int alpha_slider_max = 100;
int alpha_slider;
double alpha;
double beta;
int value = 0;

//	OpenGL Window
double asp = 1;
double dim = 2;
double x = 0;
double y = 0;
double z = 0;

//	Mouse
int px, py;


void Project()
{
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrtho(-asp*dim,asp*dim,-dim,+dim,-dim,+dim);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
}

void reshape(int width, int height)
{
	asp = (height>0) ? (double)width/height :1;
	glViewport(0,0,width,height);
	Project();
}

void keyboard(unsigned char key, int kx, int ky)
{
	double speed = 0.1*dim;
	switch(key)
	{
		case 27:
			exit(0);
		case '-':
			dim+=0.05;
			Project();
			break;
		case '=':
			dim-=0.05;
			Project();
			break;
		case 'w':
			y += speed;
			break;
		case 's':
			y -= speed;
			break;
		case 'a':
			x -= speed;
			break;
		case 'd':
			x += speed;
			break;
	}
	glutPostRedisplay();
}

void mouse(int button, int state, int mx, int my)
{
	if (state == GLUT_DOWN)
	{
		px = mx;
		py = my;
	}
}

void mouse_move(int mx, int my)
{
	int w = glutGet(GLUT_WINDOW_WIDTH);
	int h = glutGet(GLUT_WINDOW_HEIGHT);
	x -= (double)(px-mx)/w*dim;
	y += (double)(py-my)/h*dim;
	px = mx;
	py = my;
	glutPostRedisplay();
}



void idle()
{
	// does nothing
}

static void box(double x, double y, double z, 
				double dx, double dy, double dz)
{
	glPushMatrix();
	glTranslated(x,y,z);
	glScaled(dx,dy,dz);

	glColor3f(1,0,0);
	glBegin(GL_LINE_LOOP);
	glVertex3f(-1,+1,0);
	glVertex3f(+1,+1,0);
	glVertex3f(+1,-1,0);
	glVertex3f(-1,-1,0);
	glEnd();
	glPopMatrix();
}

void plain(	double x,double y,double z,
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
	glTexCoord2f(1,0);	glVertex3f(+1,+1, 0);
	glTexCoord2f(1,1);	glVertex3f(+1,-1, 0);
	glTexCoord2f(0,1);	glVertex3f(-1,-1, 0);
	glEnd();

	//  Undo transformations
	glPopMatrix();
}

void display()
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glEnable(GL_DEPTH_TEST);

	//glLoadIdentity();
	//box(0,0,1,1,1,1);
	glEnable(GL_TEXTURE_2D);

	glBindTexture(GL_TEXTURE_2D, texture);
	glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); 
    glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR); 
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S , GL_REPEAT );
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT );
    glTexImage2D(GL_TEXTURE_2D, 0, 3, dst.cols, dst.rows, 0, 0x80E0, GL_UNSIGNED_BYTE, dst.data);
    plain(x,y,0,asp_src,1,1);
	glDisable(GL_TEXTURE_2D);
	glFlush();
	glutSwapBuffers();
}

void on_trackbar( int, void* )
{
	alpha = (double) alpha_slider/alpha_slider_max ;
	beta = ( 1.0 - alpha );

	addWeighted( src1, alpha, src2, beta, 0.0, dst);
	glutPostRedisplay();
}

int main( int argc, char **argv )
{
	//	openCV
	if(argc != 3){
		printf("Please include a image!");
		exit(1);
	}
	else{
		src1 = imread(argv[1]);
		src2 = imread(argv[2]);
	}
	if(!src1.data || !src2.data){
		printf("No data in loaded files!");
		exit(1);
	}

	asp_src = (double)src1.size().width/src1.size().height;
	src2.copyTo(dst);

	//	Create menu window
	namedWindow("Menu",CV_GUI_EXPANDED);
	resizeWindow("Menu", 300,25);
	// Create Trackbars
	char TrackbarName[50];
	snprintf( TrackbarName, 50, "Alpha %d", alpha_slider_max );
	createTrackbar( TrackbarName, "Menu", &alpha_slider, alpha_slider_max, on_trackbar );

	//	Create openGL window
	glutInit(&argc, argv);
	glutInitDisplayMode( GLUT_RGBA );
	glutInitWindowSize(500, 500);
	glutCreateWindow("Debug GUI");
	glClearColor(0.5f,0.5f,0.5f,1.0f);

	glutDisplayFunc(display);
	glutReshapeFunc(reshape);
	glutMouseFunc(mouse);
	glutMotionFunc(mouse_move);
	glutKeyboardFunc(keyboard);
	glutIdleFunc(idle);

	glutMainLoop();

	return 0;
}