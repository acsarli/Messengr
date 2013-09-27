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
#import "CBChatViewController.h"
#import "SocketIO.h"
@interface CBMainViewController : UIViewController <CBFlipsideViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, SocketIODelegate>
{
    dispatch_queue_t backgroundQueue;
}

@property (strong, nonatomic) IBOutlet UITableView * tv;

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSString *ourName;
@property NSMutableDictionary * chatData;
@property NSMutableDictionary *vcs;
@property SocketIO *socket;
- (IBAction)showInfo:(id)sender;
-(void) registerName;

- (void)getData;
-(void) updateChatData;
-(void) contactsFTumblr;
@end
