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
#import <ImageIO/ImageIO.h>

@implementation CaptureSessionManager

// T1
@synthesize captureSession;
@synthesize previewLayer;
// T2
@synthesize stillImageOutput;
@synthesize stillImage;

#pragma mark - Capture Session Configuration

- (id)init {
	if (self = [super init]) {
		[self setCaptureSession:[[AVCaptureSession alloc] init]];
	}
	return self;
}

- (void)addVideoPreviewLayer{
	[self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:[self captureSession]]];
}

- (void)addVideoInput{
	AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if (videoDevice) {
		NSError *error = nil;
		AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
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

// T2
- (void)addStillImageOutput{
	[self setStillImageOutput:[[AVCaptureStillImageOutput alloc] init]]; // tutorial had a autorelease at the end.
	// not sure what this is for
	NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
	[[self stillImageOutput] setOutputSettings:outputSettings];
	
	AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in [[self stillImageOutput] connections]){
		for (AVCaptureInputPort *port in [connection inputPorts]){
			if ([[port mediaType] isEqualToString:AVMediaTypeVideo]) {
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) {
			break;
		}
	}
	
	[[self captureSession] addOutput:[self stillImageOutput]];
}

// T2
- (void)captureStillImage{
	AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in [[self stillImageOutput] connections]) {
		for (AVCaptureInputPort *port in [connection inputPorts]){
			if([[port mediaType] isEqual:AVMediaTypeVideo]){
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) {
			break;
		}
	}
	
	ALog(@"about to request a capture from: %@", [self stillImageOutput]);
	/* Changes that had to be made
	 * imageSampleBuffer --> imageDataSampleBuffer
	 */

	[[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:videoConnection
														 completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
															 CFDictionaryRef exifAttachments = CMGetAttachment(imageDataSampleBuffer, kCGImagePropertyExifDictionary, NULL);
															 
															 if (exifAttachments) {
																 //ALog(@"attachements: %@", exifAttachments);
															 }
															 else {
																 //ALog(@"no attachments");
															 }
															  
															 NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
															 UIImage *image = [UIImage imageWithData:imageData]; // tutorial has a alloc here. but that proved to produce an error when added. same with [image release]
															 [self setStillImage:image];
															 //[image release];
															 [[NSNotificationCenter defaultCenter] postNotificationName:kImageCapturedSuccessfully object:nil];
															 [self stopFeed];
														}
	 ];
}

- (void)stopFeed {
	// This needs to be reviewed.
	[[self captureSession] stopRunning];
	
	// T1
	previewLayer = nil;
	captureSession = nil;
	
	// T2
	stillImageOutput = nil;
	stillImage = nil;
}

- (void)dealloc {
	// This needs to be reviewed.
	[[self captureSession] stopRunning];
	
	// T1
	previewLayer = nil;
	captureSession = nil;
	
	// T2
	stillImageOutput = nil;
	stillImage = nil;
}

@end
