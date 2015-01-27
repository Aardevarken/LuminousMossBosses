//
//  ObsViewController.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 1/11/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Observation.h"
#import "ObsTableViewController.h"
#import "ObservationCell.h"


@implementation ObsTableViewController

NSMutableArray *_observations;
int hit = 0;

- (void) viewDidLoad
{
	[super viewDidLoad];
	
//	NSLog(@"In ObsTableViewController");
	_observations = [NSMutableArray arrayWithCapacity:20];
	
	Observation *newObs = [[Observation alloc] init];
	newObs.name = @"name test 1";
	newObs.date = @"data test 1";
	//	observation.plantImage = 1;
	newObs.percent = @"10%";
	[_observations addObject:newObs];
	
	newObs = [[Observation alloc] init];
	newObs.name = @"name test 2";
	newObs.date = @"data test 2";
	//	observation.plantImage = 2;
	newObs.percent = @"20%";
	[_observations addObject:newObs];
	
	newObs = [[Observation alloc] init];
	
	newObs.name = @"name test 3";
	newObs.date = @"data test 3";
	//	observation.plantImage = 3;
	newObs.percent = @"30%";
	[_observations addObject:newObs];
	
	self.observations = _observations;
	//	obsViewController.observations = _observations;
	
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//	NSLog(@"(%i) Selecting number of rows --> %lu", hit, (unsigned long)[self.observations count]);
	hit++;
	return [self.observations count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//	NSLog(@"Getting data");
	
	
	//UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ObservationCell_ID"];
	
	ObservationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ObservationCell_ID"];
	Observation *observation = [self.observations objectAtIndex:indexPath.row];
	
//	NSLog(@"Data: %@, %@, %@", observation.name, observation.date, observation.percent);
	//UILabel *nameLabel = (UILabel *)[cell viewWithTag:102];
	cell.nameLabel.text = observation.name;
	cell.dateLabel.text = observation.date;
	cell.percentLabel.text = observation.percent;
	
	/*
	UILabel *dateLabel = (UILabel *)[cell viewWithTag:103];
	dateLabel.text = observation.date;
	
	
	UILabel *percentLabel = (UILabel *)[cell viewWithTag:104];
	percentLabel.text = observation.percent;
	*/
	return cell;
}

@end