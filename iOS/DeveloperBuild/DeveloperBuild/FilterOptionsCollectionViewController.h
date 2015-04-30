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
@property (nonatomic, readwrite) NSUInteger filterOptionIndexNumber;
@property (nonatomic, strong) NSArray *filterOptionImagePath;
@property (nonatomic, strong) NSArray *optionsToFilter;

@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UICollectionView *imageCollectionView;

- (IBAction)saveButton:(UIButton *)sender;
@end
