//
//  AppDelegate.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-8.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "Reachability.h"
#import "CMDEncryptedSQLiteStore.h"
#import "CityInfo.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;

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
    
//    [self importProAndCityDataJsonIntoDB];
    
    self.rootVC = [[[RootViewController alloc] init] autorelease];
    self.rootVC.currentCity = self.newCity;
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:self.rootVC] autorelease];
    self.window.rootViewController = nav;

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
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
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

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
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
        [PersistenceHelper setData:self.newCity forKey:kCityName];
    }];
    

}

//- (void)importProAndCityDataJsonIntoDB
//{
//    NSString *areaJsonPath = [[NSBundle mainBundle] pathForResource:@"getProAndCityData" ofType:@"json"];
//    NSData *areaJsonData = [[NSData alloc] initWithContentsOfFile:areaJsonPath];
//    NSMutableDictionary *areaDictTmp = [NSJSONSerialization JSONObjectWithData:areaJsonData options:NSJSONReadingAllowFragments error:nil];
//    [areaJsonData release];
//    
//    NSArray *provinceArrayTmp = [areaDictTmp objectForKey:@"AreaList"];
//    [provinceArrayTmp enumerateObjectsUsingBlock:^(NSDictionary *proDict, NSUInteger idx, BOOL *stop) {
//        
//        NSArray *cityArrayJsonTmp = [proDict objectForKey:@"citylist"];
//        [cityArrayJsonTmp enumerateObjectsUsingBlock:^(NSDictionary *cityDict, NSUInteger idx, BOOL *stop) {
//            CityInfo *cityInfo = [NSEntityDescription insertNewObjectForEntityForName:@"CityInfo" inManagedObjectContext:self.managedObjectContext];
//            [cityInfo setValuesForKeysWithDictionary:cityDict];
//        }];
//        NSError *error = nil;
//        if (![self.managedObjectContext save:&error]) {
//            NSLog(@"error %@", error);
//            abort();
//        }
//    }];
//}



#pragma mark - Core Data stack


- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"zhdltxl" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"zhdltxl.sqlite"];
    
    NSError *error = nil;
//    _persistentStoreCoordinator = [CMDEncryptedSQLiteStore makeStore:[self managedObjectModel]:kCoreDataKey];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
@end
