//
//  MyObservationData.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/14/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyObservationData : NSObject{
	NSDictionary *myObsData;
}

+ (MyObservationData *)getSharedInstance;

/**
 * Remove all observation in the database that had their assests deleted.
 */
- (void)cleanUpDatabase;

/**
 * Delete the dictionary storying the my observation.
 */
+ (void)deallocMyObsData;

/**
 * Remove assets from the database and myObsData.
 */
- (BOOL)removeAsset:assetID withStatus:assetStatus;

/**
 * Change an assets status
 */
- (BOOL)changeAssetStatus:assetID fromStatus:oldStatus toStatus:newStatus;

/**
 *
 */
- (BOOL)updateAsset:assetID; 


@end
