//
//  ViewController.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

// 
// Images used in this example by Petr Kratochvil released into public domain
// http://www.publicdomainpictures.net/view-image.php?image=9806
// http://www.publicdomainpictures.net/view-image.php?image=1358
//
#import "UIImageView+WebCache.h"
#import "CBChatViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "SocketIO.h"
#import "SocketIOPacket.h"
#import "CBMainViewController.h"

@interface CBChatViewController ()
{
    IBOutlet UIView *textInputView;
    IBOutlet UITextField *textField;
    UIBubbleTableView *bubbleTable;
}

@end

@implementation CBChatViewController
@synthesize bubbleTable;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Initialize variables
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(done:) name:@"goAway" object:nil];
    
    if(self.chatData == nil)
        self.chatData = [[NSMutableArray alloc] init];
       
    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 120 means that if the next messages comes in 2 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
    
    bubbleTable.snapInterval = 120;
    
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)
    
    bubbleTable.showAvatars = YES;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    
    //bubbleTable.typingBubble = NSBubbleTypingTypeNone;
    
    [bubbleTable reloadData];
    
    numberOf50Chats = 1;
    
    CGPoint bottomOffset = CGPointMake(0, bubbleTable.contentSize.height - bubbleTable.bounds.size.height);
    [bubbleTable setContentOffset:bottomOffset animated:NO];

    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [bubbleTable addGestureRecognizer:gr];
    
    // Keyboard events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
-(IBAction)dismissKeyboard:(id)sender;
{
    [textField resignFirstResponder];
}
-(void)done:(id)obj
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = self.chatWith;
    CGPoint bottomOffset = CGPointMake(0, bubbleTable.contentSize.height - bubbleTable.bounds.size.height);
    [bubbleTable setContentOffset:bottomOffset animated:NO];
    [super viewWillAppear:animated];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [self.chatData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [self.chatData objectAtIndex:row];
}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if(self.interfaceOrientation == UIInterfaceOrientationLandscapeRight || self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        kbSize = CGSizeMake(kbSize.height, kbSize.width);

    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textInputView.frame;
        frame.origin.y -= kbSize.height;
        textInputView.frame = frame;
        
        
        frame = bubbleTable.frame;
        frame.size.height -= kbSize.height;
        bubbleTable.frame = frame;
    }];
    CGPoint bottomOffset = CGPointMake(0, bubbleTable.contentSize.height - bubbleTable.bounds.size.height);
    [bubbleTable setContentOffset:bottomOffset animated:YES];}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if(self.interfaceOrientation == UIInterfaceOrientationLandscapeRight || self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        kbSize = CGSizeMake(kbSize.height, kbSize.width);
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textInputView.frame;
        frame.origin.y += kbSize.height;
        textInputView.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height += kbSize.height;
        bubbleTable.frame = frame;
    }];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches Began");
    [textField resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
}


- (void)messageReceived:(NSString *)string
{
    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    
    NSBubbleData *sayBubble = [NSBubbleData dataWithText:string date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeSomeoneElse];
    sayBubble.avatarImage = [[UIImageView alloc] init];
    [sayBubble.avatarImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://api.tumblr.com/v2/blog/%@.tumblr.com/avatar", self.chatWith]]
                   placeholderImage:[UIImage imageNamed:@"missingAvatar.png"]];
    [self.chatData addObject:sayBubble];
    [bubbleTable reloadData];
    
    CGPoint bottomOffset = CGPointMake(0, bubbleTable.contentSize.height - bubbleTable.bounds.size.height);
    [bubbleTable setContentOffset:bottomOffset animated:YES];
}

#pragma mark - Actions

- (IBAction)sayPressed:(id)sender
{

    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;

    NSBubbleData *sayBubble = [NSBubbleData dataWithText:textField.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
    sayBubble.avatarImage = [[UIImageView alloc] init];
    NSString *urlString = [NSString stringWithFormat: @"http://api.tumblr.com/v2/blog/%@.tumblr.com/avatar", self.name];
    [sayBubble.avatarImage setImageWithURL:[NSURL URLWithString: urlString]
                          placeholderImage:[UIImage imageNamed:@"missingAvatar.png"]];
    [self.chatData addObject:sayBubble];
    [bubbleTable reloadData];
    
    [self.socketIO sendEvent:@"chatwith" withData:self.chatWith];
    [self.socketIO sendEvent:@"sendchat" withData:textField.text];

    textField.text = @"";
    [textField resignFirstResponder];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset == 0)
    {
        //Load more old bubbles
        numberOf50Chats += 1;
    [self.socketIO sendEvent:@"chatHistory" withData:@{@"name": self.chatWith, @"start": [NSNumber numberWithInt:numberOf50Chats*150], @"stop": [NSNumber numberWithInt:1]}];
    }
}

/* NSBubbleData *heyBubble = [NSBubbleData dataWithText:@"Hey, halloween is soon" date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
 heyBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
 
 NSBubbleData *photoBubble = [NSBubbleData dataWithImage:[UIImage imageNamed:@"halloween.jpg"] date:[NSDate dateWithTimeIntervalSinceNow:-290] type:BubbleTypeSomeoneElse];
 photoBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
 
 NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
 replyBubble.avatar = nil;
 
 bubbleData = [[NSMutableArray alloc] initWithObjects:heyBubble, photoBubble, replyBubble, nil];
 bubbleTable.bubbleDataSource = self;
*/
@end
