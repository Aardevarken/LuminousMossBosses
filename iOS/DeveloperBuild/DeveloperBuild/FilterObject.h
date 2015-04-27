//
//  FilterObject.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/26/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterObject : NSObject
@property (nonatomic, strong) NSString *filterDatabaseName;
@property (nonatomic, strong) NSString *filterValue;

- (FilterObject*)initWithFilter:(NSString*)fdbname usingValue:(NSString*)fvalue;

@end
