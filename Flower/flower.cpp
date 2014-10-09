#include <opencv/cv.h>
#include <opencv2/core/core.hpp>
#include <opencv2/objdetect/objdetect.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <iostream>
using namespace cv;
using namespace std;

String flower_cascade_name = "flower.xml";
CascadeClassifier flower_cascade;

int main(int argc, char** argv) {
  if (argc != 2) {
    cout <<" Usage: display_image ImageToLoadAndDisplay" << endl;
    return -1;
  }

  if (!flower_cascade.load(flower_cascade_name)) {
    cout << "Error loading cascafe file." << endl;
    return -1;
  };

  Mat image;
  image = imread(argv[1], CV_LOAD_IMAGE_COLOR);

  if (!image.data) {
    cout << "Could not open or find the image" << endl;
    return -1;
  }

  /////

  Mat image_gray;
  cvtColor(image, image_gray, CV_BGR2GRAY);
  equalizeHist(image_gray, image_gray);

  vector<Rect> flowers;
  flower_cascade.detectMultiScale(image_gray, flowers);
  
  for(size_t i = 0; i < flowers.size(); i++) {
    Point center(flowers[i].x + flowers[i].width*0.5, flowers[i].y + flowers[i].height*0.5);
    ellipse(image, center, Size(flowers[i].width*0.5, flowers[i].height*0.5), 0, 0, 360, Scalar(255, 0, 0), 4);
  }

  /////

  namedWindow("Flower Detection", CV_WINDOW_KEEPRATIO);
  imshow("Flower Detection", image);
  waitKey(0);

  cout << "Found " << flowers.size() << " flowers." << endl;

  return 0;
}
