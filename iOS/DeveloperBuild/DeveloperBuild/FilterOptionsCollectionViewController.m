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

#define RED 0/255.0
// NOTE, for green the float value of 92/255.0 does not produce a value of 92
// when displayed in the simulator. 0.48 however does.
// I used a color picker to ret the value of the grid tab when selected.
#define GREEN 0.48//92/255.0
#define BLUE 255/255.0
#define ALPHA 100/100.0



@interface FilterOptionsCollectionViewController ()
//! Create an array of NSStrings representing the image path.
/*!
 Runs a table query with the FieldGuideManager for the image names. These image
 names are stored in the optionsToFilter methods. This method is only called once durring loading to display all of the images.
 /return An array where every element is an NSString in the format of: "GlossaryImages/<filename>.jpeg".
 */
- (NSArray*) createImageArray;
@end

@implementation FilterOptionsCollectionViewController{
	NSUInteger numberOfImages;			/*! number of images to display. Counted durring loading to increase preformance. */
}

@synthesize filterOptionIndexNumber;
@synthesize imageCollectionView;
@synthesize filterOptionImagePath;
@synthesize optionsToFilter;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	filterOptionImagePath = [self createImageArray];
	numberOfImages = [filterOptionImagePath count];
	// for debugging
//	[self printFilterOptionsImages];
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
	NSString *imgpath = [filterOptionImagePath objectAtIndex:indexPath.row];
	
	UIImage *tempImage = [UIImage imageNamed:imgpath];
	
	if (!tempImage) {
		ALog(@"Image %@ could not be found\n", imgpath);
		// image from https://www.contender.com/img/icon-exclamation.png
		tempImage = [UIImage imageNamed:@"icon-exclamation.png"];
	}
	else {
	
	}
	
	viewcell.optionImage.image = tempImage;
	
	return viewcell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [imageCollectionView cellForItemAtIndexPath:indexPath];
	cell.contentView.backgroundColor = [UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:ALPHA];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell *cell = [imageCollectionView cellForItemAtIndexPath:indexPath];
	cell.contentView.backgroundColor = [UIColor blackColor];
	[cell setSelected:NO];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	NSArray *a = [[NSArray alloc] initWithArray:[[self imageCollectionView] indexPathsForSelectedItems]];
	NSInteger i = [a indexOfObject:indexPath];

	if (i == NSNotFound) {
		return YES;
	} else {
		UICollectionViewCell *cell = [imageCollectionView cellForItemAtIndexPath:indexPath];
		[cell setSelected:NO];
		[[self imageCollectionView] deselectItemAtIndexPath:indexPath animated:NO];
		cell.contentView.backgroundColor = [UIColor blackColor];
		return NO;
	}
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSArray*) createImageArray{
	FieldGuideManager *fgm = [FieldGuideManager getSharedInstance];
	FilterOptions *fo = [FilterOptions getSharedInstance];
	NSString *dbname = [[fo filterDatabasenNamesWithImages] objectAtIndex:filterOptionIndexNumber];
	
	[self setOptionsToFilter:[fgm getFilterOptionsFor:dbname]];
	
	NSMutableArray *imageNamesWithPath = [[NSMutableArray alloc] initWithCapacity:[[self optionsToFilter] count]];
	UIImage *tempImage;
	for (NSString* img in [self optionsToFilter]) {
		
		NSString *imgpath = [[NSString alloc] initWithFormat:@"GlossaryImages/%@.jpeg", img];
		tempImage = [UIImage imageNamed:imgpath];
		
		if (!tempImage) {
			ALog(@"Image %@ could not be found\n", imgpath);
			break;
		}
		else {
			[imageNamesWithPath addObject:imgpath];
		}
	}
	
	// Might need to dealloc some memory here.
	return [[NSArray alloc] initWithArray:imageNamesWithPath];
}

- (void)printFilterOptionsImages{
	printf("Contents of filterOptionsImages:\n");
	for (unsigned long index = 0; index < filterOptionImagePath.count; ++index) {
		printf("\t [%lu] %s\n", index, [[filterOptionImagePath objectAtIndex:index] UTF8String]);
	}
	printf("\n");
}

#pragma mark - IBaction
- (IBAction)saveButton:(UIButton *)sender {
	NSArray *selectedItems = [[self imageCollectionView] indexPathsForSelectedItems];
	NSAssert([selectedItems count] <= 1, @"Multiple selection is not supported");

	NSIndexPath *indexPath = [selectedItems firstObject];
	NSUInteger index = indexPath.row;
	NSString *newFilterValue;
	
	if (index == 0) {
		newFilterValue = @"All";
	}
	else{
		newFilterValue = [[self optionsToFilter] objectAtIndex:index];
	}
	
	FilterOptions *fo = [FilterOptions getSharedInstance];
	[fo updateFilterOptionsWithImagesAtIndex:filterOptionIndexNumber withOption:newFilterValue];
	
	[[self navigationController] popViewControllerAnimated:YES];
}
@end
