//
//  MyInfoViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-5-3.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVPullToRefresh.h"
#import "ChatList.h"

@interface MySMSViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *SMSChatListArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger maxrow;

@property (nonatomic, assign) BOOL shouldClearDB;



@end
