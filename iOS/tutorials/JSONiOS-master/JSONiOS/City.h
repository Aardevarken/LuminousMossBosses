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

//Methods
- (id) initWithCityID: (NSString *) cID andCityName: (NSString *) cName andCityState: (NSString *) cState andCityPopulation: (NSString *) cPopulation andCityCountry: (NSString *) cCountry;

@end
