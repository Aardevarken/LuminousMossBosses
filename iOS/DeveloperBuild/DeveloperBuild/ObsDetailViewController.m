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
#import "UserDataDatabase.h"

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
            UIImageOrientation orientation = (UIImageOrientation) (int) r.orientation;
			obsImage.image = [UIImage imageWithCGImage:r.fullResolutionImage scale:r.scale orientation:orientation];
            
		}
			failureBlock: nil];
	}
	
	
	// hide the progress bar when the page is loaded.
	progressBar.hidden = YES;
	[progressBar setProgress:0.0 animated:NO];
	
	// if this came from the identified tab
	if (![[plantInfo objectForKey:@"status"] isEqual:@"pending-noid"]){
		[idButton setEnabled:NO];
		idButton.hidden = YES;
	}
	else {
		[progressBar setProgress:0.0 animated:NO];
	}
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
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		//[detectionHelper runDetectionAlgorithm:obsImage.image progressBar:progressBar maxPercentToFill:1.0];
		detectionHelper *detectionObject = [[detectionHelper alloc] initWithAssetID:[plantInfo objectForKey:@"imghexid"]];
		[detectionObject runDetectionAlgorithm:obsImage.image progressBar:progressBar maxPercentToFill:1.0];
		
		dispatch_sync(dispatch_get_main_queue(), ^{
			if ([detectionObject getIsSilene]) {
				percentLabel.text = @"100%";
			}
			else{
				percentLabel.text = @"0%";
			}
			
			// set everthing we just calculated
			obsImage.image = [detectionObject getIdentifiedImage];
			percentLabel.text = [NSString stringWithFormat:@"%.0f%%",[detectionObject getIDProbability]*100];
			if ([detectionObject getIsSilene]) {
				percentLabel.textColor = [UIColor colorWithRed:0 green:255.f blue:0 alpha:1];
			} else {
				percentLabel.textColor = [UIColor colorWithRed:255.f green:0 blue:0 alpha:1];
			}
			
			// update the table row
			// prep variables
			NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
			[nf setMaximumFractionDigits:2];
			float newprob = floorf([detectionObject getIDProbability]*100 + 0.5);
			NSNumber *NSnewprob = [NSNumber  numberWithFloat:newprob];
			NSString *assetid = [NSString stringWithFormat:@"%@",[plantInfo objectForKey:@"imghexid"]];
			NSString *newState = @"pending-id";
			
			// update row variables
			BOOL success = [[UserDataDatabase getSharedInstance]
							updateRow:assetid andNewPercentIDed:NSnewprob andNewStatus:newState];
			
			//[[UserDataDatabase getSharedInstance] updateRow:assetid percentIDed:NSnewprob state:newState];
							//updateRow:assetid percentIDed:NSnewprob state:newState];
			
			
			// did it all work? if not show an error.
			NSString *alertString = @"Data update failed";
			if (success == NO) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
			}
			/*
			NSNumber *dp = [NSNumber numberWithFloat:[detectionObject getIDProbability]];
			BOOL success = [[UserDataDatabase getSharedInstance] saveData:[plantInfo objectForKey:@"imghexid"] date:[plantInfo objectForKey:@"date"] latitude:[plantInfo objectForKey:@"latitiude"] longitude:[plantInfo objectForKey:@"longitude"] percentIDed:dp];
			
			NSString *alertString = @"Data update failed";
			if (success == NO) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
			}
			 */
			
			// hide the progress bar and the button so the text can be seen
			progressBar.hidden = YES;
			idButton.hidden = YES;
		});
	});
	//progressBar.hidden = YES;

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
