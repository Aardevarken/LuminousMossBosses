/*****************************************************************
**	Author: Jacob Rail					**
**	Created: Sat Sep 20, 2014				**
**								**
**	This program is based of off the edge detection		**
** tutorial from:						**
** http://dasl.mem.drexel.edu/~noahKuntz/openCVTut5.html	**
*****************************************************************/

#import "cv.h"
#import "highgui.h"

int high_switch_value = 0;
int highInt = 0;
int low_switch_value = 0;
int lowInt = 0;

void switch_callback_h( int position ){
	highInt = position;
}
void switch_callback_l( int position ){
	lowInt = position;
}

int main(int argc, char* argv[])
{
	const char* name = "Edge Detection Window";

	// Kernel size
	int N = 7;

	// Set up image(s)
	IplImage* org_img = cvLoadImage( argv[1], 0 );
	
	IplImage* img = cvCreateImage(cvSize(512,512),org_img->depth, org_img->nChannels);
	cvResize(org_img, img);

	IplImage* img_b = cvCreateImage( cvSize(img->width+N-1,img->height+N-1), img->depth, img->nChannels );
	IplImage* out = cvCreateImage( cvGetSize(img_b), IPL_DEPTH_8U, img_b->nChannels );

	// Add convolution boarders
	CvPoint offset = cvPoint((N-1)/2,(N-1)/2);
	cvCopyMakeBorder(img, img_b, offset, IPL_BORDER_REPLICATE, cvScalarAll(0));

	// Make window
	cvNamedWindow( name, 1 );
	
	// Edge Detection Variables
	int aperature_size = N;
	double lowThresh = 20;
	double highThresh = 40;

	// Create trackbars
	cvCreateTrackbar( "High", name, &high_switch_value, 4, switch_callback_h );
	cvCreateTrackbar( "Low", name, &low_switch_value, 4, switch_callback_l );

	while( 1 ) {
		switch( highInt ){
			case 0:
				highThresh = 200;
				break;
			case 1:
				highThresh = 400;
				break;
			case 2:
				highThresh = 600;
				break;
			case 3:
				highThresh = 800;
				break;
			case 4:
				highThresh = 1000;
				break;
		}
		switch( lowInt ){
			case 0:
				lowThresh = 0;
				break;
			case 1:
				lowThresh = 100;
				break;
			case 2:
				lowThresh = 200;
				break;
			case 3:
				lowThresh = 400;
				break;
			case 4:
				lowThresh = 600;
				break;
		}

		// Edge Detection
		cvCanny( img_b, out, lowThresh*N*N, highThresh*N*N, aperature_size );		
		cvShowImage(name, out);
		
		if( cvWaitKey( 15 ) == 27 ) 
			break;
	}

	// Release
	cvReleaseImage( &img );
	cvReleaseImage( &img_b );
	cvReleaseImage( &out );
	cvDestroyWindow( name );

	return 0;
}

