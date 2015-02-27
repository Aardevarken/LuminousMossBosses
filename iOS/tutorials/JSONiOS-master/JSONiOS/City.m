//
//  City.m
//  JSONiOS
//
//  Created by Kurup, Vishal on 4/14/13.
//  Copyright (c) 2013 conkave. All rights reserved.
//

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
