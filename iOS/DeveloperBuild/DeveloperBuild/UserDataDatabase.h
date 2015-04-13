//
//  UserDateDatabase.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 3/4/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <sqlite3.h>

@interface UserDataDatabase : NSObject <CLLocationManagerDelegate>{
	NSString *databasePath;
	
	@private
	NSArray *columnNamesArray;
	CLLocation *bestEffortAtLocation;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *locations;
/**
 Test to see if an instance of the database exists, if there is not instance of the database then call createDB.
 @returns instance of the database.
 */
+(UserDataDatabase*) getSharedInstance;

/**
 Create a database based off of hardcoded string. If called to create a database that already exists, display an error. 
 @returns YES if creation is successful, NO if database already exists or failed to create database table.
 */
-(BOOL) createDB;

-(BOOL) saveData:(NSString*) imghexid date:(NSString*)date latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude percentIDed:(NSNumber*)percentIDed;

-(NSArray*) findByImgID:(NSString*)imghexid;

-(NSArray*) findObsByStatus:(NSString*)status like:(BOOL)like orderBy:(NSString*)orderBy;

-(BOOL) printResults:(NSArray*)array;

-(BOOL) updateRow:(NSString*)imghexid andNewPercentIDed:(NSNumber*)percentIDed andNewStatus:(NSString*)status;

-(BOOL) deleteRow:(NSString*)identifier fromColumn:(NSString*)column;

-(void) startLocationTracking;
-(void) stopLocationTracking;
-(void) getGPS;

-(void) pauseLocationTracking;

@end
