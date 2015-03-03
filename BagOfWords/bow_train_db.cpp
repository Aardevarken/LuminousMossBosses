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

#include <mysql_connection.h>
#include <mysql_driver.h>
#include <cppconn/statement.h>

using namespace sql;
using namespace cv;
using namespace std;


int main(int argc, char** argv) {  
  vector<string> positive;
  vector<string> negative;
  vector<string> both;

  Driver* driver = get_driver_instance();
  Connection* con = driver->connect("tcp://localhost:3306", "jamie", "luciDMoss");
  Statement* stmt = con->createStatement();
  stmt->execute("USE luminous_db;");

  // Fetch positives from db.
  ResultSet* positiveResults = stmt->executeQuery("SELECT FileName, Location FROM observations WHERE UseForTraining=true AND isSilene=true;");
  while (positiveResults->next()) {
    positive.push_back("/work/pics/bow_data/" + positiveResults->getString("FileName"));
    both.push_back("/work/pics/bow_data/" + positiveResults->getString("FileName"));
  }
  delete positiveResults;

  // Fetch negatives from db.
  ResultSet* negativeResults = stmt->executeQuery("SELECT FileName, Location FROM observations WHERE UseForTraining=true AND isSilene=false;");
  while (negativeResults->next()) {
    negative.push_back("/work/pics/bow_data/" + negativeResults->getString("FileName"));
    both.push_back("/work/pics/bow_data/" + negativeResults->getString("FileName"));
  }
  delete negativeResults;
  
  delete stmt;
  delete con;
  
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
  
  
  
  
  
  
  
  
  
  
  
  
