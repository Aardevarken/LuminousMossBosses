#include <stdio.h>
#include "opencv2/opencv.hpp"

using namespace cv;

int main() 
{
	VideoCapture cap(0);

	if(!cap.isOpened()){
		printf("Failed to open Camera");
		exit(1);
	}

	Mat edges;
	namedWindow("Camera", CV_WINDOW_KEEPRATIO);
	int docanny = 0;
	int doblur = 0;
	while(true){
		Mat frame;
		cap >> frame;
		cvtColor(frame, edges, CV_BGR2GRAY);
		if (doblur)
			GaussianBlur(edges, edges, Size(7,7),1.5,1.5);
		if (docanny)
			Canny(edges, edges, 0, 30, 3);
		imshow("Camera", edges);
		int key = cvWaitKey(30);
		if (key == 32) break;
		if (key == 49) docanny = !docanny;
		if (key == 50) doblur = !doblur;
		//if(waitKey(33)) break;
		//if(waitKey(49) == 0) docanny = !docanny;
	}
	return 0;
}