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

@interface ObsTableViewController ()

@end

#define getDataURL @"http://flowerid.cheetahjokes.com/cgi-bin/observations.py"
#define MAX_NUMB_DISPLAYED 10

@implementation ObsTableViewController
@synthesize json, observationsArray;

NSMutableArray *_observations;
int hit = 0;


- (void) viewDidLoad
{
	[super viewDidLoad];
	
	/*
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
	*/
	[self retrieveData];
	
	
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

- (void) retrieveData
{
	NSURL* url = [NSURL URLWithString:getDataURL];
	NSData* data = [NSData dataWithContentsOfURL:url];
	
	json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
	
	// set up array
	observationsArray = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < json.count && i < MAX_NUMB_DISPLAYED; i++){
		
		// print what was retreived for debugging.
		NSLog(@"#%d: %@", i , [json objectAtIndex:i]);
		
		// create objects
		NSString * newFileName = [[json objectAtIndex:i] objectForKey:@"FileName"];
		NSNumber * newImageID = [[json objectAtIndex:i] objectForKey:@"ImageID"];
		NSNumber * newObsID = [[json objectAtIndex:i] objectForKey:@"ObsID"];
		
		NewObs * newObs = [[NewObs alloc]initWithFileName:newFileName andImageID:newImageID andObsID:newObsID];
		
		[observationsArray addObject:newObs];
	}

}

@end