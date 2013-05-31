//
//  CBMainViewController.h
//  Messengr
//
//  Created by Adrian Sarli on 5/30/13.
//  Copyright (c) 2013 Adrian Sarli. All rights reserved.
//

#import "CBFlipsideViewController.h"
#import <dispatch/dispatch.h>
#import "CBPictureCell.h"
#import "ViewController.h"

@interface CBMainViewController : UIViewController <CBFlipsideViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    dispatch_queue_t backgroundQueue;
}

@property (strong, nonatomic) IBOutlet UITableView * tv;

@property (strong, nonatomic) NSArray *data;
- (IBAction)showInfo:(id)sender;

- (void)getData;

@end
