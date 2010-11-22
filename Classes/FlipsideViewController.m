//
//  FlipsideViewController.m
//  InstantTimer
//
//  Created by Scott Ferguson on 10-09-25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import "MainViewController.h"


@implementation FlipsideViewController

@synthesize delegate, picker;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];      
    //Get the default time duration
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    NSTimeInterval time = [userDefs doubleForKey:UserDefaultKey];
    // If there is no default set, use coded default.
    if (time == 0.0f) {
        //(should only do this the first time the ap is used after it is installed)
        time = 600.0f;
    }
    // Set the picker to the defaul duration.
    self.picker.countDownDuration = time;
}


- (IBAction)done:(id)sender {
    // Save the countDownDuration to the user defaults
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    [userDefs setDouble:[self.picker countDownDuration] forKey:UserDefaultKey];
    
	[self.delegate flipsideViewControllerDidFinish:self];	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
    self.picker = nil;
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
    self.picker = nil;
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Allow any orientation
	return YES;
}


- (void)dealloc {
    self.picker = nil;
    [super dealloc];
}


@end
