//
//  MyHomePageViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-14.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDetail.h"
#import "MyInfo.h"
#import "SBTableAlert.h"
#import "ProvinceViewController.h"
#import "SelectPharViewController.h"
#import "CustomBadge.h"

@interface MyHomePageViewController : UIViewController
<
UIAlertViewDelegate,
UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
NSFetchedResultsControllerDelegate,
SBTableAlertDelegate,
SBTableAlertDataSource,
CityViewControllerDelegate,
SelectPharViewControllerDelegate
>

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
@property (retain, nonatomic) IBOutlet UILabel *userIdLabel;
@property (retain, nonatomic) IBOutlet UILabel *mailNameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *xun_VImage;

@property (retain, nonatomic) NSMutableArray *leftArray;
@property (retain, nonatomic) NSMutableArray *rightArray;
@property (retain, nonatomic) NSMutableArray *selectorArray;
@property (retain, nonatomic) NSMutableArray *selectorNameArray;
@property (retain, nonatomic) NSString *headIconUrl;

@property (retain, nonatomic) UserDetail *userDetail;
@property (retain, nonatomic) NSMutableDictionary *unreadMessageDict;


@property (retain, nonatomic) MyInfo *myInfo;




@property (retain, nonatomic) NSMutableArray *residentArray;
@property (retain, nonatomic) NSMutableArray *pharArray;
@property (retain, nonatomic) NSMutableArray *residentImageArray;
@property (retain, nonatomic) NSMutableArray *pharImageArray;

@property (nonatomic, retain) UIView *modifyView;

@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextField *telField;
@property (nonatomic, retain) UITextField *mailField;

@property (nonatomic, retain) NSMutableArray *unreadCountArray;
@property (retain, nonatomic) IBOutlet UIButton *messageButton;
@property (retain, nonatomic) IBOutlet UIButton *mailButton;
@property (retain, nonatomic) IBOutlet UIButton *chatButton;

@property (nonatomic, retain) NSArray *zdNameArray;
@property (nonatomic, retain) NSMutableDictionary *zdDict;
@property (nonatomic, retain) NSNumber *zdValue;
@property (nonatomic, copy) NSString *zdName;

@property (nonatomic, retain) NSThread *checkUnreadMailThread;
@property (nonatomic, assign) BOOL viewWillAppearing;

@property (nonatomic, retain) CustomBadge *messageBadge;
@property (nonatomic, retain) CustomBadge *mailBadge;
@property (nonatomic, retain) CustomBadge *chatBadge;


@end
