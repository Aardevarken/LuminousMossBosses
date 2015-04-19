//
//  CaptureSessionManager.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/19/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface CaptureSessionManager : NSObject{
	// Nothing here ...
}

@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (retain) AVCaptureSession *captureSession;

- (void)addVideoPreviewLayer;
- (void)addVideoInput;

@end
