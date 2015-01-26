//
//  ViewController.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 1/5/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <opencv2/opencv.hpp>		// Change this later so that only
									// the needed opencv files are
									// included.

@interface ViewController : UIViewController <UIScrollViewDelegate> {
	cv::CascadeClassifier flower_cc;
	cv::HOGDescriptor bow;
	cv::LatentSvmDetector svm;
	
	NSArray *testImages;
	NSUInteger numberOfImages;
	NSInteger currentImage;
	IBOutlet UILabel *nameOfCurrentImage;

	NSInteger redRec;
	NSInteger greenRec;
	NSInteger blueRec;
	
}

// For adding a scroll view
@property (nonatomic, strong) IBOutlet UIImageView* imageView;
@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;


@end

