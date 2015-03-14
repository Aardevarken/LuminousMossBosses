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
#import "MyObservations.h"
#import "UserDataDatabase.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ObsViewController ()

@end

#define getDataURL @"http://flowerid.cheetahjokes.com/cgi-bin/observations.py"
#define MAX_NUMB_DISPLAYED 5

@implementation ObsViewController
@synthesize json, observationsArray;
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
	
	[self retrieveData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
	return 40;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	switch (section) {
		case 0:
			return @"Unknown Observations";
			break;
		case 1:
			return @"Identified Observations";
			break;
		default:
			return @"";
			break;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger count;
	NSArray *data;
	
	// All variable declaration must be pulled out of the switch statment
	switch (section) {
		case 0:
			data = [[UserDataDatabase getSharedInstance] findObsByStatus:@"pending_noid" orderBy:nil];
			count = [data count];
			break;
		case 1:
			data = [[UserDataDatabase getSharedInstance] findObsByStatus:@"pending_gotid" orderBy:nil];
			count = [data count];
		default:
			count = 0;
			break;
	}
	
	return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	ObservationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ObservationCell_ID"];
//	NewObs *myObservation = [self.observationsArray objectAtIndex:indexPath.row];
	NSArray *data = [[UserDataDatabase getSharedInstance] findObsByStatus:@"pending_noid" orderBy:nil]; // need to refactor
	
	NSDictionary *dic = [data objectAtIndex:indexPath.row];
	
	NSURL *url = [NSURL URLWithString:[dic objectForKey:@"imghexid"]];
	
	if ([url  isEqual: @"(null)"]) {
		NSLog(@"img path is null");
		return cell;
	}
	
	ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
	
	[lib assetForURL: url resultBlock: ^(ALAsset *asset) {
		ALAssetRepresentation *r = [asset defaultRepresentation];
		cell.plantImageView.image = [UIImage imageWithCGImage: r.fullResolutionImage];
	}
		failureBlock: nil];
	
	cell.nameLabel.text		= [NSString stringWithFormat:@"%@", [dic objectForKey:@"Unknown"]];
	cell.dateLabel.text		= [NSString stringWithFormat:@"%@", [dic objectForKey:@"date"]];
	cell.percentLabel.text	= [NSString stringWithFormat:@"%@", [dic objectForKey:@"percentIDed"]];
	
	
	
	//cell.plantImageView.image = [dic objectForKey:@"imghexid"];
	
	/*
	
	cell.nameLabel.text = myObservation.FileName;
	cell.dateLabel.text = [NSString stringWithFormat:@"ImageID: %@",myObservation.ImageID];
	cell.percentLabel.text = @"";
	
	//[self retriveImage: myObservation.FileName];
	
	//	"http://flowerid.cheetahjokes.com/pics/silene/"
	//cell.plantImageView.image = [[UIImageView alloc] init];
	//cell.plantImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"http://flowerid.cheetahjokes.com/pics/silene/%@", myObservation.FileName]];
	
	NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[NSString stringWithFormat: @"http://flowerid.cheetahjokes.com/pics/silene/%@", myObservation.FileName]]];
	if ( data == nil )
		return cell;
	// WARNING: is the cell still using the same data by this point??
	cell.plantImageView.image = [UIImage imageWithData: data];

		//[data release];
	
	//cell.plantImageView.image = [self getImageFromURL:myObservation.FileName];
	 
	 */
	return cell;
}


- (void) retrieveData
{
	/*
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
	*/
}

- (UIImage *) retriveImage: (NSString *) fName
{
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat: @"http://flowerid.cheetahjokes.com/pics/silene/%@", fName]];
	NSData* data = [NSData dataWithContentsOfURL:url];
	
	json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
	
	// set up array
	
	//observationsArray = [[NSMutableArray alloc] init];
	/*
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
	*/
	
	NSLog(@"%@", [json objectAtIndex:0]);
	
	UIImage * newImage = [json objectAtIndex:0];
	
	return newImage;

}

-(UIImage *) getImageFromURL:(NSString *)fName {
	UIImage * result;
	
	NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://flowerid.cheetahjokes.com/pics/silene/%@", fName]]];
	result = [UIImage imageWithData:data];
	
	return result;
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
