//
//  FieldGuideDetailViewController.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/25/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FieldGuideDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	
}

@property (nonatomic, strong) NSNumber *speciesID;
@property (nonatomic, strong) NSDictionary *speciesInfo;

// UI properties
@property (strong, nonatomic) IBOutlet UIImageView *plantImageView;
@property (strong, nonatomic) IBOutlet UITableView *speciesInfoTableView;
@property (strong, nonatomic) IBOutlet UILabel *nameOfSpeciesLabel;


@end
