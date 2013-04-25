//
//  CityInfo.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-25.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserDetail;

@interface CityInfo : NSManagedObject

@property (nonatomic, retain) NSString * centerlat;
@property (nonatomic, retain) NSString * centerlon;
@property (nonatomic, retain) NSString * cityid;
@property (nonatomic, retain) NSString * cityname;
@property (nonatomic, retain) NSString * countylist;
@property (nonatomic, retain) NSString * hasGotData;
@property (nonatomic, retain) NSString * provinceid;
@property (nonatomic, retain) NSString * radius;
@property (nonatomic, retain) NSSet *users;
@end

@interface CityInfo (CoreDataGeneratedAccessors)

- (void)addUsersObject:(UserDetail *)value;
- (void)removeUsersObject:(UserDetail *)value;
- (void)addUsers:(NSSet *)values;
- (void)removeUsers:(NSSet *)values;

@end
