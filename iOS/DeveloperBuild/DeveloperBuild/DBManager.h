//
//  DBManager.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/25/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject{
	NSString *databasePath;
}

/**
 *
 */
+ (DBManager*)getSharedInstance;

/**
 *
 */
- (sqlite3*)openDB;

/**
 *
 */
- (void)closeDB;

/**
 *
 */
- (BOOL)runBoolQuery:(NSString*) query;

/**
 *
 */
- (NSArray*)runTableQuery:(NSString*) query;

@end
