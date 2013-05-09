//
//  ProfileExtraViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-5-7.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileExtraViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UILabel *accountExtraLabel;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *profileExtraInfoArray;
@property (retain, nonatomic) IBOutlet UILabel *tiaoLabel;

@end
