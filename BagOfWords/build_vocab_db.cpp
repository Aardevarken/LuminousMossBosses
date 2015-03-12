#include <opencv/cv.h>
#include <opencv2/core/core.hpp>
#include <opencv2/objdetect/objdetect.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

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

#include "../AlgTester/img_helper.h"


int main(int argc, char** argv) {  
  vector<string> both;

  Driver* driver = get_driver_instance();
  Connection* con = driver->connect("tcp://localhost:3306", "jamie", "luciDMoss");
  Statement* stmt = con->createStatement();
  stmt->execute("USE luminous_db;");

  // Fetch training images from db.
  ResultSet* trainingResults = stmt->executeQuery("SELECT FileName, Location FROM observations WHERE UseForTraining=true;");
  while (trainingResults->next()) {
    both.push_back(trainingResults->getString("Location") + "/" + trainingResults->getString("FileName"));
  }
  delete trainingResults;
  
  delete stmt;
  delete con;
  
  // Choose algorithms
  Ptr<FeatureDetector> detector = FeatureDetector::create("ORB");
  Ptr<DescriptorExtractor> extractor = new OpponentColorDescriptorExtractor(Ptr<DescriptorExtractor>(DescriptorExtractor::create("ORB")));
  
  // Get descriptors for all features in all images.
  Mat allDescriptors(1, extractor->descriptorSize(), CV_32F);
  for (size_t i=0; i<both.size(); i++) {
    vector<KeyPoint> keyPoints;
    Mat descriptors;
    Mat img = img_helper::resizeSetWidth(imread(both[i]), 200);
    detector->detect(img, keyPoints);
    extractor->compute(img, keyPoints, descriptors);
    descriptors.convertTo(descriptors, CV_32F);
    allDescriptors.push_back(descriptors);
  }
  
  // Cluster features into groups, called "words"
  BOWKMeansTrainer bowtrainer(1500); //num clusters
  bowtrainer.add(allDescriptors);
  Mat floatVocabulary = bowtrainer.cluster();
  Mat vocabulary;
  floatVocabulary.convertTo(vocabulary, CV_8UC1);
  
  // Save to xml file
  FileStorage vocabStore("vocabulary.xml", FileStorage::WRITE);
  vocabStore << "vocabulary" << vocabulary;
  return 0;
}
  
