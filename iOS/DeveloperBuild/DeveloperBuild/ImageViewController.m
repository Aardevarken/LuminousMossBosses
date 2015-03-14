//
//  ImageViewController.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 2/24/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "ImageViewController.h"
#import "opencv2/highgui/ios.h"
#import "detector.h"
#import "MyObservations.h"

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

@implementation ImageViewController
@synthesize imageView, choosePhotoBtn, takePhotoBtn;

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


- (IBAction)addObservation:(UIButton *)sender {
	
	// use this to find the location of the database on your mechine disk.
	if(false)
		NSLog(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory  inDomains:NSUserDomainMask] lastObject]);
	
	BOOL success = NO;
	NSString *alertString = @"Data insertion failed";
	NSString *img = [NSString stringWithFormat:@"%@", self.capedImg];
	if(TRUE){
		success = [[UserDataDatabase getSharedInstance] saveData:img date:0 latitude:[NSNumber numberWithDouble:1.0] longitude:[NSNumber numberWithDouble:-1.0] percentIDed:[NSNumber numberWithDouble:0.05]];
	}
	else {
	}
	
	if (success == NO) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
	
	NSArray *data = [[UserDataDatabase getSharedInstance] findByImgID:@"test1"];
	if (data == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data not found" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
	else {
		if (TESTING){
			for (id row in data){
				NSEnumerator *enumerator = [row keyEnumerator];
				id key;
				while ((key = [enumerator nextObject])) {
					NSString *element = [row objectForKey:key];
					NSLog(@"%@: %@", key, element);
				}
				NSLog(@"------");
			}
		}
	}
	
	
}

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

/*
 * imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"]; 
 * stores the hex id for the image in imageView under _storage in a UIImage format
 */

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	[picker dismissViewControllerAnimated:YES completion:NULL];
	//imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
	UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
	NSString *urlPath = [[info objectForKey:@"UIImagePickerControllerReferenceURL"] absoluteString];
	self.capedImg = urlPath;
	imageView.image = image;
	
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

@end








