//
//  NSString+Utils.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-11.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

- (NSString *)numString
{
    NSMutableString *numString = [NSMutableString stringWithCapacity:self.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [numString appendString:buffer];
            
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    
    return numString;
    
}

@end
