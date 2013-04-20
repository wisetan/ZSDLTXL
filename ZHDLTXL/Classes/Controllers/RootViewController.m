//
//  RootViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-8.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "RootViewController.h"
#import "ContactCell.h"
#import "Contact.h"
#import "ProvinceViewController.h"
#import "LoginViewController.h"
#import "SendMessageViewController.h"
#import "SendEmailViewController.h"
#import "ChatViewController.h"
#import "OtherHomepageViewController.h"
#import "UIImageView+WebCache.h"
#import "MyHomePageViewController.h"
#import "MyFriendViewController.h"
//#import "SelectViewController.h"

#import "ZhaoshangAndDailiViewController.h"
#import "UIImageView+WebCache.h"

@interface RootViewController ()

@property (nonatomic, retain) NSMutableArray *sectionTitleArray;

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([self isLogined]) {
        self.loginLabel.text = @"我的主页";
    }
    else{
        self.loginLabel.text = @"登录";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSLog(@"sections: %@", [[UILocalizedIndexedCollation currentCollation] sectionTitles]);
//    [[UILocalizedIndexedCollation currentCollation] sectionForObject:nil collationStringSelector:@selector(123)];
    
    [self addObserver];
    
    //location manager
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1000.f;
    [self.locationManager startUpdatingLocation];
    
    //contact array
    self.contactArray = [[[NSMutableArray alloc] init] autorelease];
    self.contactDictSortByAlpha = [[NSMutableDictionary new] autorelease];
    
    //nav bar image
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topmargin.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    //bottom image view
	self.bottomImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_bg.png"]] autorelease];
    self.bottomImageView.frame = CGRectMake(0, self.view.frame.size.height-45-44, 320, 45);
    self.bottomImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.bottomImageView];

    
    //login button
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.loginButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];

    self.loginButton.frame = CGRectMake(5, 5, 101, 34);
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 101.f, 34.f)] autorelease];
    
    if ([self isLogined]) {
        self.loginLabel.text = @"我的主页";
        [self.loginButton addTarget:self action:@selector(showMyHomepage:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [self.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        self.loginLabel.text = @"登录";
    }
    
    [self.loginLabel setFont:[UIFont systemFontOfSize:16]];
    self.loginLabel.backgroundColor = [UIColor clearColor];
    self.loginLabel.textColor = [UIColor whiteColor];
    self.loginLabel.textAlignment = NSTextAlignmentCenter;
    [self.loginButton addSubview:self.loginLabel];
    [self.bottomImageView addSubview:self.loginButton];
    
    
    //select button
    self.selButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.selButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    [self.selButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    self.selButton.frame = CGRectMake(214, 5, 101, 34);
    UILabel *selLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 101, 34)] autorelease];
    selLabel.text = @"筛选";
    [selLabel setFont:[UIFont systemFontOfSize:16]];
    selLabel.backgroundColor = [UIColor clearColor];
    selLabel.textColor = [UIColor whiteColor];
    selLabel.textAlignment = NSTextAlignmentCenter;
    [self.selButton addSubview:selLabel];
    [self.bottomImageView addSubview:self.selButton];
    
    //contact table view
    self.contactTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44-45)] autorelease];
    [self.contactTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.contactTableView.delegate = self;
    self.contactTableView.dataSource = self;
    
    [self.view addSubview:self.contactTableView];
    
    //left area barbutton
    self.areaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.areaButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.areaButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    [self.areaButton addTarget:self action:@selector(selectArea:) forControlEvents:UIControlEventTouchUpInside];
    self.areaButton.frame = CGRectMake(0, 0, 101, 34);
    self.areaLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 0, 101, 34)] autorelease];
    self.areaLabel.text = self.currentCity;
    [self.areaLabel setFont:[UIFont systemFontOfSize:16]];
    self.areaLabel.backgroundColor = [UIColor clearColor];
    self.areaLabel.textColor = [UIColor whiteColor];
    self.areaLabel.textAlignment = NSTextAlignmentCenter;
    [self.areaButton addSubview:self.areaLabel];
    
    UIImageView *areaIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_icon.png"]] autorelease];
    areaIcon.frame = CGRectMake(7, 3, 28, 28);
    areaIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapOnIcon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnLocationIcon)];
    [areaIcon addGestureRecognizer:tapOnIcon];
    [self.areaButton addSubview:areaIcon];
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.areaButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    //left friend barbutton
    self.friendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.friendButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.friendButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    [self.friendButton addTarget:self action:@selector(myFriend:) forControlEvents:UIControlEventTouchUpInside];
    self.friendButton.frame = CGRectMake(0, 0, 101, 34);
    UILabel *friendLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 101, 34)] autorelease];
    friendLabel.text = @"我的好友";
    [friendLabel setFont:[UIFont systemFontOfSize:16]];
    friendLabel.backgroundColor = [UIColor clearColor];
    friendLabel.textColor = [UIColor whiteColor];
    friendLabel.textAlignment = NSTextAlignmentCenter;
    [self.friendButton addSubview:friendLabel];
    
    UIBarButtonItem *rBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.friendButton] autorelease];
    [self.navigationItem setRightBarButtonItem:rBarButton];
    
    [PersistenceHelper setData:self.currentCity forKey:kCityName];
    [self getInvestmentUserList];
    
}

- (BOOL)isLogined
{
    NSString *userid = [PersistenceHelper dataForKey:kUserId];
    return [userid isValid];
}

- (void)tapOnLocationIcon
{
    [self selectArea:nil];
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
            if ([[cityDict objectForKey:@"cityname"] isEqualToString:self.currentCity]) {
                self.curProvinceId = [cityDict objectForKey:@"provinceid"];
                self.curCityId = [cityDict objectForKey:@"cityid"];
                
                [PersistenceHelper setData:self.curCityId forKey:kCityId];
                [PersistenceHelper setData:self.curProvinceId forKey:kProvinceId];
                *stop = YES;
            }
        }];
    }];
}

- (void)getInvestmentUserList
{
    [self setProvinceIdAndCityIdOfCity:self.currentCity];
    NSLog(@"current city; %@", self.currentCity);
    //parameter: provinceid, cityid, userid(用来取备注),
    NSString *userid = kAppDelegate.userId;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.curProvinceId, @"provinceid",
                                                                    self.curCityId, @"cityid",
                                                                    userid, @"userid",
                                                                    @"getInvestmentUserList.json", @"path", nil];
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hub.labelText = @"获取商家列表";
    NSLog(@"dict: %@", dict);
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            
//            NSLog(@"商家列表：%@", json);
            NSMutableArray *contactArray = [NSMutableArray new];
            [[json objectForKey:@"InvestmentUserList"] enumerateObjectsUsingBlock:^(NSDictionary *contactDict, NSUInteger idx, BOOL *stop) {
//                NSLog(@"contact Dict: %@", contactDict);) {

                Contact *contact = [Contact new];
                contact.userid = [[contactDict objectForKey:@"id"] stringValue];
                contact.username = [contactDict objForKey:@"username"];
                contact.tel = [contactDict objForKey:@"tel"];
                contact.mailbox = [contactDict objectForKey:@"mailbox"];
                contact.picturelinkurl = [contactDict objectForKey:@"picturelinkurl"];
                contact.col1 = [contactDict objectForKey:@"col1"];
                contact.col2 = [contactDict objectForKey:@"col2"];
                contact.col2 = [contactDict objectForKey:@"col2"];
//                if ([contact.picturelinkurl isValid]) {
//                    NSLog(@"pic url: %@", contact.picturelinkurl);
//                }
                
                [contactArray addObject:contact];
                [contact release];
            }];
            
//            NSLog(@"contact array %@", contactArray);
            NSDictionary *contactDict = [NSDictionary dictionaryWithObjectsAndKeys:self.currentCity, @"cityName", contactArray, @"contactArray", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kInvestmentUserListRefreshed object:contactDict];
            [contactArray release];
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        } else {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
    
    
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

- (void)showMyHomepage:(UIButton *)sender
{
    NSLog(@"我得主页");
    MyHomePageViewController *myHomePageVC = [[MyHomePageViewController alloc] init];
    [self.navigationController pushViewController:myHomePageVC animated:YES];
    [myHomePageVC release];
    
}

- (void)select:(UIButton *)sender
{
    NSLog(@"select");
    ZhaoshangAndDailiViewController *zdVC = [[ZhaoshangAndDailiViewController alloc] init];
    [self.navigationController pushViewController:zdVC animated:YES];
    [zdVC release];
}

- (void)selectArea:(UIButton *)sender
{
    NSLog(@"select area");
    ProvinceViewController *areaVC = [[ProvinceViewController alloc] init];
    areaVC.isAddResident = NO;
    [self.navigationController pushViewController:areaVC animated:YES];
    [areaVC release];
}

- (void)myFriend:(UIButton *)sender
{
    NSLog(@"my friend");
    MyFriendViewController *myFriendVC = [[MyFriendViewController alloc] init];
    myFriendVC.provinceid = self.curProvinceId;
    myFriendVC.cityid = self.curCityId;
    myFriendVC.userid = kAppDelegate.userId;
    [self.navigationController pushViewController:myFriendVC animated:YES];
    [myFriendVC release];
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return [self.indexArray count];
    return [[self.contactDictSortByAlpha allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *indexKey = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    NSInteger count = [[self.contactDictSortByAlpha objectForKey:indexKey] count];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[UILocalizedIndexedCollation currentCollation] sectionTitles];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"contactCell";
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    NSString *indexKey = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:indexPath.section];
    Contact *contact = [[self.contactDictSortByAlpha objectForKey:indexKey] objectAtIndex:indexPath.row];
//    NSLog(@"contact url: %@", contact.picturelinkurl);
    
    [cell.headIcon setImageWithURL:[NSURL URLWithString:contact.picturelinkurl] placeholderImage:[UIImage imageByName:@"AC_talk_icon.png"]];
    
    if ([[self.contactDictSortByAlpha objectForKey:indexKey] count] != 0) {
        cell.nameLabel.text = [[[self.contactDictSortByAlpha objectForKey:indexKey] objectAtIndex:indexPath.row] username];
    }
    
    cell.unSelectedImage.hidden = YES;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *indexKey = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    if ([[self.contactDictSortByAlpha objectForKey:indexKey] count] == 0) {
        return 0.f;
    }
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OtherHomepageViewController *homeVC = nil;
    if (IS_IPHONE_5) {
        homeVC = [[OtherHomepageViewController alloc] initWithNibName:@"OtherHomepageViewController_ip5" bundle:nil];
    }
    else{
        homeVC = [[OtherHomepageViewController alloc] initWithNibName:@"OtherHomepageViewController" bundle:nil];
    }
    
    NSString *indexKey = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:indexPath.section];
    homeVC.contact = [[self.contactDictSortByAlpha objectForKey:indexKey] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:homeVC animated:YES];
    [homeVC release];
}




#pragma mark - contactHimView delegate

- (void)message:(Contact *)contact
{
    NSLog(@"send message");
    SendMessageViewController *smVC = [[SendMessageViewController alloc] init];
    [self.navigationController pushViewController:smVC animated:YES];
    [smVC release];
}

- (void)email:(Contact *)contact
{
    NSLog(@"send email");
    SendEmailViewController *seVC = [[SendEmailViewController alloc] init];
    [self.navigationController pushViewController:seVC animated:YES];
    [seVC release];
}

- (void)chat:(Contact *)contact
{
    NSLog(@"chat");
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:chatVC animated:YES];
    [chatVC release];
}


#pragma mark - notification

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(investmentUserListRefreshed:) name:kInvestmentUserListRefreshed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registSucceed:) name:kRegistSuccedd object:nil];
    
    //inspect city
    [kAppDelegate addObserver:self forKeyPath:@"newCity" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"city changed");
    id newValue = [change objectForKey:@"new"];
    NSLog(@"city :%@", newValue);
    if ((newValue != [NSNull null]) && [(NSString *)newValue isValid]){
        self.currentCity = newValue;
        [PersistenceHelper setData:self.currentCity forKey:kCityName];
        self.areaLabel.text = self.currentCity;
        [self getInvestmentUserList];
    }
}

- (void)registSucceed:(NSNotification *)noti
{
    NSLog(@"regist succeed");
    self.loginLabel.text = @"我的主页";
}

- (void)investmentUserListRefreshed:(NSNotification *)noti
{
//    NSLog(@"__func__: %@", noti);

    
    [self.contactArray removeAllObjects];
    [self.contactArray addObjectsFromArray:[[noti object] objectForKey:@"contactArray"]];
    //按字母分组
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (NSString *indexKey in [theCollation sectionTitles]) {
        NSMutableArray *contactArrayTmp = [[NSMutableArray alloc] init];
        [self.contactDictSortByAlpha setObject:contactArrayTmp forKey:indexKey];
        [contactArrayTmp release];
    }
        
    [self.contactArray enumerateObjectsUsingBlock:^(Contact *contact, NSUInteger idx, BOOL *stop) {
        NSString *indexKey = [NSString stringWithFormat:@"%c", indexTitleOfString([contact.username characterAtIndex:0])];
        [[self.contactDictSortByAlpha objectForKey:indexKey] addObject:contact];
//        if ([contact.picturelinkurl isValid]) {
//            NSLog(@"pic url: %@", contact.picturelinkurl);
//        }
    }];
    
    
    self.curProvinceId = [PersistenceHelper dataForKey:kProvinceId];
    self.curCityId = [PersistenceHelper dataForKey:kCityId];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.dat",self.curProvinceId, self.curCityId];
    NSString *userDataFile = [[NSString alloc] initWithString:[kDocumentory stringByAppendingPathComponent:fileName]];

    
    NSString *oldFile = [PersistenceHelper dataForKey:kUserDataFile];
    NSLog(@"oldFile %@", oldFile);
    NSLog(@"newFile %@", userDataFile);
    
    if ([oldFile isValid] && ![[NSFileManager defaultManager] fileExistsAtPath:oldFile]) {
        [NSKeyedArchiver archiveRootObject:self.contactDictSortByAlpha toFile:userDataFile];
    }
    else if (![userDataFile isEqualToString:oldFile]) {

        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:oldFile])
        {
            NSError *error;
            if (![fileManager removeItemAtPath:oldFile error:&error])
            {
                NSLog(@"Error removing file: %@", error);
            };
        }
        [PersistenceHelper setData:userDataFile forKey:kUserDataFile];
        [NSKeyedArchiver archiveRootObject:self.contactDictSortByAlpha toFile:userDataFile];
    }
    
    self.currentCity = [PersistenceHelper dataForKey:kCityName];
    self.areaLabel.text = self.currentCity;
    [self.contactTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
