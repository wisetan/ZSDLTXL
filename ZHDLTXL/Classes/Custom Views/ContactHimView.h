//
//  ContactHimView.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-9.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "CustomBadge.h"

@protocol ContactHimViewDelegate <NSObject>

- (void)message:(Contact *)contact;
- (void)email:(Contact *)contact;
- (void)chat:(Contact *)contact;

@end


@interface ContactHimView : UIView

@property (nonatomic, assign) NSInteger funcNum;
@property (nonatomic, retain) NSMutableArray *funcArray;
@property (nonatomic, assign) id<ContactHimViewDelegate> delegate;
@property (nonatomic, retain) Contact *contact;
@property (nonatomic, assign) BOOL isAppeared;

@property (nonatomic, retain) UIImageView *messageIcon;
@property (nonatomic, retain) UIImageView *emailIcon;
@property (nonatomic, retain) UIImageView *chatIcon;

@property (nonatomic, assign) BOOL hasBadge;

@property (nonatomic, retain) NSArray *badgeNumberArray;

@end
