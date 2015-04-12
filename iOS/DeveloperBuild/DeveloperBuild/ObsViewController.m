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
#import "ObsDetailViewController.h"
#import "ServerAPI.h"

@interface ObsViewController ()

@end

#define getDataURL @"http://flowerid.cheetahjokes.com/cgi-bin/observations.py"
#define MAX_NUMB_DISPLAYED 5

@implementation ObsViewController{
	NSArray *plants;
	NSArray *pendingObservations;
	NSMutableArray *idedObservations;
}


@synthesize json, observationsArray;
NSMutableArray *_myObservations;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	
	//NSLog(@"In ObsViewController (ObsViewController.m)");
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
	
	// please work
	/** /
	pendingObservations = [[UserDataDatabase getSharedInstance] findObsByStatus:@"pending-noid" like:NO orderBy:NULL];
	idedObservations = [[UserDataDatabase getSharedInstance] findObsByStatus:@"pending-id" like:NO orderBy:NULL];
	
	//NSLog(@"po:%lu \t io:%lu", (unsigned long)[pendingObservations count], (unsigned long)[idedObservations count]);
	
	selectedSection = -1;
	selectedRow = -1;
	//NSLog(@"\n");
	/**/
	// keep this work
	
	[self retrieveData];
}

- (void)viewWillAppear:(BOOL)animated{
	/**/
	pendingObservations = [[UserDataDatabase getSharedInstance] findObsByStatus:@"pending-noid" like:NO orderBy:NULL];
	//idedObservations = [[UserDataDatabase getSharedInstance] findObsByStatus:@"pending-id" like:NO orderBy:NULL];
	idedObservations = [NSMutableArray array];
	
	for(id object in [[UserDataDatabase getSharedInstance] findObsByStatus:@"pending-id" like:NO orderBy:NULL]){
		[idedObservations addObject:object];
	}
	//NSLog(@"po:%lu \t io:%lu", (unsigned long)[pendingObservations count], (unsigned long)[idedObservations count]);
	
	selectedSection = -1;
	selectedRow = -1;
	/**/
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
	NSInteger count = -1;
	NSArray *data;// = pendingObservations;
	
	// All variable declaration must be pulled out of the switch statment
	switch (section) {
		case 0:
			data = pendingObservations;//[[UserDataDatabase getSharedInstance] findObsByStatus:@"pending-noid" like:NO orderBy:nil];
			count = [pendingObservations count];
			break;
		case 1:
			data = idedObservations;//[[UserDataDatabase getSharedInstance] findObsByStatus:@"pending-id" like:NO orderBy:nil];
			count = [idedObservations count];
			break;
		default:
			count = 0;
			break;
	}
	
	//NSLog(@"section: %ld \t count: %ld", (long)section, (long)count);
	return count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[idedObservations removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
	else {
		NSLog(@"Unhandled editing sytle! %ld", editingStyle);
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	ObservationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ObservationCell_ID" forIndexPath:indexPath];
	///? what does this do ?///
	if (cell == nil) {
		// do something
	}
	
//	NewObs *myObservation = [self.observationsArray objectAtIndex:indexPath.row];
	NSArray *data;
	if (indexPath.section == 0) {
		data = pendingObservations;
	}
	else if (indexPath.section == 1){
		data = idedObservations;
	}
	else {
		return cell;
	}
	
	//[[UserDataDatabase getSharedInstance] findObsByStatus:@"pending_noid" orderBy:nil]; // need to refactor
	
	NSDictionary *dic = [data objectAtIndex:indexPath.row];
	
	NSURL *url = [NSURL URLWithString:[dic objectForKey:@"imghexid"]];
	
	if ([url  isEqual: @"(null)"]) {
		NSLog(@"img path is null");
		return cell;
	}
	
	ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
	
	[lib assetForURL: url
		 resultBlock: ^(ALAsset *asset) {
		ALAssetRepresentation *r = [asset defaultRepresentation];
        UIImageOrientation orientation = (UIImageOrientation) (int) r.orientation;
        cell.plantImageView.image = [UIImage imageWithCGImage:r.fullResolutionImage scale:r.scale orientation:orientation];
	}
		failureBlock: nil];
	
	cell.nameLabel.text		= @"Unknown";//[NSString stringWithFormat:@"%@", [dic objectForKey:@"imghexid"]];
	cell.dateLabel.text		= [NSString stringWithFormat:@"%@", [dic objectForKey:@"date"]];
	
//	if ([[dic objectForKey:@"percentIDed"]  isEqual: @"(null)"]) {
//		cell.percentLabel.text	= @"";	}
//	else{
//	NSString *percentString = [NSString stringWithFormat:@"%@", [dic objectForKey:@"percentIDed"]];
	if ([dic objectForKey:@"percentIDed"] == NULL) {
		cell.percentLabel.text	= @"";
	}
	else{
		cell.percentLabel.text	= [NSString stringWithFormat:@"%@%%", [dic objectForKey:@"percentIDed"]];
	}
//	
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	selectedSection = indexPath.section;
	selectedRow = indexPath.row;
}

#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	if ([segue.identifier isEqualToString:@"MyObsSegue"]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		//NSLog(@"indexpath: %@", indexPath);
		//NSLog(@"indexpath.section: %ld", (long)indexPath.section);
		//NSLog(@"indexpath.row: %ld", (long)indexPath.row);

		ObsDetailViewController *destViewController = segue.destinationViewController;
		//NSLog(@"%@", [pendingObservations objectAtIndex:indexPath.row]);
		
		
		NSDictionary *selectedPendingObservation;
		switch (indexPath.section) {
			case 0:
				selectedPendingObservation = [pendingObservations objectAtIndex:indexPath.row];
				break;
			case 1:
				selectedPendingObservation = [idedObservations objectAtIndex:indexPath.row];
				break;
			default:
				// show an alert here
				NSLog(@"ERROR, THIS LINE OF CODE SHOULD NEVER HIT <prepareForSegue ObsViewController.m>");
    break;
		}
		
		destViewController.plantInfo = selectedPendingObservation;//[pendingObservations objectAtIndex:indexPath.row];
		//NSLog(@"Leaving prepareForSegue MyObsSegue");
	}
}

- (IBAction)syncAllBtn:(UIButton *)sender {
	for(id object in idedObservations){
		[[UserDataDatabase getSharedInstance] updateRow:[object objectForKey:@"imghexid"] andNewPercentIDed:[object objectForKey:@"percentIDed"] andNewStatus:@"synced"];
        NSDictionary* observationData = object;
        
        // Get position and time data
        NSString* date = [NSString stringWithFormat:@"%@", [observationData objectForKey:@"date"]];
        float lat = [[observationData objectForKey:@"latitude"] floatValue];
        float lng = [[observationData objectForKey:@"longitude"] floatValue];
        
        // Get image url
        NSURL *url = [NSURL URLWithString:[observationData objectForKey:@"imghexid"]];
        if ([url  isEqual: @"(null)"]) {
            NSLog(@"img path is null");
        }
        
        // Fetch image at url
        ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL: url
             resultBlock: ^(ALAsset *asset) {
                 ALAssetRepresentation *r = [asset defaultRepresentation];
                 UIImageOrientation orientation = (UIImageOrientation) (int) r.orientation;
                 UIImage* image = [UIImage imageWithCGImage:r.fullResolutionImage scale:r.scale orientation:orientation];
                 // Unrotate image
                 UIImage* normalizedImage;
                 if (image.imageOrientation == UIImageOrientationUp) {
                     normalizedImage = image;
                 } else {
                     UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
                     [image drawInRect:(CGRect){0, 0, image.size}];
                     normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
                     UIGraphicsEndImageContext();
                 }
                 // Send to server.
                 [ServerAPI uploadObservation:date time:date lat:lat lng:lng image:normalizedImage];
             }
            failureBlock: nil];
	}
}


@end
