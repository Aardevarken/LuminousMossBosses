/*
 *	Title: detector.h	
 *	Written by: Jamie Miller
 *	Team: Luminous Moss Boss
 *	------------------------
 *	Description: Static class for detection algorithms.
 */
 
#ifndef __DETECTOR__
 
class detector {
  public:
    static Mat isolatePink(Mat image);
    static vector<identified> findFlowers(Mat image);
    static bool isThisSilene(Mat image);
};
 
#endif
