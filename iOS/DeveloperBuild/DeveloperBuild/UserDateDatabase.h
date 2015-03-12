//
//  UserDateDatabase.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 3/4/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface UserDateDatabase : NSObject{
	NSString *databasePath;
}

+(UserDateDatabase*) getSharedInstance;
-(BOOL) createDB;
-(BOOL) saveData:(NSString*) imghexid width:(NSInteger)width height:(NSInteger)height date:(NSInteger)date latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude percentIDed:(NSNumber*)percentIDed;
-(NSArray*) findByImgID:(NSString*)imghexid;
-(BOOL) printResults:(NSArray*)array;


@end
