//
//  MyObsTabBarController.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/13/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "MyObsTabBarController.h"
#import "ImageViewController.h"


@interface MyObsTabBarController ()

@end

@implementation MyObsTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	//[self.navigationController popToRootViewControllerAnimated:NO];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)homeButton:(UIBarButtonItem *)sender {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

	if ([segue.identifier isEqualToString:@"HomeButtonSegue"]) {
		
		NSLog(@"hitting home button");
		//[self.navigationController popViewControllerAnimated:NO];
		// create instance of destination
		//ImageViewController *destViewController = segue.destinationViewController;
		
		//[self.navigationController popToRootViewControllerAnimated:NO];
		
	}
}

@end
