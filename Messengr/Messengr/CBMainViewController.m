//
//  CBMainViewController.m
//  Messengr
//
//  Created by Adrian Sarli on 5/30/13.
//  Copyright (c) 2013 Adrian Sarli. All rights reserved.
//

#import "CBMainViewController.h"
#import "SocketIOPacket.h"

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
    cell.titleView.text = [[(NSDictionary *)[self.data objectAtIndex:indexPath.row] allKeys] objectAtIndex:0];
    
    //TODO: Figure out image... Ask Tim.
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: Put API calls here?
    //TODO: Push Conversation screen
    CBChatViewController *vc = [[CBChatViewController alloc] initWithNibName:@"CBChatViewController" bundle:nil];
    vc.name = self.ourName;
    
    [self.navigationController pushViewController:vc animated:YES];
     
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
    [NSTimer scheduledTimerWithTimeInterval:20.0
                                     target:self
                                   selector:@selector(refreshData)
                                   userInfo:nil
                                    repeats:YES];
    
}
-(void) refreshData
{
    [self.socket sendEvent:@"allusers" withData:nil];
}
-(void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    if([packet.name isEqualToString:@"updateusers"] && [[packet args] count] > 0)
    {
        self.data = [packet args];
        [self.tv reloadData];
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
    self.ourName = nil;
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
