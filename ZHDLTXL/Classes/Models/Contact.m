//
//  Contact.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-8.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "Contact.h"

@implementation Contact

- (void)dealloc
{
    [super dealloc];
    self.username = nil;
    self.tel = nil;
    self.mailbox = nil;
    self.picturelinkurl = nil;
    self.col1 = nil;
    self.col2 = nil;
    self.col3 = nil;;
}

@end
