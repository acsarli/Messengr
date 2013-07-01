//
//  CBFlipsideViewController.h
//  Messengr
//
//  Created by Adrian Sarli on 5/30/13.
//  Copyright (c) 2013 Adrian Sarli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class CBFlipsideViewController;

@protocol CBFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(CBFlipsideViewController *)controller;
@end

@interface CBFlipsideViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView * settingsTable;
@property (weak, nonatomic) id <CBFlipsideViewControllerDelegate> delegate;
@property UIAlertView *lav;
@property UIAlertView *dav;
- (IBAction)done:(id)sender;

@end
