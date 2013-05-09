//
//  TalkViewController.h
//  ZXCXBlyt
//
//  Created by zly on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "SMSList.h"
#import "MyInfo.h"
#import "UserDetail.h"

@class OtherTalkCell;
@class MyTalkCell;
@class TimeSplitCell;

@interface SMSTalkViewController : UIViewController<HPGrowingTextViewDelegate, EGOImageViewDelegate> {
    UIView *containerView;
    HPGrowingTextView *textView;
    NSMutableArray *dataSourceArray;
    NSString *fid;
    NSString *fAvatarUrl;
    NSInteger currentPage;
    NSTimer *timer;
    NSString *lastTime;
    UIButton *doneButton;
}

@property (nonatomic, retain) UIButton *doneButton;
@property (copy,   nonatomic) NSString *lastTime;
@property (retain, nonatomic) NSTimer *timer;
@property (retain, nonatomic) UIView *containerView;
@property (retain, nonatomic) IBOutlet UITableView *mTableView;
@property (retain, nonatomic) NSMutableArray *dataSourceArray;
@property (copy,   nonatomic) NSString *fid;
@property (copy,   nonatomic) NSString *fAvatarUrl;
@property (nonatomic, assign) BOOL hasNewSmsRecord;
@property (nonatomic, retain) SMSList *smsList;
@property (nonatomic, retain) MyInfo *myInfo;


@end
