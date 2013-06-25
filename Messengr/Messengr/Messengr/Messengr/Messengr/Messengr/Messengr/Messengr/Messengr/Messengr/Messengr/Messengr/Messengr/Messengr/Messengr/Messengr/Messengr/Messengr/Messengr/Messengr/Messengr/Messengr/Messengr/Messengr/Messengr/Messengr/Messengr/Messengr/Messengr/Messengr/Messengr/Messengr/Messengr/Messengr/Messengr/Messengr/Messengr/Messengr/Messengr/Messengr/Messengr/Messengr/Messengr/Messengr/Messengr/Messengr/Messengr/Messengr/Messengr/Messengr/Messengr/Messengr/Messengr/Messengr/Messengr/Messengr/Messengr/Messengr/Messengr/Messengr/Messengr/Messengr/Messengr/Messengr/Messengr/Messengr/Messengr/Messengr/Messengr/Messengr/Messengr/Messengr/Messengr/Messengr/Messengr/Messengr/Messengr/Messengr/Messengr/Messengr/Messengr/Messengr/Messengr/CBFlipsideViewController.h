//
//  CBFlipsideViewController.h
//  Messengr
//
//  Created by Adrian Sarli on 5/30/13.
//  Copyright (c) 2013 Adrian Sarli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBFlipsideViewController;

@protocol CBFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(CBFlipsideViewController *)controller;
@end

@interface CBFlipsideViewController : UIViewController

@property (weak, nonatomic) id <CBFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
