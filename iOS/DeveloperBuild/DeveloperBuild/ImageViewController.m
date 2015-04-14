//
//  ImageViewController.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 2/24/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "ImageViewController.h"
//#import "opencv2/highgui/ios.h"
//#import "detector.h"
#import "MyObservations.h"
#import <AssetsLibrary/AssetsLibrary.h>

// for testing //
#import "UserDataDatabase.h"
//#import "UserData.h"
// end testing //
#define TESTING 0


@interface ImageViewController ()

//-(UIImage*) runDetection:(UIImage *)image classifierName:(NSString *)cName classifierType:(NSString *)cType;

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



- (IBAction)getPhoto:(id)sender{
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	
	
	if ((UIButton *) sender == choosePhotoBtn) {
		picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	} else {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	
	
	
	//[self presentModalViewController:picker animated:YES];
	[self presentViewController:picker animated:YES completion:NULL];
}

- (void) saveObsToPhotos{
	// save image to photos
	__block BOOL didItWork = NO;
	
	if(selectedAsset == nil){
		ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
		[library writeImageToSavedPhotosAlbum:((UIImage *)[pictureInfo objectForKey:UIImagePickerControllerOriginalImage]).CGImage//(imageView.image).CGImage
									 metadata:[pictureInfo objectForKey:UIImagePickerControllerMediaMetadata]
							  completionBlock:^(NSURL *assetURL, NSError *error) {
								  
								  //NSLog(@"assertURL %@", assetURL);
								  
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

- (IBAction)addObservation:(UIButton *)sender {
	
	// use this to find the location of the database on your mechine disk.
	if(false)
		NSLog(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory  inDomains:NSUserDomainMask] lastObject]);
	
	BOOL success = NO;
	NSString *alertString = @"Data insertion failed";
	
	// save image to photos
	//[self saveObsToPhotos];
	
	// get image asset
	NSString *img = [NSString stringWithFormat:@"%@", selectedAsset];//self.capedImg];
	
	// get current date and time
	/* **************************************************************** *\
	|* for unicode info about the date format reference:				*|
	|* http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns	*|
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
	
	if(TRUE){
		success = [[UserDataDatabase getSharedInstance] saveObservation:img date:nullptr latitude:nullptr longitude:nullptr locationError:[NSNumber numberWithDouble:100.0] percentIDed:NULL];
	}
	else {
	}
	
	if (success == NO) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
	
}

/*
- (UIImage*) runDetection:(UIImage *)image{
	
	// Convert image to Mat for detection
	Mat cvImage;
	UIImageToMat(image, cvImage);
	
    // Load OpenCV classifier
    NSString* flowerXMLPath = [[NSBundle mainBundle]
                               pathForResource:@"flower25"
                               ofType:@"xml"];
    NSString* vocabXMLPath = [[NSBundle mainBundle]
                              pathForResource:@"vocabulary"
                              ofType:@"xml"];
    NSString* sileneXMLPath = [[NSBundle mainBundle]
                               pathForResource:@"silene"
                               ofType:@"xml"];
    
    detector flowerDetector([flowerXMLPath UTF8String], [vocabXMLPath UTF8String], [sileneXMLPath UTF8String]);
	
	// circle flowers
	Mat detectedImage = flowerDetector.circlePinkFlowers(cvImage);
	
	// return UIImage
	return MatToUIImage(detectedImage);
}
*/
/*
 * imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"]; 
 * stores the hex id for the image in imageView under _storage in a UIImage format
 */
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
		[library writeImageToSavedPhotosAlbum:((UIImage *)[pictureInfo objectForKey:UIImagePickerControllerOriginalImage]).CGImage//(imageView.image).CGImage
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
	//UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	//imageView.image = [self runDetection:image classifierName:@"flower25" classifierType:@"xml"];
}


// This method is called when an image has been chosen from the library or taken from the camera.
/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
 
	[self.capturedImages addObject:image];
 
	if ([self.cameraTimer isValid])
	{
		return;
	}
 
	[self finishAndUpdate];
}
*/

#pragma mark - Navigation

/** /
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	if ([segue.identifier isEqualToString:@"AddingObservationSegue"]) {
		[self.navigationController popToRootViewControllerAnimated:NO];
	}
}
/**/
@end






