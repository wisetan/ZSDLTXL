//
//  UIImage+stretch1.h
//  LeheB
//
//  Created by zhangluyi on 11-5-10.
//  Copyright 2011年 Lehe. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (UIImage_stretch)
+ (UIImage *)stretchableImage:(NSString *)imageName leftCap:(NSInteger)leftCap topCap:(NSInteger)topCap;
+ (UIImage *)imageByName:(NSString *)name ofType:(NSString *)extension;
+ (UIImage *)imageByName:(NSString *)name;
@end
