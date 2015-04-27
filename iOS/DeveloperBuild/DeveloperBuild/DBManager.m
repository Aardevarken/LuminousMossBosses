//
//  DBManager.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/25/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

/***********\
\* imports */
#import "DBManager.h"

/***********\
\* defines */
// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

/***********\
\* globals */


/******************\
\* implementation */
@implementation DBManager
+ (DBManager*) getSharedInstance{
	// not sure if this static method should be here
	static DBManager *sharedInstance = nil;
	
	// create a singleton object
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[super alloc] init];
	});
	return sharedInstance;
}

@end
