//
//  NewObs.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 2/13/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

/**
 * NOT SURE WHERE THIS INTERFACE IS USED
 */

#import <Foundation/Foundation.h>

@interface NewObs : NSObject

@property (nonatomic, strong) NSString* FileName;
@property (nonatomic, strong) NSNumber* ImageID;
@property (nonatomic, strong) NSNumber* ObsID;

// Methods
- (id) initWithFileName: (NSString*) newFileName
			 andImageID: (NSNumber*) newImgID
			   andObsID: (NSNumber*) newObsID;

@end