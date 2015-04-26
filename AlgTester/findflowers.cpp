#include <opencv/cv.h>
#include <opencv2/core/core.hpp>
#include <opencv2/objdetect/objdetect.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

#include <iostream>
#include <string>
#include <vector>
using namespace cv;
using namespace std;

#include "detector.h"

int main(int argc, char** argv) {
  detector sileneDetector("flower.xml",  "../BagOfWords/vocabulary.xml", "../BagOfWords/silene.xml");
  if (argc != 2) {
    cout << "Usage: find_flowers image" << endl;
    abort();
  }
  Mat image = imread(argv[1], CV_LOAD_IMAGE_COLOR);
  Mat pink = sileneDetector.isolatePink(image);
  vector<identified> flowers = sileneDetector.findFlowers(pink);
  for (size_t i=0; i<flowers.size(); i++) {
    // Output x y r for each flower on a separate line.
    cout << flowers[i].get_cvx() << " " << flowers[i].get_cvy() << " " << flowers[i].get_cvr() << endl;
  }
}