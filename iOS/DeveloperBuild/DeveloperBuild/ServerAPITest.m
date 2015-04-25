//
//  ServerAPITest.m
//  DeveloperBuild
//
//  Created by Jamie Frampton Miller on 3/17/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ServerAPI.h"

@interface ServerAPITest : XCTestCase

@end

@implementation ServerAPITest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    NSURL* url = [NSURL URLWithString:@"http://www.i2clipart.com/cliparts/3/b/9/6/clipart-simple-flower-3b96.png"];
    //NSData* data = [NSData dataWithContentsOfURL:url];
    //NSArray* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    //UIImage* downloadedImage = [json objectAtIndex:0];
    UIImage* downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    
    
    XCTAssertTrue([ServerAPI uploadObservation:@"2015-3-8" time:@"11:04" lat:2.203 lng:3.32 locationerror:10.4 image:downloadedImage]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
