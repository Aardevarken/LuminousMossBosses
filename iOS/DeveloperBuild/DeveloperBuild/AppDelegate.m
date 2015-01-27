//
//  AppDelegate.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 1/5/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "AppDelegate.h"
#import "Observation.h"
#import "ObsTableViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

NSMutableArray *_observations;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	// Override point for customization after application launch.
	_observations = [NSMutableArray arrayWithCapacity:20];
	
	Observation *newObs = [[Observation alloc] init];
	newObs.name = @"name test 1";
	newObs.date = @"data test 1";
//	observation.plantImage = 1;
	newObs.percent = @"10%";
	[_observations addObject:newObs];
	
	newObs = [[Observation alloc] init];
	newObs.name = @"name test 2";
	newObs.date = @"data test 2";
//	observation.plantImage = 2;
	newObs.percent = @"20%";
	[_observations addObject:newObs];
	
	newObs = [[Observation alloc] init];
	
	newObs.name = @"name test 3";
	newObs.date = @"data test 3";
//	observation.plantImage = 3;
	newObs.percent = @"30%";
	[_observations addObject:newObs];
	
	
	/*
	UITabBarController *tabBarController = (UITabBarController *) self.window.rootViewController;
	UINavigationController *navigationController = [tabBarController viewControllers][0];
	ObsViewController *obsViewController = [navigationController viewControllers][0];
	obsViewController.observations = _observations;
	*/
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
