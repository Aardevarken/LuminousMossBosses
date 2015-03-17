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

+ (UIImage *) runDetectionAlgorithm:(UIImage *)unknownImage progressBar:(UIProgressView*)progressBar maxPercentToFill:(float)percentMultiplier
{
	int numberOfUpdates = 7;
	int updateNumber = 1;
	// Create mat image
	Mat cvImage;
	[progressBar setProgress:percentMultiplier*(updateNumber/numberOfUpdates++)];
	UIImageToMat(unknownImage, cvImage);
	[progressBar setProgress:percentMultiplier*(updateNumber/numberOfUpdates++)];
	// Load OpenCV classifier
	
	NSString *flowerXMLPath = [[NSBundle mainBundle] pathForResource:@"flower25" ofType:@"xml"];
	[progressBar setProgress:percentMultiplier*(updateNumber/numberOfUpdates++)];
	NSString *vocabXMLPath = [[NSBundle mainBundle] pathForResource:@"vocabulary" ofType:@"xml"];
	[progressBar setProgress:percentMultiplier*(updateNumber/numberOfUpdates++)];
	NSString *sileneXMLPath = [[NSBundle mainBundle] pathForResource:@"silene" ofType:@"xml"];
	[progressBar setProgress:percentMultiplier*(updateNumber/numberOfUpdates++)];
	
	// run detection
	detector flowerDetector([flowerXMLPath UTF8String], [vocabXMLPath UTF8String], [sileneXMLPath UTF8String]);
	[progressBar setProgress:percentMultiplier*(updateNumber/numberOfUpdates++)];
	
	// Circle flowers
	Mat detectedImage = flowerDetector.circlePinkFlowers(cvImage);
	[progressBar setProgress:percentMultiplier*(updateNumber/numberOfUpdates++)];
	
	// Convert image from Mat to UIImage and return the results
	return MatToUIImage(detectedImage);
	//return unknownImage;
}

@end
