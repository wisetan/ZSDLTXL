//
//  SelectImageView.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-13.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectImageView : UIImageView

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) NSInteger indexSection;
@property (nonatomic, assign) NSInteger indexRow;

@end
