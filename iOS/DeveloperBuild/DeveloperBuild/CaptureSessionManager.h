//
//  CaptureSessionManager.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/19/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <UIKit/UIKit.h>

#define kImageCapturedSuccessfully @"imageCaptureSuccessfully"

@interface CaptureSessionManager : NSObject{
	// Nothing here ...
}

@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (retain) AVCaptureSession *captureSession;

@property (retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, retain) UIImage *stillImage;


- (void)addVideoPreviewLayer;
- (void)addVideoInput;


- (void)addStillImageOutput;	// WHY DID THIS HAVE A BUILD IN METHOD?
- (void)captureStillImage;

- (void)stopFeed;


@end
