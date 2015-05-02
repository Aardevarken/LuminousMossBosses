//
//  ObsDetailViewController.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 3/14/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObsDetailViewController : UIViewController{

}

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *percentLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UIImageView *obsImage;
@property (strong, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

@property (nonatomic, strong) NSDictionary *plantInfo;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UIButton *startRunning;
@property (strong, nonatomic) IBOutlet UIView *identifyView;

@property (strong, nonatomic) IBOutlet UIButton *tapToStartBtn;
@property (strong, nonatomic) IBOutlet UIButton *toFieldGuide1;
@property (strong, nonatomic) IBOutlet UIButton *toFieldGuide2;
@property (strong, nonatomic) IBOutlet UIView *buttonSuperView;

- (IBAction)startButton:(UIButton *)sender;



@end
