//
//  CBAppDelegate.h
//  Messengr
//
//  Created by Adrian Sarli on 5/30/13.
//  Copyright (c) 2013 Adrian Sarli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBMainViewController;

@interface CBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CBMainViewController *mainViewController;
@property (strong, nonatomic) UINavigationController *navController;


@end
