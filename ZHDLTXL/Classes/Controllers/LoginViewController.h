//
//  LoginViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-9.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) UIButton *backBarButton;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property (retain, nonatomic) IBOutlet UIButton *registButton;
@property (retain, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextfield;

@end
