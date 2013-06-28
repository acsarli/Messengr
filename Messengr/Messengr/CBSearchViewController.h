//
//  CBSearchViewController.h
//  Messengr
//
//  Created by Adrian Sarli on 6/27/13.
//  Copyright (c) 2013 Adrian Sarli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketIO.h"

@interface CBSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property IBOutlet UISearchBar *sb;
@property IBOutlet UITableView *tv;
@property SocketIO *socket;
@property NSArray *data;

-(IBAction)done:(id)sender;
@end
