//
//  DetailViewController.h
//  JSONiOS
//
//  Created by Kurup, Vishal on 4/14/13.
//  Copyright (c) 2013 conkave. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * population;
@property (nonatomic, strong) NSString * country;

@property (strong, nonatomic) IBOutlet UILabel *cityName;
@property (strong, nonatomic) IBOutlet UILabel *cityPopulation;
@property (strong, nonatomic) IBOutlet UILabel *cityCountry;

@end
