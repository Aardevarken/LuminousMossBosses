//
//  testViewController.m
//  Luminous ID
//
//  Created by Jack Skinner on 5/3/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//
#define     TEXT @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.1234567890123456789012345678901234567890123456789012345678"
#define     TEXT2 @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
#define     TEXT3 @"THIS IS IT."

#import "testViewController.h"
#import "testTableViewCell.h"

@interface testViewController ()

@end

@implementation testViewController{

}

@synthesize testTableView;
@synthesize testDisplayData;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   // [self setTestDisplayData:];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    NSString *db = [[[FilterOptions getSharedInstance] filterDatabasenNamesWithImages] objectAtIndex:filterOptionIndexNumber];
//    
//    [self setOptionsToFilter:[[FieldGuideManager getSharedInstance] getFilterOptionsFor:db]];
//    [self setOptionsToFilter:@[@"All"]];
//    [self setOptionsToFilter:[optionsToFilter arrayByAddingObjectsFromArray:[[FieldGuideManager getSharedInstance] getFilterOptionsFor:db]]];
//    
    return 3;//[[self testDisplayData] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"testViewCell_ID_1";
    testTableViewCell *cell;
    cell = [testTableView dequeueReusableCellWithIdentifier:@"testViewCell_ID_1" forIndexPath:indexPath];
    cell.label.text = @"Label";
    if(indexPath.row == 2){
        cell.textview.text = TEXT2;
    }
    else if (indexPath.row == 1){
        cell.textview.text = TEXT3;
    }
    else if (indexPath.row == 0){
        cell.textview.text = TEXT;
    }
    
    NSAttributedString * celltext = [[NSMutableAttributedString alloc] initWithString:cell.textview.text];
    NSAttributedString * cellLabel = [[NSMutableAttributedString alloc] initWithString:cell.label.text];
    CGFloat a = [self textViewHeightForAttributedText:celltext andWidth: 300];
    CGFloat b = [self textViewHeightForAttributedText:cellLabel andWidth: 100];
    testTableView.rowHeight = a+b;
    
//    
//    // Configure the cell...
//    NSString *someText = [[NSString alloc] initWithString:[[self optionsToFilter] objectAtIndex:indexPath.row]];
//    cell.filterOptionLabel.text = someText;
//    NSString *img = [[NSString alloc] initWithFormat:@"GlossaryImages/%@.jpeg", someText];
//    cell.filterOptionImage.image = [UIImage imageNamed:img];
//    
    return cell;
}

// DIS SHIT FIGURES OUT THE CELL SIZE YO!

- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
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
