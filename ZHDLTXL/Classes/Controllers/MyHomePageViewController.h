//
//  MyHomePageViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-14.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactHimView.h"

@interface MyHomePageViewController : UIViewController <ContactHimViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) UIButton *backBarButton;


@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *mail;

@property (retain, nonatomic) UIImageView *headIcon;
@property (retain, nonatomic) UILabel *nameLabel;
@property (retain, nonatomic) UILabel *telLabel;
@property (retain, nonatomic) UILabel *mailLabel;


@property (retain, nonatomic) UIButton *modifyButton;
@property (retain, nonatomic) NSMutableArray *residentArray;
@property (retain, nonatomic) NSMutableArray *preferArray;
@property (retain, nonatomic) NSMutableArray *residentImageArray;
@property (retain, nonatomic) NSMutableArray *preferImageArray;

@property (nonatomic, retain) UIView *modifyView;

@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextField *telField;
@property (nonatomic, retain) UITextField *mailField;

@end
