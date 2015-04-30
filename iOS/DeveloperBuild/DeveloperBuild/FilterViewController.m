//
//  FilterViewController.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/25/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterTableViewCell.h"
#import "FieldGuideManager.h"
#import "FilterOptions.h"
#import "FilterOptionsViewController.h"
#import "FilterOptionsTabViewController.h"

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define printa(fmt, ...) printf(("%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@interface FilterViewController ()

@end

/*** temp vars used as place holders to generate cells ***/
static NSDictionary* filters;
static NSArray *filterCellTitles;
static NSArray *filterCellOptions;
static NSArray *filterCellTitlesWithImages;
static NSArray *filterCellOptionsWithImages;
static NSMutableDictionary *filterCurrentValue;
/*** end of temp vars ***/

@implementation FilterViewController

@synthesize filterTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Do any additional setup after loading the view.
	NSDictionary *titleAndFilters = [[NSDictionary alloc] initWithObjectsAndKeys:
									 @"Flower color", @"flowercolor",
									 @"Habitat", @"habitat",
									 @"Petal number", @"petalnumber",
									 @"Inflorescence", @"inflorescence",
									 @"Leaf arrangement", @"leafarrangement",
									 nil];
	
	 NSDictionary *filtersWithImages = [[NSDictionary alloc] initWithObjectsAndKeys:
						 @"Flower shape", @"flowershape",
						 @"Leaf shape", @"leafshapefilter",
						 nil];
	
	[[FilterOptions getSharedInstance] createFiltersWithTitles:titleAndFilters];
	[[FilterOptions getSharedInstance] createFiltersWithTitlesAndImages:filtersWithImages];

	[self getFilterTitle];
}

- (void)getFilterTitle{
	FilterOptions *theFilter = [FilterOptions getSharedInstance];

	filterCellTitlesWithImages = [theFilter filterTitlesWithImages];
	filterCellOptionsWithImages = [theFilter filterOptionsWithImages];
	filterCellTitles = [theFilter filterTitle];
	filterCellOptions = [theFilter filterOption];
//	filterCellTitles = [[theFilter filterTitle] arrayByAddingObjectsFromArray:filterCellTitlesWithImages];
//	filterCellOptions = [[theFilter filterOption] arrayByAddingObjectsFromArray:filterCellOptionsWithImages];
}

- (void)viewWillAppear:(BOOL)animated{
	[self.filterTableView reloadData];	// cannot call realoadData. will erase selected rows.
	[super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	if (section == 0) {
		return filterCellTitles.count;
	}
	else if (section == 1) {
		return filterCellTitlesWithImages.count;
	}
	else {
		return 0;
	}
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

	FilterTableViewCell *cell;
	NSString *fvt;
	NSUInteger index = indexPath.row;
	
	if (indexPath.section == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell_ID"];
		cell.filterName.text = [filterCellTitles objectAtIndex:index];
		fvt = [filterCellOptions objectAtIndex:index];
	}
	else if (indexPath.section == 1) {
//		index -= [[[FilterOptions getSharedInstance] filterTitle] count];
		cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCellWithImage_ID"];
		cell.filterName.text = [filterCellTitlesWithImages objectAtIndex:index];
		fvt = [filterCellOptionsWithImages objectAtIndex:index];
		
		if (![fvt isEqualToString:@"All"]) {
			cell.filterValueImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"GlossaryImages/%@.jpeg", fvt]];
		} else {
			cell.filterValueImage.image = nil;
		}
	}
	else {
		return cell;
	}

	cell.filterValue.text = fvt;
	
	if ([fvt isEqualToString:@"All"]) {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}


/**
 *	The following method *should not be needed and is marked for deletion.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//	NSString *title = [[NSString alloc] initWithString:[filterCellTitles objectAtIndex:indexPath.row]];
//	NSString *opt = [[NSString alloc] initWithString:[filterCellOptions objectAtIndex:indexPath.row]];
//	ALog(@"title: %@ \t option: %@ indexPath: %ld(row) ", title, opt, (long)indexPath.row);
	[filterCurrentValue setObject:@"pending" forKey:[NSNumber numberWithUnsignedInteger:indexPath.row]];
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	NSString *segueID = @"FilterOptionSegue";
	
	if ([segue.identifier isEqualToString:segueID]) {
		NSIndexPath *indexPath = [self.filterTableView indexPathForSelectedRow];
		
		FilterOptionsViewController *destViewController = segue.destinationViewController;
		
		destViewController.filterOptionIndexNumber = (NSUInteger)indexPath.row;
	}
	
	NSString *segueIDToFilterOptionsTab = @"SegueIDFilterOptionTBC";
	
	if ([segue.identifier isEqualToString:segueIDToFilterOptionsTab]) {
		
		ALog(@"Preparing segue to %@", segueIDToFilterOptionsTab);
		NSIndexPath *indexPath = [self.filterTableView indexPathForSelectedRow];
		
		//destViewController.filterOptionIndexNumber = (NSUInteger)indexPath.row;
		
		/*** Try #2 ***/
		UITabBarController *tabar = segue.destinationViewController;
		FilterOptionsTabViewController *vcat0 = [tabar.viewControllers objectAtIndex:0];
		FilterOptionsTabViewController *vcat1 = [tabar.viewControllers objectAtIndex:1];
		
		vcat0.filterOptionIndexNumber = indexPath.row;
//		vcat1.filterOptionIndexNumber = indexPath.row;
		
//		svc.groupArray = [(NSArray*)sender objectAtIndex:0];
//		svc.userArray = [(NSArray*)sender objectAtIndex:1];
//		svc.taskArray = [(NSMutableArray*)sender objectAtIndex:2];
//		svc.selfArray = [(NSMutableArray*)sender objectAtIndex:3];
		[tabar setSelectedIndex:0];
	}
}

- (IBAction)cancelButton:(UIButton *)sender {
	[[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)searchButton:(UIButton *)sender {

	NSArray *selectedIndexPath = [filterTableView indexPathsForSelectedRows];
	
	NSLog(@"selected: %ld", (long)[[selectedIndexPath objectAtIndex:0] row]);
	
	[[FilterOptions getSharedInstance] generateFilterQuery];
	
	[[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)resetFilterButton:(UIBarButtonItem *)sender {
	FilterOptions *fo = [FilterOptions getSharedInstance];
	[fo resetFilterOptions];
	filterCellOptions = [fo filterOption];
	filterCellOptionsWithImages = [fo filterOptionsWithImages];
	[self.filterTableView reloadData];
}

@end
