//
//  MainViewController.h
//  InstantTimer
//
//  Created by Scott Ferguson on 10-09-25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import <AVFoundation/AVFoundation.h>

extern NSString * const FormatStringFor00;
extern NSString * const UserDefaultKey;

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, AVAudioPlayerDelegate> {

    UIButton *pauseStartButton;
    UIButton *stopButton;
    UILabel *hoursLabel;
    UILabel *minutesLabel;
    UILabel *secondsLabel;
    NSTimer *displayTimer;
    NSTimer *countdownTimer;
    NSTimeInterval secondsToCountdown;
}

@property (retain) IBOutlet UIButton *pauseStartButton;
@property (retain) IBOutlet UIButton *stopButton;
@property (retain) IBOutlet UILabel *hoursLabel;
@property (retain) IBOutlet UILabel *minutesLabel;
@property (retain) IBOutlet UILabel *secondsLabel;

- (IBAction)showInfo:(id)sender;
- (IBAction)pauseStartCountdown:(id)sender;
- (IBAction)stopCountdown:(id)sender;

@end
