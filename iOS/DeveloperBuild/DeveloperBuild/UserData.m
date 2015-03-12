//
//  UserData.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 3/4/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "UserData.h"

@implementation UserData

@synthesize uniqueId = _uniqueId;
@synthesize imghexid = _imghexid;
@synthesize width = _width;
@synthesize hight = _hight;
@synthesize date = _date;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize percentIDed = _percentIDed;

- (id)initWithUniqueID:(NSString *)imghexid
//- (id)initWithUniqueID:(int)uniqueID imghexid:(NSString *)imghexid width:(NSInteger *)width hight:(NSInteger *)hight date:(NSInteger *)date latitude:(NSDecimalNumber *)latitude longitude:(NSDecimalNumber *)longitude percentIDed:(NSDecimalNumber *)percentIDed


{
	if ((self = [super init])) {
//		self.uniqueId = uniqueID;
		self.imghexid = imghexid;
//		self.width = width;
//		self.hight = hight;
//		self.date = date;
//		self.latitude = latitude;
//		self.longitude = longitude;
//		self.percentIDed = percentIDed;
	}
	return self;
}

- (void) dealloc
{
	self.imghexid = nil;
//	self.width = nil;
//	self.hight = nil;
//	self.date = nil;
//	self.latitude = nil;
//	self.longitude = nil;
//	self.percentIDed = nil;
}

@end