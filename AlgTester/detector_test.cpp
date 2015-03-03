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
  detector sileneDetector("flower.xml", "../BagOfWords/vocabulary.xml", "../BagOfWords/silene.xml");

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

  while (dirent* file=readdir(test_samples_positive)) {
    if (file->d_type == 0x8) { // 0x8 refers to file, as opposed to directory or link
      positive.push_back(positive_dir + "/" + file->d_name);
    }
  }

  while (dirent* file=readdir(test_samples_negative)) {
    if (file->d_type == 0x8) {
      negative.push_back(negative_dir + "/" + file->d_name);
    }
  }
  
  // Initialize some variables for statistics later.
  int total = positive.size() + negative.size();
  int expected_positive = positive.size();
  int expected_negative = negative.size();
  int actual_positive = 0;
  int actual_negative = 0;
  int false_positive = 0;
  int false_negative = 0;
  
  for (int i=0; i<positive.size(); i++) {
    cout << positive[i] << endl;
    Mat image = imread(positive[i], CV_LOAD_IMAGE_COLOR);
    
    if (sileneDetector.isThisSilene(image)) {
      actual_positive += 1;
    } else {
      cout << "False negative: " << positive[i] << endl;
      false_negative += 1;
    }
    cout << "-------------------------" << endl;
  }

  for (int i=0; i<negative.size(); i++) {
    cout << negative[i] << endl;
    Mat image = imread(negative[i], CV_LOAD_IMAGE_COLOR);
    if (sileneDetector.isThisSilene(image)) {
      cout << "False positive: " << negative[i] << endl;
      false_positive += 1;
    } else {
      actual_negative += 1;
    }
    cout << "-------------------------" << endl;
  }
  
  int correct = actual_positive + actual_negative;
  int incorrect = false_positive + false_negative;
  
  cout << "Correctly identified: " << double(correct)/total << endl;
  cout << "False Positives: " << double(false_positive)/total << endl;
  cout << "False Negatives: " << double(false_negative)/total << endl;

  closedir(test_samples_positive);
  closedir(test_samples_negative);
}
