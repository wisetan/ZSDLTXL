//
//  cellTapGestureRecognizer.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-13.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Contact;
@interface CellTapGestureRecognizer : UITapGestureRecognizer

@property (nonatomic, copy) NSString *indexKey;
@property (nonatomic, assign) NSInteger indexRow;
@property (nonatomic, assign) NSInteger indexSection;
//@property (nonatomic, copy) NSString *userId;

@property (nonatomic, retain) Contact *contact;

@end
