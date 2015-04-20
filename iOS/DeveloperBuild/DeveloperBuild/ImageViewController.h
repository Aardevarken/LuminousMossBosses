//
//  ImageViewController.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 2/24/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

/******************************************************************************\
 * This file will be under going changes to fix bugs and UI issues. 
 * There are 2 tutorials that will affect this file. all lines added outside
 of the blocks indicating tutorial code will be marked with 'T1' for tutorial #1
 and 'T2' for tutorial #2.
 * This comments will be removed after additional fuctionality is implemented, 
 tested, and commited. 
 * CaptureSessionManager.h &.m where added for these tutorials and will not be
 marked up.
\******************************************************************************/

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CaptureSessionManager.h"	// T1

@interface ImageViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
	UIImageView * imageView;
	UIButton * choosePhotoBtn;
	UIButton * takePhotoBtn;
	UINavigationController * testNav;
	
}

@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet UIButton * choosePhotoBtn;
@property (nonatomic, retain) IBOutlet UIButton * takePhotoBtn;
@property (nonatomic, retain) IBOutlet UIButton * addObsBtn;	// might not need

- (IBAction)getPhoto:(id) sender;
- (IBAction)addObservation:(UIButton *)sender;

/*** START OF TUTORIAL ONLY FILES ***/
// Code added from the iOS Camera Overlay Example Using AVCaptureSession tutorial
// @ http://www.musicalgeometry.com/?p=1273
// This is the first of two parts. Some of this tutorial will be re-written.
// Some or all of the above code may need to be removed.

@property (retain) CaptureSessionManager *captureManager;
@property (nonatomic, retain) UILabel *scanningLabel;

/*** END OF TUTORIAL ONLY FILES ***/
@end



