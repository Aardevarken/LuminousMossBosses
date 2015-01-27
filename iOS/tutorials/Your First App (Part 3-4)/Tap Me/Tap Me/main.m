//
//  main.m
//  Tap Me
//
//  Created by Jacob Rail on 12/28/14.
//  Copyright (c) 2014 CU Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

/////
///  UIApplication serves as the central brain of your app. It gives you a
///	 powerful app with graphical capabilities that allows your app to take
///	 advantage of all of the features of an iOS device.

///  While command-line applications will have more code in main.m, iOS apps
///	 just need to boot up UIApplication and hand off control.

///	 In 99.99% of the iOS apps you’ll encounter as a developer, you never need
///	 to edit main.m; therefore it is stored away in the Supporting Files folder.
/////
int main(int argc, char * argv[]) {
	@autoreleasepool {
	    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
	}
}
