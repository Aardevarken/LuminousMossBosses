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

// Methods needed to make the dictionary (unknownAssets) KVC complient.
// The following methods are recomended in the tutorial.
/** /
-(NSUInteger) countOfUnknownAssets;

-(id)objectInUnknownAssetsAtIndex:(NSUInteger)index;

-(void)insertObject:(id *)object inUnknownAssetsAtIndex:(NSUInteger)index;

-(void)removeObjectFromUnknownAssetsAtIndex:(NSUInteger)index;

-(void)replaceObjectInUnknownAssetsAtIndex:(NSUInteger)index withObject:(id)object;
/**/
// The following methods are methods that i might need to add in because i would like to use a dictionary, and the tutorial uses an array.
/** /
-(void)setValue:(id)value forKey:(NSString *)key;
-(id)
/**/

+(IdentifyingAssets *) getSharedInstance;


@end
