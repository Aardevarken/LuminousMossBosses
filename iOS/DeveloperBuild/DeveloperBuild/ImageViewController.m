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

@interface ImageViewController ()
//-(UIImage*) runDetection:(UIImage *)image classifierName:(NSString *)cName classifierType:(NSString *)cType;

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

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	[picker dismissViewControllerAnimated:YES completion:NULL];
	imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
	//UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	//imageView.image = [self runDetection:image classifierName:@"flower25" classifierType:@"xml"];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/* from old tutorial */
/*
- (IBAction)takePhoto:(UIButton *)sender {
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	
	[self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectPhoto:(UIButton *)sender
{
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	
	[self presentViewController:picker animated:YES completion:NULL];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
	self.imageView.image = chosenImage;
	
	[picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[picker dismissViewControllerAnimated:YES completion:NULL];
}
 */
@end








