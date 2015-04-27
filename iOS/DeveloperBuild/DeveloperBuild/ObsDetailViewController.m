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

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

detectionHelper *detectionObject;

@interface ObsDetailViewController ()
@end

@implementation ObsDetailViewController
@synthesize nameLabel;
@synthesize percentLabel;
@synthesize dateLabel;
@synthesize obsImage;
@synthesize plantInfo;
@synthesize startRunning;
@synthesize longitudeLabel;
@synthesize latitudeLabel;
@synthesize locationLabel;
@synthesize tapToStartBtn;
@synthesize buttonSuperView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	nameLabel.text = [NSString stringWithFormat:@"%@", [plantInfo objectForKey:@"imghexid"]];
	percentLabel.text = [NSString stringWithFormat:@"%@%% ", [plantInfo objectForKey:@"percentIDed"]];
	dateLabel.text = [NSString stringWithFormat:@"%@", [plantInfo objectForKey:@"datetime"]];
	
	locationLabel.text = [
						  NSString stringWithFormat:@"%.4f° N, %.4f° W   ±%ld m",
						  [[plantInfo objectForKey:@"latitude"] floatValue],
						  [[plantInfo objectForKey:@"longitude"] floatValue],
						  [[plantInfo objectForKey:@"locationerror"] integerValue]];
	
	
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
	
	
	[[self tapToStartBtn] setTitle:@"Observation has been identified" forState:UIControlStateDisabled];

	// if this came from the identified tab
	if ([[plantInfo objectForKey:@"status"] isEqual:@"pending-noid"]){
        NSString* imghexid = [plantInfo objectForKey:@"imghexid"];
//		[[self startRunningBtn] setHidden:NO];
        detectionObject = [IdentifyingAssets getByimghexid:imghexid];
		
		if ([detectionObject.percentageComplete isEqualToNumber:[NSNumber numberWithInt:0]]){
			[self.startRunning setEnabled:NO];
			[self.activityIndicator startAnimating];
			[self hideTapToStartBtnText];
			[[self tapToStartBtn] setHidden:YES];
		}
		else {
			//[self setTapToStartBtnText];
			//[[self tapToStartBtn] setEnabled:NO];
			//..[[self startRunning] setEnabled:YES];
			//[self hideTapToStartBtnText];
			
		}
	}
	else {
		[self setTapToStartBtnText];
//		[startRunningBtn setHidden:YES];
//		[startRunningBtn setEnabled:NO];
//		[[self identifyView] setHidden:YES];
	}
}

- (void)viewWillAppear:(BOOL)animated{
	// add an observer to the identification helper object assosiated with the asset id
	[[IdentifyingAssets getByimghexid:[plantInfo objectForKey:@"imghexid"]] addObserver:self forKeyPath:@"percentageComplete" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
	
	NSString *t = [plantInfo objectForKey:@"isSilene"];
	NSString *name = [NSString alloc];
	
	if ([t isEqualToString:@"yes"]) {
		name = @"Silene";
	}
	else if ([t isEqualToString:@"idk"]){
		name = @"Unidentified";
	}
	else {
		name = @"Unknown";
	}
	
	nameLabel.text = name;
}

- (void)viewWillDisappear:(BOOL)animated{
	// remove the observer assosiated with the asset id.
	[[IdentifyingAssets getByimghexid:[plantInfo objectForKey:@"imghexid"]] removeObserver:self forKeyPath:@"percentageComplete"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * When the view loads call this function to prep the buttons and activity
 indicator.
 * Call this function when ever the state changes to have a new title for the 
 new state
 */
- (void)setTapToStartBtnText{
	// set the title of the tap to... button to represent the current state
	[[self tapToStartBtn] setTitle:[self getTitleOfBtnForState]
						  forState:UIControlStateNormal];
	
	// Show and enable the tap to... button
	[[self tapToStartBtn] setHidden:NO];
	[[self tapToStartBtn] setEnabled:YES];
	// hide and disable the running btn
	[[self startRunning] setHidden:YES];
	[[self startRunning] setEnabled:NO];
	// hide and stop the activity indicator
	[[self activityIndicator] setHidden:YES];
	[[self activityIndicator] stopAnimating];
}

/**
 * When the tapToStartBtn is pressed call this function to hide, show, start, 
 and disable the necessary items.
 */
- (void)hideTapToStartBtnText{
//	[[self tapToStartBtn] setEnabled:NO];
//	[[self tapToStartBtn] setHidden:YES];
	
	[[self startRunning] setHidden:NO];
	
	[[self activityIndicator] setHidden:NO];
	[[self activityIndicator] startAnimating];
}


/**
 * Given a state stored in plantInfo, getTitleOfBtnForState will return a string to be used as the
 * title of the tapToStartBtn.
 */
- (NSString*)getTitleOfBtnForState{
	NSString *state = [[self plantInfo] objectForKey:@"status"];
	NSString *tapTo = [NSString alloc];
	
	if ([state isEqual:@"pending-noid"]) {
		tapTo = @"Identify";
	}
	else if([state isEqual:@"pending-id"]){
		//tapTo = @"Sync";
		return [NSString stringWithFormat:@"Observation has been identified"];
	}
	else {
#warning needs to throw an erro if this is hit
		tapTo = @"...";
	}
	
	return [NSString stringWithFormat:@"Tap to %@", tapTo];
}

- (void)updateObservationData{
	// set everthing we just calculated
	obsImage.image = [detectionObject identifiedImage];
	percentLabel.text = [NSString stringWithFormat:@"%.0f%%",[[detectionObject probability] floatValue]*100];
	
	NSString *t = [plantInfo objectForKey:@"isSilene"];
	NSString *name = [NSString alloc];
	
	if ([detectionObject positiveID]) {
		percentLabel.textColor = [UIColor colorWithRed:0 green:255.f blue:0 alpha:1];
		name = @"Silene";

	} else {
		percentLabel.textColor = [UIColor colorWithRed:255.f green:0 blue:0 alpha:1];
		name = @"Unknown";
	}
	[[self nameLabel] setText:name];
	startRunning.hidden = YES;
	[[self tapToStartBtn] setHidden:NO];
}

- (IBAction)startButton:(UIButton *)sender {
	// Hide the tapToStartBtn
	[tapToStartBtn setEnabled:NO];
	[tapToStartBtn setHidden:YES];
	
	// show running btn, but keep it disabled.
#warning @"Running..." will be displayed before the title change. 
	[startRunning setTitle:[NSString stringWithFormat:@"Identifying ..."] forState:UIControlStateNormal];
	[startRunning setEnabled:NO];
	[startRunning setHidden:NO];
	
	//Start an activity indicator here
	[self.activityIndicator startAnimating];
	
	if ([[[self plantInfo] objectForKey:@"status"] isEqualToString:@"pending-noid"]) {
		[self startIdentification];
	}
	else {
#warning Need to make sure this case is never hit.
		ALog(@"THIS SHOULD NEVER HIT");
	}
}

/** 
 * Run the identification
 */
- (void)startIdentification{
	// run the detection algorithm.
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[detectionObject runDetectionAlgorithm:obsImage.image];
	});
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	
	if ([keyPath isEqualToString:@"percentageComplete"]) {
		
		if ([[change valueForKey:@"new"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
			dispatch_sync(dispatch_get_main_queue(), ^{
				[self updateObservationData];	// update the on screen data
				[[self activityIndicator] stopAnimating];	// stop the activity indicator
				[[self startRunning] setHidden:YES];	// hide the id button.
//				[[self identifyView] setHidden:YES];
				
				[[self tapToStartBtn] setHidden:NO];
				[[self tapToStartBtn] setEnabled:NO];
//				[self setTapToStartBtnText];
				
			});
		}
        
        // Changing back to -1 indicates an error with updating the database after identification.
        // Want to reset back to before identification was started.
        if ([[change valueForKey:@"new"] isEqualToNumber:[NSNumber numberWithInt:-1]]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [[self activityIndicator] stopAnimating];
		  });
        }
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
