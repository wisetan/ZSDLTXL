//
//  RootViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-8.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "AllContactViewController.h"
#import "ContactCell.h"
#import "Contact.h"
#import "ProvinceViewController.h"
#import "SendMessageViewController.h"
#import "SendEmailViewController.h"
#import "ChatViewController.h"
#import "UIImageView+WebCache.h"
#import "MyHomePageViewController.h"
#import "MyFriendViewController.h"
#import "LoginViewController.h"


#import "UIImageView+WebCache.h"
#import "CityInfo.h"

#import "AllContact.h"

#import "UIScrollView+SVInfiniteScrolling.h"
#import "OtherHomepageViewController.h"

#import "DES3Util.h"

@interface AllContactViewController ()

@end

@implementation AllContactViewController

#pragma mark - tab bar

- (NSString *)tabImageName
{
    return nil;
}

// Setting the title of the tab.
- (NSString *)tabTitle
{
    return @"全部";
}

#pragma mark - life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [PersistenceHelper dataForKey:kCityName];
    self.page = 0;

    reloading = NO;
//    [self setProvinceIdAndCityIdOfCity:[PersistenceHelper dataForKey:kCityName]];
//    [self createTableFooter];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topmargin.png"] forBarMetrics:UIBarMetricsDefault];
    
    //login button
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [loginButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    
    loginButton.frame = CGRectMake(5, 5, 75, 34);
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 75.f, 34.f)] autorelease];
    
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.loginLabel setFont:[UIFont systemFontOfSize:16]];
    self.loginLabel.backgroundColor = [UIColor clearColor];
    self.loginLabel.textColor = [UIColor whiteColor];
    self.loginLabel.textAlignment = NSTextAlignmentCenter;
    [loginButton addSubview:self.loginLabel];
    
    UIBarButtonItem *rBarButton = [[[UIBarButtonItem alloc] initWithCustomView:loginButton] autorelease];
    self.navigationItem.rightBarButtonItem = rBarButton;
    
    //left area barbutton
    UIButton * areaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [areaButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [areaButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    [areaButton addTarget:self action:@selector(selectArea:) forControlEvents:UIControlEventTouchUpInside];
    areaButton.frame = CGRectMake(0, 0, 75, 34);
    self.areaLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 55.f, 34)] autorelease];
    self.areaLabel.text = @"地区";
    [self.areaLabel setFont:[UIFont systemFontOfSize:16]];
    self.areaLabel.backgroundColor = [UIColor clearColor];
    self.areaLabel.textColor = [UIColor whiteColor];
    self.areaLabel.textAlignment = NSTextAlignmentCenter;
    [areaButton addSubview:self.areaLabel];
    
    UIImageView *areaIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_icon.png"]] autorelease];
    areaIcon.frame = CGRectMake(5, 3, 28, 28);
    areaIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapOnIcon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnLocationIcon)];
    [areaIcon addGestureRecognizer:tapOnIcon];
    [areaButton addSubview:areaIcon];
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:areaButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    if ([self isLogined]) {
        self.loginLabel.text = @"主页";
    }
    else{
        self.loginLabel.text = @"登录";
    }
    
    NSLog(@"friend frame %@", NSStringFromCGRect(self.view.frame));
    CGFloat viewHeight;
    if (IS_IPHONE_5) {
        viewHeight = 548;
    }
    else{
        viewHeight = 460;
    }
    
    
    
    self.mTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, viewHeight-44-45-44)] autorelease];
    [self.mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    
    [self.view addSubview:self.mTableView];
    
    self.contactArray = [[[NSMutableArray alloc] init] autorelease];
    self.searchContactArray = [[[NSMutableArray alloc] init] autorelease];
    
    
    self.searchBar=[[[UISearchBar  alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)] autorelease];
    self.searchBar.delegate = self;
    self.searchBar.autocorrectionType=UITextAutocorrectionTypeNo;
    self.searchBar.autocapitalizationType=UITextAutocapitalizationTypeNone;
    self.searchBar.keyboardType=UIKeyboardAppearanceDefault;
    self.searchBar.hidden=NO;
    self.searchBar.placeholder=[NSString stringWithCString:"查找联系人"  encoding: NSUTF8StringEncoding];
//    self.mTableView.tableHeaderView=self.searchBar;
    [self.view addSubview:self.searchBar];
    
    self.searchDC=[[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] autorelease];
    self.searchDC.searchResultsDataSource=self;
    self.searchDC.searchResultsDelegate=self;
    self.searchDC.delegate = self;
    [self.searchDC  setActive:NO];
    
    self.searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.searchTableView.dataSource = self;
    self.searchTableView.delegate = self;
    self.isSearching = NO;

    
//    [self getAllContactFromDB];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLoginNoti:) name:kLoginNotification object:nil];
    self.canPullRefresh = YES;
    
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:kCityName
                                               options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                               context:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.isLogined) {
        self.loginLabel.text = @"主页";
    }
    else{
        self.loginLabel.text = @"登录";
    }
    
    if (self.isFetchingData == NO) {
        self.isFetchingData = YES;
        [self getAllContactFromDB];
        [self setProvinceIdAndCityIdOfCity:[PersistenceHelper dataForKey:kCityName]];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.isFetchingData = NO;
    [super viewWillDisappear:animated];
}

- (void)tapOnLocationIcon
{
    [self selectArea:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    NSString *oldCity = [change objForKey:@"old"];
    NSString *newCity = [change objForKey:@"new"];
    if (![oldCity isEqualToString:newCity]) {
        self.canPullRefresh = YES;
        reloading = NO;
        [self.contactArray removeAllObjects];
        [self getAllContactFromDB];
        self.title = [change objForKey:@"new"];
    }
}

- (void)receiveLoginNoti:(NSNotification *)noti
{
    self.loginLabel.text = @"我的主页";
}

- (void)getAllContactFromDB
{
    self.page = 0;
    [self.contactArray removeAllObjects];
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"cityid == %@ AND loginid == %@", [PersistenceHelper dataForKey:kCityId], kAppDelegate.userId];
    NSArray *contactArray = [AllContact findAllWithPredicate:pred];
    if (contactArray.count > 0) {
        self.page = ceil(((CGFloat)contactArray.count / 50));
        [self.contactArray addObjectsFromArray:contactArray];
        [self.mTableView reloadData];
        [self createTableFooter];
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
    }
    else{
        [self getInvestmentUserListFromServer];
    }
}

- (void)getInvestmentUserListFromServer
{
    [self setProvinceIdAndCityIdOfCity:[PersistenceHelper dataForKey:kCityName]];
    //    NSLog(@"current city; %@", self.currentCity);
    //parameter: provinceid, cityid, userid(用来取备注),
    NSString *listPage = [NSString stringWithFormat:@"%d", self.page];
    NSString *userid = kAppDelegate.userId;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.curProvinceId, @"provinceid",
                          self.curCityId, @"cityid",
                          listPage, @"page",
                          @"50", @"maxrow",
                          userid, @"userid",
                          @"getAllUserListByPage.json", @"path", nil];
    
    
    NSLog(@"all contact dict %@", dict);
    
    
    //    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    //    hub.labelText = @"获取商家列表";
    
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            
            if (![[json objForKey:@"InvestmentUserList"] isValid]) {
                [self.contactArray removeAllObjects];
                [self.mTableView reloadData];
                self.canPullRefresh = NO;
                [self createFinishTableFooter];
                [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
                [kAppDelegate showWithCustomAlertViewWithText:@"该地区暂无商家" andImageName:nil];
                NSLog(@"%@ 该地区暂无商家", [PersistenceHelper dataForKey:kCityName]);
                return;
            }
            
            NSArray *jsonArray = [self deCryptJsonDict:json OfJsonKey:@"InvestmentUserList"];
            
            [jsonArray enumerateObjectsUsingBlock:^(NSDictionary *contactDict, NSUInteger idx, BOOL *stop) {
                //                NSLog(@"contact Dict: %@", contactDict);
                
                AllContact *contact = [AllContact MR_createEntity];
                
                contact.userid = [[contactDict objForKey:@"id"] stringValue];
                contact.username = [contactDict objForKey:@"username"];
                contact.tel = [contactDict objForKey:@"tel"];
                contact.mailbox = [contactDict objForKey:@"mailbox"];
                contact.picturelinkurl = [contactDict objForKey:@"picturelinkurl"];
                contact.col1 = [contactDict objForKey:@"col1"];
                contact.col2 = [contactDict objForKey:@"col2"];
                contact.col2 = [contactDict objForKey:@"col2"];
                contact.cityid = [PersistenceHelper dataForKey:kCityId];
                contact.loginid = [kAppDelegate userId];
                contact.username_p = makePinYinOfName(contact.username);
                
                
                //                NSLog(@"name pinyin %@", contact.username_p);
                
                contact.sectionkey = [NSString stringWithFormat:@"%c", indexTitleOfString([contact.username characterAtIndex:0])];
                
                [self.contactArray addObject:contact];
                DB_SAVE();
            }];
            
            self.page++;
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            [self loadDataEnd];
            [self.mTableView reloadData];
        } else {
            
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            [self loadDataEnd];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
        [self loadDataEnd];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (NSArray *)deCryptJsonDict:(NSDictionary *)dict OfJsonKey:(NSString *)jsonKey
{
    NSString *jsonEncryptStr = [[dict objForKey:jsonKey] removeSpace];
    NSString *userid = [kAppDelegate userId];
    NSMutableString *key = [NSMutableString stringWithString:[kBaseKey substringToIndex:24-userid.length]];
    [key appendFormat:@"%@", userid];
    NSArray *jsonArray = [[DES3Util decrypt:jsonEncryptStr withKey:key] objectFromJSONString];
    return jsonArray;
}

- (void)setProvinceIdAndCityIdOfCity:(NSString *)city
{
    NSString *areaJsonPath = [[NSBundle mainBundle] pathForResource:@"getProAndCityData" ofType:@"json"];
    NSData *areaJsonData = [[NSData alloc] initWithContentsOfFile:areaJsonPath];
    NSMutableDictionary *areaDictTmp = [NSJSONSerialization JSONObjectWithData:areaJsonData options:NSJSONReadingAllowFragments error:nil];
    [areaJsonData release];
    
    NSArray *provinceArrayTmp = [areaDictTmp objectForKey:@"AreaList"];
    [provinceArrayTmp enumerateObjectsUsingBlock:^(NSDictionary *proDict, NSUInteger idx, BOOL *stop) {
        
        NSArray *cityArrayJsonTmp = [proDict objectForKey:@"citylist"];
        [cityArrayJsonTmp enumerateObjectsUsingBlock:^(NSDictionary *cityDict, NSUInteger idx, BOOL *stop) {
            if ([[cityDict objectForKey:@"cityname"] isEqualToString:city]) {
                self.curProvinceId = [cityDict objectForKey:@"provinceid"];
                self.curCityId = [cityDict objectForKey:@"cityid"];
                
                //                [PersistenceHelper setData:self.curCityId forKey:kCityId];
                [PersistenceHelper setData:self.curProvinceId forKey:kProvinceId];
                *stop = YES;
            }
        }];
    }];
}

- (BOOL)isLogined
{
    NSString *userid = [PersistenceHelper dataForKey:kUserId];
    return [userid isValid];
}

- (void)login:(UIButton *)sender
{
    NSLog(@"login");
    if ([self isLogined]) {
        //已经登录，进入我的主页
        MyHomePageViewController *myHomeVC = [[MyHomePageViewController alloc] init];
        [self.navigationController pushViewController:myHomeVC animated:YES];
        [myHomeVC release];
    }
    else{
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        [loginVC release];
    }
}

- (void)selectArea:(UIButton *)sender
{
    NSLog(@"select area");
    ProvinceViewController *areaVC = [[ProvinceViewController alloc] init];
    areaVC.isAddResident = NO;
    self.page = 0;
    self.isFetchingData = NO;
    [self.navigationController pushViewController:areaVC animated:YES];
    [areaVC release];
}

- (void)getUserCount
{
//    /getAllUserCount.json
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:self.curCityId, @"cityid", self.curProvinceId, @"provinceid", @"getAllUserCount.json", @"path", nil];
    
    NSLog(@"paradict %@", paraDict);
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            self.count = [[json objForKey:@"returncount"] intValue];
            [self getInvestmentUserListFromServer]; //取完联系人总数，取第一页列表
        }
    } failure:^(NSError *error) {
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

#pragma mark - pull refresh

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 下拉到最底部时显示更多数据
    if(!reloading && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height)+20))
    {
        if (self.canPullRefresh && !self.searchDC.active)
        {
            [self loadDataBegin];
        }
    }
}

// 开始加载数据
- (void)loadDataBegin
{
    if (reloading == NO)
    {
        reloading = YES;
        UIActivityIndicatorView *tableFooterActivityIndicator = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(75.0f, 10.0f, 20.0f, 20.0f)] autorelease];
        [tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [tableFooterActivityIndicator startAnimating];
        [self.mTableView.tableFooterView addSubview:tableFooterActivityIndicator];
        
        [self getInvestmentUserListFromServer];
    }
}

// 加载数据完毕
- (void)loadDataEnd
{
    reloading = NO;
//    [self showLoadNum];
    
    [self createTableFooter];
}

- (void)showLoadNum
{
    NSInteger finishNum = MIN(self.count, self.page*50);
    NSString *promptStr = [NSString stringWithFormat:@"已加载%d/%d联系人",finishNum, self.count];
    //                [kAppDelegate showWithCustomAlertViewWithText:promptStr andImageName:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = promptStr;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:2];
}

// 创建表格底部
- (void)createTableFooter
{
    self.mTableView.tableFooterView = nil;
    UIView *tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.mTableView.bounds.size.width, 40.0f)] autorelease];
    UILabel *loadMoreText = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 116.0f, 40.0f)] autorelease];
    [loadMoreText setCenter:tableFooterView.center];
    [loadMoreText setFont:[UIFont systemFontOfSize:14]];
    [loadMoreText setText:@"上拉显示更多数据"];
    [tableFooterView addSubview:loadMoreText];
    
    self.mTableView.tableFooterView = tableFooterView;
}

- (void)createFinishTableFooter
{
    self.mTableView.tableFooterView = nil;
    UIView *tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.mTableView.bounds.size.width, 40.0f)] autorelease];
    UILabel *loadMoreText = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 116.0f, 40.0f)] autorelease];
    [loadMoreText setCenter:tableFooterView.center];
    [loadMoreText setFont:[UIFont systemFontOfSize:14]];
    [loadMoreText setText:@"数据加载完成"];
    loadMoreText.textAlignment = NSTextAlignmentCenter;
    [tableFooterView addSubview:loadMoreText];
    
    self.mTableView.tableFooterView = tableFooterView;
}




#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDC.searchResultsTableView) {
//        NSLog(@"search contact array count %d", self.searchContactArray.count);
        return self.searchContactArray.count;
        
    }
    else{
        NSLog(@"contact array count %d", self.contactArray.count);
        return self.contactArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDC.searchResultsTableView) {
//        NSLog(@"search tableview cell");
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        static NSString *cellID = @"contactCell";
        ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil] objectAtIndex:0];
        }
        [self configureCell:cell atIndexPath:indexPath OfTableView:(UITableView *)tableView];
        
        return cell;
    }
    
    
    static NSString *cellID = @"contactCell";
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil] objectAtIndex:0];
    }
    [self configureCell:cell atIndexPath:indexPath OfTableView:(UITableView *)tableView];
    
    return cell;
}

- (void)configureCell:(ContactCell *)cell atIndexPath:(NSIndexPath *)indexPath OfTableView:(UITableView *)tableView
{
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    AllContact *userDetail;
    
    
    if (tableView == self.searchDC.searchResultsTableView) {
        userDetail = [self.searchContactArray objectAtIndex:indexPath.row];
    }
    else{
        userDetail = [self.contactArray objectAtIndex:indexPath.row];
    }
    
    
    
    cell.headIcon.layer.cornerRadius = 4;
    cell.headIcon.layer.masksToBounds = YES;
    [cell.headIcon setImageWithURL:[NSURL URLWithString:userDetail.picturelinkurl] placeholderImage:[UIImage imageByName:@"AC_talk_icon.png"]];
    
    
    if ([userDetail.remark isValid]) {
        NSMutableString *userName = [NSMutableString stringWithFormat:@"%@(%@)", userDetail.username, userDetail.remark];
        cell.nameLabel.text = userName;
    }
    else{
        cell.nameLabel.text = userDetail.username;
    }
    
    cell.unSelectedImage.hidden = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OtherHomepageViewController *otherProfileVC = [[OtherHomepageViewController alloc] init];
    
    if (tableView == self.searchDC.searchResultsTableView) {
        otherProfileVC.contact = [self.searchContactArray objectAtIndex:indexPath.row];
        [self.searchDC setActive:NO];
    }
    else{
        otherProfileVC.contact = [self.contactArray objectAtIndex:indexPath.row];
    }
    
    [self.navigationController pushViewController:otherProfileVC animated:YES];
    [otherProfileVC release];
}

#pragma mark - UISearchDisplayController Delegate Methods

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    self.isSearching = YES;
    [self.searchBar setShowsCancelButton:YES animated:NO];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // 当用户改变搜索字符串时，让列表的数据来源重新加载数据
//    [self filterContentForSearchText:searchString scope:nil];
    // 返回YES，让table view重新加载。
    return NO;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // 当用户改变搜索范围时，让列表的数据来源重新加载数据
//    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:nil];
    // 返回YES，让table view重新加载。
    
    return NO;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    NSLog(@"load result");

    self.searchTableOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height)];
    NSLog(@"frame %@", NSStringFromCGRect(self.searchTableOverlayView.frame));
    self.searchTableOverlayView.backgroundColor = [UIColor blackColor];
    self.searchTableOverlayView.alpha = 0.8;
    self.searchTableView = tableView;
}
//
- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView
{
    NSLog(@"unload result");
    [UIView animateWithDuration:.3 animations:^{
        self.searchTableOverlayView.alpha = 0.f;
        [self.searchTableOverlayView removeFromSuperview];
        [self.searchTableOverlayView release];
    }];
    
}
//
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    NSLog(@"show result");
    if (self.isSearching) {
        [self.searchTableView.superview addSubview:self.searchTableOverlayView];
//        add seachTableOverlayView as a subview of searchTableVIew.superview
        self.searchTableView.hidden = YES;
//        tableView.hidden = YES;
    }
    else{
        self.searchTableView.hidden = NO;
        self.searchTableOverlayView.hidden = YES;
    }
}


#pragma mark - search bar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"cancel clicked!!!!!!!!!");    
    [self.searchContactArray removeAllObjects];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search clicked!!!!!!!!!");

    ///getZsUserByName.json, userid, proviceid, cityid, name
    self.isSearching = YES;
    
    NSDictionary *paraDict = @{@"path": @"getZsUserByName.json",
                               @"userid": kAppDelegate.userId,
                               @"provinceid": self.curProvinceId,
                               @"cityid": self.curCityId,
                               @"name": searchBar.text};
//    [self.searchDC setActive:NO];
    
    
//    NSLog(@"search contact para dict %@", paraDict);
    
    [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
//    hud.labelText = @"搜索";
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        self.isSearching = NO;
        if ([GET_RETURNCODE(json) isEqualToString:@"0"]) {
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
//            NSLog(@"search contact json %@", json);
            
            [self.searchContactArray removeAllObjects];
            NSArray *tmpArray = [Utility deCryptJsonDict:json OfJsonKey:@"DataList"];
            [tmpArray enumerateObjectsUsingBlock:^(NSDictionary *contactDict, NSUInteger idx, BOOL *stop) {
                AllContact *contact = [AllContact createEntity];
                contact.userid = [[contactDict objForKey:@"id"] stringValue];
                contact.username = [contactDict objForKey:@"username"];
                contact.tel = [contactDict objForKey:@"tel"];
                contact.mailbox = [contactDict objForKey:@"mailbox"];
                contact.picturelinkurl = [contactDict objForKey:@"picturelinkurl"];
                contact.col1 = [contactDict objForKey:@"col1"];
                contact.col2 = [contactDict objForKey:@"col2"];
                contact.col2 = [contactDict objForKey:@"col2"];
                contact.cityid = [PersistenceHelper dataForKey:kCityId];
                contact.loginid = [kAppDelegate userId];
                contact.username_p = makePinYinOfName(contact.username);
                [self.searchContactArray addObject:contact];
            }];
            
            if (self.searchContactArray.count == 0) {
                self.searchDC.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            }
            
//            NSLog(@"searchContactArray %@", self.searchContactArray);
            
//            NSLog(@"tableview %@", self.mTableView);
//            [self.mTableView reloadData];
            
            [self.searchDC.searchResultsTableView reloadData];
            
            [UIView animateWithDuration:.2 animations:^{
                self.searchTableView.hidden = NO;
                self.searchTableOverlayView.hidden = YES;
            }];

        }
        else{
            [UIView animateWithDuration:.2 animations:^{
                self.searchTableView.hidden = NO;
                self.searchTableOverlayView.hidden = YES;
            }];
            
            [self.searchDC.searchResultsTableView reloadData];
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        self.isSearching = NO;
        [UIView animateWithDuration:.2 animations:^{
            self.searchTableView.hidden = NO;
            self.searchTableOverlayView.hidden = YES;
        }];
        
        [self.searchDC.searchResultsTableView reloadData];
        [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
    
    
    
    
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.searchContactArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.username contains[cd] %@",searchText];
    NSArray *array = [AllContact findAllWithPredicate:predicate];
    [self.searchContactArray addObjectsFromArray:array];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginNotification object:nil];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
