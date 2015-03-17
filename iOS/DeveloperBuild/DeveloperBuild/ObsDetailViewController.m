//
//  ObsDetailViewController.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 3/14/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "ObsDetailViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "detectionHelper.h"
#import "detector.h"
#import "opencv2/highgui/ios.h"

@interface ObsDetailViewController ()

@end

@implementation ObsDetailViewController
@synthesize nameLabel;
@synthesize percentLabel;
@synthesize dateLabel;
@synthesize obsImage;
@synthesize plantInfo;
@synthesize progressBar;
@synthesize idButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	nameLabel.text = [NSString stringWithFormat:@"Name: %@", [plantInfo objectForKey:@"imghexid"]];
	percentLabel.text = [NSString stringWithFormat:@"%@%% ", [plantInfo objectForKey:@"percentIDed"]];
	dateLabel.text = [NSString stringWithFormat:@"Date: %@", [plantInfo objectForKey:@"date"]];
	
	NSURL *url = [NSURL URLWithString:[plantInfo objectForKey:@"imghexid"]];

	if (![url  isEqual: @"(null)"]) {
		ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
		
		[lib assetForURL: url resultBlock: ^(ALAsset *asset) {
			ALAssetRepresentation *r = [asset defaultRepresentation];
			obsImage.image = [UIImage imageWithCGImage: r.fullResolutionImage];
		}
			failureBlock: nil];
	}
	
	// hide the progress bar when the page is loaded.
	progressBar.hidden = YES;
	//progressBar = [[UIProgressView alloc] init];
	[progressBar setProgress:0.0 animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateProgBar:(UIProgressView*)progbar amount:(float)amount{
	[progbar setProgress:amount animated:YES];
}

- (IBAction)startIdentificationButton:(UIButton *)sender {
	//Start an activity indicator here

	progressBar.hidden = NO;
	BOOL animate = NO;
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSLog(@"running in background");
		
		//Call your function or whatever work that needs to be done
		//Code in this part is run on a background thread
		
		// show progress bar
		//progressBar.hidden = NO;
		//NSNumber *totalProgressForDetection = [[NSNumber alloc] initWithFloat:0.9];
		float totalProgressForDetection = 0.9;
		//[self performSelectorOnMainThread:@selector(updateProgBar:amount:) withObject:<#(id)#> waitUntilDone:<#(BOOL)#>]
		dispatch_sync(dispatch_get_main_queue(), ^(void) {
			
			//Stop your activity indicator or anything else with the GUI
			//Code here is run on the main thread
			//NSLog(@"bar = 0");
			[progressBar setProgress:0.1 animated:animate];
			//progressBar.progress = 0.0;
		});

		/*UIImage *idedImage = [detectionHelper runDetectionAlgorithm:obsImage.image progressBar:progressBar maxPercentToFill:totalProgressForDetection];
		 */
		float percentMultiplier = totalProgressForDetection;
		int numberOfUpdates = 7;
		int updateNumber = 1;
		UIImage *unknownImage = obsImage.image;
		// Create mat image
		Mat cvImage;
		//[progressBar setProgress:percentMultiplier*(updateNumber/numberOfUpdates++)];
		UIImageToMat(unknownImage, cvImage);
		//[progressBar setProgress:percentMultiplier*(updateNumber/numberOfUpdates++)];
		// Load OpenCV classifier
		
		NSString *flowerXMLPath = [[NSBundle mainBundle] pathForResource:@"flower25" ofType:@"xml"];
		//[progressBar setProgress:percentMultiplier*(updateNumber/numberOfUpdates++)];
		NSString *vocabXMLPath = [[NSBundle mainBundle] pathForResource:@"vocabulary" ofType:@"xml"];
		//[progressBar setProgress:percentMultiplier*(updateNumber/numberOfUpdates++)];
		NSString *sileneXMLPath = [[NSBundle mainBundle] pathForResource:@"silene" ofType:@"xml"];
		//[progressBar setProgress:percentMultiplier*(updateNumber/numberOfUpdates++)];
		
		
		dispatch_sync(dispatch_get_main_queue(), ^(void) {
			
			//Stop your activity indicator or anything else with the GUI
			//Code here is run on the main thread
			
		});
		
		// run detection
		dispatch_sync(dispatch_get_main_queue(), ^{
			//NSLog(@"bar = 0.3");
			[progressBar setProgress:0.2 animated:animate];
			//progressBar.progress = 0.3;//((float)pageDownload/(float)pagesToDownload);
		});
		//progressBar.progress = 0.9;
		detector flowerDetector([flowerXMLPath UTF8String], [vocabXMLPath UTF8String], [sileneXMLPath UTF8String]);
		//[progressBar setProgress:percentMultiplier*(updateNumber/numberOfUpdates++)];
		
		// Circle flowers
		dispatch_sync(dispatch_get_main_queue(), ^(void) {
			
			//Stop your activity indicator or anything else with the GUI
			//Code here is run on the main thread
			//NSLog(@"bar = 0.8");
			[progressBar setProgress:0.3 animated:animate];
			//progressBar.progress = 0.9;
		});

		Mat detectedImage = flowerDetector.circlePinkFlowers(cvImage);
		//[progressBar setProgress:percentMultiplier*(updateNumber/numberOfUpdates++)];
		dispatch_sync(dispatch_get_main_queue(), ^(void) {
			
			//Stop your activity indicator or anything else with the GUI
			//Code here is run on the main thread
			//NSLog(@"bar = 0.9");
			[progressBar setProgress:0.85 animated:YES];
			//progressBar.progress = 0.9;
		});
		
		UIImage *newImage = MatToUIImage(detectedImage);

		
		dispatch_sync(dispatch_get_main_queue(), ^(void) {
			
			//Stop your activity indicator or anything else with the GUI
			//Code here is run on the main thread
			//NSLog(@"bar = 0.9");
			[progressBar setProgress:0.95 animated:animate];
			//progressBar.progress = 0.9;
		});
		
		
		
		dispatch_sync(dispatch_get_main_queue(), ^(void) {
			
			//Stop your activity indicator or anything else with the GUI
			//Code here is run on the main thread
			//NSLog(@"updating image");
			obsImage.image = newImage;
			percentLabel.text = @"100";
			
			[progressBar setProgress:1.00 animated:animate];
			progressBar.hidden = YES;
			idButton.hidden = YES;
		});
		

		NSLog(@"leaving background");
	});
	
	//progressBar.hidden = NO;
	//[progressBar set]

}


#pragma mark - Navigation

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	if ([segue.identifier isEqualToString:@"MyObsSegue"]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	}
}
*/

@end
