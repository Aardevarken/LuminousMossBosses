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

@implementation detectionHelper{
	float progressBarPercentage;
	NSString *assetID;
	UIImage *identifiedImage;
	BOOL isSilene;
	float probability;
}

- (instancetype) initWithAssetID:(NSString *)newAssetID
{
	if (self) {
		self.percentageComplete = [NSNumber numberWithFloat:-1.0];
		self.pAssetID = newAssetID;
		
		progressBarPercentage = 0;
		assetID = newAssetID;
		identifiedImage = nil;
		probability = NULL;
		isSilene = NULL;
	}
	return self;
}

- (float) getCurrentProgress
{
	return progressBarPercentage;
}

- (UIImage *) getIdentifiedImage
{
	return identifiedImage;
}

- (float) getIDProbability
{
	return probability;
}

- (void) updatePercentCompleated:(float)updatePercentage
{
	progressBarPercentage = updatePercentage;
}

- (BOOL) getIsSilene
{
	return isSilene;
}

- (void) runDetectionAlgorithm:(UIImage *)unknownImage
{
	///////////////
	// test code //
	[self setValue:[NSNumber numberWithFloat:0] forKey:@"percentageComplete"];
	
	// end of test code //
	//////////////////////
	
	
	// Some house cleaning before we begin. Before the thread is called to run the
	// the ientification, all variables associated with the identification should be
	// reinitialized.
	identifiedImage = nil;		// might be bad practice to do this
	isSilene = NULL;			// same as probability
	
	//////////////////////
	// stage 0: Preping //
	Mat cvImage;
	// By default all images saved to the gallery on iPhone are landscape with a field in the EXIF data specifying if it is actually portrait. This will remove that orientation field from the EXIF data and rotate the physical pixels, making it easier to convert back and forth to a Mat.
	UIImage* normalizedImage;
	if (unknownImage.imageOrientation == UIImageOrientationUp) {
		normalizedImage = unknownImage;
	} else {
		UIGraphicsBeginImageContextWithOptions(unknownImage.size, NO, unknownImage.scale);
		[unknownImage drawInRect:(CGRect){0, 0, unknownImage.size}];
		normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	UIImageToMat(normalizedImage, cvImage);

	// Load openCV classifiers
	NSString *flowerXMLPath = [[NSBundle mainBundle] pathForResource:@"flower25" ofType:@"xml"];
	NSString *vocabXMLPath = [[NSBundle mainBundle] pathForResource:@"vocabulary" ofType:@"xml"];
	NSString *sileneXMLPath = [[NSBundle mainBundle] pathForResource:@"silene" ofType:@"xml"];
	
	/////////////
	// stage 1 //
	// run detection
	detector flowerDetector([flowerXMLPath UTF8String], [vocabXMLPath UTF8String], [sileneXMLPath UTF8String]);
	
	// circle flowers
	Mat detectedImage = flowerDetector.circlePinkFlowers(cvImage);
	
	// convert image to UIImage
	UIImage* newImage = MatToUIImage(detectedImage);
	identifiedImage = newImage;
	
	/////////////
	// stage 2 //
	Mat cvImageBGR;
	cvtColor(cvImage, cvImageBGR, CV_BGR2RGB);
	probability = flowerDetector.probability(cvImageBGR);
	
	/////////////
	// stage 3 //
	//UIImageToMat(unknownImage, cvImage);
	isSilene = flowerDetector.isThisSilene(cvImageBGR);
	

	/////////////
	// stage 4 //
	sleep(5);
	[self setValue:[NSNumber numberWithFloat:1] forKey:@"percentageComplete"];
}

@end
