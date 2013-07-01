//
//  CBContactsViewController.h
//  Messengr
//
//  Created by Adrian Sarli on 6/30/13.
//  Copyright (c) 2013 Adrian Sarli. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SocketIO;

@interface CBContactsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) SocketIO *socket;
@property (strong, nonatomic) NSMutableArray *contacts;
@property (strong, nonatomic) IBOutlet UITableView *tv;
-(IBAction)addContact:(id)sender;
-(IBAction)done:(id)sender;
@end
