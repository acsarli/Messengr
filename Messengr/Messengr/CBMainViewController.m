//
//  CBMainViewController.m
//  Messengr
//
//  Created by Adrian Sarli on 5/30/13.
//  Copyright (c) 2013 Adrian Sarli. All rights reserved.
//

#import "CBMainViewController.h"
#import "SocketIOPacket.h"
#import "NSBubbleData.h"
#import "TMAPIClient.h"
#import "NSData+Conversion.h"
#import "CBSearchViewController.h"
#import "CBContactsViewController.h"
#import "UIImageView+WebCache.h"
#import "CBChatViewController.h"
#import "UIBubbleTableView.h"

@interface CBMainViewController ()
    //Private methods
@end

@implementation CBMainViewController

#pragma mark - Table View Stuff

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the cell
    CBPictureCell * cell = (CBPictureCell *) [tableView dequeueReusableCellWithIdentifier:@"CBPC"];
    if(cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CBPictureCell" owner:nil options:nil] objectAtIndex:0];
    
    //Use the cell
    if ([self.data count] < 1)
        return cell;
    cell.titleView.text = [[self.data objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    if([[[self.data objectAtIndex:indexPath.row] objectForKey:@"contact"] boolValue])
        cell.titleView.textColor = [UIColor blackColor];
    else
        cell.titleView.textColor = [UIColor grayColor];
    
    if([[[self.data objectAtIndex:indexPath.row] objectForKey:@"unread"] boolValue])
        cell.titleView.font = [UIFont boldSystemFontOfSize:17];
    else
        cell.titleView.font = [UIFont systemFontOfSize:17];
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://api.tumblr.com/v2/blog/%@.tumblr.com/avatar", cell.titleView.text]]
                                         placeholderImage:[UIImage imageNamed:@"missingAvatar.png"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *nameToTalkTo = [[self.data objectAtIndex:indexPath.row] objectForKey:@"name"];
    //Unselect row
    [self.tv deselectRowAtIndexPath:indexPath animated:NO];
    
    //Unbold row
    for (NSMutableDictionary *nameDict in self.data) {
        if ([[nameDict objectForKey:@"name"] isEqualToString:nameToTalkTo]) {
            //set as read
            [nameDict setObject:[NSNumber numberWithBool:NO] forKey:@"unread"];
        }
    }
    [self.tv reloadData];
    
    [self startChat:nameToTalkTo];
}

-(void)beginChat:(NSNotification *)notif
{
    [self startChat:notif.object];
}
-(void)startChat:(NSString *)nameToTalkTo
{
    if([self.vcs objectForKey:nameToTalkTo])
        [self.navigationController pushViewController:[self.vcs objectForKey:nameToTalkTo] animated:YES];
    else
    {
        CBChatViewController *vc = [[CBChatViewController alloc] initWithNibName:@"CBChatViewController" bundle:nil];
        vc.name = self.ourName;
        vc.chatWith = nameToTalkTo;
        vc.chatData = [self.chatData objectForKey:nameToTalkTo];
        vc.socketIO = self.socket;
        
        [self.vcs setObject:vc forKey:nameToTalkTo];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        NSString *nameToDelete = [[self.data objectAtIndex:indexPath.row] objectForKey:@"name"];
        [self.socket sendEvent:@"removeConversation" withData:nameToDelete];
        [self refreshData];
    }
}
#pragma mark - Data/API Stuff
- (void)getData
{
    //Connect to server
    self.socket = [[SocketIO alloc] initWithDelegate:self];
    ///'self.socketIO.useSecure = YES;
    [self.socket connectToHost:@"MSSGR60912.COM" onPort:8080];

}
- (void) socketIODidConnect:(SocketIO *)socket;
{
    NSLog(@"Connected");
    [self refreshData];

    
    if([[TMAPIClient sharedInstance] OAuthToken] != nil)
        [self.socket sendEvent:@"authenticate" withData:@{@"key": [[TMAPIClient sharedInstance] OAuthToken], @"secret":[[TMAPIClient sharedInstance] OAuthTokenSecret]} andAcknowledge:nil];
    
    [self registerName];
    [self refreshData];
}
- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
    NSLog(@"Disconnected... sleeping for 30 seconds");
    [self performSelectorInBackground:@selector(reconnect) withObject:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goAway" object:nil];
}

- (void) reconnect {
    [NSThread sleepForTimeInterval:1];
    [self.socket disconnect];
    [self.socket connectToHost:@" MSSGR60912.COM" onPort:8080];
}


-(void) refreshData
{
    [self.socket sendEvent:@"getConversations" withData:nil];
}

-(void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    if([packet.name isEqualToString:@"updatecontacts"] && [[packet args] count] > 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updatecontacts" object:[[packet args] objectAtIndex:0]];
        for (NSString *name in [[packet args] objectAtIndex:0]) {
            [self.socket sendEvent:@"chatHistory" withData:name];
        }
    }
    if([packet.name isEqualToString:@"updateconversations"] && [[packet args] count] > 0)
    {
        NSArray *contactNames= [[packet args] objectAtIndex:0];
        if (contactNames == [NSNull null]) {
            return;
        }
        //Remove all contacts not in the new list
        //first remove all contacts
        NSMutableArray *toDelete = [[NSMutableArray alloc] init];
        for (NSMutableDictionary *nameDict in self.data) {
            if([[nameDict objectForKey:@"contact"] isEqualToNumber:[NSNumber numberWithBool:YES]])
                [toDelete addObject:nameDict];
        }
        
        [self.data removeObjectsInArray:toDelete];
        
        for (NSString *name in contactNames)
        {
            //check for duplicate
            BOOL dup = NO;
            for (NSDictionary *nameDict in self.data) {
                if ([[nameDict objectForKey:@"name"] isEqualToString:name]) {
                    dup = YES;
                }
            }
            if(!dup)
                [self.data addObject:[@{@"name": name, @"contact":@YES, @"unread":@NO} mutableCopy]];
        }

        //if ([self.data objectForKey:self.ourName])
        //    [self.data removeObjectForKey:self.ourName];
        
        [self.tv reloadData];
        
        [self updateChatData];
        return;
    }
    //Make sure this is a chat update and not from us
    if([packet.name isEqualToString:@"updatechat"] && [[packet args] count] > 1 && ![[[packet args] objectAtIndex:0] isEqualToString:self.ourName])
    {
        //Add it to the appropriate chat data
        //First get the name of the sender
        NSString *senderName = [[packet args] objectAtIndex:0];
        NSString *message = [[packet args] objectAtIndex:1];
        
        //Change the UITableView
        BOOL dup = NO;
        //make sure the sender is in the data var
        for (NSMutableDictionary *nameDict in self.data) {
            if ([[nameDict objectForKey:@"name"] isEqualToString:senderName]) {
                dup = YES;
                
                //set unread, but only if we are't in the vc
                //bad logic...
                //TODO: fix logic...
                UIViewController *vc = [self.vcs objectForKey:senderName];
                if (vc.isViewLoaded && vc.view.window) {}
                else
                    [nameDict setObject:[NSNumber numberWithBool:YES] forKey:@"unread"];
            }
        }
        if (! dup) {
            [self refreshData];
           // [self.data addObject:[@{@"name": senderName, @"contact":@NO, @"unread":@YES} mutableCopy]];
        }
        //Refresh table
        [self.tv reloadData];
        
        //Check for vc
        if ([self.vcs objectForKey:senderName])
            [[self.vcs objectForKey:senderName] messageReceived:message];
        else //Add it to the right chatData
        {
            //Make sure the chat data exists
            if(![self.chatData objectForKey:senderName])
            {
                [self.chatData setObject:[NSMutableArray array] forKey:senderName];
                [self.socket sendEvent:@"chatHistory" withData:@{@"name":senderName, @"start":[NSNumber numberWithInt:150], @"stop":[NSNumber numberWithInt:1]}];
            }
            
            NSBubbleData *sayBubble = [NSBubbleData dataWithText:message date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeSomeoneElse];
            sayBubble.avatarImage = [[UIImageView alloc] init];
            [sayBubble.avatarImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://api.tumblr.com/v2/blog/%@.tumblr.com/avatar", senderName]]
                                  placeholderImage:[UIImage imageNamed:@"missingAvatar.png"]];
            [[self.chatData objectForKey:senderName] addObject:sayBubble];
        }
    }
    if([packet.name isEqualToString:@"name"])
    {
        self.ourName = [packet.args objectAtIndex:0];
        [self registerName];
    }
    if([packet.name isEqualToString:@"searchedContacts"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchResults" object:[packet.args objectAtIndex:0]];
    }
    if([packet.name isEqualToString:@"chatHistory"])
    {
        NSString *chatWithName = [packet.args objectAtIndex:0];
        NSArray *cData = [packet.args objectAtIndex:3];
        int start = [[packet.args objectAtIndex:1] integerValue];
        int stop = [[packet.args objectAtIndex:2] integerValue];
        
        //remove vc
        //[self.vcs removeObjectForKey:chatWithName];
        [self.chatData setObject:[NSMutableArray array] forKey:chatWithName];
        
        
        //TODO: Add receiving of additional history
        //add to data
        for (int i=0; i<([cData count]-2); i+=3) {
            double iv = [[cData objectAtIndex:i] doubleValue];
            NSTimeInterval t = floor(iv/1000);
            NSDate *d = [NSDate dateWithTimeIntervalSince1970:t];
            if([[cData objectAtIndex:i+1] isEqualToString:self.ourName])
            {
                NSBubbleData *sayBubble = [NSBubbleData dataWithText:[cData objectAtIndex:i+2] date:d type:BubbleTypeMine];
                sayBubble.avatarImage = [[UIImageView alloc] init];
                [sayBubble.avatarImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://api.tumblr.com/v2/blog/%@.tumblr.com/avatar", self.ourName]]
                                      placeholderImage:[UIImage imageNamed:@"missingAvatar.png"]];
                [[self.chatData objectForKey:chatWithName] insertObject:sayBubble atIndex:0];
            }
            else
            {
                NSBubbleData *sayBubble = [NSBubbleData dataWithText:[cData objectAtIndex:i+2] date:d type:BubbleTypeSomeoneElse];
                sayBubble.avatarImage = [[UIImageView alloc] init];
                [sayBubble.avatarImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://api.tumblr.com/v2/blog/%@.tumblr.com/avatar", [cData objectAtIndex:i+1]]]
                                      placeholderImage:[UIImage imageNamed:@"missingAvatar.png"]];
                [[self.chatData objectForKey:chatWithName] addObject:sayBubble];
            }
        }
        if([self.vcs objectForKey:chatWithName])
        {
            [(CBChatViewController *)[self.vcs objectForKey:chatWithName] setChatData:[self.chatData objectForKey:chatWithName]];
            [[(CBChatViewController *)[self.vcs objectForKey:chatWithName] bubbleTable] reloadData];
        }
    }
}

-(void)registerName
{
    if ([self.socket isConnected])
    {
        [self.socket sendEvent:@"adduser" withData:self.ourName];
            [self.socket sendEvent:@"registerDevice" withData:[[[NSUserDefaults standardUserDefaults] objectForKey:@"devicetoken"] hexadecimalString]];
    }
}

-(void) updateChatData
{
    for (NSDictionary *nameDict in self.data) {
        [self.socket sendEvent:@"chatHistory" withData:@{@"name":[nameDict objectForKey:@"name"], @"start":[NSNumber numberWithInt:150], @"stop":[NSNumber numberWithInt:1]}];
    }
}
#pragma mark - UIViewController Methods
-(void)viewDidLoad
{
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x445a75);
    self.data = [NSMutableArray array];
    backgroundQueue = dispatch_queue_create("com.adriansarli.bgqueue", NULL);
    self.chatData = [[NSMutableDictionary alloc] init];
    self.ourName = nil;
    self.vcs = [[NSMutableDictionary alloc] init];
    [self getData]; //Only call this once,please!
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginChat:) name:@"beginChat" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"logout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deactivate) name:@"deactivate" object:nil];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Get the data
    //[self getData];
    
    //Setup the toolbar items
    
    //Gear button; Goes on left
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gear"] style:UIBarButtonItemStyleBordered target:self action:@selector(showInfo:)];
       
    //Contact button; Goes on right
    UIBarButtonItem *contactButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"group"] style:UIBarButtonItemStyleBordered target:self action:@selector(addContact:)];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = settingsButton;
    self.navigationItem.rightBarButtonItem = contactButton;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeScaleAspectFit;
    
    /*if (self.ourName == nil) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter a name:" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    }*/
    [self.socket sendEvent:@"getConversations" withData:nil];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.socket sendEvent:@"addContact" withData:[[alertView textFieldAtIndex:0] text]];
    [self.socket sendEvent:@"getContacts" withData:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.vcs = [[NSMutableDictionary alloc] init];
}

-(IBAction)addContact:(id)sender
{
    /*UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add Contact" message:@"Enter the username:" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
     alert.alertViewStyle = UIAlertViewStylePlainTextInput;
     [alert show];*/
    
    CBContactsViewController *cvc = [[CBContactsViewController alloc] initWithNibName:@"CBContactsViewController" bundle:nil];
    cvc.socket = self.socket;
    [self.socket sendEvent:@"getContacts" withData:nil];
    [self presentModalViewController:cvc animated:YES];
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
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:controller];
    nc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nc animated:YES completion:nil];
}
-(void)logout
{
    [self.socket sendEvent:@"logout" withData:nil];
    [self relogin];
}
-(void)deactivate
{
    [self.socket sendEvent:@"deactivate" withData:nil];
    [self relogin];
}
-(void)relogin
{    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"secret"];
    
    [[TMAPIClient sharedInstance] authenticate:@"messengr" callback:^(NSError *error) {
        if (error != nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Authenticate With Tumblr" message:@"You must allow this app to see your Tumblr account to use it." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        [self.socket connectToHost:@"MSSGR60912.COM" onPort:8080];

        //store in defaults
        [[NSUserDefaults standardUserDefaults] setObject:[[TMAPIClient sharedInstance] OAuthToken] forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] setObject:[[TMAPIClient sharedInstance] OAuthTokenSecret] forKey:@"secret"];
        
        
        //Name ourselves
        SocketIOCallback cb = ^(id argsData) {
        };
        [self.socket sendEvent:@"authenticate" withData:@{@"key": [[TMAPIClient sharedInstance] OAuthToken], @"secret":[[TMAPIClient sharedInstance] OAuthTokenSecret]} andAcknowledge:cb];
    }];
    
}
@end
