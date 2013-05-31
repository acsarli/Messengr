//
//  CBMainViewController.m
//  Messengr
//
//  Created by Adrian Sarli on 5/30/13.
//  Copyright (c) 2013 Adrian Sarli. All rights reserved.
//

#import "CBMainViewController.h"


@interface CBMainViewController ()
    //Private methods
-(void) getDataFromServer;
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
    cell.titleView.text = [(NSDictionary *)[self.data objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    //TODO: Figure out image... Ask Tim.
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: Put API calls here?
    //TODO: Push Conversation screen
    CBChatViewController *vc = [[CBChatViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
     
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#pragma mark - Data/API Stuff
- (void)getData
{
    //Do the magic stuff to get the data. Simulated for now
    dispatch_async(backgroundQueue, ^(void) {
        [self getDataFromServer];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tv reloadData];
        });
    });
}

//This is called in the background from GCD. DO NOT CALL! IT WILL BLOCK!
-(void) getDataFromServer;
{
    self.data = [NSArray arrayWithObjects:
                 [NSDictionary dictionaryWithObjectsAndKeys:@"Adrian Sarli", @"name", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"Tim Taylor", @"name", nil], nil];
}
#pragma mark - UIViewController Methods
-(void)viewDidLoad
{
    backgroundQueue = dispatch_queue_create("com.adriansarli.bgqueue", NULL);
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
