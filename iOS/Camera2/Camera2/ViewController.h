//
//  ViewController.h
//  Camera2
//
//  Created by Jack Skinner on 1/20/15.
//  Copyright (c) 2015 LuminousMossBoss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    
    
    __weak IBOutlet UIImageView *ImageView;
    
    
    UIImagePickerController *picker;
    UIImage *image;
}
- (IBAction)TakePhoto:(id)sender;


@end

