//
//  FieldGuideManager.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/25/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "FieldGuideManager.h"

/**********\
\* define */
// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define printa(fmt, ...) printf(("%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
// database name
#define databaseName @"FieldGuide.db"

/***********\
\* globals */
static FieldGuideManager *sharedInstance = nil;
static NSString* databasePath = nil;
static NSDictionary *typeMap = nil;
// globals added for the field guide.
// NSString *filter = nil;//[NSString stringWithFormat:@"SELECT latin_name, common_name FROM species ORDER BY latin_name"];


/*******************\
\* private methods */
@interface FieldGuideManager ()
/**
 *
 */
- (sqlite3*)openDB;

/**
 *
 */
- (void)closeDB:(sqlite3*) database;

/**
 *
 */
- (BOOL)runBoolQuery:(NSString*) query;

/**
 *
 */
- (NSArray*)runTableQuery:(NSString*) query;
@end


@implementation FieldGuideManager

/*
 * The following functions are required for the field guide database
 */
+ (FieldGuideManager*)getSharedInstance{
	// create a singleton object
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[super alloc] init];
	});
	return sharedInstance;
}

#pragma mark - sqlite helper methods
- (sqlite3*)openDB{
	// Find the path to the database file iff it hasn't been found already.
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		// get the document directory
		NSString *docsDir;
		NSArray *dirPaths;
		dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
		docsDir = dirPaths[0];
		
		/*** TEST CODE ***/
		
		NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"FieldGuide" ofType:@"db"];
		
		// build the path to the database file
		databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:databaseName]];
		
		
		NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
		NSString *targetPath = [libraryPath stringByAppendingPathComponent:databaseName];
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
			// database doesn't exist in your library path... copy it from the bundle
			//NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"FieldGuide" ofType:@"db"];
			NSError *error = nil;
			
			if (![[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:targetPath error:&error]) {
				ALog(@"Error: %@", error);
			}
		}
		
		
		
		//ALog(@"\n\ndb path: %@\n\ntargetPath: %@", databasePath, targetPath);
		databasePath = targetPath;
//		printa("Database can be found at:\n%s\n\n", [databasePath UTF8String]);
		/*** END OF TEST CODE ***/
		
	});
	
	// Open the database handler.
	sqlite3 *database = nil;
	if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		return database;
	} else {
		ALog(@"Failed to open database: %s", sqlite3_errmsg(database));
		sqlite3_close(database);
		return nil;
	}
}

- (void)closeDB:(sqlite3*) database {
	sqlite3_close(database);
}

/**
 *	There should be no need for this method because we will not be inserting or
 deleting any data from the field guide.
 */
- (BOOL)runBoolQuery:(NSString *)query{
	ALog(@"THIS METHOD IS MARKED FOR DELETION");
	
	// Open database
	sqlite3 *database = [self openDB];
	if (database == nil) {
		return NO;
	}
	
	// Build statement
	const char *insert_stmt = [query UTF8String];
	sqlite3_stmt *statement = nil;
	sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
	
	// Get satus and close DB
	int queryStatus = sqlite3_step(statement);
	sqlite3_finalize(statement);
	
	// Return or log errors.
	if (queryStatus == SQLITE_DONE) {
		[self closeDB:database];
		return YES;
	} else {
		ALog(@"Bool query failed: %s", sqlite3_errmsg(database));
		[self closeDB:database];
		return NO;
	}
}

/**
 *
 */
- (NSArray*)runTableQuery:(NSString *)query{
	// Open database
	sqlite3 *database = [self openDB];
	if (database == nil) {
		return nil;
	}
	
	// Build statement
	sqlite3_stmt *statement = nil;
	sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL);
	
	// Convert result table into an array of dictionaries.
	NSMutableArray* results = [[NSMutableArray alloc] init];
	int queryStatus;
//	queryStatus = sqlite3_step(statement);
//	
//	int debug = queryStatus;
//	int n = 0;
//	printa("----------------------------------------------------------\n");
//	printa("QUERY: %s\n", [query UTF8String]);
//	printa("debug(%d): %d\n",n++ ,debug);
	for (queryStatus = sqlite3_step(statement); queryStatus == SQLITE_ROW; queryStatus = sqlite3_step(statement)) {
		NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
		
		// Iterate through columns and insert name->value paris based on typing
		// the column.
		int count = sqlite3_column_count(statement);
		for (int i = 0; i < count; i++) {
			NSString *name = [NSString stringWithUTF8String:sqlite3_column_name(statement, i)];
			NSObject *value = nil;
			NSString *typeName = [typeMap valueForKey:name];
			
			//if ([typeName isEqual:@"string"]) {
			value = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, i)];
			//} else if ([typeName isEqual:@"double"]){
			//	value = [NSNumber numberWithDouble:sqlite3_column_double(statement, i)];
			//}
			
			[dictionary setObject:value forKey:name];
		}
		
		/*** some debugging code ***/
//		if (debug != queryStatus) {
//			printa("\t\tdebug(%d): %d\n",n ,debug);
//		}
//		++n;
//		debug = queryStatus;
		/*** debugging code ***/

		
		// Add to results array
		[results addObject:(NSDictionary*) dictionary];
	}
//	printa("debug(%d): %d\n",n++ ,debug);
//	printa("----------------------------------------------------------\n\n");
	// Get status and close DB
	sqlite3_finalize(statement);
	
	// Return results if all is good.
	if (queryStatus == SQLITE_DONE) {
		[self closeDB:database];
		return results;
	} else {
		ALog(@"Table query failed: %s", sqlite3_errmsg(database));
		[self closeDB: database];
		return nil;
	}
}

#pragma mark - field guide queries
/*
 given a filter, you can filter by N options.
 You can only filter flowercolor, habitat, infloresence, leafarrangement, leafshape, and petalnumber with this.
 
 SELECT species.id, filter_1.name, filter_2.name, ..., filter_N.name
 FROM species, filter_1, filter_2, ..., filter_N
 JOIN species_filter_1 on species.id = filter_1.species_id
 JOIN filter_1 on filter_1.id = filter_1_id;
 ...
 WHERE filter_1.name = <FilterByThis_1>
 AND filter_2.name = <FilterByThis_2>
 ...
 AND filter_N.name = <FilterByThis_N>
 ORDER BY species.id;
 */
//NSMutableArray *results = nil;
//NSArray *filterResults = nil;
//NSString *filter = [NSString stringWithFormat:@"SELECT species.latin_name, species.common_name"];// FROM species ORDER BY species.latin_name"];

- (NSArray*)getDataFilteredBy:(NSString*)filter{
	return [self runTableQuery:filter];
}

- (NSArray*)getAllData{
	NSString *filter = [NSString stringWithFormat:@"SELECT id, latin_name, common_name, code FROM species ORDER BY latin_name"];
	return [self runTableQuery:filter];
}

- (NSDictionary*)findSpeciesByID:(NSNumber*)id{
	NSString *query = [NSString stringWithFormat:
					   @"SELECT growthform.name, code, latin_name, common_name, family, description, flowershape.name, leafshapefilter.name, photocredit "
					   @"FROM species "
					   @"JOIN growthform on growthformid = growthform.id "
					   @"JOIN flowershape on flowershape.id = flowershapeid "
					   @"JOIN leafshapefilter on leafshapefilterid = leafshapefilter.id "
					   @"WHERE species.id = %d"
					   @";", (int)[id integerValue]
					   ];
	
	NSArray *results = [self runTableQuery:query];
	
	if (results != nil && results.count == 1){
		return results[0];
	} else {
		return nil;
	}
}

- (NSString*)getImagePathForSpeciesWithID:(NSNumber*)id{
	NSString *query = [NSString stringWithFormat:
					   @"SELECT code "
					   @"FROM species "
					   @"WHERE species.id = %d "
					   @";", (int)[id integerValue]
					   ];
	
	NSArray *results = [self runTableQuery:query];
	
	if (results != nil && results.count == 1){
		NSString *imgPath = [NSString stringWithFormat:@"FORBS/%@.jpg", [results[0] objectForKey:@"code"]];
		return imgPath;
	} else {
		return nil;
	}
}

- (NSArray*)getFilterOptionsFor:(NSString*)filter{
	NSString *query = [NSString stringWithFormat:
					   @"SELECT name "
					   @"FROM %@;",
					   filter
					   ];

	NSArray *results = [self runTableQuery:query];

	NSMutableArray *flat = [[NSMutableArray alloc] initWithCapacity:results.count];
	for (int i = 0; i < results.count; ++i) {
		[flat addObject:[[results objectAtIndex:i] objectForKey:@"name"]];
	}
	
	return flat;
}

/**
 *
 */
/*
- (NSArray*)filterFieldGuidColor:(NSString *)color{
	 addtional data tha might be usefull
	flowercolor.name
	 
	 id INTEGER NOT NULL,
	 growthform_id INTEGER, 			// table
	 code VARCHAR,
	 latin_name VARCHAR,
	 common_name VARCHAR,
	 family VARCHAR,
	 description VARCHAR,
	 flowershape_id INTEGER, 		// table
	 leafshapefilter_id INTEGER, 	// table
	 photocredit VARCHAR,
	 
 
	
	SELECT species.id species.latin_name, species.common_name, species.family
	FROM species
	JOIN species_flowercolor
		ON species.id = species_id
	JOIN flowercolor
		ON flowercolor.id = flowercolor_id
	WHERE flowercolor.name = "yellow"
	ORDER BY species.id;
	
	return nil;
}
*/
/**
 *
 */
//- (NSMutableArray*) applyFilter:(NSArray*);

@end




























