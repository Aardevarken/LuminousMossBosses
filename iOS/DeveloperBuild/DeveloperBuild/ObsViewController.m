//
//  ObsViewController.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 1/12/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObsViewController.h"
#import "Observation.h"
#import "ObservationCell.h"

@interface ObsViewController ()

@end

@implementation ObsViewController

NSMutableArray *_myObservations;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	
	NSLog(@"In ObsViewController (ObsViewController.m)");
	_myObservations = [NSMutableArray arrayWithCapacity:20];
	
	Observation *newObs = [[Observation alloc] init];
	newObs.name = @"name test 1";
	newObs.date = @"data test 1";
	//	observation.plantImage = 1;
	newObs.percent = @"10%";
	[_myObservations addObject:newObs];
	
	newObs = [[Observation alloc] init];
	newObs.name = @"name test 2";
	newObs.date = @"data test 2";
	//	observation.plantImage = 2;
	newObs.percent = @"20%";
	[_myObservations addObject:newObs];
	
	newObs = [[Observation alloc] init];
	
	newObs.name = @"name test 3";
	newObs.date = @"data test 3";
	//	observation.plantImage = 3;
	newObs.percent = @"30%";
	[_myObservations addObject:newObs];
	
	self.myObservations = _myObservations;

	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.myObservations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	ObservationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ObservationCell_ID"];
	Observation *myObservation = [self.myObservations objectAtIndex:indexPath.row];
	
	cell.nameLabel.text = myObservation.name;
	cell.dateLabel.text = myObservation.date;
	cell.percentLabel.text = myObservation.percent;
	
	return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
