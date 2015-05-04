//
//  FieldGuideManager.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/25/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

/**	Database manager for the field guide.
 FieldGuideManager is used to access all field guide data.
 */

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface FieldGuideManager : NSObject{
	NSString *databasePath;
}
// Properties
@property (nonatomic, strong) NSString *fetchQuery;

// Method functions.
//! Constructor.
/*!
 The field guide manager is a singleton and the getSharedInstance method will
 create an instance of the field guide manager when it first called. All other 
 calls will return this instance.
 */
+ (FieldGuideManager*)getSharedInstance;

//!	Get the results of a predefined query.
/*!	
 Returns the resulsts of the stored filter. 
 \sa fetchQuery;
 \returns NSArray* of NSDictionary*.
 */
- (NSArray*)getAllData;

//! Return information for a particular species by an id.
/*!
 Becuase of how the database parser works, all the information is distrubuted 
 over several database and gether all of the data for a particular species id 
 we run several queries and combine the results.
 
 \return A dictionary where keys = database column names (id, latin_name, etc.)
 and values = column value for that particular row.
 */
- (NSDictionary*)findSpeciesByID:(NSNumber*)id;


//! Get the path for a image in the FORBS folder.
/*!
 The image name is code.jpeg where code is a coloumn in the database. Code is a
 unique six letter all word with all capital letters. 
 
 \return An NSString* to the image path.
 */
- (NSString *)getImagePathForSpeciesWithID:(NSNumber*)id;


//!	Get all options for a given filter
/*!
 \param[in] filter The filter you want to get options for
 \returns NSArray* of options. Flattens the dictaionary returned from 
 runTableQuery so the returned array contains all values from the 'name' column.
 */
- (NSArray*)getFilterOptionsFor:(NSString*)filter;

- (void)dropTable;
@end
