//
//  IdentifyingAssets.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/18/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "IdentifyingAssets.h"

@implementation IdentifyingAssets

+(IdentifyingAssets *) getSharedInstance {
	static IdentifyingAssets *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

- (id)init {
	if (self = [super init]) {
		self.unknownAssets = [[NSMutableDictionary alloc] init];
	}
	return self;
}

+(detectionHelper*) getByimghexid:(NSString*) imghexid {
    NSMutableDictionary* assets = [IdentifyingAssets getSharedInstance].unknownAssets;
    detectionHelper* detectionObject = [assets objectForKey:imghexid];
    if (detectionObject == nil) {
        detectionObject = [[detectionHelper alloc] initWithAssetID:imghexid];
        [assets setValue:detectionObject forKey:imghexid];
    }
    return detectionObject;
}

@end
