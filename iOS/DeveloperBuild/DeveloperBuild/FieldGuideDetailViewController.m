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

CGFloat textViewFontSize = 16.0f;

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	DetailFieldGuidCell *cell = [speciesInfoTableView dequeueReusableCellWithIdentifier:@"DetailFieldGuideCell_ID_2"];

	NSString *val = [valueInfoToDisplay objectAtIndexedSubscript:indexPath.row];
	NSString *t = [typeMap objectForKey:[keyInfoToDisplay objectAtIndex: indexPath.row]];
	
	cell.title.text = t;
//	
//	NSString *randtext2 = @"Unpacked reserved sir offering bed judgment may and quitting speaking. Is do be improved raptures offering required in replying raillery. <END>"
//	@"\n this is the next line"
//	@"\n and the last line";
//	BOOL debug = NO;
//	NSString *tv;
//	if ([t isEqualToString:@"Description"]) {
//		tv = randtext2;
//		debug = YES;
//	}
//	else {
//		tv = val;
//		cell.textview.text = tv;
//	}
	
	cell.textview.text = val;
	cell.textview.font = [UIFont systemFontOfSize:textViewFontSize];
	cell.textview.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
	cell.textview.textColor = [UIColor colorWithRed:86/255.0f green:86/255.0f blue:79/255.0f alpha:1.0f];

//	NSMutableAttributedString *atv = [[NSMutableAttributedString alloc] initWithString:tv];
//	UIFont *attfont = [UIFont systemFontOfSize:textViewFontSize];
//	[atv addAttribute:NSFontAttributeName value:attfont range:NSMakeRange(0, [atv length])];
//	[[cell textview] setAttributedText:atv];
//	
	NSAttributedString * celltext = [[NSMutableAttributedString alloc] initWithString:cell.textview.text];
	
	
	CGFloat a = cell.title.frame.size.height;//[self textViewHeightForAttributedText:cellLabel andWidth:100];
	CGFloat b = [self textViewHeightForAttributedText:celltext andWidth:cell.textview.frame.size.width];
	[speciesInfoTableView setRowHeight:(a + b)];
//	if (debug) {
//		NSLog(@"-----------------------\n"
//			  @"(a)title: %@ len: %lu\n"
//			  @"(b)value: %@ len: %lu\n"
//			  @"height: %f(a) + %f(b)\n",
//			  cell.title.text,(unsigned long)[t length],
//			  tv, (unsigned long)[tv length],
//			  a, b);
//		
//		NSLog(@"\n"
//			  @"contentSize h:%f  w:%f \n"
//			  @"frameHeight h:%f  w:%f \n"
//			  @"\n",
//			  cell.textview.contentSize.height, cell.textview.contentSize.width,
//			  cell.textview.frame.size.height, cell.textview.frame.size.width);
//		
//		NSLog(@"description: %@\n\n", cell.textview.description);
//		NSLog(@"description: %@", cell.title.description);
//
//	}
	return cell;
}

// DIS SHIT FIGURES OUT THE CELL SIZE YO!

- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
	UITextView *calculationView = [[UITextView alloc] init];
	[calculationView setAttributedText:text];
	[calculationView setFont:[UIFont systemFontOfSize:textViewFontSize]];
	CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
	return size.height;
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
