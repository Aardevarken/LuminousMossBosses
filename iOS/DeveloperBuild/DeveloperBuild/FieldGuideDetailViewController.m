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
	[mdic removeObjectForKey:@"description"];
	
	
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
	return keyInfoToDisplay.count/2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	DetailFieldGuidCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailFieldGuideCell_ID_2"];
	
	//NSString *val = [valueInfoToDisplay objectAtIndex:indexPath.row];
	//if (![val isEqualToString:@"."]) {
	//cell.value.text = [valueInfoToDisplay objectAtIndex:indexPath.row];
	

//	NSString *randtext1 = @"So by colonel hearted ferrars. Draw from upon here gone add one.";
//	//}
//
	

	NSString *val = [valueInfoToDisplay objectAtIndexedSubscript:indexPath.row];
	NSString *t = [typeMap objectForKey:[keyInfoToDisplay objectAtIndex: indexPath.row]];
	cell.title.text = t;//[typeMap objectForKey:[keyInfoToDisplay objectAtIndex:indexPath.row]];
	NSMutableString *mt = [[NSMutableString alloc] initWithString:val];
	
	for (int i = 1; i < [val length]; i+=3) {
		[mt appendString:val];
		[mt appendString:@" + "];
	}
	NSString *randtext2 = @"Unpacked reserved sir offering bed judgment may and quitting speaking. Is do be improved raptures offering required in replying raillery. <END>";
	
	NSString *tv = randtext2;//[[NSString alloc] initWithFormat:@"%@%@",[valueInfoToDisplay objectAtIndex:indexPath.row], randtext2];
					
					
	NSAttributedString * celltext = [[NSMutableAttributedString alloc] initWithString:tv];
	NSAttributedString * cellLabel = [[NSMutableAttributedString alloc] initWithString:cell.title.text];
	CGFloat a = [self textViewHeightForAttributedText:cellLabel andWidth:100];
	CGFloat b = [self textViewHeightForAttributedText:celltext andWidth:300];
	tableView.rowHeight = a + b;
	NSLog(@"-----------------------\n"
		  @"title: len: %lu\n"
		  @"value: len: %lu\n"
		  @"height: %f(a) + %f(b)",
		  (unsigned long)[t length], (unsigned long)[mt length], a, b);
	
	cell.textview.text = randtext2;//mt;//tv;//[valueInfoToDisplay objectAtIndexedSubscript:indexPath.row];
	[cell.textview setFont:[UIFont systemFontOfSize:16.0f]];
	
	return cell;
}

// DIS SHIT FIGURES OUT THE CELL SIZE YO!

- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
	UITextView *calculationView = [[UITextView alloc] init];
	[calculationView setAttributedText:text];
	CGFloat fontSize = 16.0f;
	UIColor *fontColor = [UIColor greenColor];
	[calculationView setFont:[UIFont systemFontOfSize:fontSize]];
	[calculationView setTextColor:fontColor];
	CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
	return size.height;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Define `veryverySmallTitleFont`
	CGFloat fs = 16.0f;
	CGFloat veryverySmallTitleFont = 16;//[UIFont systemFontOfSize:fs];
	// Define `descLabel`
	
	NSString *ourText =  @"Unpacked reserved sir offering bed judgment may and quitting speaking. Is do be improved raptures offering required in replying raillery. <END>";
	UIFont *font = [UIFont fontWithName:@"Verdana" size:veryverySmallTitleFont];
	font = [font fontWithSize:veryverySmallTitleFont];
	
//	CGSize constraintSize = CGSizeMake(descLabel.frame.size.width, 1000);
//	CGSize labelSize = [ourText sizeWithFont:font
//						   constrainedToSize:constraintSize
//							   lineBreakMode:UILineBreakModeWordWrap];
	
	return 30;//labelSize.height;
}
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
