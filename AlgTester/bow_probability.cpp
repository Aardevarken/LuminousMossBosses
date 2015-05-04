#include <opencv/cv.h>
#include <opencv2/core/core.hpp>
#include <opencv2/objdetect/objdetect.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#include <iostream>
#include <string>
#include <vector>
#include <dirent.h>
using namespace cv;
using namespace std;

#include "detector.h"

int main(int argc, char** argv) {
        detector sileneDetector("/home/ubuntu/LuminousMossBosses/AlgTester/flower.xml",  "/home/ubuntu/LuminousMossBosses/BagOfWords/vocabulary.xml", "/home/ubuntu/LuminousMossBosses/BagOfWords/silene.xml");
//	detector sileneDetector("flower.xml",  "../BagOfWords/vocabulary.xml", "../BagOfWords/silene.xml");
	if (argc != 2) {
		cout << "Usage: bow_probability IMAGE_PATH\n";
		abort();
	}
	Mat image = imread(argv[1], CV_LOAD_IMAGE_COLOR);
	cout << sileneDetector.probability(image) << endl;
}
