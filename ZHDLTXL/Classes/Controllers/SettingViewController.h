//
//  SettingViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-15.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyHomePageViewController.h"


@interface SettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *menuTableView;
@property (nonatomic, retain) NSMutableArray *menuNameArray;
@property (nonatomic, retain) NSMutableArray *selectorArray;
@property (nonatomic, retain) NSMutableArray *selectorNameArray;
@property (nonatomic, retain) UIButton *backBarButton;

@property (nonatomic, retain) MyHomePageViewController *MyHomeVC;

@end
