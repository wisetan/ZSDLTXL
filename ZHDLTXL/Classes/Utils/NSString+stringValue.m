//
//  NSString+stringValue.m
//  LeheV2
//
//  Created by zhangluyi on 11-8-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSString+stringValue.h"

@implementation NSString (NSString_stringValue)

- (NSString *)stringValue {
    return self;
}

- (NSString *)trimTagCode {
    return [[self removeSpace] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
}

- (NSString *)removeSpace {
    if (self && [self isKindOfClass:[NSString class]] && [self length] > 0) {
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return self;
}

- (NSString *)removeSpaceAndNewLine {
    if (self && [self isKindOfClass:[NSString class]] && [self length] > 0) {
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return self;
}

- (NSString *)removeNewLine {
    if (self && [self isKindOfClass:[NSString class]] && [self length] > 0) {
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }
    return self;
}


- (BOOL)isValid {
    if (self && [[self removeSpace] length] > 0) {
        return YES;
    }
    return NO;
}

// 正则判断手机号码地址格式
- (BOOL)isMobileNumber
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isValidEmail
{
    return [self isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"];
}

@end

@implementation NSArray (NSArray_stringValue)

- (NSArray *)stringValue {
    return nil;
}
@end