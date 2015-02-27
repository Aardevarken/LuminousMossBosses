//
//  ViewController.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 1/5/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "detector.h"

@interface ViewController : UIViewController <UIScrollViewDelegate> {
	
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

