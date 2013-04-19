//
//  LoginViewController.h
//  ZXCXBlyt
//
//  Created by zly on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCTextfieldCell.h"

@interface LoginViewController : UIViewController<ELCTextFieldDelegate> {
    UITableView *mTableView;
    BOOL isAutoLogin;
    UITextField *userName;
    UITextField *password;
}

@property (retain, nonatomic) IBOutlet UIButton *autoLoginButton;
@property (retain, nonatomic) IBOutlet UITableView *mTableView;
@property (assign, nonatomic) BOOL isAutoLogin;

@property (nonatomic, retain) UIButton *backBarButton;

@end
