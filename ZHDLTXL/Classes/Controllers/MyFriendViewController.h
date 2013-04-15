//
//  MyFriendViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-15.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFriendViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableDictionary *contactDictSortByAlpha;
@property (nonatomic, retain) UITableView *contactTableView;
@property (nonatomic, retain) UIButton *backBarButton;

@property (nonatomic, copy) NSString *provinceid;
@property (nonatomic, copy) NSString *cityid;
@property (nonatomic, copy) NSString *userid;

@property (nonatomic, retain) NSMutableArray *contactArray;

@end
