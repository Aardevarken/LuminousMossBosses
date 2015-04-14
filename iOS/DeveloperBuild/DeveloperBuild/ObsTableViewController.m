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

- (void) viewDidLoad
{
	[super viewDidLoad];
	[self retrieveData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.observations count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ObservationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ObservationCell_ID"];
	Observation *observation = [self.observations objectAtIndex:indexPath.row];
	
	cell.nameLabel.text = observation.name;
	cell.dateLabel.text = observation.date;
	cell.percentLabel.text = observation.percent;
	
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