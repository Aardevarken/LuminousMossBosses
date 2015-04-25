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

/**
 *
 */
+ (FieldGuideManager*)getSharedInstance;


@end
