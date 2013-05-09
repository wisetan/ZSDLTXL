//
//  DES3Util.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-29.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES3Util : NSObject

// 加密方法
+ (NSString*)encrypt:(NSString*)plainText;

// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText withKey:(NSString *)key;

@end
