#include <opencv/cv.h>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>

#include <iostream>
#include <string>
#include <vector>
#include <dirent.h>
#include <iostream>
#include <fstream>

#include <mysql_connection.h>
#include <mysql_driver.h>
#include <cppconn/statement.h>

using namespace sql;
using namespace cv;
using namespace std;

int main(int argc, char** argv) {
  vector<string> positive;
  vector<string> negative;

  Driver* driver = get_driver_instance();
  Connection* con = driver->connect("tcp://localhost:3306", "jamie", "luciDMoss");
  Statement* stmt = con->createStatement();
  stmt->execute("USE luminous_db;");

  // Fetch positives from db.
  ResultSet* positiveResults = stmt->executeQuery("SELECT r.Location AS Location, r.Filename AS Filename FROM rotation_objects AS r LEFT JOIN detection_objects AS d ON d.ObjectID = r.ParentDetectionObjectID WHERE d.IsPosDetect=true AND r.Location IS NOT Null AND r.Filename IS NOT Null;");
  while (positiveResults->next()) {
    positive.push_back(positiveResults->getString("Location") + "/" + positiveResults->getString("FileName"));
  }
  delete positiveResults;

  // Fetch negatives from db.
  ResultSet* negativeResults = stmt->executeQuery("SELECT FileName, Location FROM detection_objects WHERE IsPosDetect=false AND Filename IS NOT NULL AND Location IS NOT NULL;");
  while (negativeResults->next()) {
    negative.push_back(negativeResults->getString("Location") + "/" + negativeResults->getString("FileName"));
  }
  delete negativeResults;
  
  delete stmt;
  delete con;
  
  // Print manifest files.
  fstream positive_manifest;
  positive_manifest.open("positive.manifest", fstream::out | fstream::app);
  for (size_t i=0; i<positive.size(); i++) {
    string name = positive[i];
    Mat image = imread(name);
    int width = image.cols;
    int height = image.rows;
    positive_manifest << name << " 1 0 0 " << width << " " << height << endl;
  }
  positive_manifest.close();
  
  fstream background_manifest;
  background_manifest.open("background.manifest", fstream::out | fstream::app);
  for (size_t i=0; i<negative.size(); i++) {
    background_manifest << negative[i] << endl;
  }
  background_manifest.close();
}
