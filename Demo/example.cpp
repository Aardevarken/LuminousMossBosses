#ifdef __APPLE__
	#include <cv.h>
	#include <highgui.h>
	#include <imgproc.h>
#else
	#include <opencv/cv.h>
	#include <opencv/highgui.h>
	#include <opencv2/core/core.hpp>
	#include <opencv2/highgui/highgui.hpp>
	#include <opencv2/imgproc/imgproc.hpp>
#endif
#include <iostream>

using namespace cv;
using namespace std;

int highInt=0;
int lowInt=0;
int high_switch_value=0;
int low_switch_value=0;

void switch_callback_h( int position ){
	highInt = position;
}
void switch_callback_l( int position ){
	lowInt = position;
}

int main(int argc, char** argv) {
  if (argc != 2) {
    cout <<" Usage: display_image ImageToLoadAndDisplay" << endl;
    return -1;
  }

  Mat image;
  image = imread(argv[1], CV_LOAD_IMAGE_COLOR);

  if (!image.data) {
    cout <<  "Could not open or find the image" << std::endl ;
    return -1;
  }

  Mat img_hsv;
  cvtColor(image, img_hsv, COLOR_BGR2HSV);
  Mat image3;
  inRange(img_hsv, Scalar(140, 50, 100), Scalar(200, 255, 255), image3);
  Mat dst, image3_color;
  cvtColor(image3, image3_color, COLOR_GRAY2RGB);
  //addWeighted(image3_color, 0.8, image, 0.2, 0.0, dst);
  bitwise_and(image3_color, image, dst);

  Mat image2;
  inRange(image, Scalar(230, 150, 230), Scalar(270, 200, 270), image2);
  //inRange(image, Scalar(30, 40, 0), Scalar(170, 150, 50), image2);
  //inRange(image, Scalar(0, 40, 30), Scalar(50, 150, 170), image2);

  //Mat dst, image3_color;
  //cvtColor(image2, image3_color, COLOR_GRAY2RGB);
  //addWeighted(image3_color, 0.8, image, 0.2, 0.0, dst);
  
  
  Mat dstCon;
  dst.convertTo(dstCon, -1, 2, 0);
  
  // Edge Detection Variables
  int N = 7;
	int aperature_size = N;
	double lowThresh = 600;//20
	double highThresh = 800;//40
  // Edge Detection
  Mat lines;
  Canny(dstCon, lines, lowThresh*N*N, highThresh*N*N, aperature_size, false);		
/*
	// Create trackbars
	cvCreateTrackbar( "High", "Display window", &high_switch_value, 9, switch_callback_h );
	cvCreateTrackbar( "Low", "Display window", &low_switch_value, 6, switch_callback_l );

  // Add convolution boarders
	Point offset = cvPoint((N-1)/2,(N-1)/2);
	Mat lines_b;
	copyMakeBorder(lines, lines_b, offset, IPL_BORDER_REPLICATE, cvScalarAll(0));

  cvNamedWindow("Display window", CV_WINDOW_KEEPRATIO);
  imshow("Display window", lines_b);
  waitKey(0);
*/
	/*while( 1 ) {
		switch( highInt ){
			case 0:
				highThresh = 100;
				break;
			case 1:
				highThresh = 200;
				break;
			case 2:
				highThresh = 300;
				break;
			case 3:
				highThresh = 400;
				break;
			case 4:
				highThresh = 500;
				break;
			case 5:
				highThresh = 600;
				break;
			case 6:
				highThresh = 700;
				break;
			case 7:
				highThresh = 800;
				break;
			case 8:
				highThresh = 900;
				break;
			case 9:
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
				lowThresh = 300;
				break;
			case 4:
				lowThresh = 400;
				break;
			case 5:
				lowThresh = 500;
				break;
			case 6:
				lowThresh = 600;
				break;
		}
  }*/

  namedWindow("Display window", CV_WINDOW_KEEPRATIO);
  //while(true) {
    imshow("Display window", image);
    waitKey(0);
    imshow("Display window", img_hsv);
    waitKey(0);
    imshow("Display window", image3);
    waitKey(0);
    imshow("Display window", dst);
    waitKey(0);
    imshow("Display window", dstCon);
    waitKey(0);
    imshow("Display window", lines);
    waitKey(0);
  //}

  return 0;
}
