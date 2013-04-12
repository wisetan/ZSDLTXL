//
//  AppDelegate.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-8.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define kNetworkErrorMessage        @"您的网络不好哦，检查一下"
#define kEventMyLatlonChanged       @"kEventMyLatlonChanged"
#define kInvalidLocation            0.0f

@class MBProgressHUD;

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
    MBProgressHUD *HUD;
    CLLocationManager *locationManager;
    BOOL isGpsError;
    double gLat;
    double gLon;
    NSString *uuid;

    UIImage *pickedPhotoImage;
    NSString *hotspotContent;
    NSString *userId;
    BOOL shakeDetected;
    BOOL alreadyCheckin;
    NSDate *lastUpdateDate;
    NSInteger requestIndex;
    NSInteger lastMessageCount;
    NSInteger lastInnerMessageCount;
    NSString *tokenAsString;
    
}

@property (strong, nonatomic) UIWindow *window;



@property (nonatomic, copy)   NSString *tokenAsString;

@property (nonatomic, assign) BOOL alreadyCheckin;
@property (nonatomic, retain) NSDate *lastUpdateDate;
@property (nonatomic, copy)   NSString *hotspotContent;

@property (nonatomic, retain) UIImage *pickedPhotoImage;

@property (nonatomic, assign) BOOL isGpsError;
@property (nonatomic, assign) double gLat;
@property (nonatomic, assign) double gLon;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, copy)   NSString *uuid;
@property (nonatomic, copy)   NSString *userId;
@property (nonatomic, retain) NSMutableDictionary *reviewedNews;

@property (nonatomic, copy) NSString *lastCity;
@property (nonatomic, copy) NSString *newCity;
@property (nonatomic, retain) CLGeocoder *geocoder;

- (void)showWithCustomAlertViewWithText:(NSString *)text andImageName:(NSString *)image;

//about GPS
- (void)initGPS;
- (BOOL)cityChanged;

@end
