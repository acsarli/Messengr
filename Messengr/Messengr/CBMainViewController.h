//
//  CBMainViewController.h
//  Messengr
//
//  Created by Adrian Sarli on 5/30/13.
//  Copyright (c) 2013 Adrian Sarli. All rights reserved.
//

#import "CBFlipsideViewController.h"

@interface CBMainViewController : UIViewController <CBFlipsideViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView * tv;

- (IBAction)showInfo:(id)sender;

@end
