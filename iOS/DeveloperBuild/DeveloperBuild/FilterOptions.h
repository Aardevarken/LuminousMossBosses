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

@property (nonatomic, strong) NSArray *filterTitlesWithImages;
@property (nonatomic, strong) NSArray *filterDatabasenNamesWithImages;
@property (nonatomic, strong) NSMutableArray *filterOptionsWithImages;

+ (FilterOptions*) getSharedInstance;
//- (void) addFiltersWithTitles:(NSDictionary*)titlesWithFilters;
//- (void) addFiltersAndImagesWithTitles:(NSDictionary*)filtersWithImages;
- (void) createFiltersWithTitlesAndImages:(NSDictionary*)titlesWithFilters;
- (void) createFiltersWithTitles:(NSDictionary*)titlesWithFilters;
- (NSString*) getDatabaseNameAtIndex:(NSInteger)index;
- (void) updateFilterOptionsAtIndex:(NSUInteger)index withOption:(NSString*)newFilterValue;
- (void) updateFilterOptionsWithImagesAtIndex:(NSUInteger)index withOption:(NSString *)newFilterValue;
- (void) generateFilterQuery;
- (void) resetFilterOptions;
- (void) printFilters;

@end
