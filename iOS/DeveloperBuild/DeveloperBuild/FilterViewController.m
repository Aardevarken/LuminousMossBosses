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
						 @"Leaf shape", @"leafshape",
						 nil];
	
	[[FilterOptions getSharedInstance] createFiltersWithTitles:titleAndFilters];
	[[FilterOptions getSharedInstance] createFiltersWithTitlesAndImages:filtersWithImages];

	[self getFilterTitle];
}

- (void)getFilterTitle{
	FilterOptions *theFilter = [FilterOptions getSharedInstance];

	filterCellTitlesWithImages = [theFilter filterTitlesWithImages];
	filterCellOptionsWithImages = [theFilter filterOptionsWithImages];

	filterCellTitles = [[theFilter filterTitle] arrayByAddingObjectsFromArray:filterCellTitlesWithImages];
	filterCellOptions = [[theFilter filterOption] arrayByAddingObjectsFromArray:filterCellOptionsWithImages];
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
	return 1;//2;
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
	
	if (index < [[[FilterOptions getSharedInstance] filterTitle] count]) {
	//if (indexPath.section == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell_ID"];
		cell.filterName.text = [filterCellTitles objectAtIndex:index];
		fvt = [filterCellOptions objectAtIndex:index];
	}
	else if (index < ([[[FilterOptions getSharedInstance] filterTitle] count] +[[[FilterOptions getSharedInstance] filterTitle] count])) {
	//else if (indexPath.section == 1) {
		index -= [[[FilterOptions getSharedInstance] filterTitle] count];
		cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCellWithImage_ID"];
		cell.filterName.text = [filterCellTitlesWithImages objectAtIndex:index];
		fvt = [filterCellOptionsWithImages objectAtIndex:index];
		if (![fvt isEqualToString:@"All"]) {
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.filterValueImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"GlossaryImages/%@.jpg", fvt]];
		}
	}
	else {
		return cell;
	}

	if ([fvt isEqualToString:@"All"]) {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *title = [[NSString alloc] initWithString:[filterCellTitles objectAtIndex:indexPath.row]];
	NSString *opt = [[NSString alloc] initWithString:[filterCellOptions objectAtIndex:indexPath.row]];
	NSLog(@"title: %@ \t option: %@ indexPath: %ld(row) ", title, opt, (long)indexPath.row);
	
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
}

- (IBAction)cancelButton:(UIButton *)sender {
	NSLog(@"%@", filterCurrentValue);
	[[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)searchButton:(UIButton *)sender {

	NSArray *selectedIndexPath = [filterTableView indexPathsForSelectedRows];
	
	NSLog(@"selected: %ld", (long)[[selectedIndexPath objectAtIndex:0] row]);
	
	[[FilterOptions getSharedInstance] generateFilterQuery];
	
	[[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)resetFilterButton:(UIBarButtonItem *)sender {
	[[FilterOptions getSharedInstance] resetFilterOptions];
	filterCellOptions = [[FilterOptions getSharedInstance] filterOption];
	[self.filterTableView reloadData];
}

@end
