//
//  FilterOptions.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/26/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "FilterOptions.h"
#import "FieldGuideManager.h"

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define printa(fmt, ...) printf(("%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@implementation FilterOptions{
	int currentTitleIndexRow;
	NSString *selectFilterOption;
	NSArray *imageExceptions;
}

@synthesize filterTitle;
@synthesize filterDatabaseName;
@synthesize filterOption;
@synthesize filterTitlesWithImages;
@synthesize filterDatabasenNamesWithImages;
@synthesize filterOptionsWithImages;


+ (FilterOptions*)getSharedInstance{
	static FilterOptions *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
		
	});
	return sharedInstance;
}

- (void) createFiltersWithTitlesAndImages:(NSDictionary*)titlesWithFilters{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self setFilterTitlesWithImages:[titlesWithFilters allValues]];
		[self setFilterDatabasenNamesWithImages:[titlesWithFilters allKeys]];
		[self setFilterOptionsWithImages:[self nullArrayOfLenght:filterTitlesWithImages.count]];
	});
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

- (void) updateFilterOptionsWithImagesAtIndex:(NSUInteger)index withOption:(NSString *)newFilterValue{
	[[self filterOptionsWithImages] setObject:newFilterValue atIndexedSubscript:index];
}


- (NSString*) getDatabaseNameAtIndex:(NSInteger)index{
	if (index < [filterDatabaseName count]) {
		return [filterDatabaseName objectAtIndex:index];
	} else {
		index -= [filterDatabaseName count];
		return [filterDatabasenNamesWithImages objectAtIndex:index];
	}
}

- (void) generateFilterQuery{
	// the following is how the string needs to be formated for species_<databasename>
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
								 @"JOIN species_%@ ON species.id = species_%@.species_id\n"
								 @"JOIN %@ ON %@.id = %@_id\n",
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
	
	NSUInteger ie = [filterDatabasenNamesWithImages indexOfObject:@"leafarrangement"];
	NSString *filterBy = [filterOptionsWithImages objectAtIndex:ie];
	if (![filterBy isEqualToString:@"All"]) {
		
		NSString *dbName = [filterDatabasenNamesWithImages objectAtIndex:ie];
		NSString *newJoin = [[NSString alloc] initWithFormat:
							 @"JOIN species_%@ ON species.id = species_%@.species_id\n"
							 @"JOIN %@ ON %@.id = %@_id\n",
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
	
	capacity = [filterTitlesWithImages count];
	
	for (NSUInteger filterAtIndex = 0; filterAtIndex < capacity; ++filterAtIndex) {
		NSString *filterBy = [filterOptionsWithImages objectAtIndex:filterAtIndex];
		
		if (![filterBy isEqualToString:@"All"]) {
			if (filterAtIndex == ie) {
				continue;
			}
			
			NSString *dbName = [filterDatabasenNamesWithImages objectAtIndex:filterAtIndex];
			
			
			NSString *newJoin = [[NSString alloc] initWithFormat:
								 @"JOIN %@ ON species.%@_id = %@.id\n",
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
	
	ALog(@"\nQuery:\n%@\n\n", query);
	[[FieldGuideManager getSharedInstance] setFetchQuery:query];
}



- (void)resetFilterOptions{
	[self setFilterOption:[self nullArrayOfLenght:[filterTitle count]]];
	[self setFilterOptionsWithImages:[self nullArrayOfLenght:[filterTitlesWithImages count]]];
}

- (void)printFilters{
	
	printf("\n\ttitle \t dbname \t option\n");
	for (NSUInteger i = 0; i < filterTitle.count; ++i) {
		printf("[%lu]\t%s\t| %s \t| %s\n", i, [[filterTitle objectAtIndex:i] UTF8String], [[filterDatabaseName objectAtIndex:i] UTF8String], [[filterOption objectAtIndex:i] UTF8String]);
	}
	
	for (NSUInteger i = 0; i < filterTitlesWithImages.count; ++i) {
		printf("[%lu]\t%s\t| %s \t| \t%s\n", i, [[filterTitlesWithImages objectAtIndex:i] UTF8String], [[filterDatabasenNamesWithImages objectAtIndex:i] UTF8String], [[filterOptionsWithImages objectAtIndex:i] UTF8String]);
	}
	
	printf("\n");
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
