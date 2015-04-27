//
//  FilterOptions.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/26/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "FilterOptions.h"
#import "FieldGuideManager.h"

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

- (void) updateFilterOptionsAtIndex:(NSUInteger)index withOption:(NSString*)newFilterValue{
	[[self filterOption] setObject:newFilterValue atIndexedSubscript:index];
}

- (void) generateFilterQuery{
	// the following is how the string needs to be formated.
	/******
	 SELECT species.id, species.latin_name, species.common_name, species.code
	 FROM species
	 JOIN species_filter_1 on species.id = filter_1.species_id
	 JOIN filter_1 on filter_1.id = filter_1_id;
	 ...
	 WHERE filter_1.name = <FilterByThis_1>
	 AND filter_2.name = <FilterByThis_2>
	 ...
	 AND filter_N.name = <FilterByThis_N>
	 ORDER BY species.latin_name;
	 */
	
	NSUInteger capacity = filterTitle.count;
	
	NSString *selectFrom = @"SELECT species.id, species.latin_name, species.common_name, species.code\n"
						   @"FROM species\n";
	NSString *orderBy = @"ORDER BY species.latin_name";
	
	NSMutableArray *joins = [[NSMutableArray alloc] initWithCapacity:capacity];
	NSMutableArray *whereAnds = [[NSMutableArray alloc] initWithCapacity:capacity];
	for (NSUInteger filterAtIndex = 0; filterAtIndex < capacity; ++filterAtIndex) {
		NSString *filterBy = [filterOption objectAtIndex:filterAtIndex];
		if (![filterBy isEqualToString:@"All"]) {
		
			NSString *dbName = [filterDatabaseName objectAtIndex:filterAtIndex];
			NSString *newJoin = [[NSString alloc] initWithFormat:
								 @"JOIN species_%@ ON species.id = species_%@.speciesid\n"
								 @"JOIN %@ ON %@.id = %@id\n",
								 dbName,
								 dbName,
								 dbName,
								 dbName,
								 dbName
								 ];
			
			NSString *newWhere = [[NSString alloc] initWithFormat:
								  @"%@.name = \"%@\"\n",
								  dbName,
								  filterBy
								  ];
			
			[joins addObject:newJoin];
			[whereAnds addObject:newWhere];
		}
	}
	
	NSMutableString *query = [[NSMutableString alloc] initWithString:selectFrom];
	//[query appendString:selectFrom];
	[query appendString:[joins componentsJoinedByString:@""]];
	NSString *whereOrAnd = @"WHERE ";

	for (NSString *additionalOptions in whereAnds) {
		[query appendString:whereOrAnd];
		[query appendString:additionalOptions];
		whereOrAnd = @"AND ";
	}
	
	[query appendString:orderBy];
	
	NSLog(@"\nQuery:\n%@\n\n", query);
	[[FieldGuideManager getSharedInstance] setFetchQuery:query];
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
