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
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.mainViewController = [[CBMainViewController alloc] initWithNibName:@"CBMainViewController" bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    [TMAPIClient sharedInstance].OAuthConsumerKey = @"BGJp5fgJmBPFkyv5XeqhmItNPcxj9AH2pbgJ4S2UuZzRPGOFxS";
    [TMAPIClient sharedInstance].OAuthConsumerSecret = @"TjRO9vo07zk5S7SAeFA9NEVBEo7gead6nOxE6whsNdPO0zb6s8";
    
    [[TMAPIClient sharedInstance] authenticate:@"messengr" callback:^(NSError *error) {
        //Name ourselves
        [self.mainViewController.socket sendEvent:@"authenticate" withData:@{@"key": [[TMAPIClient sharedInstance] OAuthToken], @"secret":[[TMAPIClient sharedInstance] OAuthTokenSecret]} andAcknowledge:nil];
    }];
    
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[TMAPIClient sharedInstance] handleOpenURL:url];
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
