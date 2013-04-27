//
//  CityInfo.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-27.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CityInfo : NSManagedObject

@property (nonatomic, retain) NSString * centerlat;
@property (nonatomic, retain) NSString * centerlon;
@property (nonatomic, retain) NSString * cityid;
@property (nonatomic, retain) NSString * cityname;
@property (nonatomic, retain) NSString * countylist;
@property (nonatomic, retain) NSString * provinceid;
@property (nonatomic, retain) NSString * radius;

@end
