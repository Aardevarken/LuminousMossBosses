//
//  IdentifyingAssets.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/18/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdentifyingAssets : NSObject

@property (nonatomic, strong) NSMutableDictionary *unknownAssets;

+(IdentifyingAssets *) getSharedInstance;

@end
