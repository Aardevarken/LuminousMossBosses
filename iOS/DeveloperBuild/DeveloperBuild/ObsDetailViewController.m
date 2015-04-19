//
//  ObsDetailViewController.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 3/14/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "ObsDetailViewController.h"
#import "detectionHelper.h"
#import "UserDataDatabase.h"
#import "IdentifyingAssets.h"
#import <AssetsLibrary/AssetsLibrary.h>

static NSMutableArray *runningAldOnAsset;
detectionHelper *detectionObject;

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
@synthesize longitudeLabel;
@synthesize latitudeLabel;
//@synthesize activityIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	nameLabel.text = [NSString stringWithFormat:@"Name: %@", [plantInfo objectForKey:@"imghexid"]];
	percentLabel.text = [NSString stringWithFormat:@"%@%% ", [plantInfo objectForKey:@"percentIDed"]];
	dateLabel.text = [NSString stringWithFormat:@"Date: %@", [plantInfo objectForKey:@"datetime"]];
	latitudeLabel.text = [NSString stringWithFormat:@"%@", [plantInfo objectForKey:@"latitude"]];
	longitudeLabel.text = [NSString stringWithFormat:@"%@", [plantInfo objectForKey:@"longitude"]];

	
	
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
	
	// Initiate the dictionary once.
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		runningAldOnAsset = [[NSMutableArray alloc] init];//[[self alloc] init];
	});
	
	/*Refactoring out progress bar*/
	//progressBar.hidden = YES;
	//[progressBar setProgress:0.0 animated:NO];
	// if this came from the identified tab
	if ([[plantInfo objectForKey:@"status"] isEqual:@"pending-noid"]){
		//[idButton setEnabled:NO];
		//idButton.hidden = YES;
		startActivityIndicator = -1;
		/*
		for (int assetRefNum = 0; assetRefNum < runningAldOnAsset.count; ++assetRefNum){
			if([runningAldOnAsset[assetRefNum] isEqualToString:[plantInfo objectForKey:@"imghexid"]]){
				NSLog(@"Already in array");
				[[self activityIndicator ]startAnimating];	//startActivityIndicator = assetRefNum;
				[idButton setEnabled:NO];
				break;
			}
		}
		*/
		NSLog(@"%@",[[IdentifyingAssets getSharedInstance].unknownAssets description]);
		
		if ((detectionObject = [[IdentifyingAssets getSharedInstance].unknownAssets objectForKey:[plantInfo objectForKey:@"imghexid"]]) == nil) {

			detectionObject = [[detectionHelper alloc] initWithAssetID:[plantInfo objectForKey:@"imghexid"]];
			
			[[IdentifyingAssets getSharedInstance].unknownAssets setValue:detectionObject forKey:[plantInfo objectForKey:@"imghexid"]];
		}
		else if ([detectionObject.percentageComplete isEqualToNumber:[NSNumber numberWithInt:-1]]){
			
		}
		else if ([detectionObject.percentageComplete isEqualToNumber:[NSNumber numberWithInt:0]]){
			[self.idButton setEnabled:NO];
			[self.activityIndicator startAnimating];
		}
		else if ([detectionObject.percentageComplete isEqualToNumber:[NSNumber numberWithInt:1]]){
			
		}
		
		
	}
	else {
		[idButton setEnabled:NO];
		//_activityIndicator.hidden = YES;
		//[progressBar setProgress:0.0 animated:NO];
	}
	/*End of refactoring*/
	
	NSLog(@"self(%@) ai: %@", self.activityIndicator.description);
	
}

- (void)viewWillAppear:(BOOL)animated{
	[[[IdentifyingAssets getSharedInstance].unknownAssets objectForKey:[plantInfo objectForKey:@"imghexid"]] addObserver:self forKeyPath:@"percentageComplete" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
	[[[IdentifyingAssets getSharedInstance].unknownAssets objectForKey:[plantInfo objectForKey:@"imghexid"]] removeObserver:self forKeyPath:@"percentageComplete"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateProgBar:(UIProgressView*)progbar amount:(float)amount{
	[progbar setProgress:amount animated:YES];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	
	if ([keyPath isEqualToString:@"percentageComplete"]) {
		NSLog(@"%@", change.description);
		
		if ([[change valueForKey:@"new"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
			dispatch_sync(dispatch_get_main_queue(), ^{
				[[self activityIndicator] stopAnimating];
				[[self idButton] setHidden:YES];
				NSLog(@"<SELF IND: %@", self.activityIndicator.description);
				[self updateObservationData];
			});
		}
	}
}

- (void)updateObservationData{
	NSLog(@"Done Iding");
	//[self stopCircle];
	if ([detectionObject getIsSilene]) {
		percentLabel.text = @"100%";
	}
	else{
		percentLabel.text = @"0%";
	}
	
	//sleep(20);
	// set everthing we just calculated
	obsImage.image = [detectionObject getIdentifiedImage];
	//[self setValue:[NSString stringWithFormat:@"%.0f%%",[detectionObject getIDProbability]*100] forKeyPath:@"percentLabel.text"];
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
	
	if(FALSE){
		// update row variables
		BOOL success = [[UserDataDatabase getSharedInstance]
						updateObservation:assetid andNewPercentIDed:NSnewprob andNewStatus:newState];
		
		// did it all work? if not show an error.
		NSString *alertString = @"Data update failed";
		if (success == NO) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		}
	}
	// hide the progress bar and the button so the text can be seen
	
	/*Refactor out progress bar* /
	 progressBar.hidden = YES;
	 /*End of refactoring*/
	
	[runningAldOnAsset removeObject:[plantInfo objectForKey:@"imghexid"]];
	//[self stopCircle];
	idButton.hidden = YES;
	NSLog(@"ALL DONE HERE");
}

- (IBAction)startIdentificationButton:(UIButton *)sender {
	//Start an activity indicator here

	/*Refactor out progress bar* /
	progressBar.hidden = NO;
	/*End of refactoring*/
	
	if (startActivityIndicator == -1) {
		///////////////
		// test code //
		static int test = 0;
		/** /
		detectionHelper *detectionObject = [[detectionHelper alloc] initWithAssetID:[plantInfo objectForKey:@"imghexid"]];
		
		[[IdentifyingAssets getSharedInstance].unknownAssets setValue:detectionObject forKey:[plantInfo objectForKey:@"imghexid"]];
		
		NSLog(@"dic: %@", [IdentifyingAssets getSharedInstance].unknownAssets.description);
		
		[[[IdentifyingAssets getSharedInstance].unknownAssets objectForKey:[plantInfo objectForKey:@"imghexid"]] addObserver:self forKeyPath:@"percentageComplete" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
		/**/
		// end of test code //
		//////////////////////
		
		[runningAldOnAsset addObject:[plantInfo objectForKey:@"imghexid"]];
		[self.activityIndicator startAnimating];
		[idButton setEnabled:NO];
		
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

			//detectionHelper *detectionObject = [[detectionHelper alloc] initWithAssetID:[plantInfo objectForKey:@"imghexid"]];
			[detectionObject runDetectionAlgorithm:obsImage.image];
			
			
//			dispatch_sync(dispatch_get_main_queue(), ^{
//				NSLog(@"Done Iding");
//				//[self stopCircle];
//				if ([detectionObject getIsSilene]) {
//					percentLabel.text = @"100%";
//				}
//				else{
//					percentLabel.text = @"0%";
//				}
//				
//				//sleep(20);
//				// set everthing we just calculated
//				obsImage.image = [detectionObject getIdentifiedImage];
//				//[self setValue:[NSString stringWithFormat:@"%.0f%%",[detectionObject getIDProbability]*100] forKeyPath:@"percentLabel.text"];
//				percentLabel.text = [NSString stringWithFormat:@"%.0f%%",[detectionObject getIDProbability]*100];
//				if ([detectionObject getIsSilene]) {
//					percentLabel.textColor = [UIColor colorWithRed:0 green:255.f blue:0 alpha:1];
//				} else {
//					percentLabel.textColor = [UIColor colorWithRed:255.f green:0 blue:0 alpha:1];
//				}
//				
//				// update the table row
//				// prep variables
//				NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
//				[nf setMaximumFractionDigits:2];
//				float newprob = floorf([detectionObject getIDProbability]*100 + 0.5);
//				NSNumber *NSnewprob = [NSNumber  numberWithFloat:newprob];
//				NSString *assetid = [NSString stringWithFormat:@"%@",[plantInfo objectForKey:@"imghexid"]];
//				NSString *newState = @"pending-id";
//				
//				if(FALSE){
//					// update row variables
//					BOOL success = [[UserDataDatabase getSharedInstance]
//									updateObservation:assetid andNewPercentIDed:NSnewprob andNewStatus:newState];
//					
//					// did it all work? if not show an error.
//					NSString *alertString = @"Data update failed";
//					if (success == NO) {
//						UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//						[alert show];
//					}
//				}
//				// hide the progress bar and the button so the text can be seen
//				
//				/*Refactor out progress bar* /
//				progressBar.hidden = YES;
//				/*End of refactoring*/
//				
//				[runningAldOnAsset removeObject:[plantInfo objectForKey:@"imghexid"]];
//				//[self stopCircle];
//				idButton.hidden = YES;
//				NSLog(@"ALL DONE HERE");
//			});
		});
	}
	else{
		[NSError errorWithDomain:@"idbutton is not disabled" code:100 userInfo:nil];
	}
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
