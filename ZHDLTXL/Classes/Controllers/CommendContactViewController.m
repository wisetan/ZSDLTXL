//
//  CommendContactViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-26.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "CommendContactViewController.h"
#import "OtherHomepageViewController.h"
#import "MyHomePageViewController.h"
#import "LoginViewController.h"
#import "ProvinceViewController.h"

@interface CommendContactViewController ()

@end

@implementation CommendContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *)tabImageName
{
    return nil;
}

// Setting the title of the tab.
- (NSString *)tabTitle
{
    return @"推荐";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [PersistenceHelper dataForKey:kCityName];
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
    
    
    
    self.mTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, viewHeight-44-45)] autorelease];
    [self.mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    
    [self.view addSubview:self.mTableView];
    
    
    self.commendContactArray = [[[NSMutableArray alloc] init] autorelease];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLoginNoti:) name:kLoginNotification object:nil];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:kCityName
                                               options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                               context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kCityName]) {
        NSString *newCity = [change objForKey:@"new"];
        NSString *oldCity = [change objForKey:@"old"];
        if (![newCity isEqualToString:oldCity]) {
            
            self.title = newCity;
        }
    }
}

- (void)receiveLoginNoti:(NSNotification *)noti
{
    self.title = [PersistenceHelper dataForKey:kCityName];
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

        [self.commendContactArray removeAllObjects];
        [self getCommendData];

    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.isFetchingData = NO;
}

- (void)selectArea:(UIButton *)sender
{
    NSLog(@"select area");
    ProvinceViewController *areaVC = [[ProvinceViewController alloc] init];
    areaVC.isAddResident = NO;
    self.page = 1;
    [self.navigationController pushViewController:areaVC animated:YES];
    [areaVC release];
}

- (void)getCommendData
{
    NSLog(@"userid %@", kAppDelegate.userId);
        
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"loginid == %@ AND cityid == %@", kAppDelegate.userId, [PersistenceHelper dataForKey:kCityId]];
    [self.commendContactArray addObjectsFromArray:[CommendContact findAllWithPredicate:pred]];
    if (self.commendContactArray.count == 0) {
        [self getInvestmentUserListFromServer];
    }
    else{
        [self.mTableView reloadData];
    }
}

- (void)getUserCount
{
    //获取好友总数
    [self setProvinceIdAndCityIdOfCity:[PersistenceHelper dataForKey:kCityName]];
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:self.curCityId, @"cityid", self.curProvinceId, @"provinceid", @"getZsRrecommendCount.json", @"path", [kAppDelegate userId], @"userid", nil];
    
    NSLog(@"paradict %@", paraDict);
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            self.commendCount = [[json objForKey:@"returncount"] intValue];
            [self getInvestmentUserListFromServer];
        }
    } failure:^(NSError *error) {
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (void)getInvestmentUserListFromServer
{
    NSLog(@"current city; %@", self.currentCity);
    //parameter: provinceid, cityid, userid(用来取备注),
    [self setProvinceIdAndCityIdOfCity:[PersistenceHelper dataForKey:kCityName]];
    NSString *userid = kAppDelegate.userId;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.curProvinceId, @"provinceid",
                          [PersistenceHelper dataForKey:kCityId], @"cityid",
                          userid, @"userid",
                          @"getZsRrecommendList.json", @"path", nil];
    
    
    NSLog(@"all contact dict %@", dict);
    
    
    [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];

    
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            
            //            NSLog(@"friend json %@", json);
            
            NSArray *friendArray = [Utility deCryptJsonDict:json OfJsonKey:@"DataList"];
            NSLog(@"friend arrat %@", friendArray);
            
            
            
            [friendArray enumerateObjectsUsingBlock:^(NSDictionary *contactDict, NSUInteger idx, BOOL *stop) {
                NSLog(@"contact Dict: %@", contactDict);
                
                CommendContact *contact = [CommendContact MR_createEntity];
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
                
                NSLog(@"pinyin %@", makePinYinOfName(contact.username));
                
                contact.sectionkey = [NSString stringWithFormat:@"%c", indexTitleOfString([contact.username characterAtIndex:0])];
                [self.commendContactArray addObject:contact];
                DB_SAVE();
            }];
            
            [self.mTableView reloadData];
            
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
        } else {
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}



#pragma mark - help method

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



- (void)tapOnLocationIcon
{
    [self selectArea:nil];
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commendContactArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"contactCell";
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil] objectAtIndex:0];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(ContactCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    
    CommendContact *commendContact = [self.commendContactArray objectAtIndex:indexPath.row];
    
    cell.headIcon.layer.cornerRadius = 4;
    cell.headIcon.layer.masksToBounds = YES;
    [cell.headIcon setImageWithURL:[NSURL URLWithString:commendContact.picturelinkurl] placeholderImage:[UIImage imageByName:@"AC_talk_icon.png"]];
    
    if ([commendContact.remark isValid]) {
        NSMutableString *userName = [NSMutableString stringWithFormat:@"%@(%@)", commendContact.username, commendContact.remark];
        cell.nameLabel.text = userName;
    }
    else{
        cell.nameLabel.text = commendContact.username;
    }
    
    cell.unSelectedImage.hidden = YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OtherHomepageViewController *otherProfileVC = [[OtherHomepageViewController alloc] init];

    
    otherProfileVC.contact = [self.commendContactArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:otherProfileVC animated:YES];
    [otherProfileVC release];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginNotification object:nil];
    [super dealloc];
}

@end
