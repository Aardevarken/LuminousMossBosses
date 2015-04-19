//
//  IdentifyingAssets.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/18/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "IdentifyingAssets.h"

@implementation IdentifyingAssets

/**
 * instancetype is a contextual keyword that can be used as a result type to signal that a method returns a related result type.
 * instancetype, unlike id, can only be used as the result type in a method declaration.
 * At the type of writing this i have no justification for this other than i am following the tutorial closely. 
 * Referenced from: http://www.appcoda.com/understanding-key-value-observing-coding/
 */
// Might need to make this class a singleton??? MIGHT!
/*
- (instancetype)init
{
	self = [super init];
	if (self) {
		self.unknownAssets = [[NSDictionary alloc] init];
	}
	
	return self;
}
*/

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


@end
