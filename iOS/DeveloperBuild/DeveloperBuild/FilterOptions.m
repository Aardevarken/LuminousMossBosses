//
//  FilterOptions.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/26/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "FilterOptions.h"

@implementation FilterOptions{
	int currentTitleIndexRow;
	NSString *selectFilterOption;
}

@synthesize filterTitle;
@synthesize filterDatabaseName;
@synthesize filterOption;

+ (FilterOptions*)getSharedInstance{
	static FilterOptions *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

- (void) createFiltersWithTitles:(NSDictionary*)titlesWithFilters{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self setFilterTitle:[titlesWithFilters allValues]];
		[self setFilterDatabaseName:[titlesWithFilters allKeys]];
		[self setFilterOption:[self nullArrayOfLenght:filterTitle.count]];
	});
}

- (void) addFilterOption:(NSString*)newOption toFilter:(NSString*)filterTitle{
	[[self filterOption] addObject:newOption];
}

- (NSString*) generateFilterQuery{
#warning Method not yet implemented;
	return nil;
}

#pragma mark - private memeber functions
- (NSMutableArray *)nullArrayOfLenght:(NSUInteger)len{
	NSMutableArray *nullarray = [[NSMutableArray alloc] initWithCapacity:len];
	
	for (NSInteger i = 0; i < len; ++i){
		[nullarray addObject:@"All"];
	}
	return nullarray;
}
@end
