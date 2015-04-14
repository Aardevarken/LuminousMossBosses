//
//  AppDelegate.m
//  DeveloperBuild
//
//  Created by Jacob Rail on 1/5/15.
//  Copyright (c) 2015 CU Boulder. All rights reserved.
//

#import "AppDelegate.h"
#import "UserDataDatabase.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

NSMutableArray *_observations;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	if (![CLLocationManager locationServicesEnabled]) {
		// location services is disabled, alert user
		UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DisabledTitle", @"DisabledTitle")
																		message:NSLocalizedString(@"DisabledMessage", @"DisabledMessage")
																	   delegate:nil
															  cancelButtonTitle:NSLocalizedString(@"OKButtonTitle", @"OKButtonTitle")
															  otherButtonTitles:nil];
		[servicesDisabledAlert show];
	}
	else{
		// Start the GPS tracking
		[[UserDataDatabase getSharedInstance] startLocationTracking];
	}
	
	// Clean up the database
	[[UserDataDatabase getSharedInstance] removeDeletedAssets];

	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	[[UserDataDatabase getSharedInstance] stopLocationTracking];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

	// Clean up the database
	[[UserDataDatabase getSharedInstance] removeDeletedAssets];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
