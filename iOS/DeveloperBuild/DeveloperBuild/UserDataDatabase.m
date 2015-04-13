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
#define CREATE_DB_STMT "CREATE TABLE observations (imghexid text not null primary key, date datetime not null, latitude decimal(9,6) not null, longitude decimal(9,6) not null, status text not null default \"pending-noid\", percentIDed tinyint);"
#define TESTING YES

static UserDataDatabase *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;


@implementation UserDataDatabase

+(UserDataDatabase*) getSharedInstance{
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
			const char *sql_stmt = "CREATE TABLE observations (imghexid text not null primary key, date datetime not null, latitude decimal(9,6) not null, longitude decimal(9,6) not null, status text not null default \"pending-noid\", percentIDed tinyint);";
			if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
				isSuccess = NO;
				//NSLog(@"Failed to create table");
			}
			
			
			sqlite3_close(database);
			return isSuccess;
		}
		else {
			isSuccess = NO;
			//NSLog(@"Failed to open/create database");
		}
	}
	//NSLog(@"Database creation successful.");
	return isSuccess;
}

-(BOOL) saveData:(NSString*) imghexid date:(NSString*)date latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude percentIDed:(NSNumber*)percentIDed;
{
	
	if([latitude isKindOfClass:[NSNull class]] && [longitude isKindOfClass:[NSNull class]] && [date isKindOfClass:[NSNull class]]){
#warning Change latitude and longitude to floats/doubles to reduce the amount of conversion for NSNumber?
		latitude = [NSNumber numberWithFloat:bestEffortAtLocation.coordinate.latitude];
		longitude = [NSNumber numberWithFloat:bestEffortAtLocation.coordinate.longitude];
		date = bestEffortAtLocation.timestamp;
	}
	const char *dbpath = [databasePath UTF8String];
	if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
		// the following string may be wrong. NSInteger might need to be an in, and NSNumber a double/fload.
		
		NSString *insertSQL = [NSString stringWithFormat:@"insert into observations (imghexid, date, latitude, longitude, percentIDed) values (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", imghexid, date, latitude, longitude, percentIDed];
		
		
		const char *insert_stmt = [insertSQL UTF8String];
		sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
		if (sqlite3_step(statement) == SQLITE_DONE) {
			return YES;
		}
		else {
			NSLog(@"Failed: %s", sqlite3_errmsg(database));
			return NO;
		}
		//sqlite3_reset(statement); // not sure why this is here.
	}
	return NO;
}


/***********************************************************************************************\
 * this function will take in a sqlite stament and return the results in an array of ditionaries.
 *
 * Status: Incomplete
\************************************************************************************************/
-(NSArray*) findObsByStatus:(NSString*)status like:(BOOL)like orderBy:(NSString*)orderBy
{
	// create optional order by statement
	NSString *orderBystmt;
	NSString *statusStmt;
	if (orderBy != nil){
		orderBystmt = [NSString stringWithFormat:@" order by %@", orderBy];
	}
	//else if(![orderBy length]) {orderBystmt = [NSString stringWithFormat:@"order by %@", orderBy];}
	else{
		orderBystmt = @"";
	}
	
	if (like){
		statusStmt = [NSString stringWithFormat:@"status LIKE \"%@\"", status];
	}
	else {
		statusStmt = [NSString stringWithFormat:@"status=\"%@\"", status];
	}

	const char *dbpath = [databasePath UTF8String];
	if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
		
		NSString *querySQL = [NSString stringWithFormat:@"select * from observations where %@%@;", statusStmt, orderBystmt];
		//NSLog(@"SQL: %@", querySQL);
		const char *query_stmt = [querySQL UTF8String];
		NSMutableArray *resultArray = [[NSMutableArray alloc] init];
		
		// get the name of each column
		/*
		 0|imghexid|text|1||1
		 1|date|datetime|1||0
		 2|latitude|decimal(9,6)|1||0
		 3|longitude|decimal(9,6)|1||0
		 4|status|text|1|"pending_noid"|0
		 5|percentIDed|tinyint|0||0
		 */
		NSArray *keyArray = @[@"imghexid", @"date", @"latitude", @"longitude", @"status", @"percentIDed"];
		
		if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW) {
				do{
					NSMutableArray *objectArray = [[NSMutableArray alloc] init];
					
					// Position 0 imghexid
					NSString *imghexid = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 0)];
					[objectArray addObject:imghexid]; // name is the string provided above
					
					// Position 1 date
					NSString *date = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 1)];
					[objectArray addObject:date];
					
					// Position 2 latitude
					double latitude = sqlite3_column_double(statement, 2);
					[objectArray addObject:[NSNumber numberWithDouble:latitude]];
					
					// Position 3 longitude
					double longitude = sqlite3_column_double(statement, 3);
					[objectArray addObject:[NSNumber numberWithDouble:longitude]];
					
					//Position 4 status
					NSString *status = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 4)];
					[objectArray addObject:status];
					
					//Position 6 percentIDed
					double percentIDed = sqlite3_column_double(statement, 5);
					[objectArray addObject:[NSNumber numberWithDouble:percentIDed]];
					
					
					NSDictionary *rowResults = [NSDictionary dictionaryWithObjects:objectArray forKeys:keyArray];
					[resultArray addObject:rowResults];
				} while(sqlite3_step(statement) == SQLITE_ROW);
			}
			else {
				//NSLog(@"Not found"); not needed
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

-(BOOL) updateRow:(NSString *)imghexid andNewPercentIDed:(NSNumber *)percentIDed andNewStatus:(NSString *)status
{
	sqlite3_stmt *updateStmt;
	const char *dbpath = [databasePath UTF8String];
	BOOL success = NO;
	if(sqlite3_open(dbpath, &database) == SQLITE_OK){
		const char *sql = "UPDATE observations SET status=?, percentIDed=? WHERE imghexid=?";
		//UPDATE Cars SET Name='Skoda Octavia' WHERE Id=3;
		//NSString *querySQL = [NSString stringWithFormat:@"UPDATE Observations SET state=\"%@\", percentIDed=%@ WHERE imghexid=\"%@\"", state, percentIDed,imghexid];
		
		if (sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) == SQLITE_OK) {
			sqlite3_bind_text(updateStmt, 3, [imghexid UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(updateStmt, 1, [status UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(updateStmt, 2, [[NSString stringWithFormat:@"%@", percentIDed] UTF8String], -1, SQLITE_TRANSIENT);
		}
	}
	char *errmsg;
	sqlite3_exec(database, "COMMIT", NULL, NULL, &errmsg);
	
	if (SQLITE_DONE != sqlite3_step(updateStmt)){
		NSLog(@"Error while updating. %s", sqlite3_errmsg(database));
		return NO;
	}
	else {
		success = YES;
		//[self clearClick:nil];	// have no idea what this does
	}
	
	sqlite3_finalize(updateStmt);
	sqlite3_close(database);
	
	return success;
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

-(BOOL) deleteRow:(NSString *)identifier fromColumn:(NSString *)column
{
	sqlite3 *database;
	
	if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		sqlite3_stmt *deleteStmt;
		NSString *sql_str = [NSString stringWithFormat:@"DELETE FROM observations WHERE %@=%@", column, identifier];
		const char *sql = [sql_str UTF8String];
		
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) == SQLITE_OK){
			if (sqlite3_step(deleteStmt) != SQLITE_DONE) {
				NSLog(@"ERROR: %s", sqlite3_errmsg(database));
				sqlite3_close(database);
				return NO;
			}
			else{
				// no error
			}
		}
		sqlite3_finalize(deleteStmt);
	}
	sqlite3_close(database);
	return YES;
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

-(void) startLocationTracking
{
	// Create the manager object
	_locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	
	// This is the most important property to set for the manager. It ultimately determines how the mannager will attempt to acquire location and thus, the amount of power that will be consumed.
	self.locationManager.desiredAccuracy =  kCLLocationAccuracyBest;//kCLLocationAccuracyNearestTenMeters;
	
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

- (void) getGPS
{
	/** /
	// Create the manager object
	_locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	
	// This is the most important property to set for the manager. It ultimately determines how the mannager will attempt to acquire location and thus, the amount of power that will be consumed.
	self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	
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
	/**/
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
	//
	CLLocation *newLocation = locations.lastObject;

	/** /
	static unsigned int updateCount = 0;
	if (locations.count == 1) {
		NSLog(@"Update(%u) \t%@", updateCount, newLocation.description);
	}
	else if (locations.count > 1){
		#warning Need to check time stamp when multible GPS coordinates.
	}
	else {
		#warning THIS SHOULD NEVER HIT!
	}
	++updateCount;
	/**/
	
	
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
	
	
	//NSLog(@"New Horizontal Accuracy \t%f (float)", newLocation.horizontalAccuracy);
	//NSLog(@"New Vertial Accuracy \t%f (float)", newLocation.verticalAccuracy);
	//NSLog(@"Desired Accuracy \t\t%f (float)", self.locationManager.desiredAccuracy);
	//NSLog(@"Best Horizontal Accuracy\t%f (float)", bestEffortAtLocation.horizontalAccuracy);
	//NSLog(@"Best Vertial Accuracy\t%f (float)", bestEffortAtLocation.verticalAccuracy);
	//NSLog(@"\n---------------------------\n");
	
	// test the mesurement to see if it is more accurate than the previous mesurement
	if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
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
			else {
				NSLog(@"Description \t%@", newLocation.description);
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
	NSLog(@"%@", state);
	[self.locationManager stopUpdatingLocation];
	self.locationManager.delegate = nil;
}
@end





