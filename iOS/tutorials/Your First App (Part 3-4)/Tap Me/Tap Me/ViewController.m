//
//  ViewController.m
//  Tap Me
//
//  Created by Jacob Rail on 12/28/14.
//  Copyright (c) 2014 CU Boulder. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
/////
///
/////
- (AVAudioPlayer *) setupAudioPlayerWithFile:(NSString *) file type:(NSString *) type
{
	// You need to know the full path to the sound file, and [NSBundle mainBundle] will tell you where in the project to look. AVAudioPlayer needs to know the path in the form of a URL, so the full path is converted to URL format.
	NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:type];
	NSURL *url = [NSURL fileURLWithPath:path];
	
	// A NSError object will store an error message if something goes wrong when setting up the AVAudioPlayer. Usually nothing will go wrong — but it’s always good practice to check for errors, just in case!
	NSError *error;
	
	// This is the important call to set up AVAudioPlayer. You’re passing in the URL, and the error will get filled in if something goes wrong.
	AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	
	// If something goes wrong, the audioPlayer will be set to nil, which you can check for with the exclamation mark symbol. If that happens, the error will be logged to the console.
	if (!audioPlayer) {
		NSLog(@"%@",[error description]);
	}
	
	// If all goes well, the AVAudioPlayer object will be returned!
	return audioPlayer;
}

/////
/// Call all these methods when the app is loaded.
/////
- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	/// Set backgound image for view
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tile.png"]];
	/// Set backgound image for time label
	timerLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"field_time.png"]];
	/// Set backgound image for score label
	scoreLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"field_score"]];
	/// Set up AVAudioPlayer objects
	buttonBeep = [self setupAudioPlayerWithFile:@"ButtonTap" type:@"wav"];
	secondBeep = [self setupAudioPlayerWithFile:@"SecondBeep" type:@"wav"];
	backgoundMusic = [self setupAudioPlayerWithFile:@"HallOfTheMountainKing" type:@"mp3"];
	
	
	[self setupGame];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


/////
/// Implementation for our buttonPressed method
/*	To link this method to something from the storyboard, make sure you are
 *	viewing the whole storyboard (by clicking outside of the view) then right
 *	click on the element and drag it to the view background and select the 
 *	method from those listed below.
 
 *	To connect an outlet to a label do the same only drag the link to the view
 *	controller (represented as the yellow circle in the view header) to the
 *	label. 
 */
/////
- (IBAction) buttonPressed
{
	/// Use this for debugging
//	NSLog(@"Pressed!");	// Print to the console when buttonPressed is called.
	
	// This is an example of how to set a label's text from code. You can also
	// set text color, size, alighment, etc.
//	scoreLabel.text = @"Pressed!";
	

	
	/// This is additional code i added after the tutorial.		////
	if (count == 0) {
		timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
												 target:self
											   selector:@selector(subtractTime)
											   userInfo:nil
												repeats:YES];
		/// Play a sound
		[backgoundMusic setVolume:0.3];
		[backgoundMusic play];
		count++;
	}
	else
	{
		/// End of my code.											////
		
		/// Play sound
		[buttonBeep play];
		
		/// Count the number of times the button is pressed.
		count ++;	// Increment the counter. I assume uninit ints are set to 0.
		
		// Update the score label.
		scoreLabel.text = [NSString stringWithFormat:@"Score\n%li", count];
	}
}


/////
///	Method for initializing the game state
/////
- (void) setupGame
{
	/// Initialize variables
	seconds = 30;	// starting time
	count = 0;		// # of counts
	
	/// Initialize timer and score labels
	timerLabel.text = [NSString stringWithFormat:@"Time: %i", seconds];
	scoreLabel.text = [NSString stringWithFormat:@"Score\n%i", count];
	
	
//	/// Play a sound
//	[backgoundMusic setVolume:0.0];
//	[backgoundMusic play];
	
	/// I have moved this timer so that the timer starts when you tap the button
	/// Start updating the timer
	//	TimeInterval	-	timer will go off every 1 second.
	//	target	-	where to send the message? self to update our view.
	//	selector	-	what method you want to call, put @selector around attribute names
	//	userInfo	-	any extra info you want to store in the timer
	//	repeates	-	if the timer should repeat or just fire off once.
//	timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
//											 target:self
//										   selector:@selector(subtractTime)
//										   userInfo:nil
//											repeats:YES];
	
	/// This is additional code i added after the tutorial.		////
//	[tapButton setTitle:@"Tap here to begin"
//			   forState:UIControlStateNormal];
	/// End of my code.											////
}

/////
/// Method for subtracting time every second
/////
- (void) subtractTime
{
	seconds--;
	timerLabel.text = [NSString stringWithFormat:@"Time: %i", seconds];
	
	/// Play a sound
	[secondBeep play];
	
	/// check to see if time left = 0
	if (seconds == 0){
		[timer invalidate];	// stop the timer from calling subtractTime again.
		
		/// Alert when game is over
		// Title	-	title that appears at the top of the alert
		// Message	-	message in the center of the alert.
		// Delegate	-	.....
		// Cancel Button Title	-	title of the button
		// Other Button Titles	-	list of additional button titles
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle:@"Time is up!"
							  message:[NSString stringWithFormat:@"You scored %i points", count]
							  delegate:self
							  cancelButtonTitle:@"Play Again"
							  otherButtonTitles:nil];
		[alert show];
		
		// my code to lower volume when a game is done.
		[backgoundMusic setVolume:0.1];
	}
}

/////
/// Alert view method.
/*	
 *	When the game ends, a UIAlertView will be displayed with the score and a
 *	button. When the button is tapped, a message will be sent to the delegate 
 *	-— your view controller -— which will then call the setupGame method.	
 */
/////
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self setupGame];
}


@end



///	EOF ///