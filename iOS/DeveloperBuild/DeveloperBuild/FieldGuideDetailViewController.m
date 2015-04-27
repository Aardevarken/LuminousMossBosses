//
//  FieldGuideDetailViewController.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/25/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "FieldGuideDetailViewController.h"
#import "FieldGuideManager.h"
#import "DetailFieldGuidCell.h"

static NSArray* valueInfoToDisplay;
static NSArray* keyInfoToDisplay;

@interface FieldGuideDetailViewController ()

@end

@implementation FieldGuideDetailViewController

@synthesize speciesInfo;
@synthesize speciesInfoTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	speciesInfo = [[FieldGuideManager getSharedInstance] findSpeciesByID:[self speciesID]];
	valueInfoToDisplay = [speciesInfo allValues];
	keyInfoToDisplay = [speciesInfo allKeys];
	
	[[self nameOfSpeciesLabel] setText:[speciesInfo objectForKey:@"latin_name"]];
	NSString *imgName = [NSString stringWithFormat:@"FORBS/%@.jpg", [speciesInfo objectForKey:@"code"]];
	[[self plantImageView] setImage:[UIImage imageNamed:imgName]];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return keyInfoToDisplay.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	DetailFieldGuidCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailFieldGuideCell_ID"];
	
	cell.value.text = [valueInfoToDisplay objectAtIndex:indexPath.row];
	cell.title.text = [keyInfoToDisplay objectAtIndex:indexPath.row];
	
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

@end
