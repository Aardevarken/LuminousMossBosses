//
//  City.h
//  JSONiOS
//
//  Created by Jacob Rail on 2/10/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property (nonatomic, strong) NSString * cityName;
@property (nonatomic, strong) NSString * cityID;
@property (nonatomic, strong) NSString * cityState;
@property (nonatomic, strong) NSString * cityPop;
@property (nonatomic, strong) NSString * cityCountry;

// Methods
- (id) initWithCityID: (NSString *) cID and andCityName: (NSString *) cName andCityState: (NSString *) cState andCityPopulation: (NSString *) cPopulation and cityCountry: (NSString *) cCountry;


@end
