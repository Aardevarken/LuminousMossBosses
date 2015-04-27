//
//  FieldGuideManager.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/25/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface FieldGuideManager : NSObject{
	NSString *databasePath;
}

@property (nonatomic, strong) NSString *fetchQuery;

/**
 *
 */
+ (FieldGuideManager*)getSharedInstance;
- (NSArray*)getAllData;
- (NSDictionary*)findSpeciesByID:(NSNumber*)id;

/**
 * get the image path in the form FORBS/image_name.jpg
 */
- (NSString *)getImagePathForSpeciesWithID:(NSNumber*)id;

- (NSArray*)getFilterOptionsFor:(NSString*)filter;

@end
