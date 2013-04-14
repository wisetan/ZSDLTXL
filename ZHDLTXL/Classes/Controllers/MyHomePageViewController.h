//
//  MyHomePageViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-14.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHomePageViewController : UIViewController

@property (nonatomic, retain) UIButton *backBarButton;


@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *mail;

@property (retain, nonatomic) UIImageView *headIcon;
@property (retain, nonatomic) UILabel *nameLabel;
@property (retain, nonatomic) UILabel *telLabel;
@property (retain, nonatomic) UILabel *mailLabel;


@property (retain, nonatomic) UIButton *modifyButton;

@end
