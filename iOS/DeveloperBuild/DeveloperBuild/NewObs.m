//
//  NewObs.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 2/13/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "NewObs.h"


@implementation NewObs
@synthesize FileName, ImageID, ObsID;

- (id) initWithFileName:(NSString *)newFileName
			 andImageID:(NSNumber *)newImgID
			   andObsID:(NSNumber *)newObsID
{
	self = [super init];
	if (self){
		FileName = newFileName;
		ImageID = newImgID;
		ObsID = newObsID;
	}
	
	return self;
}


@end
/*
 #import "City.h"
 
 @implementation City
 @synthesize cityID, cityName, cityState, cityPopulation, cityCountry;
 
 - (id) initWithCityID: (NSString *) cID andCityName: (NSString *) cName andCityState: (NSString *) cState andCityPopulation: (NSString *) cPopulation andCityCountry: (NSString *) cCountry
 {
 self = [super init];
 if (self)
 {
 cityID = cID;
 cityName = cName;
 cityState = cState;
 cityPopulation = cPopulation;
 cityCountry = cCountry;
 }
 
 return self;
 }
 
 @end
 
 */