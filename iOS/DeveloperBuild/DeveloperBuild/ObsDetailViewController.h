//
//  ObsDetailViewController.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 3/14/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObsDetailViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *percentLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UIImageView *obsImage;

@property (nonatomic, strong) NSDictionary *plantInfo;
@property (nonatomic, strong) IBOutlet UIProgressView *progressBar;

@property (nonatomic, strong) IBOutlet UIButton *idButton;

- (IBAction)startIdentificationButton:(UIButton *)sender;

@end
