//
//  UserDateDatabase.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 3/4/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "UserDateDatabase.h"
#import "UserData.h"

static UserDateDatabase *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation UserDateDatabase

+(UserDateDatabase*) getSharedInstance{
	if (!sharedInstance) {
		sharedInstance = [[super allocWithZone:NULL] init];
		[sharedInstance createDB];
	}
	return sharedInstance;
}

-(BOOL) createDB {
	NSString *docsDir;
	NSArray *dirPaths;
	// get the document directory
	dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	docsDir = dirPaths[0];
	// build the path to the database file
	databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent: @"userdata.db"]];
	BOOL isSuccess = YES;
	NSFileManager *filemgr = [NSFileManager defaultManager];
	if ([filemgr fileExistsAtPath:databasePath] == NO) {
		const char *dbpath = [databasePath UTF8String];
		if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
			char *errMsg;
			const char *sql_stmt = "create table if not exists observations (imghexid text, width int, height int, date int, latitude num, longitude num, percentIDed num)";
			if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
				isSuccess = NO;
				NSLog(@"Failed to create table");
			}
			sqlite3_close(database);
			return isSuccess;
		}
		else {
			isSuccess = NO;
			NSLog(@"Failed to open/create database");
		}
	}
	NSLog(@"Database creation successful.");
	return isSuccess;
}

-(BOOL) saveData:(NSString*) imghexid width:(NSInteger)width height:(NSInteger)height date:(NSInteger)date latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude percentIDed:(NSNumber*)percentIDed;
{
	const char *dbpath = [databasePath UTF8String];
	if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
		// the following string may be wrong. NSInteger might need to be an in, and NSNumber a double/fload.
		NSString *insertSQL = [NSString stringWithFormat:@"insert into observations (imghexid, width, height, date, latitude, longitude, percentIDed) values (\"%@\", \"%ld\", \"%ld\", \"%ld\", \"%@\", \"%@\", \"%@\")", imghexid, (long)width, (long)height, (long)date, latitude, longitude, percentIDed];
		const char *insert_stmt = [insertSQL UTF8String];
		sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
		if (sqlite3_step(statement) == SQLITE_DONE) {
			return YES;
		}
		else {
			NSLog(@"Failed: %s", sqlite3_errmsg(database));
			return NO;
		}
		sqlite3_reset(statement); // not sure why this is here.
	}
	return NO;
}


/***********************************************************************************************\
 * this function will take in a sqlite stament and return the results in an array of ditionaries.
 *
 * Status: Incomplete
\************************************************************************************************/
-(NSArray*) find:(NSString*)selectStm from:(NSString*)fromStm where:(NSString*)whereStmParam orderBy:(NSString*)orderByStmParam;
{
	const char *dbpath = [databasePath UTF8String];
	if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
		NSString *whereStmt = @"";
		NSString *orderByStmt = @"";
		if (whereStmParam != nil) {
			whereStmt = [NSString stringWithFormat:@"where %@", whereStmParam];
		}
		if (orderByStmParam != nil) {
			orderByStmt = [NSString stringWithFormat:@"order by %@", orderByStmParam];
		}
		
		NSString *querySQL = [NSString stringWithFormat:@"select %@ from %@ %@ order by %@", selectStm, fromStm, whereStmt, orderByStmt];
		const char *query_stmt = [querySQL UTF8String];
		NSMutableArray *resultArray = [[NSMutableArray alloc] init];
		NSArray *keyArray = @[@"imghexid", @"width", @"height", @"date", @"latitude", @"longitude", @"percentIDed"];
		
		if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW) {
				while(sqlite3_step(statement) == SQLITE_ROW) {
					NSMutableArray *objectArray = [[NSMutableArray alloc] init];
					
					// Position 0 imghexid
					NSString *imghexid = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 0)];
					[objectArray addObject:imghexid]; // name is the string provided above
					
					// Position 1 width
					int width = sqlite3_column_int(statement, 1);
					[objectArray addObject: [NSNumber numberWithInt:width]];
					
					// Position 2 height
					int height = sqlite3_column_int(statement, 2);
					[objectArray addObject: [NSNumber numberWithInt:height]];
					
					// Position 3 date
					int date = sqlite3_column_int(statement, 3);
					[objectArray addObject: [NSNumber numberWithInt:date]];
					
					// Position 4 latitude
					double latitude = sqlite3_column_double(statement, 4);
					[objectArray addObject:[NSNumber numberWithDouble:latitude]];
					
					// Position 5 longitude
					double longitude = sqlite3_column_double(statement, 5);
					[objectArray addObject:[NSNumber numberWithDouble:longitude]];
					
					//Position 6 percentIDed
					double percentIDed = sqlite3_column_double(statement, 6);
					[objectArray addObject:[NSNumber numberWithDouble:percentIDed]]; // name is the string provided above
					
					NSDictionary *rowResults = [NSDictionary dictionaryWithObjects:objectArray forKeys:keyArray];
					[resultArray addObject:rowResults];
				}
			}
			else {
				NSLog(@"Not found");
				return nil;
			}
			sqlite3_reset(statement);	// not sure what this is used for
			return resultArray;
		}
		else {
			NSLog(@"Failed: %s", sqlite3_errmsg(database));
		}
		
	}
	return nil;
}


-(NSArray*) findByImgID:(NSString *)imghexid
{
	const char *dbpath = [databasePath UTF8String];
	if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
		NSString *querySQL = [NSString stringWithFormat:@"select * from observations"];// where imghexid=\"%@\"", imghexid];
		const char *query_stmt = [querySQL UTF8String];
		NSMutableArray *resultArray = [[NSMutableArray alloc] init];
		NSArray *keyArray = @[@"imghexid", @"width", @"height", @"date", @"latitude", @"longitude", @"percentIDed"];
		
		if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW) {
				do {
					NSMutableArray *objectArray = [[NSMutableArray alloc] init];
					
					// Position 0 imghexid
					NSString *imghexid = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 0)];
					[objectArray addObject:imghexid]; // name is the string provided above
					
					// Position 1 width
					int width = sqlite3_column_int(statement, 1);
					[objectArray addObject: [NSNumber numberWithInt:width]];
					
					// Position 2 height
					int height = sqlite3_column_int(statement, 2);
					[objectArray addObject: [NSNumber numberWithInt:height]];
					
					// Position 3 date
					int date = sqlite3_column_int(statement, 3);
					[objectArray addObject: [NSNumber numberWithInt:date]];
					
					// Position 4 latitude
					double latitude = sqlite3_column_double(statement, 4);
					[objectArray addObject:[NSNumber numberWithDouble:latitude]];
					
					// Position 5 longitude
					double longitude = sqlite3_column_double(statement, 5);
					[objectArray addObject:[NSNumber numberWithDouble:longitude]];
					
					//Position 6 percentIDed
					double percentIDed = sqlite3_column_double(statement, 6);
					[objectArray addObject:[NSNumber numberWithDouble:percentIDed]]; // name is the string provided above
					
					NSDictionary *rowResults = [NSDictionary dictionaryWithObjects:objectArray forKeys:keyArray];
					[resultArray addObject:rowResults];
				}while(sqlite3_step(statement) == SQLITE_ROW);
			}
			else {
				NSLog(@"Not found");
				return nil;
			}
			sqlite3_reset(statement);	// not sure what this is used for
			return resultArray;
		}
		else {
			NSLog(@"Failed: %s", sqlite3_errmsg(database));
		}
		
	}
	return nil;
}

-(BOOL) printResults:(NSArray*) array
{
	for (id row in array){
		NSEnumerator *enumerator = [row keyEnumerator];
		id key;
		while ((key = [enumerator nextObject])) {
			NSString *element = [row objectForKey:key];
			NSLog(@"%@\t", element);
		}
		NSLog(@"------");
	}
	return YES;
}



@end





