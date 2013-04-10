//
//  UIPlaceHolderTextView.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-10.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView
{
    NSString *placeholder;
    UIColor *placeholderColor;
    
@private
    UILabel *placeHolderLabel;
}

@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
