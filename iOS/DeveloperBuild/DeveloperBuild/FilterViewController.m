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
									 @"Leaf shape", @"leafshape",
									 @"Petal number", @"petalnumber",
									 @"Inflorescence", @"inflorescence",
									 @"Leaf arrangement", @"leafarrangement",
									 nil];
	
	[[FilterOptions getSharedInstance] createFiltersWithTitles:titleAndFilters];

	[self getFilterTitle];
}

- (void)getFilterTitle{
	filterCellTitles = [[NSArray alloc] initWithArray:[[FilterOptions getSharedInstance] filterTitle]];
	filterCellOptions = [[FilterOptions getSharedInstance] filterOption];
}

- (void)viewWillAppear:(BOOL)animated{
	[self.filterTableView reloadData];	// cannot call realoadData. will erase selected rows. 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return filterCellTitles.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

	FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell_ID"];
	cell.filterName.text = [filterCellTitles objectAtIndex:indexPath.row];//[NSString stringWithFormat:@"Filter #%ld", (long)indexPath.row];
	
	NSString *fvt = [filterCellOptions objectAtIndex:indexPath.row];
	if ([fvt isEqualToString:@"All"]) {
		cell.accessoryType = UITableViewCellAccessoryNone;//UITableViewCellAccessoryCheckmark;
	}
	cell.filterValue.text = fvt;
	//[NSString stringWithFormat:@"filter value #%ld", (long)indexPath.row];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *title = [[NSString alloc] initWithString:[filterCellTitles objectAtIndex:indexPath.row]];
	NSString *opt = [[NSString alloc] initWithString:[filterCellOptions objectAtIndex:indexPath.row]];
	NSLog(@"title: %@ \t option: %@ indexPath: %ld(row) ", title, opt, (long)indexPath.row);
	
	[filterCurrentValue setObject:@"pending" forKey:[NSNumber numberWithUnsignedInteger:indexPath.row]];
}

- (void)createFilterStmt{
	NSMutableArray *joins;
	NSMutableArray *wheres;
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

@end
