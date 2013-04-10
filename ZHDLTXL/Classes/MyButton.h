//
//  MyButton.h
//  Mytest
//
//  Created by a a a a a on 13-1-14.
//  Copyright (c) 2013年 a a a a a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyButton : UIButton
{
    UIImage *_normalImage;
    UIImage *_highlightImage;
}
-(id)initWithFrame:(CGRect)frame normalImage:(NSString *)normalImage highlightImage:(NSString *)highlightImage;
-(id)initWithFrame:(CGRect)frame normalImage:(NSString *)normalImage selectImge:(NSString *)selectImage;
-(id)initWithFrame:(CGRect)frame normalImage:(NSString *)normalImage highlightImage:(NSString *)highlightImage selectImge:(NSString *)selectImage;

-(id)initWithFrame:(CGRect)frame backNormalImage:(NSString *)normalImage backHighlightImage:(NSString *)highlightImage;

-(void)setNormalImage:(NSString *)normalImage selectImge:(NSString *)selectImage;
-(void)setNormalImage:(NSString *)normalImage highlightImage:(NSString *)highlightImage;
-(void)setNormalImage:(NSString *)normalImage highlightImage:(NSString *)highlightImage selectImge:(NSString *)selectImage;

-(void)setBackNormalImage:(NSString *)normalImage backSelectImge:(NSString *)selectImage;

@end
