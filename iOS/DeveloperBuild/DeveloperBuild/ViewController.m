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
	Mat cvImage;
	UIImageToMat(image, cvImage);
    
    // Load OpenCV classifier
    NSString* cPath = [[NSBundle mainBundle]
                       pathForResource:@"flower25"
                       ofType:@"xml"];
	
    detector flowerDetector = detector([cPath UTF8String]);
	
    // Circle flowers
    Mat detectedImage = flowerDetector.circlePinkFlowers(cvImage);
	
	// Show image with results
	imageView.image = MatToUIImage(detectedImage);
}


@end





