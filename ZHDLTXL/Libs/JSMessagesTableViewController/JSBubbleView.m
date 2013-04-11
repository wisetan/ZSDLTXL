//
//  JSBubbleView.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//  http://www.hexedbits.com
//
//
//  Largely based on work by Sam Soffes
//  https://github.com/soffes
//
//  SSMessagesViewController
//  https://github.com/soffes/ssmessagesviewcontroller
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "JSBubbleView.h"
#import "JSMessageInputView.h"
#import "NSString+JSMessagesView.h"

#define kMarginTop 8.0f
#define kMarginBottom 4.0f
#define kPaddingTop 4.0f
#define kPaddingBottom 8.0f
#define kBubblePaddingRight 35.0f
#define KBubblePaddingRightCustom 20.f

@interface JSBubbleView()

- (void)setup;
- (BOOL)styleIsOutgoing;
- (BOOL)styleIsCustom;

@end



@implementation JSBubbleView

@synthesize style;
@synthesize text;

#pragma mark - Initialization
- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithFrame:(CGRect)frame bubbleStyle:(JSBubbleMessageStyle)bubbleStyle
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
        self.style = bubbleStyle;
    }
    return self;
}

#pragma mark - Setters
- (void)setStyle:(JSBubbleMessageStyle)newStyle
{
    style = newStyle;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)newText
{
    text = newText;
    [self setNeedsDisplay];
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)frame
{
	UIImage *image = [JSBubbleView bubbleImageForStyle:self.style];
    CGSize bubbleSize = [JSBubbleView bubbleSizeForText:self.text];
	CGRect bubbleFrame = CGRectMake(([self styleIsOutgoing] ? self.frame.size.width - bubbleSize.width : 0.0f),
                                    kMarginTop,
                                    bubbleSize.width,
                                    bubbleSize.height+10.f);
    
    if (self.style == JSBubbleMessageStyleOutgoingCustom) {
        bubbleFrame = CGRectMake(self.frame.size.width-bubbleSize.width-37.f, kMarginTop, bubbleSize.width, bubbleSize.height+10.f);
    }
    else if(self.style == JSBubbleMessageStyleIncomingCustom) {
        bubbleFrame = CGRectMake(37.f+6.f, kMarginTop, bubbleSize.width, bubbleSize.height+10.f);
    }
    
	[image drawInRect:bubbleFrame];
	
	CGSize textSize = [JSBubbleView textSizeForText:self.text];
	CGFloat textX = (CGFloat)image.leftCapWidth - 3.0f + ([self styleIsOutgoing] ? bubbleFrame.origin.x : 0.0f);
    
    if (self.style == JSBubbleMessageStyleOutgoingCustom) {
        textX = (CGFloat)image.leftCapWidth - 3.f + bubbleFrame.origin.x;
    }
    else if(self.style == JSBubbleMessageStyleIncomingCustom) {
        textX = (CGFloat)image.leftCapWidth - 3.f + bubbleFrame.origin.x;
    }
    
//    CGRect textFrame = CGRectMake(textX,
//                                  kPaddingTop + kMarginTop,
//                                  textSize.width,
//                                  textSize.height);
    CGRect textFrame = CGRectMake(textX,
                                  16.f,
                                  textSize.width,
                                  textSize.height);
    
    
    if ([self styleIsCustom]) {
        UIFont *font = [UIFont systemFontOfSize:16];
        if (self.style == JSBubbleMessageStyleIncomingCustom) {
            [[UIColor colorWithRed:136.f/255.f green:136.f/255.f blue:136.f/255.f alpha:1.f] setFill];
            [self.text drawInRect:textFrame
                         withFont:font
                    lineBreakMode:NSLineBreakByWordWrapping
                        alignment:NSTextAlignmentLeft];
        }
        else if(self.style == JSBubbleMessageStyleOutgoingCustom){
            [[UIColor colorWithRed:73.f/255.f green:73.f/255.f blue:73.f/255.f alpha:1.f] setFill];
            [self.text drawInRect:textFrame
                         withFont:font
                    lineBreakMode:NSLineBreakByWordWrapping
                        alignment:NSTextAlignmentLeft];
        }
       
    }
    else{
        [self.text drawInRect:textFrame
                     withFont:[JSBubbleView font]
                lineBreakMode:NSLineBreakByWordWrapping
                    alignment:NSTextAlignmentLeft];
    }
	
}

#pragma mark - Bubble view
- (BOOL)styleIsOutgoing
{
    return (self.style == JSBubbleMessageStyleOutgoingDefault
            || self.style == JSBubbleMessageStyleOutgoingDefaultGreen
            || self.style == JSBubbleMessageStyleOutgoingSquare
            || self.style == JSBubbleMessageStyleOutgoingCustom);
}

- (BOOL)styleIsCustom
{
    return (self.style == JSBubbleMessageStyleOutgoingCustom
            || self.style == JSBubbleMessageStyleIncomingCustom);
}

+ (UIImage *)bubbleImageForStyle:(JSBubbleMessageStyle)style
{
    switch (style) {
        case JSBubbleMessageStyleIncomingDefault:
            return [[UIImage imageNamed:@"messageBubbleGray"] stretchableImageWithLeftCapWidth:23 topCapHeight:15];
        case JSBubbleMessageStyleIncomingSquare:
            return [[UIImage imageNamed:@"bubbleSquareIncoming"] stretchableImageWithLeftCapWidth:25 topCapHeight:15];
            break;
            break;
        case JSBubbleMessageStyleOutgoingDefault:
            return [[UIImage imageNamed:@"messageBubbleBlue"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
            break;
        case JSBubbleMessageStyleOutgoingDefaultGreen:
            return [[UIImage imageNamed:@"messageBubbleGreen"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
            break;
        case JSBubbleMessageStyleOutgoingSquare:
            return [[UIImage imageNamed:@"bubbleSquareOutgoing"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
            break;
        case JSBubbleMessageStyleIncomingCustom:
//            return [[UIImage imageNamed:@"messageBubbleIncomingCustom.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(33, 20, 38, 26) resizingMode:UIImageResizingModeStretch];
            return [UIImage stretchableImage:@"messageBubbleIncomingCustom.png" leftCap:20 topCap:34];
            break;
        case JSBubbleMessageStyleOutgoingCustom:
//            return [[UIImage imageNamed:@"messageBubbleOutgoingCustom.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 30, 0) resizingMode:UIImageResizingModeStretch];
            return [UIImage stretchableImage:@"messageBubbleOutgoingCustom.png" leftCap:20 topCap:34];
            break;
    }
    
    return nil;
}

+ (UIFont *)font
{
    return [UIFont systemFontOfSize:16.0f];
}

+ (CGSize)textSizeForText:(NSString *)txt
{
    CGFloat width = [UIScreen mainScreen].applicationFrame.size.width * 0.65f;
    CGFloat height = MAX([JSBubbleView numberOfLinesForMessage:txt],
                         [txt numberOfLines]) * [JSMessageInputView textViewLineHeight];
    
    return [txt sizeWithFont:[JSBubbleView font]
           constrainedToSize:CGSizeMake(width, height)
               lineBreakMode:NSLineBreakByWordWrapping];
}

+ (CGSize)bubbleSizeForText:(NSString *)txt
{
	CGSize textSize = [JSBubbleView textSizeForText:txt];
	return CGSizeMake(textSize.width + kBubblePaddingRight,
                      textSize.height + kPaddingTop + kPaddingBottom);
}

+ (CGFloat)cellHeightForText:(NSString *)txt
{
    return [JSBubbleView bubbleSizeForText:txt].height + kMarginTop + kMarginBottom + 35;
}

+ (int)maxCharactersPerLine
{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 33 : 109;
}

+ (int)numberOfLinesForMessage:(NSString *)txt
{
    return (txt.length / [JSBubbleView maxCharactersPerLine]) + 1;
}

@end