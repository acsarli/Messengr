//
//  CBAboutViewController.m
//  Messengr
//
//  Created by Adrian Sarli on 6/30/13.
//  Copyright (c) 2013 Adrian Sarli. All rights reserved.
//

#import "CBAboutViewController.h"
#import <MessageUI/MessageUI.h>

@interface CBAboutViewController ()

@end

@implementation CBAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)email:(id)sender
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    [picker setSubject:@"Messengr"];
    [picker setToRecipients:[NSArray arrayWithObject:@"info+MessengrApp@codebeam.com"]];
    
    picker.navigationBar.barStyle = UIBarStyleDefault; // choose your style, unfortunately, Translucent colors behave quirky.
    
    picker.mailComposeDelegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
}
-(IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
