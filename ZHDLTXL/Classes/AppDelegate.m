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
    self.geocoder = [[[CLGeocoder alloc] init] autorelease];
    [self initGPS];
    
    RootViewController *rootVC = [[[RootViewController alloc] init] autorelease];
//    if ([userId isValid]) {
//        rootVC.hasRegisted = YES;
//    }
//    else{
//        rootVC.hasRegisted = NO;
//    }
    
    if (self.isGpsError) {
        self.newCity = @"北京";
    }
    
    rootVC.currentCity = self.newCity;
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:rootVC] autorelease];
    self.window.rootViewController = nav;


    
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

- (void)loginFinishedWithAnimation:(BOOL)animate {
//    UIViewController *currentController = [[[self.leveyTabBarController viewControllers] objectAtIndex:self.leveyTabBarController.selectedIndex] topViewController];
//    [currentController dismissModalViewControllerAnimated:animate];
//    
//    if ([currentController isKindOfClass:[zxHomeViewController class]]) {
//        [currentController performSelector:@selector(moveToCurrentLocation) withObject:nil afterDelay:0.5];
//    }
//    
//    [leveyTabBarController hidesTabBar:NO animated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"kNotifactionLoginSuccess" object:nil];
//    
//    [self updateDeviceToken];
}

- (NSString *)userId
{
    if (![userId isValid]) {
        return (NSString *)[PersistenceHelper dataForKey:@"userid"];
    }
    return nil;
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
//        [self getCurrentCity];
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

- (void)getCurrentCity
{
    [self.geocoder reverseGeocodeLocation: locationManager.location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"place: %@", placemarks);
         self.newCity = placemark.locality;
         NSLog(@"city: %@", placemark.locality);
     }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
    CLLocationCoordinate2D coord = [[locations objectAtIndex:0] coordinate];
    NSLog(@"lat: %f, lon: %f", coord.latitude, coord.longitude);
    CLLocation *location = [[[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude] autorelease];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        self.newCity = [placemark performSelector:NSSelectorFromString(@"administrativeArea")];
        self.newCity = [self.newCity substringToIndex:[self.newCity length] -1];
        if ([self cityChanged]) {
            if (![self.newCity isValid]) {
                self.newCity = @"北京";
            }
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kCityChangedNotification object:self.newCity]];
            NSLog(@"lastcity: %@, newCity: %@",self.lastCity, self.newCity);
            self.lastCity = self.newCity;
        }
        NSLog(@"city: %@", self.newCity);
    }];
    [manager stopUpdatingLocation];
}

//- (void)displayPlacemarks:(NSArray *)placemarks
//{
//    CLPlacemark *placemark = [placemarks objectAtIndex:0];
//    NSLog(@"placemark, %@", placemark);
//    NSLog(@"placemark dict: %@", placemark.addressDictionary);
//    self.newCity = [placemark performSelector:NSSelectorFromString(@"administrativeArea")];
//    NSLog(@"city: %@", self.newCity);
//}

- (BOOL)cityChanged
{
    NSLog(@"lastcity: %@, newCity: %@",self.lastCity, self.newCity);
    return ![self.lastCity isEqualToString:self.newCity];
}

@end
