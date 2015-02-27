//
//  ViewController.h
//  cwc_ios_mysql
//
//  Created by Jacob Rail on 2/2/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HomeModelProtocol>

@property (nonatomic, weak) IBOutlet UITableView *listTableView;

@end

