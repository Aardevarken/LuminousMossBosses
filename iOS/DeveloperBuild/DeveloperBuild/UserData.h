//
//  UserData.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 3/4/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserData : NSObject{
	int _uniqueId;
	// The following are the objects stored in the db
	NSString *_imghexid;
	// the following may not need to be pointers.
	NSInteger *_width;
	NSInteger *_hight;
	NSInteger *_date;
	NSDecimalNumber *_latitude;
	NSDecimalNumber *_longitude;
	NSDecimalNumber *_percentIDed;

}

@property (nonatomic, assign) int uniqueId;
@property (nonatomic, copy) NSString *imghexid;
@property (nonatomic, assign) NSInteger *width;
@property (nonatomic, assign) NSInteger *hight;
@property (nonatomic, assign) NSInteger *date;
@property (nonatomic, copy) NSDecimalNumber *latitude;
@property (nonatomic, copy) NSDecimalNumber *longitude;
@property (nonatomic, copy) NSDecimalNumber *percentIDed;

- (id)initWithUniqueID:(NSString *)imghexid;
//- (id)initWithUniqueID:(int)uniqueID imghexid:(NSString *)imghexid width:(NSInteger *)width hight:(NSInteger *)hight date:(NSInteger *)date latitude:(NSDecimalNumber *)latitude longitude:(NSDecimalNumber *)longitude percentIDed:(NSDecimalNumber *)percentIDed;

@end
