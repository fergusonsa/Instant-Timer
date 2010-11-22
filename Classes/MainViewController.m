//
//  MainViewController.m
//  InstantTimer
//
//  Created by Scott Ferguson on 10-09-25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

NSString * const FormatStringFor00 = @"%.2i";
NSString * const UserDefaultKey = @"InstantTimer_TimerDuration";

@interface MainViewController ()

@property () NSTimeInterval secondsToCountdown;
@property (retain) NSTimer *displayTimer;
@property (retain) NSTimer *countdownTimer;

- (void)countdownCompletedSoAlertUser;
- (void) startUpdatingDisplay;
- (void) updateTimeRemainingDisplay;
- (void) displayTimeRemaining;

@end

@implementation MainViewController

@synthesize stopButton, pauseStartButton, hoursLabel, minutesLabel, secondsLabel, displayTimer, countdownTimer, secondsToCountdown;

- (void)viewDidLoad {    
	[super viewDidLoad];
    DebugLog(@"starting");
    if (self.secondsToCountdown == 0.0f && !self.countdownTimer && ![self.countdownTimer isValid]) {
        NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
        self.secondsToCountdown = [userDefs doubleForKey:UserDefaultKey];
    }    
    // Registers this class as the delegate of the audio session. 
    [[AVAudioSession sharedInstance] setDelegate: self];
    
    // The AmbientSound category allows application audio to mix with Media Player 
    // audio. The category also indicates that application audio should stop playing 
    // if the Ring/Siilent switch is set to "silent" or the screen locks. 
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: nil];
    
    // Activates the audio session. 
    NSError *activationError = nil; 
    [[AVAudioSession sharedInstance] setActive: YES error: &activationError];
}

- (void) startUpdatingDisplay {
    DebugLog(@"starting");
    // In case the countdown timer has been running for a while, calculate the time remaining to show.
    NSDate *fireDate = [self.countdownTimer fireDate];
    self.secondsToCountdown = [fireDate timeIntervalSinceNow];
    if (self.secondsToCountdown > 0.0f && self.countdownTimer && [self.countdownTimer isValid]) {
        // Timer is already running so start the display timer to update the time remaining properly
        // get the time remaining to display.
        
        if (self.displayTimer == nil) {
            self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimeRemainingDisplay) userInfo:nil repeats:YES];   
        }
    }
    [self displayTimeRemaining];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DebugLog(@"starting");
    // Check to see if the countdown timer is not running and there is a time set
    if (self.secondsToCountdown > 0.0f && !self.countdownTimer && ![self.countdownTimer isValid]) {
        //Get the default time duration
        NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
        self.secondsToCountdown = [userDefs doubleForKey:UserDefaultKey];
        // If there is no default set, send the user to the info page.
//        if (self.secondsToCountdown == 0.0f) {
//            [self showInfo:self];
//            return;
//        } 
        // Start it!
        if (self.secondsToCountdown > 0.0f && self.countdownTimer == nil) {
            self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:self.secondsToCountdown target:self selector:@selector(countdownCompletedSoAlertUser) userInfo:nil repeats:NO];   
        }
    } 
    [self startUpdatingDisplay];

}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    DebugLog(@"starting");
    
    if (!self.countdownTimer || ![self.countdownTimer isValid]) {
        // Get the time duration
        //Get the default time duration
        NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
        self.secondsToCountdown = [userDefs doubleForKey:UserDefaultKey];
    }        
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)pauseStartCountdown:(id)sender {
    DebugLog(@"starting");
    // If the timer is currently going, pause it
    if (self.secondsToCountdown == 0.0f || self.countdownTimer || [self.countdownTimer isValid]) {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
        [self.displayTimer invalidate];
        self.displayTimer = nil;

    } else {
        // Start it!
        if (self.countdownTimer == nil) {
            self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:self.secondsToCountdown target:self selector:@selector(countdownCompletedSoAlertUser) userInfo:nil repeats:NO];   
        }
        if (self.displayTimer == nil) {
            self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimeRemainingDisplay) userInfo:nil repeats:YES];   
        }
    }

        
}

- (IBAction)stopCountdown:(id)sender {
    DebugLog(@"starting");
    if ( self.countdownTimer || [self.countdownTimer isValid])
    {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
        [self.displayTimer invalidate];
        self.displayTimer = nil;
        
    }
}

- (IBAction)showInfo:(id)sender {    
    DebugLog(@"starting");
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (void)countdownCompletedSoAlertUser {
    DebugLog(@"starting");
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Instant Timer" message:@"Time up!." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];

    if ( self.displayTimer || [self.displayTimer isValid])
    {
        [self.displayTimer invalidate];
        self.displayTimer = nil;
        
    }
    
}

- (void) displayTimeRemaining {
    DebugLog(@"starting");
    self.secondsToCountdown = [[self.countdownTimer fireDate] timeIntervalSinceNow];
    if (self.secondsToCountdown < 0.0f) {
        self.secondsToCountdown = 0.0f;
    }
    
    NSNumber *num = [NSNumber numberWithDouble:self.secondsToCountdown];
    int intTime = [num intValue];
    // Set the picker to the defaul duration.
    self.secondsLabel.text = [NSString stringWithFormat:FormatStringFor00, intTime % 60];
    self.minutesLabel.text = [NSString stringWithFormat:FormatStringFor00, (intTime % 3600) / 60];
    self.hoursLabel.text = [NSString stringWithFormat:FormatStringFor00, intTime / 3600];
}

- (void) updateTimeRemainingDisplay {
    DebugLog(@"starting");
    if (self.secondsToCountdown > 0) {
        self.secondsToCountdown -= 1.0f;
    }
    [self displayTimeRemaining];
    
}

- (void)didReceiveMemoryWarning {
    DebugLog(@"starting");
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    DebugLog(@"starting");
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.stopButton = nil;
    self.pauseStartButton = nil;
    self.hoursLabel = nil;
    self.minutesLabel = nil;
    self.secondsLabel = nil;
    [self.displayTimer invalidate];
    self.displayTimer = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    DebugLog(@"starting");
	// Allow any orientation.
	return YES;
}

- (void)dealloc {
    DebugLog(@"starting");
    self.stopButton = nil;
    self.pauseStartButton = nil;
    self.hoursLabel = nil;
    self.minutesLabel = nil;
    self.secondsLabel = nil;
    [self.displayTimer invalidate];
    self.displayTimer = nil;
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
    [super dealloc];
}
@end
 
