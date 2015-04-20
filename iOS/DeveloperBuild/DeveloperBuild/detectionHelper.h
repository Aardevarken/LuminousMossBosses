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

@interface detectionHelper : NSObject

@property (nonatomic) NSNumber *percentageComplete;
@property (nonatomic, strong) NSString *assetID;
@property (nonatomic, assign) BOOL positiveID;
@property (nonatomic, strong) NSNumber *probability;
@property (nonatomic, strong) UIImage *identifiedImage;
/**
 * Given an image, progress bar, and a percentage to fill runDetectionAlgorithm will run several tests and update the progress bar.
 * Should ONLY be called by a thread; However this condition is not checked
 * All updates to the progress bar are does by calling the main thread.
 * This code is concrete and will need to be refactored at some point.
 */
- (void) runDetectionAlgorithm:(UIImage *) unknownImage;

/**
 * Constructor, needs to be refactored to fit better design patterns. 
 */
- (id) initWithAssetID:(NSString*)newAssetID;

/**
 * NOT SURE WHAT THIS FUNCTION IS USED FOR
 */
//- (void) updatePercentCompleated:(float)updatePercentage;

// Getter functions
//- (UIImage*) getIdentifiedImage;

@end
