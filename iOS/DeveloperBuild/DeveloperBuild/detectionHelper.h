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


/**
 * Given an image, progress bar, and a percentage to fill runDetectionAlgorithm will run several tests and update the progress bar.
 * Should ONLY be called by a thread; However this condition is not checked
 * All updates to the progress bar are does by calling the main thread.
 * This code is concrete and will need to be refactored at some point.
 */
- (void) runDetectionAlgorithm:(UIImage *) unknownImage progressBar:(UIProgressView*)progressBar maxPercentToFill:(float)percentMultiplier;


/**
 * Constructor, needs to be refactored to fit better design patterns. 
 */
- (id) initWithAssetID:(NSString*)newAssetID;

/**
 * NOT SURE WHAT THIS FUNCTION IS USED FOR
 */
- (void) updatePercentCompleated:(float)updatePercentage;

// Getter functions
- (float) getCurrentProgress;
- (UIImage*) getIdentifiedImage;
- (float) getIDProbability;
- (BOOL) getIsSilene;


@end
