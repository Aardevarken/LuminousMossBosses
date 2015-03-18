#ifdef FORIPHONE
  #import <opencv2/opencv.hpp>
#else
  #include <opencv/cv.h>
#endif
#include <opencv2/core/core.hpp>
#include <vector>
using namespace cv;
using namespace std;

#include "detector.h"
#include "img_helper.h"

/**
 * Constructor. This only isn't a static class so that the
 * classifier only has to be read in from disc once.
 */
detector::detector(String flower_xml, String vocab_xml, String silene_xml) {
  // Load the given flower classifier.
  if (!flower_cascade.load(flower_xml)) {
    printf("Error loading cascade file.\n");
    abort();
  };

  // Load classifier
  classifier.load(silene_xml.c_str());

  // Choose algorithms
  featureDetector = FeatureDetector::create("ORB");
  Ptr<DescriptorExtractor> extractor = new OpponentColorDescriptorExtractor(Ptr<DescriptorExtractor>(DescriptorExtractor::create("ORB")));
  Ptr<DescriptorMatcher> matcher = DescriptorMatcher::create("BruteForce");
  bowide = new BOWImgDescriptorExtractor(extractor, matcher);

  // Import vocabulary
  FileStorage vocabStore(vocab_xml, FileStorage::READ);
  Mat vocabulary;
  vocabStore["vocabulary"] >> vocabulary;
  bowide->setVocabulary(vocabulary);
}

/**
 * Makes all non-pink pixels in am image black.
 */
Mat detector::isolatePink(Mat image) {
  Mat img_hsv, mask, img_filtered;
  cvtColor(image, img_hsv, COLOR_BGR2HSV);
  inRange(img_hsv, Scalar(140, 50, 100), Scalar(200, 255, 255), mask);
  image.copyTo(img_filtered, mask);
  return img_filtered;
}

/**
 * Detect flowers
 * May miss flowers in corners while rotating image.
 */
vector<identified> detector::findFlowers(Mat image) {
  // Parameters
  const int increment = 40; // For image rotation.

  // Initialize variables.
  vector<identified> found;
  Mat rotated, temp, rotated_gray;
  double asp_src = (double)image.size().width/image.size().height;
  double centerx = image.cols/2.0;
  double centery = image.rows/2.0;
  Point2f center(centerx, centery);
  
  for (int theta=0; theta<360; theta+=increment) {
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
    for (size_t i = 0; i < flowers.size(); i++) {
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
  return found;
}


/**
 * Takes an image and returns the same image with pink flowers circled in yellow.
 */
Mat detector::circlePinkFlowers(Mat image) {
    Scalar color = Scalar(255, 255, 31);
    Mat circledImage = image;
    Mat pink = detector::isolatePink(image);
    vector<identified> flower = detector::findFlowers(pink);
    for (size_t i=0; i < flower.size(); i++) {
        circle(circledImage, Point(flower[i].get_cvx(), flower[i].get_cvy()), flower[i].get_cvr(), color, 8);
    }
    return circledImage;
}


/**
 * Bag of Words prediction.
 */
float detector::predict(Mat image) {
  // Get histogram for image
  vector<KeyPoint> keyPoints;
  Mat histogram;
  featureDetector->detect(image, keyPoints);
  bowide->compute(image, keyPoints, histogram);

  // Classify
  return classifier.predict(histogram, true);
}


/**
 * Bag of Words prediction as a normalized probability.
 */
float detector::probability(Mat image) {
    return 1.0 - 0.16*(predict(image)-0.88);
}


/**
 * True if it is silene, false if not.
 */
bool detector::isThisSilene(Mat image) {
  Mat thumbnail = img_helper::resizeSetWidth(image, 200);
  float prediction = predict(thumbnail);
  if (prediction < 0.967) {return true;}
  Mat pink = detector::isolatePink(image);
  vector<identified> flowers = detector::findFlowers(pink);
  return flowers.size() >= 1;
}
