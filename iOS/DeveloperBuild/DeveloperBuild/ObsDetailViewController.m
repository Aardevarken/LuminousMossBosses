//
//  ObsDetailViewController.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 3/14/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "ObsDetailViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ViewController.h"//"detectionHelper.h"

@interface ObsDetailViewController ()

@end

@implementation ObsDetailViewController
@synthesize nameLabel;
@synthesize percentLabel;
@synthesize dateLabel;
@synthesize obsImage;
@synthesize plantInfo;


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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startIdentificationButton:(UIButton *)sender {
	
	UIImage *idedImage = [ViewController runDetectionAlgorithm:obsImage.image];
	obsImage.image = idedImage;
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
