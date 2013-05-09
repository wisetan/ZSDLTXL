//
//  MailInfo.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-5-1.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MailInfo : NSManagedObject

@property (nonatomic, retain) NSString * userid;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * loginid;
@property (nonatomic, retain) NSString * thirdaddress;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * foldername;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * flags;
@property (nonatomic, retain) NSString * messageid;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * picturelinkurl;

@end
