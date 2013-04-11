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

@end

@implementation NSArray (NSArray_stringValue)

- (NSArray *)stringValue {
    return nil;
}
@end