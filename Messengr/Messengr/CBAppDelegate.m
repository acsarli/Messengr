//
//  CBAppDelegate.m
//  Messengr
//
//  Created by Adrian Sarli on 5/30/13.
//  Copyright (c) 2013 Adrian Sarli. All rights reserved.
//

#import "CBAppDelegate.h"

#import "CBMainViewController.h"
#import "TMAPIClient.h"
#import "SocketIO.h"
@implementation CBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//    [[UIApplication sharedApplication] unregisterForRemoteNotifications];

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.mainViewController = [[CBMainViewController alloc] initWithNibName:@"CBMainViewController" bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    [TMAPIClient sharedInstance].OAuthConsumerKey = @"BGJp5fgJmBPFkyv5XeqhmItNPcxj9AH2pbgJ4S2UuZzRPGOFxS";
    [TMAPIClient sharedInstance].OAuthConsumerSecret = @"TjRO9vo07zk5S7SAeFA9NEVBEo7gead6nOxE6whsNdPO0zb6s8";
    
    [TMAPIClient sharedInstance].OAuthToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [TMAPIClient sharedInstance].OAuthTokenSecret = [[NSUserDefaults standardUserDefaults] objectForKey:@"secret"];
    
    if([TMAPIClient sharedInstance].OAuthToken == nil)
    {
        [[TMAPIClient sharedInstance] authenticate:@"messengr" callback:^(NSError *error) {
            if (error != nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Authenticate With Tumblr" message:@"You must allow this app to see your Tumblr account to use it." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        
        //store in defaults
        [[NSUserDefaults standardUserDefaults] setObject:[[TMAPIClient sharedInstance] OAuthToken] forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] setObject:[[TMAPIClient sharedInstance] OAuthTokenSecret] forKey:@"secret"];
        
        
        //Name ourselves
        SocketIOCallback cb = ^(id argsData) {
            [self.mainViewController.socket sendEvent:@"getContacts" withData:nil];
        };
        [self.mainViewController.socket sendEvent:@"authenticate" withData:@{@"key": [[TMAPIClient sharedInstance] OAuthToken], @"secret":[[TMAPIClient sharedInstance] OAuthTokenSecret]} andAcknowledge:cb];
        }];
    }
    else
    {
        //Name ourselves
        SocketIOCallback cb = ^(id argsData) {
            [self.mainViewController.socket sendEvent:@"getContacts" withData:nil];
        };

        [self.mainViewController.socket sendEvent:@"authenticate" withData:@{@"key": [[TMAPIClient sharedInstance] OAuthToken], @"secret":[[TMAPIClient sharedInstance] OAuthTokenSecret]} andAcknowledge:cb];
    }
    
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[TMAPIClient sharedInstance] handleOpenURL:url];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    //Save
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"devicetoken"];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
