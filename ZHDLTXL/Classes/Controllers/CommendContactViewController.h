//
//  CommendContactViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-26.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CommendContactViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
{
    
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) UITableView *mTableView;

@property (nonatomic, retain) UILabel *areaLabel;
@property (nonatomic, retain) UILabel *loginLabel;

@property (nonatomic, copy) NSString *entityName;

@property (nonatomic, copy) NSString *currentCity;
@property (nonatomic, copy) NSString *originCity;


@property (nonatomic, copy) NSString *curProvinceId;
@property (nonatomic, copy) NSString *curCityId;

//@property (nonatomic, assign) enum eContactType contactType;


@property (nonatomic, assign) BOOL isFetchingData;
@property (nonatomic, assign) BOOL isAlertShow;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger commendCount;

@property (nonatomic, retain) NSMutableArray *commendContactArray;

- (void)setProvinceIdAndCityIdOfCity:(NSString *)city;

- (BOOL)isLogined;
- (void)configureCell:(ContactCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)getInvestmentUserListFromServer;

- (void)selectArea:(UIButton *)sender;

@end
