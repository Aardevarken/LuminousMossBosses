//
//  ObsViewController.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 1/11/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#ifndef DeveloperBuild_ObsViewController_h
#define DeveloperBuild_ObsViewController_h
#import <UIKit/UIKit.h>
#import "NewObs.h"

@interface ObsTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray * observations;
@property (nonatomic, strong) NSMutableArray * observationsArray;
@property (nonatomic, strong) NSMutableArray * json;

@end

#endif
