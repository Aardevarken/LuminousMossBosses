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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
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
}

- (void)viewWillDisappear:(BOOL)animated{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) saveObsToPhotos{
	ALog(@"This method is marked for removal and its code has been commented out");
//	// save image to photos
//	__block BOOL didItWork = NO;
//	
//	if(selectedAsset == nil){
//		ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//		[library writeImageToSavedPhotosAlbum:((UIImage *)[pictureInfo objectForKey:UIImagePickerControllerOriginalImage]).CGImage//(imageView.image).CGImage
//									 metadata:[pictureInfo objectForKey:UIImagePickerControllerMediaMetadata]
//							  completionBlock:^(NSURL *assetURL, NSError *error) {
//								  
//								  selectedAsset = [NSString stringWithFormat:@"%@", assetURL];
//								  /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"assetURL: %@", assetURL]
//								   message:nil
//								   delegate:nil
//								   cancelButtonTitle:@"OK"
//								   otherButtonTitles:nil];
//								   */
//								  NSLog(@"selected asset: %@", selectedAsset);
//								  didItWork = YES;
//								  //[alert show];
//							  }];
//		NSLog(@"func selectedAsset: %@", selectedAsset);
//	}
//	selectedAsset = [pictureInfo objectForKey:@"UIImagePickerControllerReferenceURL"];
}

/*
 * imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"]; 
 * stores the hex id for the image in imageView under _storage in a UIImage format
 */
// This method is called when an image has been chosen from the library or taken from the camera.
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	ALog(@"This method is marked for removal and its code has been commented out");
//	[picker dismissViewControllerAnimated:YES completion:NULL];
//	//imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//	
//	// display the image
//	UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
//	NSString *urlPath = [[info objectForKey:@"UIImagePickerControllerReferenceURL"] absoluteString];
//	self.capedImg = urlPath;
//	imageView.image = image;
//	selectedAsset = urlPath;
//	pictureInfo = info;
//	
//	
//	if(selectedAsset == nil){
//		ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//		[library writeImageToSavedPhotosAlbum:((UIImage *)[pictureInfo objectForKey:UIImagePickerControllerOriginalImage]).CGImage
//									 metadata:[pictureInfo objectForKey:UIImagePickerControllerMediaMetadata]
//							  completionBlock:^(NSURL *assetURL, NSError *error) {
//									selectedAsset = [NSString stringWithFormat:@"%@", assetURL];
//							  }];
//	}
//
//	// for testing
//	if(TESTING){
//	static int imgnum = 1;
//		NSString *breakSymbol = @"========================";
//		NSLog(@"%@ %i %@",breakSymbol, imgnum++, breakSymbol);
//		NSLog(@"imageView.image: %@", imageView.image);
//		NSLog(@"object: %@", [info objectForKey:@"UIImagePickerControllerOriginalImage"]);
//		NSLog(@"%@===%@",breakSymbol, breakSymbol);
//	}
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
	if (selectedAsset == nil){//self.capedImg == [NSString stringWithFormat:@"%@",[UIImage imageNamed:@"nocamera.png"]]) {
		NSLog(@"You cannot submit that");
		return;
	}
	
	float highestError = bestLocationForImage.horizontalAccuracy;
	
	if (highestError < bestLocationForImage.verticalAccuracy) {
		highestError = bestLocationForImage.verticalAccuracy;
	}
	
	success = [[UserDataDatabase getSharedInstance]
			   saveObservation:img
			   date: [NSString stringWithFormat:@"%@",bestLocationForImage.timestamp]
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
//	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Base.lprog/Main.storyboard" bundle:nil];
//	MyObservations *viewController = (MyObservations *)[storyboard instantiateViewControllerWithIdentifier:@"MyObservationsTabBarController"];
//	[self presentViewController:viewController animated:YES completion:nil];
	
	// try #2
//	NSString * storyboardName = @"Main";
//	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//	UITabBarController * tbc = [storyboard instantiateViewControllerWithIdentifier:@"ThisController12345"];
//	
//	//[self navigationController]
//	[self presentViewController:tbc animated:YES completion:nil];
	
	// try #3
	ObsViewController *myViewController = [[ObsViewController alloc] initWithNibName:nil bundle:nil];
	NSString * storyboardName = @"Main";
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
	UITabBarController * tbc = [storyboard instantiateViewControllerWithIdentifier:@"ThisController12345"];
//	UINavigationController *navigationController =[[UINavigationController alloc] initWithRootViewController:myViewController];
	
	//[[self navigationController] :NO];
	
	[[self navigationController] pushViewController:tbc animated:YES];
	
	//now present this navigation controller modally
	//[self presentViewController:navigationController
//					   animated:YES
//					 completion:^{
//						 
//					 }];
	
	// try #4
	//Present controller
	/*
	[self presentViewController:tbc
					   animated:YES
					 completion:nil];
	//Add to navigation Controller
	[self navigationController].viewControllers = [[self navigationController].viewControllers arrayByAddingObject:tbc];
	 */
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
	//ALog(@"Hit retake photo button");
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



