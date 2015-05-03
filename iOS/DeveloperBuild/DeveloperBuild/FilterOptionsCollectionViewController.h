//
//  FilterOptionsCollectionViewController.h
//  Luminous ID
//
//  Created by Jacob Rail on 4/29/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "FilterOptionImageCollectionViewCell.h"

@interface FilterOptionsCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>{
	
}
//! Reference number to the filter option in the FilterOptions singletion.
/*! A property set in the prepare for segue method of a calling controller. 
 It is used as a reference for the FilterOptions class to know what option was 
 selected. 
 */
@property (nonatomic, readwrite) NSUInteger filterOptionIndexNumber;

//! An array of options for the user to choose from
/*!
 */
@property (nonatomic, strong) NSArray *optionsToFilter;

//! Image representation of the option
/*!
 */
@property (nonatomic, strong) NSArray *filterOptionImagePath;

@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UICollectionView *imageCollectionView;

- (IBAction)saveButton:(UIButton *)sender;
@end
