//
//  HomeModel.h
//  cwc_ios_mysql
//
//  Created by Jacob Rail on 2/2/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HomeModelProtocol <NSObject>

- (void) itemsDownloaded:(NSArray *) items;

@end

@interface HomeModel : NSObject
<NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<HomeModelProtocol> delagate;

- (void) downloadItems;

@end
