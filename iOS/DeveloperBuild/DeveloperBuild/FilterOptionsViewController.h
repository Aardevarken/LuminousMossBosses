//
//  FilterOptionsViewController.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/26/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterOptionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	
}
// data storage
@property (nonatomic, readwrite) NSUInteger filterOptionIndexNumber;
@property (nonatomic, strong) NSArray* optionsToFilter;

- (IBAction)saveFilterOption:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *optionsTableView;

@end
