//
//  CBMainViewController.m
//  Messengr
//
//  Created by Adrian Sarli on 5/30/13.
//  Copyright (c) 2013 Adrian Sarli. All rights reserved.
//

#import "CBMainViewController.h"

@interface CBMainViewController ()

@end

@implementation CBMainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Setup the toolbar items
    
    //Gear button; Goes on left
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(showInfo:)];
    settingsButton.title = @"\u2699";
    UIFont *f1 = [UIFont fontWithName:@"Helvetica" size:24.0];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:f1, UITextAttributeFont, nil]; [settingsButton setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    //Contact button; Goes on right
    UIBarButtonItem *contactButton = [[UIBarButtonItem alloc] initWithTitle:@"Contacts" style:UIBarButtonItemStyleBordered target:self action:@selector(showContacts:)];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = settingsButton;
    self.navigationItem.rightBarButtonItem = contactButton;
    self.title = @"Messengr";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(CBFlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showInfo:(id)sender
{    
    CBFlipsideViewController *controller = [[CBFlipsideViewController alloc] initWithNibName:@"CBFlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}

@end
