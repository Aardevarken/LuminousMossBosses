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

#define kImageCapturedSuccessfully @"imageCaptureSuccessfully"	// T2

@interface CaptureSessionManager : NSObject{
	// Nothing here ...
}

// T1
@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (retain) AVCaptureSession *captureSession;
// T2
@property (retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, retain) UIImage *stillImage;

// T1
- (void)addVideoPreviewLayer;
- (void)addVideoInput;

// T2
- (void)addStillImageOutput;	// WHY DID THIS HAVE A BUILD IN METHOD?
- (void)captureStillImage;

@end
