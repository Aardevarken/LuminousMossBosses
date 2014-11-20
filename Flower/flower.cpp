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

  int num_found = 0;
  Mat rotated, temp, rotated_gray;
  int line_thickness = 4;
  
  double centerx = image.cols/2.0;
  double centery = image.rows/2.0;
  Point2f center(centerx, centery);
  namedWindow("Flower Detection", CV_WINDOW_KEEPRATIO);
  for (int theta=0; theta<360; theta+=10) {
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
    for(size_t i = 0; i < flowers.size(); i++) {
      double rotated_locationx = flowers[i].x + flowers[i].width*0.5;
      double rotated_locationy = flowers[i].y + flowers[i].height*0.5;
      Point rotated_location(rotated_locationx, rotated_locationy);
      double dx = rotated_locationx - centerx;
      double dy = rotated_locationy - centery;
      double alpha = theta * M_PI/180.0;
      double beta = atan2(dy, dx);
      double distance = sqrt(dx*dx + dy*dy);
      Point location(centerx + distance * cos(beta - alpha),
                     centery + distance * sin(beta - alpha));
      int radius = max(flowers[i].width*0.5, flowers[i].height*0.5);
      //circle(rotated, rotated_location, radius, Scalar(255, 0, 0), line_thickness);
      circle(image, location, radius, Scalar(0, 0, 255), line_thickness);
    }
    //imshow("Flower Detection", rotated);
    //waitKey(0);
  }

  /////

  //namedWindow("Flower Detection", CV_WINDOW_KEEPRATIO);
  imshow("Flower Detection", image);
  waitKey(0);

  cout << "Found " << num_found << " flowers." << endl;

  return 0;
}
