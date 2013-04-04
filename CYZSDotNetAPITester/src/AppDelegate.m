//
//  AppDelegate.m
//  CYZSDotNetAPITester
//
//  Created by Wei Li on 4/4/13.
//  Copyright (c) 2013 Yourdream. All rights reserved.
//

#import "AppDelegate.h"
#import "APIProcessingViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    self.mainVC = [[APIProcessingViewController alloc] init];
    self.window.rootViewController = self.mainVC;

    [self.window makeKeyAndVisible];
    return YES;
}

@end
