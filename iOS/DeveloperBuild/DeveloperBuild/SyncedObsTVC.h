//
//  SyncedObsVCTableViewController.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 3/18/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "ObservationCell.h"
#import "UserDataDatabase.h"

@interface SyncedObsTVC : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
