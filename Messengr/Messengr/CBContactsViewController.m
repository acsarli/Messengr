//
//  CBContactsViewController.m
//  Messengr
//
//  Created by Adrian Sarli on 6/30/13.
//  Copyright (c) 2013 Adrian Sarli. All rights reserved.
//

#import "CBContactsViewController.h"
#import "CBSearchViewController.h"
@interface CBContactsViewController ()

@end

@implementation CBContactsViewController

#pragma mark - TV methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"beginChat" object:[self.contacts objectAtIndex:indexPath.row]];
    [self.tv deselectRowAtIndexPath:indexPath animated:NO];
    [self dismissModalViewControllerAnimated:NO];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contacts count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cvcCell"];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cvcCell"];
    
    cell.textLabel.text = [self.contacts objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.socket sendEvent:@"removeContact" withData:[self.contacts objectAtIndex:indexPath.row]];
        [self.contacts removeObjectAtIndex:indexPath.row];
        [self.tv reloadData];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactsChanged:) name:@"updatecontacts" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(done:) name:@"goAway" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
-(IBAction)addContact:(id)sender
{
    CBSearchViewController *svc = [[CBSearchViewController alloc] initWithNibName:@"SearchView" bundle:nil];
    svc.socket = self.socket;
    [self presentViewController:svc animated:YES completion:nil];
}

#pragma mark - socket methods
-(void)contactsChanged:(NSNotification *)notif
{
    self.contacts = [notif.object mutableCopy];
    [self.tv reloadData];
}
-(IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
