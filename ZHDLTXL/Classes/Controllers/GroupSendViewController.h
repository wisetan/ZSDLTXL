//
//  GroupSendViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-5-5.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GroupSendVCDelegate <NSObject>

- (void)finishSelectGroupPeople:(NSArray *)groupPeople;

@end

@interface GroupSendViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *contactArray;
@property (retain, nonatomic) NSMutableArray *selectArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, retain) NSString *curProvinceId;
@property (nonatomic, retain) NSString *curCityId;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) id<GroupSendVCDelegate> delegate;


@end

