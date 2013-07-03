//
//  ViewController.h
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"
#import "SocketIO.h"
@interface CBChatViewController : UIViewController <UIBubbleTableViewDataSource, SocketIODelegate, UIScrollViewDelegate>
{
    int numberOf50Chats;
}
@property NSMutableArray *chatData;
@property SocketIO *socketIO;
@property NSString *name;
@property NSString *chatWith;
@property     IBOutlet UIBubbleTableView *bubbleTable;
- (void)messageReceived:(NSString *)string;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeight;

-(IBAction)dismissKeyboard:(id)sender;
@end
