//
//  ViewController.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 1/5/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

/**********\
 * Imports
\**********/

#import "ViewController.h"
#import "opencv2/highgui/ios.h"	// UIImageToMat()
#import "detector.h"

@interface ViewController ()
//-(void) centerScrollViewContents;
//-(void) scrollViewDoubleTapped: (UITapGestureRecognizer*)recognizer;
//-(void) scrollViewTwoFingerTapped: (UITapGestureRecognizer*)recognizer;
@end


/******************\
 * View Controller
\******************/

@implementation ViewController
/*
@synthesize imageView;	// ??? //
@synthesize scrollView = _scrollView;
*/

/*
+ (UIImage*) runDetectionAlgorithm:(UIImage *)unknownImage
{
	// For debugging
	//	NSLog(@"Image:%@ Index:%li", testImages[currentImage], currentImage);
	
	// Update the label to the name of the current image
	//nameOfCurrentImage.text = [NSString stringWithFormat:@"%@", testImages[currentImage]];
	
	// Load image
	//UIImage* image = [UIImage imageNamed:testImages[currentImage]];
	Mat cvImage;
	UIImageToMat(unknownImage, cvImage);
	
	// Load OpenCV classifier
	NSString* flowerXMLPath = [[NSBundle mainBundle]
							   pathForResource:@"flower25"
							   ofType:@"xml"];
	NSString* vocabXMLPath = [[NSBundle mainBundle]
							  pathForResource:@"vocabulary"
							  ofType:@"xml"];
	NSString* sileneXMLPath = [[NSBundle mainBundle]
							   pathForResource:@"silene"
							   ofType:@"xml"];
	
	detector flowerDetector([flowerXMLPath UTF8String], [vocabXMLPath UTF8String], [sileneXMLPath UTF8String]);
	
	// Circle flowers
	Mat detectedImage = flowerDetector.circlePinkFlowers(cvImage);
	
	return MatToUIImage(detectedImage);
	// Show image with results
	//imageView.image = MatToUIImage(detectedImage);
}
 */
- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


/***************************\
 * Methods created by Jacob
\***************************/
/*
-(IBAction) nextButtonPressed
{
	currentImage = (currentImage + 1) % numberOfImages;
	//[self displayImage];
}

-(IBAction) backButtonPressed
{
	if (currentImage == 0) {
		currentImage = numberOfImages;
	}
	
	currentImage = (currentImage - 1) % numberOfImages;
	//[self displayImage];
}

*/


@end





