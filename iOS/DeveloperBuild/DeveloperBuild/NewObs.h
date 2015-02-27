//
//  NewObs.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 2/13/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewObs : NSObject

@property (nonatomic, strong) NSString* FileName;
@property (nonatomic, strong) NSNumber* ImageID;
@property (nonatomic, strong) NSNumber* ObsID;

// Methods
- (id) initWithFileName: (NSString*) newFileName
			 andImageID: (NSNumber*) newImgID
			   andObsID: (NSNumber*) newObsID;

@end


/*
 #import <Foundation/Foundation.h>
 
 @interface City : NSObject
 
 @property (nonatomic, strong) NSString * cityName;
 @property (nonatomic, strong) NSString * cityID;
 @property (nonatomic, strong) NSString * cityState;
 @property (nonatomic, strong) NSString * cityPopulation;
 @property (nonatomic, strong) NSString * cityCountry;
 
 
 @property (nonatomic, strong) NSString * fileName;
 @property (nonatomic, strong) NSNumber * imageID;
 @property (nonatomic, strong) NSString * fileLocation;
 
 
 
 //Methods
 - (id) initWithCityID: (NSString *) cID andCityName: (NSString *) cName andCityState: (NSString *) cState andCityPopulation: (NSString *) cPopulation andCityCountry: (NSString *) cCountry;
 
 @end
 
 */

/*
 2015-02-13 17:53:49.581 JSONiOS[2993:121605] #0: {
 FileName = "Silene-acaulis-copy.jpg";
 ImageID = 211;
 ObsID = 215;
 }
 */