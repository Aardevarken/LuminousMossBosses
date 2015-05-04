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
static NSDictionary* typeMap = nil;


@interface FieldGuideDetailViewController ()

@end

@implementation FieldGuideDetailViewController

@synthesize speciesInfo;
@synthesize speciesInfoTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		typeMap = @{
					@"family"		: @"Family",
					@"latin_name"	: @"Latin name",
					@"code"			: @"Code",
					@"growthform"	: @"Growthform",
					@"common_name"	: @"Common name",
					@"flower shape"	: @"Flower shape",
					@"leaf shape filter"	:	@"Leaf shape",
					@"description"	: @"Description",
					@"photocredit"	: @"Photocredit",
					@"inflorescence"	: @"Inflorescence",
					@"habitat"		: @"Habitat",
					@"leafarrangement"	: @"Leaf arrangement",
					@"leafshape"	: @"Leaf shape",
					@"petalnumber"	: @"Petal number"
					};
	});
	
	NSMutableDictionary *mdic = [[NSMutableDictionary alloc] initWithDictionary:[[FieldGuideManager getSharedInstance] findSpeciesByID:[self speciesID]]];
	
	[[self nameOfSpeciesLabel] setText:[mdic objectForKey:@"latin_name"]];
	NSString *imgName = [NSString stringWithFormat:@"FORBS/%@.jpg", [mdic objectForKey:@"code"]];
	

	
	NSArray *keys = [mdic allKeys];
	for (int i = 0 ; i < [keys count]; i++){
		if ([mdic[keys[i]] isEqualToString:@"."] || [mdic[keys[i]] isEqualToString:@""]){
			[mdic removeObjectForKey:keys[i]];
		}
	}
	
	[mdic removeObjectForKey:@"code"];
	[mdic removeObjectForKey:@"latin_name"];
	
	
	speciesInfo = mdic;
	valueInfoToDisplay = [speciesInfo allValues];
	keyInfoToDisplay = [speciesInfo allKeys];
	
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
	
	NSString *val = [valueInfoToDisplay objectAtIndex:indexPath.row];
	if (![val isEqualToString:@"."]) {
		cell.value.text = [valueInfoToDisplay objectAtIndex:indexPath.row];
		cell.title.text = [typeMap objectForKey:[keyInfoToDisplay objectAtIndex:indexPath.row]];
	}
	
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
