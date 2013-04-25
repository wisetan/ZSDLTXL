//
//  MyInfo.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-25.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CityInfo, Pharmacology, UserDetail;

@interface MyInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * account;
@property (nonatomic, retain) NSNumber * unreadCount;
@property (nonatomic, retain) NSNumber * unreadSMSCount;
@property (nonatomic, retain) NSSet *areaList;
@property (nonatomic, retain) NSSet *pharList;
@property (nonatomic, retain) UserDetail *userDetail;
@end

@interface MyInfo (CoreDataGeneratedAccessors)

- (void)addAreaListObject:(CityInfo *)value;
- (void)removeAreaListObject:(CityInfo *)value;
- (void)addAreaList:(NSSet *)values;
- (void)removeAreaList:(NSSet *)values;

- (void)addPharListObject:(Pharmacology *)value;
- (void)removePharListObject:(Pharmacology *)value;
- (void)addPharList:(NSSet *)values;
- (void)removePharList:(NSSet *)values;

@end
