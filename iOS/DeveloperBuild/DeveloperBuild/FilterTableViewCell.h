//
//  FilterTableViewCell.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/25/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterTableViewCell : UITableViewCell
// labels
@property (strong, nonatomic) IBOutlet UILabel *filterName;
@property (strong, nonatomic) IBOutlet UILabel *filterValue;

// uiimages
@property (strong, nonatomic) IBOutlet UIImageView *filterValueImage;

@end
