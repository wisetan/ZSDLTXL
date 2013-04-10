//
//  UIImage+stretch1.m
//  LeheB
//
//  Created by zhangluyi on 11-5-10.
//  Copyright 2011年 Lehe. All rights reserved.
//

#import "UIImage+stretch.h"

@implementation UIImage (UIImage_stretch)

+ (UIImage *)stretchableImage:(NSString *)imageName leftCap:(NSInteger)leftCap topCap:(NSInteger)topCap {
    UIImage *image = [UIImage imageByName:imageName];
    UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
    return newImage;
}

+ (UIImage *)imageByName:(NSString *)name ofType:(NSString *)extension {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    return [UIImage imageWithContentsOfFile:filePath];
}

+ (UIImage *)imageByName:(NSString *)name {
    @try {
        if (name && [name length] > 0) {
            NSRange rang = [name rangeOfString:@"."];
            BOOL isDefault = NO;
            if (rang.location == NSNotFound) {
                isDefault = YES;
            }
            
            NSString *filePath = nil;
            if (isDefault) {
                filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
            } else {
                NSArray *array = [name componentsSeparatedByString:@"."];
                filePath = [[NSBundle mainBundle] pathForResource:[array objectAtIndex:0] ofType:[array objectAtIndex:1]];
            }
            return [UIImage imageWithContentsOfFile:filePath];
        }
    }
    @catch (NSException *exception) {
        return nil;
    }
    return nil;
}

//- (UIImage *)roundCornerImageWithWidth:(NSUInteger)ovalWidth height:(NSUInteger)ovalHeight {
//    
//	UIImage *newImage = nil;
//    
//	// Initialize
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//	int w = self.size.width;
//	int h = self.size.height;
//    
//	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//	CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
//    
//	CGContextBeginPath(context);
//	CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
//    
//	// Add rounded rect
//	float fw, fh;
//	if (ovalWidth == 0 || ovalHeight == 0) {
//		CGContextAddRect(context, rect);
//		return nil;
//	}
//	CGContextSaveGState(context);
//	CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
//	CGContextScaleCTM (context, ovalWidth, ovalHeight);
//	fw = CGRectGetWidth (rect) / ovalWidth;
//	fh = CGRectGetHeight (rect) / ovalHeight;
//	CGContextMoveToPoint(context, fw, fh/2);
//	CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
//	CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
//	CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
//	CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
//	CGContextClosePath(context);
//	CGContextRestoreGState(context);
//    
//	// Clean up
//	CGContextClosePath(context);
//	CGContextClip(context);
//    
//	CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);
//    
//	CGImageRef imageMasked = CGBitmapContextCreateImage(context);
//	CGContextRelease(context);
//	CGColorSpaceRelease(colorSpace);
//    
//	newImage = [[UIImage imageWithCGImage:imageMasked] retain];
//	CGImageRelease(imageMasked);
//    
//	[pool release];
//    
//	return newImage;	
//}

@end
