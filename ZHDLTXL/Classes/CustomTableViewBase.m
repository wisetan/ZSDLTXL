//
//  CustomTableViewBase.m
//  LeheV2
//
//  Created by zhangluyi on 11-7-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CustomTableViewBase.h"
//#import "Const.h"
#import "Defines.h"
#import "DreamFactoryClient.h"
#import "ValueForKey.h"
#import "DAReloadActivityButton.h"
#import "UIImage+stretch.h"
@implementation CustomTableViewBase

@synthesize refreshHeaderView, appendingActivityView, dataSourceArray;
@synthesize rightBarItem, refreshBarButtonItem, tableView;
@synthesize loadingView,tableViewHeight;
@synthesize isNeedInitBeforeRefresh;
@synthesize hasOnlyReloading;
@synthesize toolBar, toolBarButtons;
@synthesize reloadButton;
@synthesize isGroupedStyle;

- (void)dealloc
{
    self.reloadButton = nil;
    [toolBarButtons release];
    [toolBar release];
    [loadingView release];
    [tableView release];
    [rightBarItem release];
    [refreshBarButtonItem release];
    [refreshHeaderView release];
    [appendingActivityView release];
    [dataSourceArray release];
    [super dealloc];
}

#pragma mark - View lifecycle
- (void)refreshAction {
    [self sendUpdateRequestForce:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    isFirstLoading = YES;
    self.view.userInteractionEnabled = YES;
    
    isReloading    = NO;
    isAppending    = NO;
    isPullRefreshEnable = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!isGroupedStyle) {
        self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416-49) style:UITableViewStylePlain] autorelease];
    } else {
        self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416-49) style:UITableViewStyleGrouped] autorelease];
    }
    
    [self.view addSubview:self.tableView];
    self.tableView.allowsSelection = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //add refreshActivityIndicator bar
    self.reloadButton = [[[DAReloadActivityButton alloc] init] autorelease];
    reloadButton.frame = CGRectMake(0, 0, 40, 40);
    [reloadButton addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    reloadButton.showsTouchWhenHighlighted = YES;
    [reloadButton setImage:[UIImage imageByName:@"icon_nav_refresh"] forState:UIControlStateNormal];
    UIBarButtonItem *button1 = [[[UIBarButtonItem alloc] initWithCustomView:reloadButton] autorelease];
    self.navigationItem.rightBarButtonItem = button1;
    
    //init dataSource
    if (self.dataSourceArray == nil) {
        self.dataSourceArray = [[[NSMutableArray alloc] init] autorelease];
    }
    
    if (!hasOnlyReloading) {
        [dataSourceArray addObject:@"更多…"];
    }

    //add pullRefresh
    self.refreshHeaderView = [[[RefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, 320, self.tableView.bounds.size.height)] autorelease];
    self.refreshHeaderView.delegate = self;    
    [self.tableView addSubview:self.refreshHeaderView];
        
    if (toolBarButtons) {
        [self initToolBarWithButtons:toolBarButtons];
    }

}


- (void)initToolBarWithButtons:(NSArray *)buttons {
    
    self.toolBar = [[[UIView alloc] initWithFrame:CGRectMake(0, 460-44-44, 320, 44)] autorelease];
    [self.view addSubview:self.toolBar];
    
    for (int i = 0; i < [buttons count]; i++) {
        NSDictionary *dict = [buttons objectAtIndex:i];
        UIImage *image = [dict objForKey:@"image"];
        NSString *title  = [dict objForKey:@"title"];
        
        CGFloat width = 320.0f / [buttons count];
        CGFloat centerX = width*i + width/2.0f;
        CGFloat centerY = self.toolBar.frame.size.height / 2.0f;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        button.showsTouchWhenHighlighted = YES;
        button.frame = CGRectMake(0, 0, 70, 44);
        button.center = CGPointMake(centerX, centerY);
        button.tag = i;
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 17)] autorelease];
        label.text = title;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        label.center = CGPointMake(button.center.x, label.center.y);
        
        [self.toolBar addSubview:button];
        [self.toolBar addSubview:label];
        
        [button addTarget:self action:@selector(toolBarAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)toolBarAction:(UIButton *)button {
    
}

- (void)showLoadingView {
    self.tableView.alpha = 0;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)startLoadingWithText:(NSString *)text frame:(CGRect)frame {
    
    self.tableView.alpha = 0;
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil];
    self.loadingView = (LoadingView *)[nib objectAtIndex:0];
    self.loadingView.loadingTextLabel.text = text;
    self.loadingView.frame = frame;
    [self.view addSubview:loadingView];
}

- (void)stopLoading {
    if (self.loadingView) {
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
        
        //认为请求成功 显示view
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        self.tableView.alpha = 1;    
        [UIView commitAnimations];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourceArray count];
}

- (BOOL)allDatasourceFinish {
    if ([dataSourceArray count] == 0) {
        return YES;
    }
    
    NSInteger dataCount = [dataSourceArray count] - 1;
    if (dataCount % [kDefaultPageSizeString intValue] > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)finishLoadingString {
    return kAllDataLoaded;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *appendCell  = @"AppendCell";
    if (indexPath.row == [dataSourceArray count] - 1 && !hasOnlyReloading) {
        UITableViewCell *normalCell = [_tableView dequeueReusableCellWithIdentifier:@"AppendCell"];
        if (normalCell == nil) {
            normalCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:appendCell] autorelease];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
            label.backgroundColor = [UIColor clearColor];
            [normalCell.contentView addSubview:label];
            [label release];
            
            label.textAlignment = UITextAlignmentCenter;
            
            if (!self.appendingActivityView) {
                self.appendingActivityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
                appendingActivityView.frame = CGRectMake(210, 17, 15, 15);
                appendingActivityView.hidesWhenStopped = YES;
            }
            [normalCell.contentView addSubview:appendingActivityView];
        }        
        
        UILabel *contentlable = nil;
        for (UIView *view in [normalCell.contentView subviews]) {
            if ([view isKindOfClass:[UILabel class]]) {
                contentlable = (UILabel *)view; 
                break;
            }
        }
        if (contentlable) {
            if ([self allDatasourceFinish]) {
                contentlable.text = [self finishLoadingString];
                if (self.appendingActivityView.superview) {
                    [self.appendingActivityView removeFromSuperview];
                }
            } else {
                contentlable.text = @"更多…";
                if (self.appendingActivityView) {
                    appendingActivityView.frame = CGRectMake(210, 17, 15, 15);
                    appendingActivityView.hidesWhenStopped = YES;
                    [normalCell.contentView addSubview:appendingActivityView];
                }
//                if ([self.dataSourceArray count] <= 1) { //只有更多的时候隐藏更多
//                    contentlable.hidden = YES;
//                } else {
//                    contentlable.hidden = NO;
//                }
            }
        }
        
        return normalCell;
        
    } else {
        
        UITableViewCell *cell = [self tableView:_tableView cellForRowAtNotLastIndexPath:indexPath];
        [self configureCell:cell atNotLastIndexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)sendUpdateRequestForce:(BOOL)type {
    
    //检查定位功能是否打开
//    if ([kAppDelegate isGpsError] || [kAppDelegate isLocationAccessAllowed] == NO) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:kLocationAccessableMessage delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//    }
    
    if (isAppending || isReloading) {
        return;
    }
    
    if (type) {
        isReloading = YES;

    } else {
        isAppending = YES;
        [appendingActivityView startAnimating];
    }
    
    if ([reloadButton isAnimating]) {
        [reloadButton stopAnimating];
    }
    [reloadButton startAnimating];
    
    [self sendUpdateRequestForRefreshing:type];
}

- (NSDictionary *)urlDictForRefresh {
    return nil;
}

- (BOOL)isJsonValid:(NSDictionary *)json {
    if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
        return YES;
    }
    return NO;
}

- (void)restoreTableView {
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.1];
    [self performSelector:@selector(doneAppendingTableViewData) withObject:nil afterDelay:0.1];
//    [self doneLoadingTableViewData];
//    [self doneAppendingTableViewData];
    
    if (self.rightBarItem) {
        self.navigationItem.rightBarButtonItem = self.rightBarItem;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)updateDidFinishedWithKey:(NSString *)key {
    
}

- (NSString *)arrayKeyForJson:(NSDictionary *)jsonDict {
    for (NSString *key in [jsonDict allKeys]) {
        if (![key isEqualToString:@"returnCode"] && ![key isEqualToString:@"returnMess"]) {
            return key;
        }
    }
    return nil;
}

- (void)sendUpdateRequestForRefreshing:(BOOL)isRefresh {
    if (isRefresh) {
        currentPage = 0;
    } else {
        currentPage++;
    }
    NSDictionary *dict = [self urlDictForRefresh];
    NSLog(@"message dict %@", dict);
    if (dict) {
        [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
            NSLog(@"message json %@", json);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([self isJsonValid:json]) {
                [self updateDataSource:json force:isRefresh];
                [self updateDidFinishedWithKey:[self arrayKeyForJson:json]];
                [UIView animateWithDuration:0.3 animations:^{
                    self.tableView.alpha = 1;
                }];
                [tableView reloadData];
            } else {                
                [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
            }
        } failure:^(NSError *error) {
            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:nil];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        [self restoreTableView];
    } else {
        [self restoreTableView];
    }
}

- (void)doneLoadingTableViewData {	
	isReloading = NO;    
    [reloadButton stopAnimating];
	[self.refreshHeaderView lhRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)doneAppendingTableViewData {
    isAppending = NO;
    if ([appendingActivityView isAnimating]) {
        [appendingActivityView stopAnimating];
    }

    if (self.rightBarItem) {
        self.navigationItem.rightBarButtonItem = self.rightBarItem;    
    }    
    [reloadButton stopAnimating];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	if (isPullRefreshEnable) {
        [self.refreshHeaderView lhRefreshScrollViewDidScroll:scrollView];
    }

    if (!hasOnlyReloading) {
        [self appendContentWithScrollView:scrollView];
    }
}



- (void)appendContentWithScrollView:(UIScrollView *)scrollView {
    
    if (isReloading || isAppending) {
        return;
    }
    
    if ([self allDatasourceFinish]) {
        return;
    }
    
    BOOL needAppend = NO;
    
    CGSize tableViewContentSize = [scrollView contentSize];
    
    NSInteger tableHeight = self.tableView.frame.size.height;
    
    if (tableViewContentSize.height < tableHeight) {
        if (scrollView.contentOffset.y >= 60 && !self.tableView.dragging) {
            needAppend = YES;
        }
        
    } else {
        if (tableViewContentSize.height + 60 < scrollView.contentOffset.y + tableHeight && !self.tableView.dragging) {
            needAppend = YES;
        }
    }
    
    if (needAppend) {
		if (isNeedInitBeforeRefresh && 1 == [self.dataSourceArray count]) {
			return;
		}		
        [self sendUpdateRequestForce:NO];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (isNeedInitBeforeRefresh && 1 == [self.dataSourceArray count]) {
		return;
	}
	
    if (isPullRefreshEnable) {
        [self.refreshHeaderView lhRefreshScrollViewDidEndDragging:scrollView];	
    }
}

#pragma mark -
#pragma mark RefreshTableHeaderDelegate Methods

- (void)lhRefreshTableHeaderDidTriggerRefresh:(RefreshTableHeaderView*)view{
	
	[self sendUpdateRequestForce:YES];
    
}

- (BOOL)lhRefreshTableHeaderDataSourceIsLoading:(RefreshTableHeaderView*)view{
	
	return isReloading;
	
}

- (NSDate*)lhRefreshTableHeaderDataSourceLastUpdated:(RefreshTableHeaderView*)view{
	
	return [NSDate date];
	
}

- (void)updateDataSource:(NSDictionary *)jsonDict force:(BOOL)type {
    
    if ([reloadButton isAnimating]) {
        [reloadButton stopAnimating];
    }
    
    if (type) {
        if (!hasOnlyReloading) {
            [dataSourceArray removeAllObjects];
            [dataSourceArray addObject:@"更多…"];
        } else {
            [dataSourceArray removeAllObjects];
        }
    }
    
    NSArray *jsonBlocks = nil;
//    jsonBlocks = [jsonDict objForKeyPath:[self stringForParseJson]];
    jsonBlocks = [self fetchArrayFromJsonDict:jsonDict];
    if (jsonBlocks && [jsonBlocks count] > 0) {
		
        for (int i = 0; i < [jsonBlocks count]; i++) {
            NSDictionary *oneBlock = [jsonBlocks objectAtIndex:i];
            if (!hasOnlyReloading) {
                [dataSourceArray insertObject:oneBlock atIndex:[dataSourceArray count] - 1];
            } else {
                [dataSourceArray addObject:oneBlock];
            }
        }
    } else {
        if (type) {
            //如果第一次请求就没有数据
            if (jsonBlocks && [jsonBlocks count] == 0) {
                [kAppDelegate showWithCustomAlertViewWithText:@"暂无任何内容" andImageName:nil];                
            }
        } else {
            if ([dataSourceArray count] == 0) {
                [kAppDelegate showWithCustomAlertViewWithText:@"暂无任何内容" andImageName:nil];
            }
        }
	}
}

- (NSArray *)fetchArrayFromJsonDict:(NSDictionary *)jsonDict {
    return [jsonDict objForKeyPath:[self stringForParseJson]]; 
}

- (BOOL)tableViewShouldSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isAppending || isReloading) {
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (hasOnlyReloading) {
        UIViewController *detailPageController = [self tableView:_tableView pushRowAtIndexPath:indexPath];
        if (detailPageController) {
            [self.navigationController pushViewController:detailPageController animated:YES];
        }
        return;
    }
    
    if (indexPath.row == [dataSourceArray count] - 1) {

        if (isReloading || isAppending) {
            return;
        }
		
		if (isNeedInitBeforeRefresh && 1 == [dataSourceArray count]) {
			return;
		}
        
        if ([self allDatasourceFinish]) {
            return;
        }
        [self sendUpdateRequestForce:NO];
    } else {
        if (![self tableViewShouldSelectRowAtIndexPath:indexPath]) {
            UIViewController *detailPageController = [self tableView:_tableView pushRowAtIndexPath:indexPath];
            if (detailPageController) {
                [self.navigationController pushViewController:detailPageController animated:YES];
            }                    
        }
    }
}

- (UIViewController *)tableView:(UITableView *)_tableView pushRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSString *)stringForParseJson {
    return nil;
}

- (NSString *)searchStringForAppendingWall {
    return nil;
}

- (NSString *)searchStringForRefreshWall {
    return nil;
}

- (NSString *)searchStringForCustomReqeust {
    return nil;
}

- (void)customRequestFinishLoading:(NSDictionary *)jsonDict requestId:(NSInteger)requestId {}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtNotLastIndexPath:(NSIndexPath *)indexPath {
    //默认实现，需要重写
    static NSString *kContentCell = @"contentCell";
    UITableViewCell *contentCell = [_tableView dequeueReusableCellWithIdentifier:kContentCell];
    if (contentCell == nil) {
        contentCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kContentCell] autorelease];        
    }        
    return contentCell;
}

- (void)configureCell:(UITableViewCell *)theCell atNotLastIndexPath:(NSIndexPath *)indexPath {}

@end
