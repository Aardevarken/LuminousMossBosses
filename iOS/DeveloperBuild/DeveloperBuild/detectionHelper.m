//
//  detectionHelper.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 3/14/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "detectionHelper.h"
#import "detector.h"
#import "opencv2/highgui/ios.h"

@implementation detectionHelper

+ (UIImage *) runDetectionAlgorithm:(UIImage *)unknownImage
{
	// Create mat image
	Mat cvImage;
	UIImageToMat(unknownImage, cvImage);
	
	// Load OpenCV classifier
	
	NSString *flowerXMLPath = [[NSBundle mainBundle] pathForResource:@"flower25" ofType:@"xml"];
	NSString *vocabXMLPath = [[NSBundle mainBundle] pathForResource:@"vocabulary" ofType:@"xml"];
	NSString *sileneXMLPath = [[NSBundle mainBundle] pathForResource:@"silene" ofType:@"xml"];
	
	// run detection
	detector flowerDetector([flowerXMLPath UTF8String], [vocabXMLPath UTF8String], [sileneXMLPath UTF8String]);
	
	// Circle flowers
	Mat detectedImage = flowerDetector.circlePinkFlowers(cvImage);
	
	// Convert image from Mat to UIImage and return the results
	return MatToUIImage(detectedImage);
	//return unknownImage;
}

@end
