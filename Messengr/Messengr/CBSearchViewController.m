//
//  CBSearchViewController.m
//  Messengr
//
//  Created by Adrian Sarli on 6/27/13.
//  Copyright (c) 2013 Adrian Sarli. All rights reserved.
//

#import "CBSearchViewController.h"

@interface CBSearchViewController ()

@end

@implementation CBSearchViewController

#pragma mark - Table View Methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
    
    cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.socket sendEvent:@"addContact" withData:[self.data objectAtIndex:indexPath.row]];
    [self.socket sendEvent:@"getContacts" withData:nil];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Search methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 2) {
        [self.socket sendEvent:@"searchContact" withData:searchText];
    }
}
#pragma mark - Standard methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchResults:) name:@"searchResults" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(done:) name:@"goAway" object:nil];
    }
    return self;
}

-(void)searchResults:(NSNotification *)notif
{
    self.data = [notif object];
    [self.tv reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
