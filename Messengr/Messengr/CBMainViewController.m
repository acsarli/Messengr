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
    if ([[self.data  allKeys] count] < 1)
        return cell;
    cell.titleView.text = [[self.data allKeys] objectAtIndex:indexPath.row];
    
    //TODO: Figure out image... Ask Tim.
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: Put API calls here?
    //TODO: Push Conversation screen
    NSString *nameToTalkTo = [[self.data allKeys] objectAtIndex:indexPath.row];
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
#pragma mark - Data/API Stuff
- (void)getData
{
    //Connect to server
    self.socket = [[SocketIO alloc] initWithDelegate:self];
    ///'self.socketIO.useSecure = YES;
    [self.socket connectToHost:@"198.199.72.88" onPort:8080];

}
- (void) socketIODidConnect:(SocketIO *)socket;
{
    NSLog(@"Connected");
    [self refreshData];
    [NSTimer scheduledTimerWithTimeInterval:200.0
                                     target:self
                                   selector:@selector(refreshData)
                                   userInfo:nil
                                    repeats:YES];
    
    [self registerName];
}
- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
    NSLog(@"Disconnected... sleeping for 30 seconds");
    [self performSelectorInBackground:@selector(reconnect) withObject:nil];
}

- (void) reconnect {
    [NSThread sleepForTimeInterval:15];
    [self.socket disconnect];
    [self.socket connectToHost:@"198.199.72.88" onPort:8080];
}
/*- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
    [self.socket connectToHost:@"198.199.72.88" onPort:8080];
}
- (void) socketIO:(SocketIO *)socket failedToConnectWithError:(NSError *)error __attribute__((deprecated));
{
    [self.socket connectToHost:@"198.199.72.88" onPort:8080];
}*/

-(void) refreshData
{
    [self.socket sendEvent:@"allusers" withData:nil];
}

-(void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    if([packet.name isEqualToString:@"updateusers"] && [[packet args] count] > 0)
    {
        self.data = [[[packet args] objectAtIndex:0] mutableCopy];
        if ([self.data objectForKey:self.ourName])
            [self.data removeObjectForKey:self.ourName];
        
        [self.tv reloadData];
        return;
    }
    //Make sure this is a chat update and not from us
    if([packet.name isEqualToString:@"updatechat"] && [[packet args] count] > 1 && ![[[packet args] objectAtIndex:0] isEqualToString:self.ourName])
    {
        //Add it to the appropriate chat data
        //First get the name of the sender
        NSString *senderName = [[packet args] objectAtIndex:0];
        NSString *message = [[packet args] objectAtIndex:1];
        //Check for vc
        if ([self.vcs objectForKey:senderName])
            [[self.vcs objectForKey:senderName] messageReceived:message];
        else //Add it to the right chatData
        {
            //Make sure the chat data exists
            if(![self.chatData objectForKey:senderName])
                [self.chatData setObject:[NSMutableArray array] forKey:senderName];
            
            NSBubbleData *sayBubble = [NSBubbleData dataWithText:message date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeSomeoneElse];
            [[self.chatData objectForKey:senderName] addObject:sayBubble];
        }
    }
}

-(void)registerName
{
    if ([self.socket isConnected])
        [self.socket sendEvent:@"adduser" withData:self.ourName];
}

#pragma mark - UIViewController Methods
-(void)viewDidLoad
{
    backgroundQueue = dispatch_queue_create("com.adriansarli.bgqueue", NULL);
    self.chatData = [[NSMutableDictionary alloc] init];
    self.ourName = nil;
    self.vcs = [[NSMutableDictionary alloc] init];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Get the data
    [self getData];
    
    //Setup the toolbar items
    
    //Gear button; Goes on left
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gear"] style:UIBarButtonItemStyleBordered target:self action:@selector(showInfo:)];
       
    //Contact button; Goes on right
    UIBarButtonItem *contactButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"group"] style:UIBarButtonItemStyleBordered target:self action:@selector(showContacts:)];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = settingsButton;
    self.navigationItem.rightBarButtonItem = contactButton;
    self.title = @"Messengr";
    
    if (self.ourName == nil) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter a name:" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    self.ourName = [[alertView textFieldAtIndex:0] text];
    [self registerName];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.vcs = [[NSMutableDictionary alloc] init];
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

@end
