#include <opencv/cv.h>
#include <opencv2/core/core.hpp>
#include <opencv2/objdetect/objdetect.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/ml/ml.hpp>

#include <iostream>
#include <string>
#include <vector>
#include <dirent.h>

#include <mysql_connection.h>
#include <mysql_driver.h>
#include <cppconn/statement.h>

using namespace sql;
using namespace cv;
using namespace std;

#include "../AlgTester/img_helper.cpp"


// Global variables to make things easier.
Ptr<FeatureDetector> detector;
Ptr<BOWImgDescriptorExtractor> bowide;
CvSVM classifier;

/**
 * Given an image filename, will attempt to predict it's classification.
 */
float predict(String imageFile) {
  Mat image = img_helper::resizeSetWidth(imread(imageFile, CV_LOAD_IMAGE_COLOR), 200);

  // Get histogram for image
  vector<KeyPoint> keyPoints;
  Mat histogram;
  detector->detect(image, keyPoints);
  bowide->compute(image, keyPoints, histogram);

  // Classify
  return classifier.predict(histogram, true);
}

int main(int argc, char** argv) {
  vector<string> positive;
  vector<string> negative;
  vector<string> both;

  Driver* driver = get_driver_instance();
  Connection* con = driver->connect("tcp://localhost:3306", "jamie", "luciDMoss");
  Statement* stmt = con->createStatement();
  stmt->execute("USE luminous_db;");

  // Fetch positives from db.
  ResultSet* positiveResults = stmt->executeQuery("SELECT FileName, Location FROM observations WHERE UseForTraining=false AND isSilene=true;");
  while (positiveResults->next()) {
    positive.push_back(positiveResults->getString("Location") + "/" + positiveResults->getString("FileName"));
    both.push_back(positiveResults->getString("Location") + "/" + positiveResults->getString("FileName"));
  }
  delete positiveResults;

  // Fetch negatives from db.
  ResultSet* negativeResults = stmt->executeQuery("SELECT FileName, Location FROM observations WHERE UseForTraining=false AND isSilene=false;");
  while (negativeResults->next()) {
    negative.push_back(negativeResults->getString("Location") + "/" + negativeResults->getString("FileName"));
    both.push_back(negativeResults->getString("Location") + "/" + negativeResults->getString("FileName"));
  }
  delete negativeResults;
  
  delete stmt;
  delete con;
  
  // Load classifier
  classifier.load("silene.xml");
  
  // Choose algorithms
  detector = FeatureDetector::create("ORB");
  Ptr<DescriptorExtractor> extractor = new OpponentColorDescriptorExtractor(Ptr<DescriptorExtractor>(DescriptorExtractor::create("ORB")));
  Ptr<DescriptorMatcher> matcher = DescriptorMatcher::create("BruteForce");
  bowide = new BOWImgDescriptorExtractor(extractor, matcher);
  
  // Import vocabulary
  FileStorage vocabStore("vocabulary.xml", FileStorage::READ);
  Mat vocabulary;
  vocabStore["vocabulary"] >> vocabulary;
  bowide->setVocabulary(vocabulary);
  
  // Print test results.
  cout << "Silene" << endl;
  for (size_t i=0; i<positive.size(); i++) {
    cout << predict(positive[i]) << endl;
  }
  
  cout << "NotSilene" << endl;
  for (size_t i=0; i<negative.size(); i++) {
    cout << predict(negative[i]) << endl;
  }
  
  cout << "Finished" << endl;
}
