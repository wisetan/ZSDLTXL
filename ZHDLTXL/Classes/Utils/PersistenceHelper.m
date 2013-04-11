//
//  PersistenceHelper.m
//  Shake
//
//  Created by zhangluyi on 11-11-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PersistenceHelper.h"
#import "NSUserDefaults+objForKey.h"

@implementation PersistenceHelper

+ (BOOL)setData:(id)obj forKey:(NSString *)key {
    if (obj && key) {
        NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
        [persistentDefaults setValue:obj forKey:key];
        return [persistentDefaults synchronize];
    }
    return NO;
}

+ (id)dataForKey:(NSString *)key {
    if (key) {
        NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
        return [persistentDefaults objForKey:key];
    }
    return nil;
}

@end
