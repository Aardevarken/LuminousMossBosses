//
//  FilterOptionsViewController.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/26/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "FilterOptionsViewController.h"
#import "FieldGuideManager.h"
#import "FilterOptions.h"
#import "OptionsTableViewCell.h"

@interface FilterOptionsViewController ()

@end

@implementation FilterOptionsViewController

@synthesize optionsTableView;
@synthesize filterOptionIndexNumber;
@synthesize optionsToFilter;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

	NSString *db = [[[FilterOptions getSharedInstance] filterDatabaseName] objectAtIndex:filterOptionIndexNumber];
	[self setOptionsToFilter:[[FieldGuideManager getSharedInstance] getFilterOptionsFor:db]];
	
	return [[self optionsToFilter] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *identifier = @"OptionsCell_ID";
	OptionsTableViewCell *cell = [optionsTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
	
	// Configure the cell...
	cell.filterOptionLabel.text = [[self optionsToFilter] objectAtIndex:indexPath.row];

	return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveFilterOption:(id)sender {
	
}
@end
