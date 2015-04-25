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
#import "UserDataDatabase.h"

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@implementation detectionHelper{
	//UIImage *identifiedImage;
	//	float probability;
}

@synthesize percentageComplete;
@synthesize assetID;
@synthesize positiveID;
@synthesize identifiedImage;
@synthesize probability;

- (instancetype) initWithAssetID:(NSString *)newAssetID
{
	if (self) {
		self.percentageComplete = [NSNumber numberWithFloat:-1.0];
		self.assetID = newAssetID;
		//assetID = newAssetID; // Frightningly, both these lines are necessary.
		self.positiveID = NULL;
		self.probability = [NSNumber numberWithFloat:-1.0];
		self.identifiedImage = NULL;
		//.identifiedImage = nil;
		//probability = NULL;
	}
	return self;
}

- (void) runDetectionAlgorithm:(UIImage *)unknownImage
{
	///////////////
	// test code //
	[self setValue:[NSNumber numberWithFloat:0] forKey:@"percentageComplete"];
	
	// end of test code //
	//////////////////////
	
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
	[self setValue:newImage forKey:@"identifiedImage"];
	
	/////////////
	// stage 2 //
	Mat cvImageBGR;
	cvtColor(cvImage, cvImageBGR, CV_BGR2RGB);
	[self setValue:[NSNumber numberWithFloat:flowerDetector.probability(cvImageBGR)] forKey:@"probability"];
	
	/////////////
	// stage 3 //
	//UIImageToMat(unknownImage, cvImage);
	[self setValue:[NSNumber numberWithFloat:flowerDetector.isThisSilene(cvImageBGR)] forKey:@"positiveID"];
	
	/////////////
	// stage 4 //
	
	
    [self lastCallIn:0];
}

- (void)lastCallIn:(int)sleepFor {
	
	/****
	ALog(@"Resuming in %d...", sleepFor);
	printf("\n%s [Line %d] Resuming in ", __PRETTY_FUNCTION__, __LINE__);
	for (int zzz = 0; zzz < sleepFor; ++zzz){
		sleep(1);
		printf("%d...",sleepFor - zzz);
	}
	
	printf("Done \n\n");
	****/
	
    // update the table row
    // prep variables
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setMaximumFractionDigits:2];
    float newprob = floorf([[self probability] floatValue]*100);
    NSNumber *NSnewprob = [NSNumber  numberWithFloat:newprob];
	
	NSString *newState = @"pending-id";
	// NSString *oldState = @"pending-noid";
    
    // update row variables
    NSString* isSileneString;
    if (self.positiveID) {
        isSileneString = @"yes";
    } else {
        isSileneString = @"no";
    }
	BOOL success = [[UserDataDatabase getSharedInstance]
                    updateObservation:[self assetID] andNewPercentIDed:NSnewprob andNewStatus:newState isSilene: isSileneString];
    
    // Did it all work? Inform the UI
    if (success) {
        [self setValue:[NSNumber numberWithFloat:1] forKey:@"percentageComplete"];
    } else {
        ALog("Database update failed after identification.");
        [self setValue:[NSNumber numberWithFloat:-1] forKey:@"percentageComplete"];
    }

}

@end
