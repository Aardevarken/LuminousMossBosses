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

- (void) runDetectionAlgorithm:(UIImage *) unknownImage progressBar:(UIProgressView*)progressBar maxPercentToFill:(float)percentMultiplier;
- (id) initWithAssetID:(NSString*)newAssetID;
- (void) updatePercentCompleated:(float)updatePercentage;
- (float) getCurrentProgress;
- (UIImage*) getIdentifiedImage;
- (float) getIDProbability;
- (BOOL) getIsSilene;


@end
