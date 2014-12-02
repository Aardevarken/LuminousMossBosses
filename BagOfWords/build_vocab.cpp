#include <opencv/cv.h>
#include <opencv2/core/core.hpp>
#include <opencv2/objdetect/objdetect.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
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
  
  // Get descriptors for all features in all images.
  Mat allDescriptors(1, extractor->descriptorSize(), CV_32F);
  for (size_t i=0; i<both.size(); i++) {
    vector<KeyPoint> keyPoints;
    Mat descriptors;
    Mat img = imread(both[i]);
    detector->detect(img, keyPoints);
    extractor->compute(img, keyPoints, descriptors);
    descriptors.convertTo(descriptors, CV_32F);
    allDescriptors.push_back(descriptors);
  }
  
  // Cluster features into groups, called "words"
  BOWKMeansTrainer bowtrainer(1500); //num clusters
  bowtrainer.add(allDescriptors);
  Mat vocabulary = bowtrainer.cluster();
  
  // Save to xml file
  FileStorage vocabStore("vocabulary.xml", FileStorage::WRITE);
  vocabStore << "vocabulary" << vocabulary;
  return 0;
}
  
