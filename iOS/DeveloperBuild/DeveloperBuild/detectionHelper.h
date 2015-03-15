//
//  detectionHelper.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 3/14/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "detector.h"

//#import "opencv2/highgui/ios.h"

@interface detectionHelper : NSObject

+ (UIImage *) runDetectionAlgorithm:(UIImage *) unknownImage;

@end
