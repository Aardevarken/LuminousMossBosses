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
  // Read in input files.
  if (argc != 3) {
    cout << "Usage: test positivedir negativedir" << endl;
    abort();
  }
  string positive_dir = argv[1];
  string negative_dir = argv[2];

  DIR* test_samples_positive = opendir(argv[1]);
  DIR* test_samples_negative = opendir(argv[2]);
  
  vector<string> positive;
  vector<string> negative;
  vector<string> both;

  while (dirent* file=readdir(test_samples_positive)) {
    if (file->d_type == 0x8) { // 0x8 refers to file, as opposed to directory or link
      positive.push_back(positive_dir + "/" + file->d_name);
      both.push_back(positive_dir + "/" + file->d_name);
    }
  }

  while (dirent* file=readdir(test_samples_negative)) {
    if (file->d_type == 0x8) {
      negative.push_back(negative_dir + "/" + file->d_name);
      both.push_back(negative_dir + "/" + file->d_name);
    }
  }
  
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

  // Get training data
  Mat samples(0, vocabulary.rows, CV_32F); // histograms of words from images
  Mat labels; // 1 is silene, 0 is not. Index must match with samples.
  for (size_t i=0; i<both.size(); i++) {
    vector<KeyPoint> keyPoints;
    Mat img, histogram;
    
    // Get histogram.
    img = imread(both[i]);
    detector->detect(img, keyPoints);
    bowide->compute(img, keyPoints, histogram);
    
    // Add histogram to silene data.
    samples.push_back(histogram);
    if (i < positive.size()) {
      labels.push_back(1);
    } else {
      labels.push_back(0);
    }
  }

  // Actually do the training
  CvSVM classifier; 
  classifier.train(samples, labels);
  
  // Save to xml file
  classifier.save("silene.xml");
  return 0;
}
  
  
  
  
  
  
  
  
  
  
  
  
