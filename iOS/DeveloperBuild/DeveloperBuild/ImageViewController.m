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
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#define TESTING YES
// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


@interface ImageViewController ()

@property (nonatomic, weak) NSTimer *cameraTimer;
@property (nonatomic) NSMutableArray *capturedImages;
@property (nonatomic, strong) NSString *capedImg;


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
@end

@implementation ImageViewController{
	NSString *selectedAsset;
	NSDictionary *pictureInfo;
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
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImageToPhotoAlbum) name:kImageCapturedSuccessfully object:nil];	// T2
		
		[self hideAddObservationBtn];
		[self hideRetakePhotoBtn];
		[self prepTakePhotoBtn];
	}
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


#pragma mark - Actions
- (IBAction)retakePhotoBtn:(id)sender {
	ALog(@"Hit retake photo button");
	[self hideAddObservationBtn];
	[self hideRetakePhotoBtn];
	[self prepTakePhotoBtn];
}

- (IBAction)takePhoto:(id)sender{
	ALog(@"hit take photo button");
	[self hideTakePhotoBtn];
	[self prepRetakePhotoBtn];
	[self prepAddObservationBtn];
	
	[[self captureManager] captureStillImage];
}

- (IBAction)addObservation:(UIButton *)sender {
	ALog(@"Hit add observation button");
	[self saveImageToPhotoAlbum];

	[self addAnOb];
}

- (void) addAnOb {
	// use this to find the location of the database on your mechine disk.
	if(TESTING){
		NSLog(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory  inDomains:NSUserDomainMask] lastObject]);
	}
	
	BOOL success = NO;
	NSString *alertString = @"Data insertion failed";
	
	// get image asset
	NSString *img = [NSString stringWithFormat:@"%@", selectedAsset];//self.capedImg];

	if (selectedAsset == nil){//self.capedImg == [NSString stringWithFormat:@"%@",[UIImage imageNamed:@"nocamera.png"]]) {
		NSLog(@"You cannot submit that");
		return;
	}
	
	success = [[UserDataDatabase getSharedInstance] saveObservation:img date:nil latitude:nil longitude:nil locationError:[NSNumber numberWithDouble:100.0] percentIDed:NULL];
	
	if (success == NO) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
	/*** END OF CODE REVIEW ***/

}

- (void)saveImageToPhotoAlbum{
	UIImage *newImage = [[self captureManager] stillImage].CGImage;
	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
	// i am not saving the images with the correct orientation.
	[library writeImageToSavedPhotosAlbum:([[self captureManager] stillImage].CGImage)
								 metadata: pictureInfo
						  completionBlock:^(NSURL *assetURL, NSError *error) {
							  selectedAsset = [NSString stringWithFormat:@"%@", assetURL];
							  ALog(@"\n\nselected asset: %@\n\n", selectedAsset);
							  
							  imageView.image = [[self captureManager] stillImage];
							  imageView.hidden = NO;
							  
							  [self hideTakePhotoBtn];
							  [self prepRetakePhotoBtn];
							  [self prepAddObservationBtn];
							  [self addAnOb];
						  }];
	
//	ALog(@"selected asset: %@", selectedAsset);
	
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{

	
	if (error != NULL) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image could not be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
		[alert show];
	}
	else {
		imageView.image = image;
		imageView.hidden = NO;
		
		[self hideTakePhotoBtn];
		[self prepRetakePhotoBtn];
		[self prepAddObservationBtn];
	}
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
	self.addObsBtn.hidden = NO;
	self.addObsBtn.enabled = YES;
}

#pragma mark - Hide buttons
- (void) hideTakePhotoBtn {
	self.takePhotoBtn.hidden = YES;
	self.takePhotoBtn.enabled = NO;
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


/*
 #pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
 
 }
 */

@end



