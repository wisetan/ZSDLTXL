//
//  ChatViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-10.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessagesViewController.h"
#import "Contact.h"

@interface ChatViewController : JSMessagesViewController <JSMessagesViewDelegate, JSMessagesViewDataSource>

@property (nonatomic, retain) UIButton *backBarButton;
@property (nonatomic, retain) NSMutableArray *messages;
@property (nonatomic, retain) NSMutableArray *timestamps;
@property (nonatomic, retain) Contact *contact;

@end
