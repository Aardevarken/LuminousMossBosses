//
//  MyObsTabBarController.h
//  DeveloperBuild
//
//  Created by Jacob Rail on 4/13/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyObsTabBarController : UITabBarController


@property (strong, nonatomic) IBOutlet UIBarButtonItem *cameraButton;


/**
 * When the user hits the home button, remove everything from the
 navigation stack and go to the root.
 * This button replaces the back button in the naviation bar.
 */
- (IBAction)homeButton:(UIBarButtonItem *)sender;

@end
