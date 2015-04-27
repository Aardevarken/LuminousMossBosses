//
//  ImageViewController.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 2/24/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CaptureSessionManager.h"

@interface ImageViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
	UIImageView * imageView;
	UIButton * choosePhotoBtn;
	UIButton * takePhotoBtn;
	UINavigationController * testNav;
	
	// Under review for removal
	// class members in the header file (can't be local as then the blocks
	// wouldn't be able to use them
	NSConditionLock* albumReadLock;		// Under review for removal
	NSData* defaultRepresentationData;	// Under review for removal
}

@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet UIButton * takePhotoBtn;
@property (nonatomic, retain) IBOutlet UIButton * addObsBtn;
@property (nonatomic, retain) IBOutlet UIButton * retakePhotoBtn;

- (IBAction)retakePhotoBtn:(id)sender;
- (IBAction)takePhoto:(id) sender;
- (IBAction)addObservation:(UIButton *)sender;

// Code added from the iOS Camera Overlay Example Using AVCaptureSession tutorial
// @ http://www.musicalgeometry.com/?p=1273
@property (retain) CaptureSessionManager *captureManager;

@end



