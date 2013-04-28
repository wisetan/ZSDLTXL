//
//  FriendContactViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-26.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import  "OtherHomepageViewController.h"


@interface FriendContactViewController : BaseViewController <FriendDidChangeDelegate>

@property (nonatomic, assign) BOOL alertShow;

@property (nonatomic, assign) NSInteger page;

@end
