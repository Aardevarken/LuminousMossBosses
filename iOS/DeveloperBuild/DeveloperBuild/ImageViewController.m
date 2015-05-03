//
//  ImageViewController.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 2/24/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//
//	Last Modified on 4/13/15 by Jacob

#import "ImageViewController.h"
#import "MyObservations.h"
#import "UserDataDatabase.h"
#import "ObsViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#define TESTING NO
// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


@interface ImageViewController ()

@property (nonatomic, weak) NSTimer *cameraTimer;
@property (nonatomic) NSMutableArray *capturedImages;
@property (nonatomic, strong) NSString *capedImg;


- (void)didFinishSavingImageWithError:(NSNotification *)note;

@end

@implementation ImageViewController{
	NSString *selectedAsset;
	NSDictionary *pictureInfo;
	CLLocation* bestLocationForImage;
}

@synthesize imageView, takePhotoBtn;
@synthesize addObsBtn;
@synthesize captureManager;
@synthesize buttonView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	// for testing button layout
//	[[self addObsBtn] setHidden:NO];
//	[[self retakePhotoBtn] setHidden:NO];
//	[[self takePhotoBtn] setHidden:YES];
	
	// check to make sure the device has a camera
	if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		// display no camera icon
		imageView.hidden = NO;
		imageView.image = [UIImage imageNamed:@"nocamera.png"];

		// display alert box
		UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"ERROR"
															  message:@"Device has no camera"
															 delegate:nil
													cancelButtonTitle:@"OK"
													otherButtonTitles:nil];
		[myAlertView show];
		[self hideTakePhotoBtn];
		[self hideRetakePhotoBtn];
		[self hideAddObservationBtn];
		//[[self buttonView] setHidden:YES];
	}
	else {
		[self setCaptureManager:[[CaptureSessionManager alloc] init]];
		
		[[self captureManager] addVideoInput];
		
		[[self captureManager] addVideoPreviewLayer];
		CGRect layerRect = [[[self view] layer] bounds];
		[[[self captureManager] previewLayer] setBounds:layerRect];
		[[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect))];
		[[[self view] layer] addSublayer:[[self captureManager] previewLayer]];

		[[self captureManager] addStillImageOutput];

		[self hideAddObservationBtn];
		[self hideRetakePhotoBtn];
		[self prepTakePhotoBtn];
	}
}


- (void) viewWillAppear:(BOOL)animated{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didFinishSavingImageWithError:)
												 name:kImageCapturedSuccessfully
											   object:nil];
	
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewWillDisappear:animated];
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item{
	NSLog(@"HERE");
	NSLog(@"Pushing: %@", [item description]);
	return YES;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
	NSLog(@"over here");
	return YES;
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item{
	NSLog(@"thing 1");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addAnOb {
	// use this to find the location of the database on your mechine disk.
	if(TESTING){
		ALog(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory  inDomains:NSUserDomainMask] lastObject]);
	}
	
	BOOL success = NO;
	NSString *alertString = @"Data insertion failed";
	
	// get image asset
	NSString *img = [NSString stringWithFormat:@"%@", selectedAsset];//self.capedImg];

	//ALog(@"SelectedAsset: %@", selectedAsset);
	if (selectedAsset == nil){
		NSLog(@"You cannot submit that");
		return;
	}
	
	float highestError = bestLocationForImage.horizontalAccuracy;
	
	if (highestError < bestLocationForImage.verticalAccuracy) {
		highestError = bestLocationForImage.verticalAccuracy;
	}
	
	NSDate* localDateTime = [NSDate dateWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:bestLocationForImage.timestamp];
	
	success = [[UserDataDatabase getSharedInstance]
			   saveObservation:img
			   date: [NSString stringWithFormat:@"%@", localDateTime]
			   latitude: [NSNumber numberWithDouble:bestLocationForImage.coordinate.latitude]
			   longitude: [NSNumber numberWithDouble:bestLocationForImage.coordinate.longitude]
			   locationError:[NSNumber numberWithFloat:highestError]
			   percentIDed:NULL];
	
	if (success == NO) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
	
	[self displayMyObservationsVC];
}


- (void)displayMyObservationsVC {
	NSString * storyboardName = @"Main";
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
	UITabBarController * tbc = [storyboard instantiateViewControllerWithIdentifier:@"MyObservations"];

	NSMutableArray *nc0 = [[NSMutableArray alloc] initWithArray:[[self navigationController] viewControllers]];


	[nc0 removeLastObject];
	
	long c = [nc0 count] - 1;
	
	if (! [[[nc0 objectAtIndex:c] title] isEqualToString:[tbc title]] ) {
		[nc0 addObject:tbc];
	}
	
	NSArray *nc3 = [[NSArray alloc] initWithArray:nc0];

	[[self navigationController] setViewControllers:nc3 animated:YES];
}

- (void)saveImageToPhotoAlbum{
	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
	// i am not saving the images with the correct orientation.
	[library writeImageToSavedPhotosAlbum:([[self captureManager] stillImage].CGImage)
							  orientation: (ALAssetOrientation) [[self captureManager] stillImage].imageOrientation
						  completionBlock:^(NSURL *assetURL, NSError *error) {
							  selectedAsset = [NSString stringWithFormat:@"%@", assetURL];
							  NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
													 error ?: [NSNull null], @"error",
													 nil];	// end of dictionary
							  [[NSNotificationCenter defaultCenter] postNotificationName:kImageCapturedSuccessfully
																				  object:nil
																				userInfo:params];
						  }];
}

- (void)didFinishSavingImageWithError:(NSNotification *)note{

	if ([note.userInfo objectForKey:@"error"] == NULL) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image could not be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
		[alert show];
	}
	else {
		imageView.image = [[self captureManager] stillImage];
		imageView.hidden = NO;

		[self hideTakePhotoBtn];
		[self prepRetakePhotoBtn];
		[self prepAddObservationBtn];
		[self addAnOb];
	}
}



#pragma mark - Actions
- (IBAction)retakePhotoBtn:(id)sender {
	[self hideAddObservationBtn];
	[self hideRetakePhotoBtn];
	[self prepTakePhotoBtn];
}

- (IBAction)takePhoto:(id)sender{
	bestLocationForImage = [[UserDataDatabase getSharedInstance] getBestKnownLocation];
	
	[self hideTakePhotoBtn];
	
	[[self captureManager] captureStillImage];
	[self prepRetakePhotoBtn];
	[self prepAddObservationBtn];
}

- (IBAction)addObservation:(UIButton *)sender {
	//ALog(@"Hit add observation button");
	
	self.addObsBtn.enabled = NO;
	[self saveImageToPhotoAlbum];
}

- (IBAction)selectButton:(id)sender {
	bestLocationForImage = [[UserDataDatabase getSharedInstance] getBestKnownLocation];
	[[[self captureManager] captureSession] stopRunning];

	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	imagePickerController.delegate = self;
	[self presentViewController:imagePickerController animated:YES completion:nil];
}

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	//You can retrieve the actual UIImage
	UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
	//Or you can get the image url from AssetsLibrary
	NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
	
	[picker dismissViewControllerAnimated:YES completion:^{
		[[self captureManager] setStillImage:image];
		[[self imageView] setHidden:NO];
		[[self imageView] setImage:image];
		
		[self prepRetakePhotoBtn];
		[self prepAddObservationBtn];
	}];
}

#pragma mark - Prep buttons

- (void) prepTakePhotoBtn{
	self.takePhotoBtn.hidden = NO;
	self.takePhotoBtn.enabled = YES;
	
	imageView.hidden = YES;
	selectedAsset = nil;
	pictureInfo = nil;
	[[captureManager captureSession] startRunning];
}
- (void) prepRetakePhotoBtn {
	self.retakePhotoBtn.hidden = NO;
	self.retakePhotoBtn.enabled = YES;
}
- (void) prepAddObservationBtn {
	[[self addObsBtn] setHidden:NO];
	[[self addObsBtn] setEnabled:YES];
}

#pragma mark - Hide buttons
- (void) hideTakePhotoBtn {
	[[self takePhotoBtn] setHidden:YES];
	[[self takePhotoBtn] setEnabled:NO];
	//[[captureManager captureSession] stopRunning];
}
- (void) hideRetakePhotoBtn {
	self.retakePhotoBtn.hidden = YES;
	self.retakePhotoBtn.enabled = NO;
}
- (void) hideAddObservationBtn {
	self.addObsBtn.hidden = YES;
	self.addObsBtn.enabled = NO;
}

- (void) printButtonState:(UIButton*) btn{
	ALog(@"Text:    %@", btn.titleLabel.text);
	ALog(@"Hidden:  %@", btn.hidden ? @"YES" : @"NO");
	ALog(@"Enabled: %@", btn.enabled ? @"YES" : @"NO");
	printf("\n");
}

/*
 #pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
 
 }
 */

@end



