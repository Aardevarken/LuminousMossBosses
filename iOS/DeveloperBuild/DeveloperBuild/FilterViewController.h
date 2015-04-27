//
//  FilterViewController.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/25/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	
}
// storage
//@property (nonatomic, strong) static NSMutableDictionary *filterCurrentValue;

// Buttons
- (IBAction)cancelButton:(UIButton *)sender;
- (IBAction)searchButton:(UIButton *)sender;

// Table View
@property (strong, nonatomic) IBOutlet UITableView *filterTableView;

@end
