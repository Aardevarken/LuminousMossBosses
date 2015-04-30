//
//  FilterOptionsCollectionViewController.m
//  Luminous ID
//
//  Created by Jacob Rail on 4/29/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "FilterOptionsCollectionViewController.h"
#import "FilterOptions.h"
#import "FieldGuideManager.h"
#import "FilterOptionImageCollectionViewCell.h"

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define printa(fmt, ...) printf(("%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@interface FilterOptionsCollectionViewController ()
- (NSArray*) createImageArray;
@end

@implementation FilterOptionsCollectionViewController{
	NSArray *filterOptionImages;
	NSUInteger numberOfImages;
}
@synthesize filterOptionIndexNumber;
@synthesize imageCollectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	filterOptionImages = [self createImageArray];
	numberOfImages = [filterOptionImages count];
	// for debugging
//	[self printFilterOptionsImages];
//	[[self imageCollectionView] reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	return numberOfImages;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *identifier = @"FilterOptionImageCVC";
	
	FilterOptionImageCollectionViewCell *viewcell = [imageCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
	NSString *imgpath = [filterOptionImages objectAtIndex:indexPath.row];
	
	UIImage *tempImage = [UIImage imageNamed:imgpath];
	
	if (!tempImage) {
		ALog(@"Image %@ could not be found\n", imgpath);
		tempImage = [UIImage imageNamed:@"round_button_normal2.png"];
	}
	else {
	
	}
	
	viewcell.optionImage.image = tempImage;
	
	return viewcell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	printf("----------SELECTED---------\n");
	printf("index [0]=%lu [1]=%lu\n", indexPath.section, indexPath.row);
	printf("img path: %s\n", [[filterOptionImages objectAtIndex:indexPath.row] UTF8String]);
	printf("\n-----------------------\n");
	
	// TODO: Select Item
	UICollectionViewCell *cell = [imageCollectionView cellForItemAtIndexPath:indexPath];
	cell.contentView.backgroundColor = [UIColor blueColor];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	printf("----------DESELECTED---------\n");
	printf("index [0]=%lu [1]=%lu\n", indexPath.section, indexPath.row);
	printf("img path: %s\n", [[filterOptionImages objectAtIndex:indexPath.row] UTF8String]);
	printf("\n-------------------------\n");
	
	// TODO: Deselect item
	UICollectionViewCell *cell = [imageCollectionView cellForItemAtIndexPath:indexPath];
	cell.contentView.backgroundColor = [UIColor blackColor];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - private member functions
- (NSArray*) createImageArray{
	FieldGuideManager *fgm = [FieldGuideManager getSharedInstance];
	FilterOptions *fo = [FilterOptions getSharedInstance];
	NSString *dbname = [[fo filterDatabasenNamesWithImages] objectAtIndex:filterOptionIndexNumber];
	
	NSArray *rawImageNames = [[NSArray alloc] initWithArray:[fgm getFilterOptionsFor:dbname]];
	
	NSMutableArray *imageNamesWithPath = [[NSMutableArray alloc] initWithCapacity:rawImageNames.count];
	for (NSString* img in rawImageNames) {
		[imageNamesWithPath addObject:[[NSString alloc] initWithFormat:@"GlossaryImages/%@.jpeg", img]];
	}
	
	// Might need to dealloc some memory here.
	return [[NSArray alloc] initWithArray:imageNamesWithPath];
}

- (void)printFilterOptionsImages{
	printf("Contents of filterOptionsImages:\n");
	for (unsigned long index = 0; index < filterOptionImages.count; ++index) {
		printf("\t [%lu] %s\n", index, [[filterOptionImages objectAtIndex:index] UTF8String]);
	}
	printf("\n");
}

@end
