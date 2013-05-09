//
//  MyMailViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-5-1.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyInfoCell.h"
#import <MailCore/MailCore.h>
#import "MyInfo.h"

@interface MyMailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *inboxMails;
@property (nonatomic, retain) NSMutableArray *outboxMails;
@property (nonatomic, retain) CTCoreAccount *myAccount;
@property (nonatomic, retain) UIView *toolBar;
@property (nonatomic, retain) NSString *headIconUrl;
@property (nonatomic, retain) MyInfo *myInfo;
@property (nonatomic, retain) NSThread *checkMailThread;
@property (nonatomic, assign) BOOL viewWillAppearing;
@property (nonatomic, assign) BOOL isInbox;
@property (nonatomic, assign) BOOL checkFinished;

@end
