//
//  RootViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-8.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactCell.h"

@interface AllContactViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate,
UISearchDisplayDelegate,
UISearchBarDelegate
>
{
    BOOL reloading;
}

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger searchPage;
@property (nonatomic, assign) NSInteger searchCount;

@property (nonatomic, assign) BOOL isFetchingData;
@property (nonatomic, assign) BOOL shouldFetchData; //当城市改变的时候应该从新取数据
@property (nonatomic, assign) BOOL canPullRefresh;  //

@property (nonatomic, retain) UITableView *mTableView;

@property (nonatomic, retain) UILabel *areaLabel;
@property (nonatomic, retain) UILabel *loginLabel;

@property (nonatomic, copy) NSString *entityName;

@property (nonatomic, copy) NSString *currentCity;
@property (nonatomic, copy) NSString *originCity;


@property (nonatomic, copy) NSString *curProvinceId;
@property (nonatomic, copy) NSString *curCityId;

@property (nonatomic, retain) NSMutableArray *contactArray;
@property (nonatomic, retain) NSMutableArray *searchContactArray;

@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *searchDC;
@property (nonatomic, retain) UITableView *searchTableView;
@property (nonatomic, retain) UIView *searchTableOverlayView;
@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, assign) BOOL addOverLayer;

@property (nonatomic, assign) NSInteger sortid;



- (void)setProvinceIdAndCityIdOfCity:(NSString *)city;
- (BOOL)isLogined;
- (void)getInvestmentUserListFromServer;
- (void)selectArea:(UIButton *)sender;



// 创建表格底部
- (void) createTableFooter:(UITableView *)tableView;
- (void) createFinishTableFooter:(UITableView *)tableView;
// 开始加载数据
- (void) loadDataBegin:(UITableView *)tableView;
// 加载数据中
//- (void) loadDataing;
// 加载数据完毕
- (void) loadDataEnd:(UITableView *)tableView;

@end
