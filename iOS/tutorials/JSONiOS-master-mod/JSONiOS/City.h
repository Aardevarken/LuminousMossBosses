//
//  City.h
//  JSONiOS
//
//  Created by Kurup, Vishal on 4/14/13.
//  Copyright (c) 2013 conkave. All rights reserved.
//

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
