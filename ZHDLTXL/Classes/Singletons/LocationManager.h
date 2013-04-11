//
//  LocationManager.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-11.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject

+ (CLLocationManager *)sharedManager;

@end
