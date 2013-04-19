//
//  SelectViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-16.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *selectTableView;
@property (retain, nonatomic) NSMutableArray *cateArray;
@property (retain, nonatomic) NSMutableArray *selectArray;

@property (retain, nonatomic) IBOutlet UIButton *confirmButton;
@property (retain, nonatomic) UIButton *backBarButton;
@property (retain, nonatomic) UIButton *rightBarButton;
@property (assign, nonatomic) NSInteger zdKind;
@end
