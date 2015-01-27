//
//  ViewController.h
//  Tap Me
//
//  Created by Jacob Rail on 12/28/14.
//  Copyright (c) 2014 CU Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>	// Allows us to use AVAudioPlayer class

/////
///	 My notes:
/*
 *	A header file is used to declare different parts of the program. Declaring
 *	means to say that it exists, but doesn’t give the actual implementation 
 *	details.

 *	An outlet in Xcode is some variable in the view controller that refers to
 *	some user interface element in the storyboard view.	
 */
/////

@interface ViewController : UIViewController<UIAlertViewDelegate> {
	/// The following two lines of code set up instance variables that can be
	/// used to programatically change the label text.
	
	// IBOutlet -	tell xcode you want it to be an outlet.
	// UILabel	-	class name for a text label.
	IBOutlet UILabel *scoreLabel;
	IBOutlet UILabel *timerLabel;

	// AVAudioPlayer objects
	AVAudioPlayer *buttonBeep;
	AVAudioPlayer *secondBeep;
	AVAudioPlayer *backgoundMusic;
	
	/// Additional variables. These will all be visable to the ViewController.m
	///	and all the methods in it.
	NSInteger	count;		// # of times the button has been pressed.
	NSInteger	seconds;	// seconds remaining
	NSTimer		*timer;		// .....
	
	/// Additional variables i added after the tutorial
	// .....
}

/////
///	 declaration for the method 'buttonPressed'
/*
 *	IBAction is telling Xcode that this method will be connected to some action.
 *	such as a button press or a switch being toggled.
 */
/////
- (IBAction)buttonPressed;


@end

