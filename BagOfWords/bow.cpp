#include <opencv/cv.h>
#include <opencv2/core/core.hpp>
#include <opencv2/objdetect/objdetect.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/ml/ml.hpp>
#include <opencv2/nonfree/nonfree.hpp>

#include <iostream>
#include <string>
#include <vector>
#include <dirent.h>
using namespace cv;
using namespace std;


int main(int argc, char** argv) {
  // Read in input image.
  if (argc != 2) {
    cout << "Usage: bow image" << endl;
    abort();
  }
  Mat image = imread(argv[1], CV_LOAD_IMAGE_COLOR);
  
  // Resize
  //int size = 600;
  //Mat image;
  //resize(input, image, Size(size,size), double(size)/input.cols, double(size)/input.rows);
  
  // Load classifier
  CvSVM classifier;
  classifier.load("silene.xml");
  
  // Choose algorithms
  Ptr<FeatureDetector> detector = FeatureDetector::create("SURF");
  Ptr<DescriptorExtractor> extractor = new OpponentColorDescriptorExtractor(Ptr<DescriptorExtractor>(new SurfDescriptorExtractor()));
  Ptr<DescriptorMatcher> matcher = DescriptorMatcher::create("BruteForce");
  Ptr<BOWImgDescriptorExtractor> bowide(new BOWImgDescriptorExtractor(extractor, matcher));
  
  // Import vocabulary
  FileStorage vocabStore("vocabulary.xml", FileStorage::READ);
  Mat vocabulary;
  vocabStore["vocabulary"] >> vocabulary;
  bowide->setVocabulary(vocabulary);
  
  // Get histogram for image
  vector<KeyPoint> keyPoints;
  Mat histogram;
  detector->detect(image, keyPoints);
  bowide->compute(image, keyPoints, histogram);
  
  // Classify
  cout << classifier.predict(histogram, true) << endl;
  
  
  
  
  
  
}
