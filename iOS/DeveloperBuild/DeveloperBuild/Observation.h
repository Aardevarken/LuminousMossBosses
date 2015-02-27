//
//  Observations.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 1/11/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#ifndef DeveloperBuild_Observations_h
#define DeveloperBuild_Observations_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Observation : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *percent;
@property (nonatomic, strong) UIImageView * image;


@end

#endif
