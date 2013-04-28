//
//  AppDelegate.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-8.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "AppDelegate.h"
#import "AllContactViewController.h"
#import "Reachability.h"
#import "CityInfo.h"
#import "AKTabBarController.h"

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
    self.geocoder = [[[CLGeocoder alloc] init] autorelease];
    [self initGPS];
    
    //判断网络
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.boracloud.com"];
    if (self.isGpsError) {
        self.newCity = @"北京";
    }
    else{
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        
        [reach startNotifier];
    }
    
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    
    self.tabController = [[AKTabBarController alloc] initWithTabBarHeight:45];
    NSArray *controllerNameArray = @[@"FriendContactViewController", @"CommendContactViewController", @"AllContactViewController", @"ZhaoshangAndDailiViewController"];
    
    NSMutableArray *controllerArray = [[NSMutableArray alloc] init];
    for (NSString *controllerName in controllerNameArray) {
        Class controllerClass = NSClassFromString(controllerName);
        id controller = [[controllerClass alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [controllerArray addObject:nav];
    }
    
    [self.tabController setViewControllers:controllerArray];
    [self.tabController setBackgroundImageName:@"tab_bottom_bg.png"];
    [self.tabController setTextColor:[UIColor whiteColor]];
    [self.tabController setSelectedBackgroundImageName:@"tab_touch.png"];
    [self.tabController setTabEdgeColor:[UIColor clearColor]];
    [self.tabController setTopEdgeColor:[UIColor clearColor]];
    [self.tabController setTabColors:@[[UIColor clearColor], [UIColor clearColor]]];
    

    self.window.rootViewController = self.tabController;

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)reachabilityChanged:(NSNotification *)noti
{
    Reachability * reach = [noti object];
    
    if([reach isReachable])
    {
        [self getCurrentCity];
        NSLog(@"网络可行");
    }
    else
    {
        NSLog(@"网络不可行");
        [self showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
}


- (NSString *)userId
{
    NSString *userIdTmp = [PersistenceHelper dataForKey:kUserId];
    if (![userIdTmp isValid]) {
        return @"0";
    }
    return userIdTmp;
}

- (BOOL)isLogined
{
    NSString *userIdTmp = [PersistenceHelper dataForKey:kUserId];
    if (![userIdTmp isValid] || [userIdTmp isEqualToString:@"0"]) {
        return NO;
    }
    return YES;
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

//about GPS
- (void)initGPS {
    if(locationManager == nil) {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 10.f;
	}
    if ([CLLocationManager locationServicesEnabled]   &&   [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        [self.locationManager startUpdatingLocation];
        self.isGpsError = NO;
    }
    else{
        self.isGpsError = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请在系统设置中打开“定位服务”来允许“招商代理通讯录”确定您的位置"
                                                       delegate:nil cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)getCurrentCity  //有网的时候
{
    __block NSString *city = nil;
    [self.geocoder reverseGeocodeLocation:locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        city = [placemark performSelector:NSSelectorFromString(@"administrativeArea")];
        city = [city substringToIndex:[city length] -1];
        if ([city isValid]) {
            self.newCity = city;
        }
        else{
            self.newCity = @"北京";
        }
        
        NSLog(@" app newcity %@", self.newCity);

        NSString *cityId = [Utility getCityIdByCityName:self.newCity];
        [PersistenceHelper setData:self.newCity forKey:kCityName];
        [PersistenceHelper setData:cityId forKey:kCityId];
    }];
    

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [manager stopUpdatingLocation];
}
@end
