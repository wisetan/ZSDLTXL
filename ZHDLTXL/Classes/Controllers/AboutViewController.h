//
//  AboutViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-5-5.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSArray *nameArray;
@property (nonatomic, retain) NSArray *selArray;

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
