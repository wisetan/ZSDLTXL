//
//  LocationManager.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-11.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager


static CLLocationManager *_sharedManager = nil;
+ (CLLocationManager *)sharedManager
{
    if (_sharedManager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedManager = [[CLLocationManager alloc] init];
        });
    }
    return _sharedManager;
}

@end
