//
//  MyObservations.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 3/1/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "MyObservations.h"

@implementation MyObservations{
	// put private instace variables here
}

// synthesize here

// define methods here
-(NSMutableArray*) myStaticArray{
	static NSMutableArray* theArray = nil;
	if(theArray == nil){
		theArray = [[NSMutableArray alloc] init];
	}
	return theArray;
}

@end


