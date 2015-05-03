/*
 *	Title: image_helper.h	
 *	Written by: Jamie Miller
 *	Team: Luminous Moss Boss
 *	------------------------
 *	Description: Static class for image processing.
 */
 
#ifdef FORIPHONE
  #import <opencv2/opencv.hpp>
#else
  #include <opencv/cv.h>
#endif
#include <opencv2/core/core.hpp>
using namespace cv;

class img_helper {
  private:
  public:
    static Mat resizeSetWidth(Mat image, int width);
};

