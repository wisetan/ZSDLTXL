//
//  CustomTableViewBase.h
//  LeheV2
//
//  Created by zhangluyi on 11-7-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTableHeaderView.h"
#import "LoadingView.h"
#import "NSString+Size.h"

#define kLoginNavigationBarButtonWidth      25
#define kLoginNavigationBarButtonHeight     31
#define kAllDataLoaded                      @"全部信息加载完成"
#define kLocationAccessableMessage          @"没有开启定位服务，请到“设置”中开启定位服务"
@class DAReloadActivityButton;
@interface CustomTableViewBase : UIViewController<RefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource> {
    RefreshTableHeaderView *refreshHeaderView;
    BOOL isReloading;
    BOOL isAppending;
    BOOL isPullRefreshEnable;
    BOOL isGroupedStyle;
    NSMutableArray *dataSourceArray;
    UIActivityIndicatorView *appendingActivityView;
    LoadingView *loadingView;
    UIBarButtonItem *refreshBarButtonItem;
    UIBarButtonItem *rightBarItem;
    UITableView *tableView;
    BOOL isFirstLoading;
	BOOL isNeedInitBeforeRefresh;
	
	NSInteger tableViewHeight;
    NSInteger currentPage;
    BOOL hasOnlyReloading;
    
    UIView *toolBar;
    NSArray *toolBarButtons;
    DAReloadActivityButton *reloadButton;
}

@property (nonatomic, retain) NSArray *toolBarButtons;
@property (nonatomic, retain) UIView *toolBar;
@property (nonatomic, assign) BOOL hasOnlyReloading;
@property (nonatomic, assign) BOOL isGroupedStyle;
@property (nonatomic, retain) LoadingView *loadingView;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain)  UIBarButtonItem *rightBarItem;
@property (nonatomic, retain)  UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, retain) RefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, retain) UIActivityIndicatorView *appendingActivityView;
@property (nonatomic, retain) NSMutableArray *dataSourceArray;
@property (nonatomic, assign) NSInteger tableViewHeight;
@property (nonatomic, retain) DAReloadActivityButton *reloadButton;
@property (nonatomic, assign) BOOL isNeedInitBeforeRefresh;

//need to override 发送请求

//BOOL hasOnlyReloading; 控制是否加载更多…
- (NSArray *)fetchArrayFromJsonDict:(NSDictionary *)jsonDict;
- (void)updateDidFinishedWithKey:(NSString *)key;
- (NSDictionary *)urlDictForRefresh;
- (NSString *)stringForParseJson; //用于解析返回的json串
- (UIViewController *)tableView:(UITableView *)_tableView pushRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtNotLastIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableViewShouldSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)configureCell:(UITableViewCell *)theCell atNotLastIndexPath:(NSIndexPath *)indexPath;
- (void)toolBarAction:(UIButton *)button; //如果有toolbar，需要重写此方法

- (void)refreshAction;
@end

@interface CustomTableViewBase ()
- (void)sendUpdateRequestForRefreshing:(BOOL)isRefresh;
- (void)startLoadingWithText:(NSString *)text frame:(CGRect)frame;
- (void)stopLoading;
- (void)showLoadingView;
- (void)doneLoadingTableViewData;
- (void)doneAppendingTableViewData;
- (void)sendUpdateRequestForce:(BOOL)type;
- (void)appendContentWithScrollView:(UIScrollView *)scrollView;
- (BOOL)allDatasourceFinish;
- (void)updateDataSource:(NSDictionary *)jsonDict force:(BOOL)type;
- (BOOL)isJsonValid:(NSDictionary *)json;
@end

