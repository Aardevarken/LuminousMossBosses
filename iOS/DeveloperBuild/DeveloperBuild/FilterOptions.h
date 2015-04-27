//
//  FilterOptions.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/26/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterOptions : NSObject
@property (nonatomic, strong) NSArray *filterTitle;
@property (nonatomic, strong) NSArray *filterDatabaseName;
@property (nonatomic, strong) NSMutableArray *filterOption;

+ (FilterOptions*) getSharedInstance;
- (void) createFiltersWithTitles:(NSDictionary*)titlesWithFilters;
- (void) updateFilterOptionsAtIndex:(NSUInteger)index withOption:(NSString*)newFilterValue;
- (void) generateFilterQuery;

@end
