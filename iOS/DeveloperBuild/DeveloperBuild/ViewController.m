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


@interface ViewController ()
//-(void) centerScrollViewContents;
//-(void) scrollViewDoubleTapped: (UITapGestureRecognizer*)recognizer;
//-(void) scrollViewTwoFingerTapped: (UITapGestureRecognizer*)recognizer;
@end


/******************\
 * View Controller
\******************/

@implementation ViewController

@synthesize imageView;	// ??? //
@synthesize scrollView = _scrollView;

- (void)viewDidLoad {
	NSLog(@"Starting viewDidLoad");
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	// Load all of the test images into an array and set counting variables.
	testImages = @[@"IMG_1976.jpg", @"IMG_1997.jpg", @"IMG_2003.jpg", @"IMG_2278.jpg", @"minuartia1.jpg"];
	numberOfImages = [testImages count];
	currentImage = 0;
	
	NSString* cPath = [[NSBundle mainBundle]
					   pathForResource:@"flower30"
					   ofType:@"xml"];
	flower_cc.load([cPath UTF8String]);
	
	// display the first image
	[self displayImage];
	
	NSLog(@"Ending viewDidLoad");
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}



/***************************\
 * Methods created by Jacob
\***************************/

-(IBAction) nextButtonPressed
{
	currentImage = (currentImage + 1) % numberOfImages;
	[self displayImage];
}

-(IBAction) backButtonPressed
{
	if (currentImage == 0) {
		currentImage = numberOfImages;
	}
	
	currentImage = (currentImage - 1) % numberOfImages;
	[self displayImage];
}

-(void) displayImage
{
	// For debugging
//	NSLog(@"Image:%@ Index:%li", testImages[currentImage], currentImage);
	
	// Update the label to the name of the current image
	nameOfCurrentImage.text = [NSString stringWithFormat:@"%@", testImages[currentImage]];
	
	// Load image
	UIImage* image = [UIImage imageNamed:testImages[currentImage]];
	cv::Mat detectedImage;
	UIImageToMat(image, detectedImage);
	
	// Convert image to grayscale
	cv::Mat gray;
	cvtColor(detectedImage, gray, CV_BGR2GRAY);
	
	// Detect
	std::vector<cv::Rect> ids;
	flower_cc.detectMultiScale(gray, ids, 1.1, 2, 0|CV_HAAR_SCALE_IMAGE, cv::Size(30, 30));
	
	// Draw all detections
	for(int i = 0; i < ids.size(); ++i){
		const cv::Rect& imgDet = ids[i];
		// Get top-left and bottome-right corner points
		cv::Point tl(imgDet.x, imgDet.y);
		cv::Point br = tl + cv::Point(imgDet.width, imgDet.height);
		
		// Draw rectangle around the face
		cv::Scalar recColor = cv::Scalar(255, 255, 31);
		cv::rectangle(detectedImage, tl, br, recColor, 15, 8, 0);
	}
	
	// Show image with results
	imageView.image = MatToUIImage(detectedImage);
}

@end
