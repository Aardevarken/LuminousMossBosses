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

#include "detector.h"

int main(int argc, char** argv) {
  detector sileneDetector = detector("flower.xml");

  vector<string> positive;
  vector<string> negative;

  Driver* driver = get_driver_instance();
  Connection* con = driver->connect("tcp://localhost:3306", "jamie", "luciDMoss");
  Statement* stmt = con->createStatement();
  stmt->execute("USE luminous_db;");

  // Fetch positives from db.
  ResultSet* positiveResults = stmt->executeQuery("SELECT FileName, Location FROM observations WHERE UseForTraining=false AND isSilene=true;");
  while (positiveResults->next()) {
    positive.push_back(positiveResults->getString("Location") + "/" + positiveResults->getString("FileName"));
  }
  delete positiveResults;

  // Fetch negatives from db.
  ResultSet* negativeResults = stmt->executeQuery("SELECT FileName, Location FROM observations WHERE UseForTraining=false AND isSilene=false;");
  while (negativeResults->next()) {
    negative.push_back(negativeResults->getString("Location") + "/" + negativeResults->getString("FileName"));
  }
  delete negativeResults;

  
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
  
  cout << "total: " << total << endl;
  cout << "expected_positive: " << expected_positive << endl;
  cout << "expected_negative: " << expected_negative << endl;
  cout << "actual_positive: " << actual_positive << endl;
  cout << "actual_negative: " << actual_negative << endl;
  cout << "false_positive: " << false_positive << endl;
  cout << "false_negative: " << false_negative << endl;
  cout << "correct: " << correct << endl;
  cout << "incorrect: " << incorrect << endl;

  //cout << "Correctly identified: " << correct << " " << double(correct)/total << endl;
  //cout << "False Positives: " << false_positive << " " << double(false_positive)/total << endl;
  //cout << "False Negatives: " << false_negative << " " << double(false_negative)/total << endl;
  //cout << "Percent of NotSilene incorrectly identified: " << double(false_positive)/expected_positive << endl;
  //cout << "Percent of Silene incorrectly identified: " << double(false_negative)/expected_negative << endl;

  delete stmt;
  delete con;
}
