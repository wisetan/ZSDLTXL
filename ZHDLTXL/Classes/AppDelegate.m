//
//  AppDelegate.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-8.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    self.uuid = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    
    
    RootViewController *rootVC = [[RootViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = nav;
    [rootVC release];
    [nav release];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
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




- (void)doShowAlertWithText:(NSString *)text imageByName:(NSString *)image {
    HUD = [[MBProgressHUD alloc] initWithView:self.window];
	[self.window addSubview:HUD];
	
    if (image && [image length] > 0) {
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageByName:image]] autorelease];
    } else {
        HUD.customView = nil;
    }
	
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
	HUD.userInteractionEnabled = NO;
    HUD.labelText = text ? text : @"出错了";
	
    [HUD show:YES];
	[HUD hide:YES afterDelay:2];
}

- (void)showWithCustomAlertViewWithText:(NSString *)text andImageName:(NSString *)image {
	
    if (HUD && HUD.superview) {
        
        if ([text isEqualToString:kNetworkErrorMessage]) {
            //当网络出问题时，不要不停的提示
            return;
        }
        
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }
    
    [self doShowAlertWithText:text imageByName:image];
}








@end
