//
//  ProvinceInfo.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-11.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "ProvinceInfo.h"

@implementation ProvinceInfo

- (void)dealloc
{
    [super dealloc];
    self.centerlat = nil;
    self.centerlon = nil;
    self.provinceid = nil;
    self.provincename = nil;
    self.radius = nil;
}

@end
