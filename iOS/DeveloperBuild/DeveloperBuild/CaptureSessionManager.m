//
//  CaptureSessionManager.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/19/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

// the following defines are from http://stackoverflow.com/questions/969130/how-to-print-out-the-method-name-and-line-number-and-conditionally-disable-nslog
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


#import "CaptureSessionManager.h"

@implementation CaptureSessionManager

@synthesize captureSession;
@synthesize previewLayer;

#pragma mark - Capture Session Configuration

- (id)init {
	if (self = [super init]) {
		[self setCaptureSession:[[AVCaptureSession alloc] init]];
	}
	return self;
}

- (void)addVideoPreviewLayer{
	[self setPreviewLayer:[[[AVCaptureVideoPreviewLayer alloc] initWithSession:[self captureSession]] autorelease]];
}

- (void)addVideoInput{
	AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if (videoDevice) {
		NSError *error;
		AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:error];
		if (!error) {
			if ([[self captureSession] canAddInput:videoIn]) {
				[[self captureSession] addInput:videoIn];
			}
			else
				ALog(@"Couldn't add video input");
		}
		else
			ALog(@"Couldn't create video input");
	}
	else
		ALog(@"Couldn't create video capture device");
}

- (void)dealloc {
	[[self captureSession] stopRunning];
	
	[previewLayer release], previewLayer = nil;
	[captureSession release], captureSession = nil;
	
	[super dealloc];
}

@end
