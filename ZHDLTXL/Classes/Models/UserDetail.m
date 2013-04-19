//
//  UserDetail.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-18.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "UserDetail.h"

@implementation UserDetail

- (void)dealloc
{
    self.userid = 0;
    self.username = nil;
    self.tel = nil;
    self.mailbox = nil;
    self.picturelinkurl = nil;
    self.invagency = 0;
    self.autograph = nil;
    self.col1 = nil;
    self.col2 = nil;
    self.col3 = nil;
    [super dealloc];
}

@end
