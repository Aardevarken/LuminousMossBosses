//
//  FilterObject.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/26/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "FilterObject.h"

@implementation FilterObject
//@synthesize filterDatabaseName;
//@synthesize filterValue;

- (FilterObject*)initWithFilter:(NSString *)fdbname usingValue:(NSString *)fvalue{
	self.filterDatabaseName = fdbname;
	self.filterValue = fvalue;
	
	return self;
}
@end
