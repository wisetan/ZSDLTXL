//
//  AddInfoViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-17.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCTextfieldCell.h"
#import "SBTableAlert.h"

@interface AddInfoViewController : UIViewController
<ELCTextFieldDelegate, UITableViewDataSource, UITableViewDelegate, SBTableAlertDelegate, SBTableAlertDataSource, UIAlertViewDelegate>

@property (nonatomic, retain) NSMutableArray *leftArray;
@property (nonatomic, retain) NSMutableArray *rightArray;
@property (nonatomic, retain) NSMutableArray *selectorNameArray;
@property (nonatomic, retain) NSMutableArray *selectorArray;


@property (nonatomic, retain) NSMutableArray *addInfo;

@property (retain, nonatomic) IBOutlet UITableView *mTableView;

@property (retain, nonatomic) NSString *userid;
@property (retain, nonatomic) NSNumber *zhaoshangOrDaili;   //修改招商代理类型
@property (retain, nonatomic) NSMutableString *provcityid;         //修改常驻地区
@property (retain, nonatomic) NSMutableString *preferid;           //修改个人偏好

@property (retain, nonatomic) NSDictionary *registDict;

@property (nonatomic, retain) NSMutableArray *residentArray;
@property (nonatomic, retain) NSMutableArray *preferArray;
@property (nonatomic, retain) NSMutableArray *zdNameArray;
@property (nonatomic, retain) NSMutableDictionary *zdDict;
@property (nonatomic, retain) NSNumber *zdValue;
@property (nonatomic, retain) MBProgressHUD *hud;


@end
