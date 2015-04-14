//
//  ImageViewController.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 2/24/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ImageViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
	UIImageView * imageView;
	UIButton * choosePhotoBtn;
	UIButton * takePhotoBtn;
	UINavigationController * testNav;
	
}

/* in old tutorial for getting camera to work. */
//@property (strong, nonatomic) IBOutlet UIImageView *imageView;
//- (IBAction)takePhoto:(UIButton *)sender;
//- (IBAction)selectPhoto:(UIButton *)sender;

@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet UIButton * choosePhotoBtn;
@property (nonatomic, retain) IBOutlet UIButton * takePhotoBtn;
@property (nonatomic, retain) IBOutlet UIButton * addObsBtn;

- (IBAction)getPhoto:(id) sender;
- (IBAction)addObservation:(UIButton *)sender;

@end



