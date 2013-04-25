//
//  AppDelegate.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-8.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import "RootViewController.h"

#define kNetworkErrorMessage        @"您的网络不好哦，检查一下"
#define kEventMyLatlonChanged       @"kEventMyLatlonChanged"
#define kInvalidLocation            0.0f

@class MBProgressHUD;

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
    MBProgressHUD *HUD;
    CLLocationManager *locationManager;
    BOOL isGpsError;
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) RootViewController *rootVC;
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, copy)   NSString *hotspotContent;


@property (nonatomic, assign) BOOL isGpsError;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, copy)   NSString *uuid;
@property (nonatomic, copy)   NSString *userId;
@property (nonatomic, copy)   NSString *cityId;
@property (nonatomic, copy)   NSString *provinceId;
@property (nonatomic, copy)   NSString *newCity;


@property (nonatomic, retain) CLGeocoder *geocoder;


- (void)showWithCustomAlertViewWithText:(NSString *)text andImageName:(NSString *)image;
- (void)initGPS;
- (void)saveContext;
- (BOOL)isLogined;
- (NSURL *)applicationDocumentsDirectory;

@end
