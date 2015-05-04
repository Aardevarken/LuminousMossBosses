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
#import "IdentifyingAssets.h"

@interface ObsViewController ()

@end
#define MAX_NUMB_DISPLAYED 5
// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define printa(fmt, ...) printf(("%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define TESTING YES

@implementation ObsViewController{
	NSArray *plants;
	NSMutableArray *pendingObservations;
	NSMutableArray *idedObservations;
}


@synthesize json, observationsArray;
NSMutableArray *_myObservations;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self updateTables];
    for(id object in pendingObservations){
        [[IdentifyingAssets getByimghexid:[object objectForKey:@"imghexid"]] addObserver:self forKeyPath:@"percentageComplete" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    for(id object in idedObservations){
        [[IdentifyingAssets getByimghexid:[object objectForKey:@"imghexid"]] addObserver:self forKeyPath:@"percentageComplete" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
	
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    for(id object in pendingObservations){
        detectionHelper* detectionObject = [IdentifyingAssets getByimghexid:[object objectForKey:@"imghexid"]];
        [detectionObject removeObserver:self forKeyPath:@"percentageComplete"];
    }
    for(id object in idedObservations){
        detectionHelper* detectionObject = [IdentifyingAssets getByimghexid:[object objectForKey:@"imghexid"]];
        [detectionObject removeObserver:self forKeyPath:@"percentageComplete"];
    }
	
	[super viewWillDisappear:animated];
}

- (void)updateTables {
    UserDataDatabase* database = [UserDataDatabase getSharedInstance];
    NSString* dateOrder = @"datetime DESC";
    NSArray* pendingResults = [database findObservationsByStatus:@"pending-noid" like:NO orderBy:dateOrder];
    NSArray* idedResults = [database findObservationsByStatus:@"pending-id" like:NO orderBy:dateOrder];
    
    pendingObservations = [[NSMutableArray alloc] initWithArray: pendingResults];
    idedObservations = [[NSMutableArray alloc] initWithArray: idedResults];
    
    selectedSection = -1;
    selectedRow = -1;
    [self.tableView reloadData];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"percentageComplete"]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self updateTables];
        });
    }
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
	// uncommenting this section will cause a crash when deleting all of the
	// observations that are being displayed.
//	unsigned long count = 0;
//	if (pendingObservations.count > 0) {
//		++count;
//	}
//	if (idedObservations.count > 0) {
//		++count;
//	}
//	
//	if (count == 0) {
//		return 0;
//	}
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger count = -1;
	
	// All variable declaration must be pulled out of the switch statment
	switch (section) {
		case 0:
			count = [pendingObservations count];
			break;
		case 1:
			count = [idedObservations count];
			break;
		default:
			count = 0;
			break;
	}
	
	return count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSDictionary *obsToRemove = [[NSDictionary alloc] initWithDictionary:[self getInfoForSection:indexPath.section andRow:indexPath.row]];
		
		switch (indexPath.section) {
			case 0:
				[pendingObservations removeObjectAtIndex:indexPath.row];
				break;
				
			case 1:
				[idedObservations removeObjectAtIndex:indexPath.row];
				break;
				
			default:
				break;
		}
		
		[[UserDataDatabase getSharedInstance] deleteObservationByID:[obsToRemove objectForKey:@"imghexid"]];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // Unsubsribe from deleted object, not really necessary.
        detectionHelper* detectionObject = [IdentifyingAssets getByimghexid:[obsToRemove objectForKey:@"imghexid"]];
        [detectionObject removeObserver:self forKeyPath:@"percentageComplete"];
	}
	else {
		NSLog(@"Unhandled editing sytle! %ld", editingStyle);
	}
}

- (NSDictionary *)getInfoForSection:(long)section andRow:(long)row{
	
	NSArray *data;
	
	switch (section) {
		case 0:
			data = pendingObservations;
			break;
		
		case 1:
			data = idedObservations;
			break;
		default:
			return NULL;
			break;
	}
	
	return [data objectAtIndex:row];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	ObservationCell *cell;
	NSArray *data;
	if (indexPath.section == 0) {
		data = pendingObservations;
		cell = [tableView dequeueReusableCellWithIdentifier:@"ObservationCell_ID" forIndexPath:indexPath];
	}
	else if (indexPath.section == 1){
		data = idedObservations;
		cell = [tableView dequeueReusableCellWithIdentifier:@"ObservationCell_ID_2" forIndexPath:indexPath];
	}
	else {
		return cell;
	}
	
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
	
	NSString *t = [dic objectForKey:@"isSilene"];
	NSString *name;
	
	if ([t isEqualToString:@"yes"]) {
		name = @"Silene acalis";
	}
	else if ([t isEqualToString:@"idk"]){
		name = @"Unidentified";
	}
	else {
		name = @"Unknown";
	}
	
	cell.nameLabel.text		= name;
	cell.dateLabel.text		= [NSString stringWithFormat:@"%@", [dic objectForKey:@"datetime"]];
	if ([dic objectForKey:@"percentIDed"] == NULL) {
		cell.percentLabel.text	= @"";
	}
	else{
		cell.percentLabel.text	= [NSString stringWithFormat:@"%@%%", [dic objectForKey:@"percentIDed"]];
	}

	return cell;
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

		ObsDetailViewController *destViewController = segue.destinationViewController;
		
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
		
		destViewController.plantInfo = selectedPendingObservation;
	}
}

- (IBAction)syncAllBtn:(UIButton *)sender {
	unsigned long originalCount = idedObservations.count;
	if (originalCount == 0) {
		return;
	}
	//[self setCurrentCount:[NSNumber numberWithUnsignedLong: originalCount]];
	IdentifyingAssets *assetID = [IdentifyingAssets getSharedInstance];
	[assetID setCurrentSyncCount:[NSNumber numberWithUnsignedLong:originalCount]];
	
	//[[self syncBtn] setTitle:[NSString stringWithFormat:@"Syncing... (%d/%lu)", 1, originalCount] forState:UIControlStateNormal];

	[[self syncBtn] setEnabled:NO];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		
		for(NSMutableDictionary *object in idedObservations){
			
			NSDictionary* observationData = object;
			
			// Get position and time data
			NSString* date = [NSString stringWithFormat:@"%@", [observationData objectForKey:@"datetime"]];
			float lat = [[observationData objectForKey:@"latitude"] floatValue];
			float lng = [[observationData objectForKey:@"longitude"] floatValue];
            float locationerror = [[observationData objectForKey:@"locationerror"] floatValue];
			
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
						 
						 
						 // upload to server
						 //sleep(2.5);
						 [ServerAPI uploadObservation:date time:date lat:lat lng:lng locationerror:locationerror image:normalizedImage];
						 
						 // change status of observation in the database
						 //sleep(0.8);
						 [[UserDataDatabase getSharedInstance] updateObservation:[object objectForKey:@"imghexid"] andNewPercentIDed:[object objectForKey:@"percentIDed"] andNewStatus:@"synced" isSilene:nil];
						 
						 // update and remove synced rows.
						 dispatch_async(dispatch_get_main_queue(), ^{
							 NSUInteger rowIndex = [idedObservations indexOfObject:object];
							 
							 [idedObservations removeObject:object];
							 
							 //[self setCurrentCount:[NSNumber numberWithUnsignedLong:(originalCount - idedObservations.count + 1)]];
							 [assetID setCurrentSyncCount:[NSNumber numberWithUnsignedLong:(originalCount - idedObservations.count + 1)]];
							 
							 [[self syncBtn] setTitle:[NSString stringWithFormat:@"Syncing... (%@/%lu)", [assetID currentSyncCount], originalCount] forState:UIControlStateNormal];
							 
							 [self removeRow:rowIndex inSection:1];
							 
							 if (idedObservations.count == 0) {
								 [[self syncBtn] setEnabled:YES];
								 [[self syncBtn] setTitle:[NSString stringWithFormat:@"Sync All"] forState:UIControlStateNormal];
								 [idedObservations removeAllObjects];
								 [self.tableView reloadData];
							 }
						 });
					 }
					failureBlock: nil];
		}
	});
}

-(void) removeRow:(NSUInteger)row inSection:(NSUInteger)section{
	NSIndexPath *myIndex = [NSIndexPath indexPathForRow:row inSection:section];
	@try {
		[[self tableView] deleteRowsAtIndexPaths:@[myIndex] withRowAnimation:UITableViewRowAnimationFade];
	}
	@catch (NSException * e) {
		ALog(@"Exception: %@", e);
	}
}


@end
