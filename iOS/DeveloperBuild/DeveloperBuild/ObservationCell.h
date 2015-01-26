//
//  ObservationCell.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 1/11/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#ifndef DeveloperBuild_ObservationCell_h
#define DeveloperBuild_ObservationCell_h

#import <UIKit/UIKit.h>

@interface ObservationCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *percentLabel;
@property (nonatomic, weak) IBOutlet UIImageView *plantImageView;

@end

#endif
