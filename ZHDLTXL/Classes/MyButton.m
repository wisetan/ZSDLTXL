//
//  MyButton.m
//  Mytest
//
//  Created by a a a a a on 13-1-14.
//  Copyright (c) 2013年 a a a a a. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

-(id)initWithFrame:(CGRect)frame normalImage:(NSString *)normalImage highlightImage:(NSString *)highlightImage;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //        _normalImage=normalImage;
        //        _highlightImage=highlightImage;
        if (normalImage) {
            [self setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
        }
        if (highlightImage) {
            [self setImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
        }
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame normalImage:(NSString *)normalImage selectImge:(NSString *)selectImage
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //        _normalImage=normalImage;
        //        _highlightImage=highlightImage;
        [self setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame normalImage:(NSString *)normalImage highlightImage:(NSString *)highlightImage selectImge:(NSString *)selectImage{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //        _normalImage=normalImage;
        //        _highlightImage=highlightImage;
        [self setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
        [self setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame backNormalImage:(NSString *)normalImage backHighlightImage:(NSString *)highlightImage{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //        _normalImage=normalImage;
        //        _highlightImage=highlightImage;
        
        UIImage *imageNormal = [[UIImage imageNamed:normalImage] stretchableImageWithLeftCapWidth:16 topCapHeight:16];
        [self setBackgroundImage:imageNormal forState:UIControlStateNormal];
        if (highlightImage) {
            UIImage *imageHigh = [[UIImage imageNamed:highlightImage] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
            [self setBackgroundImage:imageHigh forState:UIControlStateHighlighted];
        }
        
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [self.titleLabel setShadowOffset:CGSizeMake(0.5, 0.5)];
        [self setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}


-(void)setNormalImage:(NSString *)normalImage highlightImage:(NSString *)highlightImage
{
    [self setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
    
}
-(void)setNormalImage:(NSString *)normalImage selectImge:(NSString *)selectImage
{
    [self setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
}

-(void)setNormalImage:(NSString *)normalImage highlightImage:(NSString *)highlightImage selectImge:(NSString *)selectImage{
    [self setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
    [self setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
}


-(void)setBackNormalImage:(NSString *)normalImage backSelectImge:(NSString *)selectImage
{
    [self setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
}
-(UIButtonType)buttonType
{
    return UIButtonTypeCustom;
}
-(BOOL)showsTouchWhenHighlighted
{
    return YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
