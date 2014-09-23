/*************************************************************************
**	Author: Jacob Rail						**
**	Date created: Friday Sep 19, 2014				**
**									**
**									**
**	This program uses opencv to open an image. This program can be 	**
** used to test if opencv is installed properly. 			**
**									**
**	To compile this program use the folloing command: (Note that	**
** the ` symbol is a backtick not an aprostophe ')			**
** g++ `pkg-config --libs --cflags opencv` -o cvtest cvtest.cpp		**
**									**
**	This file was creaded by following "yash savani"'s tutorial on	**
** "Installing openCV and making your first program". The video can be	**
** found at https://www.youtube.com/watch?v=l2pjKZI73Dg.		**
*************************************************************************/

#include <cv.h>
#include <highgui.h>

// Main program
int main(int argc, char** argv){
	IplImage* image = cvLoadImage(argv[1]);	// Loads the image from the first argument into the IplImage data structure.
	cvNamedWindow("viewer");	// Creates a window named "viewer".
	cvShowImage("viewer", image);	// Shows the image variable in the viewr.
	cvWaitKey(0);	// Wait until any key is pressed.

	// Garbage collection
	cvReleaseImage(&image);
	cvDestroyWindow("viewer");

	// Exit the program successfully
	return 0;
}


// EOF
