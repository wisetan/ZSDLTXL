//
//  Contact.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-8.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "Contact.h"

@implementation Contact

- (id)init
{
    self = [super init];
    if (self) {
        self.username = nil;
        self.tel = nil;
        self.mailbox = nil;
        self.picturelinkurl = nil;
        self.col1 = nil;
        self.col2 = nil;
        self.col3 = nil;
    }
    return self;
}

- (void)dealloc
{
    self.username = nil;
    self.tel = nil;
    self.mailbox = nil;
    self.picturelinkurl = nil;
    self.col1 = nil;
    self.col2 = nil;
    self.col3 = nil;
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_userid forKey:@"userid"];
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_tel forKey:@"tel"];
    [aCoder encodeObject:_mailbox forKey:@"mailbox"];
    [aCoder encodeObject:_picturelinkurl forKey:@"picturelinkurl"];
    [aCoder encodeObject:_autograph forKey:@"autograph"];
    [aCoder encodeObject:_col1 forKey:@"col1"];
    [aCoder encodeObject:_col2 forKey:@"col2"];
    [aCoder encodeObject:_col3 forKey:@"col3"];
    [aCoder encodeObject:_type forKey:@"type"];
    [aCoder encodeObject:_invagency forKey:@"invagency"];
    [aCoder encodeObject:_remark forKey:@"remark"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        [self setUserid:[aDecoder decodeObjectForKey:@"userid"]];
        [self setUsername:[aDecoder decodeObjectForKey:@"username"]];
        [self setTel:[aDecoder decodeObjectForKey:@"tel"]];
        [self setMailbox:[aDecoder decodeObjectForKey:@"mailbox"]];
        [self setPicturelinkurl:[aDecoder decodeObjectForKey:@"picturelinkurl"]];
        [self setAutograph:[aDecoder decodeObjectForKey:@"autograph"]];
        [self setCol1:[aDecoder decodeObjectForKey:@"col1"]];
        [self setCol2:[aDecoder decodeObjectForKey:@"col2"]];
        [self setCol3:[aDecoder decodeObjectForKey:@"col3"]];
        [self setType:[aDecoder decodeObjectForKey:@"type"]];
        [self setInvagency:[aDecoder decodeObjectForKey:@"invagency"]];
        [self setRemark:[aDecoder decodeObjectForKey:@"remark"]];
    }
    return self;
}

@end
