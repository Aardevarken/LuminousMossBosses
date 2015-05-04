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
- (sqlite3*)openDB;
- (void)closeDB:(sqlite3*) database;
- (NSArray*)runTableQuery:(NSString*) query;
@end


@implementation FieldGuideManager

@synthesize fetchQuery;

+ (FieldGuideManager*)getSharedInstance{
	// create a singleton object
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[super alloc] init];
		
		// Set fetchQuere to its default value
		[sharedInstance setFetchQuery:
		 @"SELECT species.id, species.latin_name, species.common_name, species.code\n"
		 @"FROM species\n"
		 @"ORDER BY species.latin_name"
		 ];
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
	
		NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"FieldGuide" ofType:@"db"];
		
		// build the path to the database file
		//databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:databaseName]];
		
		//ALog(@"scp: %@", sourcePath);
		NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
		//NSString *targetPath = [libraryPath stringByAppendingPathComponent:databaseName];
		databasePath = [libraryPath stringByAppendingPathComponent:databaseName];
		//ALog(@"dbp: %@",databasePath);
		if (![[NSFileManager defaultManager] fileExistsAtPath:databasePath/*targetPath*/]) {
			// database doesn't exist in your library path... copy it from the bundle
			NSError *error = nil;
			
			if (![[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:databasePath/*targetPath*/ error:&error]) {
				ALog(@"Error: %@", error);
			}
		}
		//databasePath = targetPath;
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


/*! */
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

	for (queryStatus = sqlite3_step(statement); queryStatus == SQLITE_ROW; queryStatus = sqlite3_step(statement)) {
		NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
		
		// Iterate through columns and insert name->value paris based on typing
		// the column.
		int count = sqlite3_column_count(statement);
		for (int i = 0; i < count; i++) {
			NSString *name = [NSString stringWithUTF8String:sqlite3_column_name(statement, i)];
			NSObject *value = nil;
			value = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, i)];
			
			[dictionary setObject:value forKey:name];
		}
		
	// Add to results array
		[results addObject:(NSDictionary*) dictionary];
	}
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

-(BOOL) runBoolQuery:(NSString*) query {
	// Open DB
	sqlite3* database = [self openDB];
	if (database == nil) {
		return NO;
	}
	
	// Build Statement
	const char *insert_stmt = [query UTF8String];
	sqlite3_stmt *statement = nil;
	sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
	
	// Get status and close DB.
	int queryStatus = sqlite3_step(statement);
	sqlite3_finalize(statement);
	
	// Return or log errors.
	if (queryStatus == SQLITE_DONE) {
		[self closeDB: database];
		return YES;
	} else {
		NSLog(@"Bool Query Failed: %s", sqlite3_errmsg(database));
		[self closeDB: database];
		return NO;
	}
}

-(void) dropTable{
	[self runBoolQuery:@"DROP TABLE IF EXISTS FieldGuide.db;"];
}

#pragma mark - field guide queries

- (NSArray*)getDataFilteredBy:(NSString*)filter{
	return [self runTableQuery:filter];
}

- (NSArray*)getAllData{
	return [self runTableQuery:[self fetchQuery]];
}

- (NSDictionary*)findSpeciesByID:(NSNumber*)id{
	// Query #1
	
	
	NSString *query = [NSString stringWithFormat:
					   @"SELECT code, latin_name, common_name, family, description, photocredit "
					   @"FROM species "
					   @"WHERE species.id = %d"
					   @";", (int)[id integerValue]
					   ];

	NSArray *results1 = [self runTableQuery:query];
	
	
	// Query #2
	query = [NSString stringWithFormat:
			 @"SELECT growthform.name "
			 @"FROM species "
			 @"JOIN growthform on growthform_id = growthform.id "
			 @"WHERE species.id = %d;",
			 (int)[id integerValue]
			 ];
	
	NSArray *results2 = [self runTableQuery:query];
	
	// Query #3
	query = [NSString stringWithFormat:
			 @"SELECT flowershape.name "
			 @"FROM species "
			 @"JOIN flowershape on flowershape.id = flowershape_id "
			 @"WHERE species.id = %d;",
			 (int)[id integerValue]
			 ];
	
	NSArray *results3 = [self runTableQuery:query];
	
//	// Query #4
//	query = [NSString stringWithFormat:
//			 @"SELECT leafshapefilter.name "
//			 @"FROM species "
//			 @"JOIN leafshapefilter on leafshapefilter_id = leafshapefilter.id "
//			 @"WHERE species.id = %d;",
//			 (int)[id integerValue]
//			 ];
//	NSArray *results4 = [self runTableQuery:query];

	
	NSArray *more = @[@"habitat", @"inflorescence", @"leafarrangement", @"leafshape", @"petalnumber"];
	
//	NSMutableArray *results5 = [NSMutableArray alloc];
//
//	for (NSString *str in more){
//		[results5 addObject:[self getDataFromDB:str withSpeciesID:(int)[id integerValue]]];
//	}
	
	// combine all queries together.
	NSMutableDictionary *dicR = [[NSMutableDictionary alloc] initWithDictionary:results1[0]];
	[dicR setObject:[results2[0] objectForKey:@"name"] forKey:@"growthform"];
	[dicR setObject:[results3[0] objectForKey:@"name"] forKey:@"flower shape"];
//	[dicR setObject:[results4[0] objectForKey:@"name"] forKey:@"leaf shape filter"];
	
	for (NSString *str in more){
		[dicR addEntriesFromDictionary:[self getDataFromDB:str withSpeciesID:(int)[id integerValue]]];
	}
	
	//[dicR addEntriesFromDictionary:[results5 firstObject]];
//	ALog(@"\n\ninfo:\n %@\n", dicR);
	return [[NSDictionary alloc] initWithDictionary:dicR];
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

- (NSDictionary*)getDataFromDB:(NSString*)db withSpeciesID:(NSUInteger)pid{
	NSString *query = [[NSString alloc] initWithFormat:
						 @"SELECT %@.name \n"
						 @"FROM species \n"
						 @"JOIN species_%@ ON species.id = species_%@.species_id \n"
						 @"JOIN %@ ON %@.id = %@_id \n"
						 @"WHERE species_%@.species_id = %lu;\n",
						 db,
						 db,
						 db,
						 db,
						 db,
						 db,
						 db,
						 (unsigned long)pid
						 ];
	
	//ALog(@"%@", query);
	
	NSArray *results = [self runTableQuery:query];
	
	
	NSMutableArray *flat = [[NSMutableArray alloc] initWithCapacity:results.count];

	for (int i = 0; i < results.count; ++i) {
		[flat addObject:[[results objectAtIndex:i] objectForKey:@"name"]];
	}
	

	NSMutableDictionary *dic = [NSMutableDictionary alloc];
	NSMutableString *rstr = [[NSMutableString alloc] initWithString:@""];

	if ([flat count ]>=1) {
		[rstr appendString:[flat objectAtIndex:0]];
		
		if ([flat count] >= 2) {
			for (NSUInteger i = 1; i < (flat.count - 1); ++i) {
				[rstr appendString:@", "];
				[rstr appendString:[flat objectAtIndex:i]];
			}
			[rstr appendString:@" and "];
			[rstr appendString:[flat lastObject]];
		}
		
		//NSString * resultstr = [[flat valueForKey:@"description"] componentsJoinedByString:@", "];
		
	}
	
	
	return [[NSDictionary alloc] initWithObjectsAndKeys:rstr, db, nil];
}


@end




























