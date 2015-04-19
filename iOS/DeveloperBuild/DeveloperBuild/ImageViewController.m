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


@interface ImageViewController ()

@property (nonatomic, weak) NSTimer *cameraTimer;
@property (nonatomic) NSMutableArray *capturedImages;
@property (nonatomic, strong) NSString *capedImg;

@end

@implementation ImageViewController{
	NSString *selectedAsset;
	NSDictionary *pictureInfo;
}

@synthesize imageView, choosePhotoBtn, takePhotoBtn;
@synthesize addObsBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// check to make sure the device has a camera
	if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		// display no camera icon
		imageView.image = [UIImage imageNamed:@"nocamera.png"];
		
		// display alert box
		UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"ERROR"
															  message:@"Device has no camera"
															 delegate:nil
													cancelButtonTitle:@"OK"
													otherButtonTitles:nil];
		[myAlertView show];
	}
	selectedAsset = nil;
	pictureInfo = nil;
	
	// create obs list object
	
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) saveObsToPhotos{
	// save image to photos
	__block BOOL didItWork = NO;
	
	if(selectedAsset == nil){
		ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
		[library writeImageToSavedPhotosAlbum:((UIImage *)[pictureInfo objectForKey:UIImagePickerControllerOriginalImage]).CGImage//(imageView.image).CGImage
									 metadata:[pictureInfo objectForKey:UIImagePickerControllerMediaMetadata]
							  completionBlock:^(NSURL *assetURL, NSError *error) {
								  
								  selectedAsset = [NSString stringWithFormat:@"%@", assetURL];
								  /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"assetURL: %@", assetURL]
								   message:nil
								   delegate:nil
								   cancelButtonTitle:@"OK"
								   otherButtonTitles:nil];
								   */
								  NSLog(@"selected asset: %@", selectedAsset);
								  didItWork = YES;
								  //[alert show];
							  }];
		NSLog(@"func selectedAsset: %@", selectedAsset);
		
	}
	
	selectedAsset = [pictureInfo objectForKey:@"UIImagePickerControllerReferenceURL"];
	
}

/*
 * imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"]; 
 * stores the hex id for the image in imageView under _storage in a UIImage format
 */
// This method is called when an image has been chosen from the library or taken from the camera.
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	[picker dismissViewControllerAnimated:YES completion:NULL];
	//imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
	// display the image
	UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
	NSString *urlPath = [[info objectForKey:@"UIImagePickerControllerReferenceURL"] absoluteString];
	self.capedImg = urlPath;
	imageView.image = image;
	selectedAsset = urlPath;
	pictureInfo = info;
	
	
	if(selectedAsset == nil){
		ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
		[library writeImageToSavedPhotosAlbum:((UIImage *)[pictureInfo objectForKey:UIImagePickerControllerOriginalImage]).CGImage
									 metadata:[pictureInfo objectForKey:UIImagePickerControllerMediaMetadata]
							  completionBlock:^(NSURL *assetURL, NSError *error) {
									selectedAsset = [NSString stringWithFormat:@"%@", assetURL];
							  }];
	}

	// for testing
	if(TESTING){
	static int imgnum = 1;
		NSString *breakSymbol = @"========================";
		NSLog(@"%@ %i %@",breakSymbol, imgnum++, breakSymbol);
		NSLog(@"imageView.image: %@", imageView.image);
		NSLog(@"object: %@", [info objectForKey:@"UIImagePickerControllerOriginalImage"]);
		NSLog(@"%@===%@",breakSymbol, breakSymbol);
	}
}


#pragma mark - Actions
- (IBAction)getPhoto:(id)sender{
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	
	
	if ((UIButton *) sender == choosePhotoBtn) {
		picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	} else {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	
	[self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)addObservation:(UIButton *)sender {
	
	// use this to find the location of the database on your mechine disk.
	if(TESTING){
		NSLog(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory  inDomains:NSUserDomainMask] lastObject]);
	}
	
	BOOL success = NO;
	NSString *alertString = @"Data insertion failed";
	
	// get image asset
	NSString *img = [NSString stringWithFormat:@"%@", selectedAsset];//self.capedImg];
	
	
	/*** NEEDS CODE REVIEW ***/
	// get current date and time
	 /* **************************************************************** *\
	 |* for unicode info about the date format reference:				 *|
	 |* http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns *|
	 \* **************************************************************** */
	NSDate *today = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
	[NSTimeZone resetSystemTimeZone];
	
	
	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	
	NSString *currentTime = [dateFormatter stringFromDate:today];
	
	//NSLog(@"%@", currentTime);
	//[dateFormatter release];
	
	if (selectedAsset == nil){//self.capedImg == [NSString stringWithFormat:@"%@",[UIImage imageNamed:@"nocamera.png"]]) {
		NSLog(@"You cannot submit that");
		return;
	}
	
	
	success = [[UserDataDatabase getSharedInstance] saveObservation:img date:nullptr latitude:nullptr longitude:nullptr locationError:[NSNumber numberWithDouble:100.0] percentIDed:NULL];
	
	if (success == NO) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
	/*** END OF CODE REVIEW ***/
}

/*
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

}
 */

/* Test code here */
- (void)initCapture
{
	AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
	if (!captureInput) {
		return;
	}
	AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
	/* captureOutput:didOutputSampleBuffer:fromConnection delegate method !*/
	[captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
	NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
	NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
	NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
	[captureOutput setVideoSettings:videoSettings];
	self.captureSession = [[AVCaptureSession alloc] init];
	NSString* preset = 0;
	if (!preset) {
		preset = AVCaptureSessionPresetMedium;
	}
	self.captureSession.sessionPreset = preset;
	if ([self.captureSession canAddInput:captureInput]) {
		[self.captureSession addInput:captureInput];
	}
	if ([self.captureSession canAddOutput:captureOutput]) {
		[self.captureSession addOutput:captureOutput];
	}
	
	//handle prevLayer
	if (!self.captureVideoPreviewLayer) {
		self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
	}
	
	//if you want to adjust the previewlayer frame, here!
	self.captureVideoPreviewLayer.frame = self.view.bounds;
	self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	[self.view.layer addSublayer: self.captureVideoPreviewLayer];
	[self.captureSession startRunning];
}
/* End of test code */
@end






