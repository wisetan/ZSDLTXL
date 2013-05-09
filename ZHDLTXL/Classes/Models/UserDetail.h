//
//  UserDetail.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-27.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserDetail : NSManagedObject

@property (nonatomic, retain) NSString * autograph;
@property (nonatomic, retain) NSString * col1;
@property (nonatomic, retain) NSString * col2;
@property (nonatomic, retain) NSString * col3;
@property (nonatomic, retain) NSString * invagency;
@property (nonatomic, retain) NSString * mailbox;
@property (nonatomic, retain) NSString * picturelinkurl;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * sectionkey;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * userid;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * headiconlocalurl;
@property (nonatomic, retain) NSString * isreal;

@end
