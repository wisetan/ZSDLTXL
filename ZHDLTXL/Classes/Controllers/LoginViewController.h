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

@property (retain, nonatomic) NSManagedObjectContext *managedContext;
@property (retain, nonatomic) IBOutlet UITableView *mTableView;

@property (nonatomic, retain) UIButton *backBarButton;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, retain) MBProgressHUD *hud;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property (retain, nonatomic) IBOutlet UIButton *registButton;

@end
