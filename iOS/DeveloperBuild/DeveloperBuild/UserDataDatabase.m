//
//  UserDateDatabase.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 3/4/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//



#import "UserDataDatabase.h"
#import "UserData.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define databaseName "userdata.db"
#define TESTING NO

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

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
        @"percentIDed double,"
        @"isSilene text not null default 'idk'"
    @");";
    typeMap = @{
        @"imghexid" : @"string", // These strings decide if NSString or NSNumber or NSBoolean should be used later.
        @"datetime" : @"string",
        @"latitude" : @"double",
        @"longitude" : @"double",
        @"locationerror" : @"double",
        @"status" : @"string",
        @"percentIDed" : @"double",
        @"isSilene" : @"string"
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

#pragma mark - observation data management
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

-(BOOL) saveObservation:(NSString*) imghexid date:(NSString*)date latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude locationError:(NSNumber*) locationError percentIDed:(NSNumber*)percentIDed {
	
	//#warning Change latitude and longitude to floats/doubles to reduce the amount of conversion for NSNumber?
	if(latitude == nil && longitude == nil && date == nil){
		latitude = [NSNumber numberWithDouble:bestEffortAtLocation.coordinate.latitude];
		longitude = [NSNumber numberWithDouble:bestEffortAtLocation.coordinate.longitude];
		date = [NSString stringWithFormat:@"%@",bestEffortAtLocation.timestamp];
	} else {

	}
	
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO observations (imghexid, datetime, latitude, longitude, locationerror, percentIDed) VALUES ('%@','%@','%@','%@','%@','%@');", imghexid, date, latitude, longitude, locationError, percentIDed];
    return [self runBoolQuery:insertSQL];
}

-(BOOL) updateObservation:(NSString *)imghexid andNewPercentIDed:(NSNumber *)percentIDed andNewStatus:(NSString *)status isSilene:(NSString*) isSilene
{
    NSString* isSileneString = @"";
    if (isSilene != nil) {
        isSileneString = [NSString stringWithFormat:@", isSilene='%@'", isSilene];
    }
    NSString *query = [NSString stringWithFormat:@"UPDATE observations SET status='%@', percentIDed='%@'%@ WHERE imghexid='%@';", status, percentIDed, isSileneString, imghexid];
    return [self runBoolQuery:query];
}


-(BOOL) deleteObservationByID:(NSString*) imghexid {
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM observations WHERE imghexid='%@';", imghexid];
    return [self runBoolQuery:deleteSQL];
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

/**
 * This function will take in a sqlite statement and return the results in an array of ditionaries, or nil on error.
 */
-(NSArray*) findObservationsByStatus:(NSString*)status like:(BOOL)like orderBy:(NSString*)orderBy
{
	// create optional order by statement
	NSString* orderBystmt;
	NSString* statusStmt;
	if (orderBy != nil){
		orderBystmt = [NSString stringWithFormat:@" ORDER BY %@", orderBy];
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
 * Remove all assets that no longer exists
 */
- (void)removeDeletedAssets{
	NSString *allDataStmt = [NSString stringWithFormat:@"SELECT imghexid FROM observations;"];
	NSArray *allData = [self runTableQuery:allDataStmt];
	
	
	ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
	//NSURL *url;
	for (id object in allData){
		NSURL *url = [NSURL URLWithString:[object objectForKey:@"imghexid"]];
		
		[lib assetForURL:url
			 resultBlock:^(ALAsset *asset) {
				 if (asset == NULL) {
					 [self deleteObservationByID:[object objectForKey:@"imghexid"]];
				 }
			 }
			failureBlock:^(NSError *error) {
				ALog(@"SHOULD NOT HIT");
		}];
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

#pragma mark - GPS Methods
/******************************************************************************\
|*	The following methods are used my the UserDataDatabase to collect GPS data
|*
|*
\******************************************************************************/
-(void) startLocationTracking
{
	// Create the manager object
	_locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	
	// This is the most important property to set for the manager. It ultimately determines how the mannager will attempt to acquire location and thus, the amount of power that will be consumed.
	self.locationManager.desiredAccuracy =  kCLLocationAccuracyBest;
	
	// NOT SURE WHAT THE FOLLOWING IS FOR
	//
	// for iOS 9, specific user level permissions is required, "when-in-use" authorization grants access to the user's location.
	//
	// Important: Be sure to inlcude NSLocationWhenInUseUsageDescription along with its explanation string in your Info.plist or startUpdatingLocation will not work.
	if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
		[self.locationManager requestWhenInUseAuthorization];
	}
	
	// This is where the fun begins :-)
	self.locationManager.pausesLocationUpdatesAutomatically = NO;
	[self.locationManager startUpdatingLocation];
}

- (void)stopLocationTracking
{
	[self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
	// Get the last object updated.
	CLLocation *newLocation = locations.lastObject;	// This could be factored out.

	if (TESTING) {
		static unsigned int updateCount = 0;
		if (locations.count == 1) {
			NSLog(@"Update(%u) \t%@", updateCount, newLocation.description);
		}
		else if (locations.count > 1){
			//#warning Need to check time stamp when multible GPS coordinates.
		}
		else {
			//#warning THIS SHOULD NEVER HIT!
		}
		++updateCount;
	}
	
	// test that the horizontal accuracy does not indicate an invalid mesurement.
	if (newLocation.horizontalAccuracy < 0) {
		return;
	}
	
	// Test the age of the location mesurement to determine if the mesurement is cached, in most cases you will not want to rely on chached mesurements
	NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
	if (locationAge > 5.0) {
		return;
	}
	
	if ([newLocation.timestamp timeIntervalSinceDate:bestEffortAtLocation.timestamp] > 5) {
		bestEffortAtLocation = nil;
	}
	

	// test the mesurement to see if it is more accurate than the previous mesurement
	if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy >= newLocation.horizontalAccuracy) {
		// store the new mesurement
		bestEffortAtLocation = newLocation;
		
		// test the measurment to see if it meets the desired accuracy
		//
		// IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitude accuracy becuase it is a negative value. Instead, compare against some predetermined "real" measure of acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
		//
		if (newLocation.horizontalAccuracy <= self.locationManager.desiredAccuracy) {
			if (TESTING) {
				NSLog(@"Self \t%@", newLocation.self);
				NSLog(@"Super Class \t%@", newLocation.superclass);
				NSLog(@"Description \t%@", newLocation.description);
				NSLog(@"Latitude \t%f (float)", newLocation.coordinate.latitude);
				NSLog(@"Longitude \t%f (float)", newLocation.coordinate.longitude);
				NSLog(@"Altitude \t%f (float)", newLocation.altitude);
				NSLog(@"Course \t%f (float)", newLocation.course);
				NSLog(@"Speed \t%f  (float)", newLocation.speed);
				NSLog(@"Horizontal Accuracy \t%f (float)", newLocation.horizontalAccuracy);
				NSLog(@"Vertial Accuracy \t%f (float)", newLocation.verticalAccuracy);
				NSLog(@"Time Stamp \t%@", newLocation.timestamp);
				NSLog(@"Floor \t%@", newLocation.floor);
				
				NSLog(@"\n");
				NSLog(@"Self \t%@", self.locationManager.self);
				NSLog(@"Super Class \t%@", self.locationManager.superclass);
				NSLog(@"Description \t%@", self.locationManager.description);
				NSLog(@"Desired Accuracy \t%f (float)", self.locationManager.desiredAccuracy);
				NSLog(@"Distance Filter \t%f", self.locationManager.distanceFilter);
				NSLog(@"Heading \t%@", self.locationManager.heading);
				NSLog(@"Heading Filter \t%f (float)", self.locationManager.headingFilter);
				NSLog(@"Heading Orientation \t%d (32-bit int)", self.locationManager.headingOrientation);
				NSLog(@"\n");				
			}
			[self stopUpdatingLocationWithMessage:NSLocalizedString(@"Aquired Location", @"Acuired Location")];
		}
	}
}

// We want to get and store a location mesurement that meets teh desired accuracy. For this we are going to use horizontal accuracy as the deciding factor. In some cases, if may be better to use vertical accuracy or both together.
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	// test that the horizontal accuracy does not indicate an invalid mesurement.
	if (newLocation.horizontalAccuracy < 0) {
		return;
	}
	
	// ???
	// Test the age of the location mesurement to determine if the mesurement is cached, in most cases you will not want to rely on chached mesurements
	// ???
	NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
	if (locationAge > 5.0) {
		return;
	}
	
	// test the mesurement to see if it is more accurate than the previous mesurement
	if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
		// store the new mesurement
		bestEffortAtLocation = newLocation;
		
		// test the measurment to see if it meets the desired accuracy
		//
		// IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitude accuracy becuase it is a negative balue. Instead, compare against some predetermined "real" measure of acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
		//
		if (newLocation.horizontalAccuracy <= self.locationManager.desiredAccuracy) {
			[self stopUpdatingLocationWithMessage:NSLocalizedString(@"Aquired Location", @"Acuired Location")];
			
		}
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
	// The location 'unknown" error simply means the manager is currently unable to get the location.
	if ([error code] != kCLErrorLocationUnknown) {
		[self stopUpdatingLocationWithMessage:NSLocalizedString(@"Error", @"Error")];
	}
}

- (void)stopUpdatingLocationWithMessage:(NSString *) state{
	[self.locationManager stopUpdatingLocation];
	self.locationManager.delegate = nil;
}

- (CLLocation *) getBestKnownLocation{
	return bestEffortAtLocation;
}

@end





