//
//  UserDateDatabase.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 3/4/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//



#import "UserDataDatabase.h"
#import "UserData.h"

#define databaseName "userdata.db"

static UserDataDatabase* sharedInstance = nil;
static NSString* databasePath = nil;
static NSDictionary* typeMap = nil;

// Private methods.
@interface UserDataDatabase()
    -(BOOL) runBoolQuery:(NSString*) query;
    -(NSArray*) runTableQuery:(NSString*) query;
    -(sqlite3*) openDB;
    -(void) closeDB:(sqlite3*) database;
@end


@implementation UserDataDatabase


+(UserDataDatabase*) getSharedInstance {
	if (!sharedInstance) {
		sharedInstance = [[super allocWithZone:NULL] init];
		[sharedInstance createDB];
	}
	return sharedInstance;
}


-(BOOL) createDB {
    // Create missing tables.
    NSString* createTables = @"CREATE TABLE IF NOT EXISTS observations ("
        @"imghexid text not null primary key,"
        @"datetime text not null,"
        @"latitude double not null,"
        @"longitude double not null,"
        @"locationerror double,"
        @"status text not null default 'pending-noid',"
        @"percentIDed double"
    @");";
    typeMap = @{
        @"imghexid" : @"string", // These strings decide if NSString or NSNumber should be used later.
        @"datetime" : @"string",
        @"latitude" : @"double",
        @"longitude" : @"double",
        @"locationerror" : @"double",
        @"status" : @"string",
        @"percentIDed" : @"double"
    };
    
    // Uncomment this line the first time you run code with a new database schema.
    //[self runBoolQuery:@"DROP TABLE IF EXISTS observations;"];
    
    return [self runBoolQuery:createTables];
}


/**
 * Returns an open database if successful or nil if not.
 */
-(sqlite3*) openDB {
    // Find path to database file if it hasn't been found already.
    if (databasePath == nil) {
        // get the document directory
        NSString *docsDir;
        NSArray *dirPaths;
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = dirPaths[0];
        
        // build the path to the database file
        databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent: @"userdata.db"]];
    }
    
    // Open database handler.
    sqlite3* database = nil;
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        return database;
    } else {
        NSLog(@"Failed to open database: %s", sqlite3_errmsg(database));
        sqlite3_close(database);
        return nil;
    }
}


/**
 * Make sure to close any opened db at end of your method.
 */
-(void) closeDB:(sqlite3*) database {
    sqlite3_close(database);
}


/**
 * Runs a query that either succeeds or fails, such as an insert or delete, and reports if it was successful.
 */
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


-(BOOL) saveObservation:(NSString*) imghexid date:(NSString*)date latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude locationError:(NSNumber*) locationError percentIDed:(NSNumber*)percentIDed {
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO observations (imghexid, datetime, latitude, longitude, locationerror, percentIDed) VALUES ('%@','%@','%@','%@','%@','%@');", imghexid, date, latitude, longitude, locationError, percentIDed];
    return [self runBoolQuery:insertSQL];
}


-(BOOL) updateObservation:(NSString *)imghexid andNewPercentIDed:(NSNumber *)percentIDed andNewStatus:(NSString *)status
{
    NSString *query = [NSString stringWithFormat:@"UPDATE observations SET status='%@', percentIDed='%@' WHERE imghexid='%@';", status, percentIDed, imghexid];
    return [self runBoolQuery:query];
}


-(BOOL) deleteObservationByID:(NSString*) imghexid {
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM observations WHERE imghexid='%@';", imghexid];
    return [self runBoolQuery:deleteSQL];
}


/**
 * Runs a query that returns a table, table will be given back as an NSArray of NSDictionaries, with keys being the string
 * column names of the query. Returns nil on error, reserving an empty array for successful queries with no results.
 */
-(NSArray*) runTableQuery:(NSString*) query {
    // Open DB
    sqlite3* database = [self openDB];
    if (database == nil) {
        return nil;
    }
    
    // Build Statement
    sqlite3_stmt *statement = nil;
    sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL);
    
    // Convert result table into an array of dictionaries.
    NSMutableArray* results = [[NSMutableArray alloc] init];
    int queryStatus;
    for(queryStatus = sqlite3_step(statement); queryStatus == SQLITE_ROW; queryStatus = sqlite3_step(statement)) {
        NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
        
        // Iterate through columns and insert name->value pairs based on typing of the column.
        int count = sqlite3_column_count(statement);
        for (int i=0; i < count; i++) {
            NSString* name = [NSString stringWithUTF8String:sqlite3_column_name(statement, i)];
            NSObject* value = nil;
            NSString* typeName = [typeMap valueForKey:name];
            if ([typeName isEqual: @"string"]) {
                value = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, i)];
            } else if ([typeName isEqual:@"double"]) {
                value = [NSNumber numberWithDouble:sqlite3_column_double(statement, i)];
            }
            [dictionary setObject:value forKey:name];
        }
        // Add to results array.
        [results addObject:(NSDictionary*) dictionary];
    }
    
    // Get status and close DB.
    sqlite3_finalize(statement);
    
    // Return results if all is good.
    if (queryStatus == SQLITE_DONE) {
        [self closeDB: database];
        return results;
    } else {
        NSLog(@"Table Query Failed: %s", sqlite3_errmsg(database));
        [self closeDB: database];
        return nil;
    }
}


/**
 * This function will take in a sqlite statement and return the results in an array of ditionaries, or nil on error.
 */
-(NSArray*) findObservationsByStatus:(NSString*)status like:(BOOL)like orderBy:(NSString*)orderBy
{
	// create optional order by statement
	NSString* orderBystmt;
	NSString* statusStmt;
	if (orderBy != nil){
		orderBystmt = [NSString stringWithFormat:@" order by %@", orderBy];
	}
	//else if(![orderBy length]) {orderBystmt = [NSString stringWithFormat:@"order by %@", orderBy];}
	else{
		orderBystmt = @"";
	}
	
	if (like){
		statusStmt = [NSString stringWithFormat:@"status LIKE \"%@\"", status];
	} else {
		statusStmt = [NSString stringWithFormat:@"status=\"%@\"", status];
	}

    NSString* query = [NSString stringWithFormat:@"SELECT * FROM observations WHERE %@%@;", statusStmt, orderBystmt];
    return [self runTableQuery:query];
}

/**
 * Finds a single observation by id and returns it's columns as a dictionary, or nil on error.
 */
-(NSDictionary*) findObservationByID:(NSString *)imghexid {
	NSString* query = [NSString stringWithFormat:@"SELECT * FROM observations WHERE imghexid='%@' LIMIT 1;", imghexid];
    NSArray* results = [self runTableQuery:query];
    if (results != nil && results.count > 0) {
        return results[0];
    } else {
        return nil;
    }
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





