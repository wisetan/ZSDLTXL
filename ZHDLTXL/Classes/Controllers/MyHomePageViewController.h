//
//  MyHomePageViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-14.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDetail.h"

@interface MyHomePageViewController : UIViewController
<UIAlertViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) UIButton *backBarButton;


@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *mail;

@property (retain, nonatomic) IBOutlet UIImageView *headIcon;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *telLabel;
@property (retain, nonatomic) IBOutlet UILabel *mailLabel;
@property (retain, nonatomic) IBOutlet UIButton *modifyButton;
@property (retain, nonatomic) IBOutlet UITableView *infoTableView;

@property (retain, nonatomic) NSMutableArray *leftArray;
@property (retain, nonatomic) NSMutableArray *rightArray;
@property (retain, nonatomic) NSMutableArray *selectorArray;
@property (retain, nonatomic) NSMutableArray *selectorNameArray;
@property (retain, nonatomic) NSString *headIconUrl;

@property (retain, nonatomic) UserDetail *userDetail;




@property (retain, nonatomic) NSMutableArray *residentArray;
@property (retain, nonatomic) NSMutableArray *preferArray;
@property (retain, nonatomic) NSMutableArray *residentImageArray;
@property (retain, nonatomic) NSMutableArray *preferImageArray;

@property (nonatomic, retain) UIView *modifyView;

@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextField *telField;
@property (nonatomic, retain) UITextField *mailField;

@property (nonatomic, retain) NSMutableArray *unreadCountArray;
//@property (nonatomic, retain) ContactHimView *contactHimView;
@property (retain, nonatomic) IBOutlet UIButton *messageButton;
@property (retain, nonatomic) IBOutlet UIButton *mailButton;
@property (retain, nonatomic) IBOutlet UIButton *chatButton;

@end
