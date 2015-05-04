//
//  testViewController.h
//  Luminous ID
//
//  Created by Jack Skinner on 5/3/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface testViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
}

@property (strong, nonatomic) IBOutlet UITableView *testTableView;
@property (strong, nonatomic) NSArray *testDisplayData;


@end
