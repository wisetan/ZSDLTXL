//
//  size.m
//  LeheV2
//
//  Created by zhangluyi on 11-7-9.
//  Copyright 2011年 www.lehe.com. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)stringSizeWithMaxSize:(CGSize)maxSize fontSize:(NSInteger)fontSize {
    CGSize stringSize = [self sizeWithFont:[UIFont systemFontOfSize:fontSize] 
                         constrainedToSize:maxSize 
                             lineBreakMode:UILineBreakModeTailTruncation];
    return stringSize;
}

@end
