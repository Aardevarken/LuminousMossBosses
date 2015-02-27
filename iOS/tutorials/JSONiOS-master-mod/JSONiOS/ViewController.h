//
//  ViewController.h
//  JSONiOS
//
//  Created by Kurup, Vishal on 4/14/13.
//  Copyright (c) 2013 conkave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"
#import "DetailViewController.h"

@interface ViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray * json;
@property (nonatomic, strong) NSMutableArray * citiesArray;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

#pragma mark - Methods
- (void) retrieveData;

@end
