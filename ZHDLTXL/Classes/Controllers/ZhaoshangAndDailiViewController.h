//
//  ZhaoshangAndDailiViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-16.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhaoshangAndDailiViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) UIButton *backBarButton;
@property (retain, nonatomic) NSMutableArray *leftArray;
@property (retain, nonatomic) NSMutableArray *selectArray;

@property (retain, nonatomic) IBOutlet UIButton *confirmButton;
@property (retain, nonatomic) IBOutlet UITableView *selectTableView;

@end
