//
//  CBFlipsideViewController.m
//  Messengr
//
//  Created by Adrian Sarli on 5/30/13.
//  Copyright (c) 2013 Adrian Sarli. All rights reserved.
//

#import "CBFlipsideViewController.h"
#import "CBEULAViewController.h"

@interface CBFlipsideViewController ()

@end

@implementation CBFlipsideViewController

#pragma mark -Table View Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 2;
    else
        return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stvc"];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"stvc"];
    
    if (indexPath.section == 0 && indexPath.row == 0)
        cell.textLabel.text = @"Log Out";
    if (indexPath.section == 0 && indexPath.row == 1)
        cell.textLabel.text = @"Delete Messengr Account";
    if (indexPath.section == 1 && indexPath.row == 0)
        cell.textLabel.text = @"View EULA";
    if (indexPath.section == 1 && indexPath.row == 1)
        cell.textLabel.text = @"Report Problem";
    if (indexPath.section == 1 && indexPath.row == 2)
        cell.textLabel.text = @"About";
    
        return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"Account";
    if(section == 1)
        return @"Extra";
    else
        return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Push next
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        
        [picker setSubject:@"Problem with Messengr"];
        [picker setToRecipients:[NSArray arrayWithObject:@"info@codebeam.com"]];
           
        picker.navigationBar.barStyle = UIBarStyleDefault; // choose your style, unfortunately, Translucent colors behave quirky.
        picker.mailComposeDelegate = self;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
    else if(indexPath.section == 1 && indexPath.row == 0)
    {
    //Push EULAView
        CBEULAViewController *evc = [[CBEULAViewController alloc] initWithNibName:@"CBEULAViewController" bundle:nil];
        [self presentViewController:evc animated:YES completion:nil];
    }
}
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.title = @"Settings";
    [self.navigationItem setLeftBarButtonItem:doneButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self.navigationController];
}

@end
