#include <opencv/cv.h>
#include <opencv2/core/core.hpp>
#include <vector>
using namespace cv;
using namespace std;

#include "identified.h"
#include "detector.h"

/*
 * Makes all non-pink pixels in am image black.
 */
Mat detector::isolatePink(Mat image) {
  Mat img_hsv;
  cvtColor(image, img_hsv, COLOR_BGR2HSV);
  Mat image3;
  inRange(img_hsv, Scalar(140, 50, 100), Scalar(200, 255, 255), image3);
  Mat image3_color, image3RGB;
  cvtColor(image3, image3RGB, COLOR_GRAY2RGB);
  bitwise_and(image3RGB, image, image3_color);
  return image3_color;
}

/*
 * Show Progress for debugging.
 * Displays the percentage of a current running process
 */
void showProgress(int i, int total)
{
  int percent = floor((float)i/total*100);
  int amount = percent/10;
  cout << "\r" << percent << "% complete [";
  cout << string(amount, '|') << string(10-amount,'-') << "]";
  cout.flush();
}

/*
 * Detect flowers
 */
vector<identified> detector::findFlowers(Mat image) {
  // Parameters
  const int increment = 40; // For image rotation.

  // Initialize classifier
  String flower_cascade_name = "flower.xml";
  CascadeClassifier flower_cascade;
  if (!flower_cascade.load(flower_cascade_name)) {
    printf("Error loading cascafe file.\n");
    abort();
  };

  // Initialize variables.
  vector<identified> found;
  Mat rotated, temp, rotated_gray;
  double asp_src = (double)image.size().width/image.size().height;
  double centerx = image.cols/2.0;
  double centery = image.rows/2.0;
  Point2f center(centerx, centery);
  
  //cout << "Processing\n";
  for (int theta=0; theta<360; theta+=increment) {
    //showProgress(theta, 360);
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

    // Convert detections to nonrotated coordinates.
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
      if (!found.empty()){
        for(size_t j = 0; j < found.size(); j++){
          if( radius/2 >= abs( location.x-found[j].get_cvx() ) && 
              radius/2 >= abs( location.y-found[j].get_cvy() ) ){
            inlist = 1;
            break;
          }
        }
      }
      if (!inlist)
      {
        identified tempid(location.x, location.y, radius, true, image.cols, image.rows, asp_src);
        found.push_back(tempid);
      }
    }
  }
  //showProgress(100,100);
  //cout << endl;
  return found;
}


/*
 * True if it is silene, false if not.
 */
bool detector::isThisSilene(Mat image) {
  Mat pink = detector::isolatePink(image);
  vector<identified> flowers = detector::findFlowers(pink);
  return flowers.size() >= 1;
}
