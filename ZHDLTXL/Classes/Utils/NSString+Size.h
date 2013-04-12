//
//  size.h
//  LeheV2
//
//  Created by zhangluyi on 11-7-9.
//  Copyright 2011年 www.lehe.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Size)

- (CGSize)stringSizeWithMaxSize:(CGSize)maxSize fontSize:(NSInteger)fontSize;

@end
