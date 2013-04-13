//
//  CellButton.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-9.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellButton : UIButton

@property (nonatomic, copy) NSString *indexKey;
@property (nonatomic, assign) NSInteger indexSection;
@property (nonatomic, assign) NSInteger indexRow;
@property (nonatomic, assign) BOOL isSelected;

@end
