//
//  FilterOptionsTabViewController.m
//  Luminous ID
//
//  Created by Jacob Rail on 4/29/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "FilterOptionsTabViewController.h"
#import "FieldGuideManager.h"
#import "FilterOptions.h"
#import "OptionsTableViewCell.h"

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define printa(fmt, ...) printf(("%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@interface FilterOptionsTabViewController ()

@end

@implementation FilterOptionsTabViewController

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
	
	NSString *db = [[[FilterOptions getSharedInstance] filterDatabasenNamesWithImages] objectAtIndex:filterOptionIndexNumber];
	
	[self setOptionsToFilter:[[FieldGuideManager getSharedInstance] getFilterOptionsFor:db]];
	[self setOptionsToFilter:@[@"All"]];
	[self setOptionsToFilter:[optionsToFilter arrayByAddingObjectsFromArray:[[FieldGuideManager getSharedInstance] getFilterOptionsFor:db]]];
	
	return [[self optionsToFilter] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *identifier = @"OptionsCell_ID";
	OptionsTableViewCell *cell = [optionsTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
	
	// Configure the cell...
	NSString *someText = [[NSString alloc] initWithString:[[self optionsToFilter] objectAtIndex:indexPath.row]];
	cell.filterOptionLabel.text = someText;
	NSString *img = [[NSString alloc] initWithFormat:@"GlossaryImages/%@.jpeg", someText];
	cell.filterOptionImage.image = [UIImage imageNamed:img];
	
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
	NSIndexPath *indexPath = [[self optionsTableView] indexPathForSelectedRow];
	NSUInteger index = indexPath.row;
	NSString *newFilterValue;
	
	if (index == 0) {
		newFilterValue = @"All";
	}
	else{
		newFilterValue = [[self optionsToFilter] objectAtIndex:index];
	}
	
	FilterOptions *fo = [FilterOptions getSharedInstance];
	[fo updateFilterOptionsWithImagesAtIndex:filterOptionIndexNumber withOption:newFilterValue];
	[[self navigationController]popViewControllerAnimated:YES];
}
@end
