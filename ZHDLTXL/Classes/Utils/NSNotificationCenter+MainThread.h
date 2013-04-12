//
//  NSNotificationCenter.h
//  LeheB
//
//  Created by zhangluyi on 11-5-9.
//  Copyright 2011年 Lehe. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSNotificationCenter (MainThread)
- (void)postNotificationOnMainThread:(NSNotification *)notification;
- (void)postNotificationOnMainThreadName:(NSString *)aName object:(id)anObject;
- (void)postNotificationOnMainThreadName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;
@end
