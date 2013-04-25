//
//  Contact.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-8.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject <NSCoding>

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *mailbox;
@property (nonatomic, copy) NSString *picturelinkurl;
@property (nonatomic, copy) NSString *autograph;
@property (nonatomic, copy) NSString *col1; //bora mail
@property (nonatomic, copy) NSString *col2;
@property (nonatomic, copy) NSString *col3;
@property (nonatomic, retain) NSNumber *type;
@property (nonatomic, retain) NSNumber *invagency;
@property (nonatomic, copy) NSString *remark;

@end
