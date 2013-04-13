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
    self.contactArray = [[NSMutableArray alloc] init];
    self.contactDictSortByAlpha = [NSMutableDictionary new];
    
    //nav bar image
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topmargin.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    //bottom image view
	self.bottomImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_bg.png"]] autorelease];
    self.bottomImageView.frame = CGRectMake(0, self.view.frame.size.height-45-44, 320, 45);
    self.bottomImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.bottomImageView];
    [self.bottomImageView release];
    
    //login button
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.loginButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];

    self.loginButton.frame = CGRectMake(5, 5, 101, 34);
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 101.f, 34.f)];
    
    if (self.hasRegisted) {
        loginLabel.text = @"我的主页";
        [self.loginButton addTarget:self action:@selector(showMyHomepage:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [self.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        loginLabel.text = @"登录";
    }
    
    [loginLabel setFont:[UIFont systemFontOfSize:16]];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.textAlignment = NSTextAlignmentCenter;
    [self.loginButton addSubview:loginLabel];
    [self.bottomImageView addSubview:self.loginButton];
    
    
    //select button
    self.selButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.selButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    [self.selButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    self.selButton.frame = CGRectMake(214, 5, 101, 34);
    UILabel *selLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 101, 34)];
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
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 101, 34)];
    areaLabel.text = @"北京";
    [areaLabel setFont:[UIFont systemFontOfSize:16]];
    areaLabel.backgroundColor = [UIColor clearColor];
    areaLabel.textColor = [UIColor whiteColor];
    areaLabel.textAlignment = NSTextAlignmentCenter;
    [self.areaButton addSubview:areaLabel];
    
    UIImageView *areaIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_icon.png"]];
    areaIcon.frame = CGRectMake(7, 3, 28, 28);
    areaIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapOnIcon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnLocationIcon)];
    [areaIcon addGestureRecognizer:tapOnIcon];
    [self.areaButton addSubview:areaIcon];
    
    UIBarButtonItem *lBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.areaButton];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    //left friend barbutton
    self.friendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.friendButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.friendButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    [self.friendButton addTarget:self action:@selector(myFriend:) forControlEvents:UIControlEventTouchUpInside];
    self.friendButton.frame = CGRectMake(0, 0, 101, 34);
    UILabel *friendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 101, 34)];
    friendLabel.text = @"我的好友";
    [friendLabel setFont:[UIFont systemFontOfSize:16]];
    friendLabel.backgroundColor = [UIColor clearColor];
    friendLabel.textColor = [UIColor whiteColor];
    friendLabel.textAlignment = NSTextAlignmentCenter;
    [self.friendButton addSubview:friendLabel];
    
    UIBarButtonItem *rBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.friendButton];
    [self.navigationItem setRightBarButtonItem:rBarButton];
    
    [self getInvestmentUserList];
    
}

- (void)addContactHimView
{
    self.contactHimView = [[ContactHimView alloc] initWithFrame:CGRectMake(0, 0, 256, 56)];
    [self.view addSubview:self.contactHimView];
    self.contactHimView.center = CGPointMake(self.contactTableView.center.x + 320, self.contactTableView.center.y);
    self.contactHimView.delegate = self;
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
    
    NSArray *provinceArrayTmp = [areaDictTmp objectForKey:@"AreaList"];
    [provinceArrayTmp enumerateObjectsUsingBlock:^(NSDictionary *proDict, NSUInteger idx, BOOL *stop) {
        
        NSArray *cityArrayJsonTmp = [proDict objectForKey:@"citylist"];
        [cityArrayJsonTmp enumerateObjectsUsingBlock:^(NSDictionary *cityDict, NSUInteger idx, BOOL *stop) {
            if ([[cityDict objectForKey:@"cityname"] isEqualToString:self.currentCity]) {
                self.curProvinceId = [cityDict objectForKey:@"provinceid"];
                self.curCityId = [cityDict objectForKey:@"cityid"];
            }
        }];
    }];
}

- (void)getInvestmentUserList
{
    [self setProvinceIdAndCityIdOfCity:self.currentCity];
    //parameter: provinceid, cityid, userid(用来取备注),
    long userId = [kAppDelegate.userId longLongValue];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.curProvinceId, @"provinceid",
                                                                    self.curCityId, @"cityid",
                                                                    [NSNumber numberWithLong:userId], @"userid",
                                                                    @"getInvestmentUserList.json", @"path", nil];
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hub.labelText = @"获取商家列表";
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            
//            NSLog(@"商家列表：%@", json);
            NSMutableArray *contactArray = [NSMutableArray new];
            [[json objectForKey:@"InvestmentUserList"] enumerateObjectsUsingBlock:^(NSDictionary *contactDict, NSUInteger idx, BOOL *stop) {
                //                NSLog(@"contact Dict: %@", contactDict);
                Contact *contact = [Contact new];
                contact.userid = [[contactDict objectForKey:@"id"] longValue];
                contact.username = [contactDict objForKey:@"username"];
                contact.tel = [contactDict objForKey:@"tel"];
                contact.mailbox = [contactDict objectForKey:@"mailbox"];
                contact.picturelinkurl = [contactDict objectForKey:@"picturelinkurl"];
                contact.col1 = [contactDict objectForKey:@"col1"];
                contact.col2 = [contactDict objectForKey:@"col2"];
                contact.col2 = [contactDict objectForKey:@"col2"];
                [contactArray addObject:contact];
                [contact release];
            }];
            
//            NSLog(@"contact array %@", contactArray);
            [[NSNotificationCenter defaultCenter] postNotificationName:kInvestmentUserListRefreshed object:contactArray];
            [contactArray release];
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
    LoginViewController *loginVC = nil;
    if (IS_IPHONE_5) {
        loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController_ip5" bundle:nil];
    }
    else{
        loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:loginVC animated:YES];
    [loginVC release];
}

- (void)showMyHomepage:(UIButton *)sender
{
    NSLog(@"我得主页");
}

- (void)select:(UIButton *)sender
{
    NSLog(@"select");
}

- (void)selectArea:(UIButton *)sender
{
    NSLog(@"select area");
    ProvinceViewController *areaVC = [[ProvinceViewController alloc] init];
    [self.navigationController pushViewController:areaVC animated:YES];
    [areaVC release];
}

- (void)myFriend:(UIButton *)sender
{
    NSLog(@"my friend");
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
//    cell.headIcon.image = [UIImage imageNamed:@"AC_talk_icon.png"];
    
    NSString *indexKey = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:indexPath.section];
    NSString *imageUrl = [[[self.contactDictSortByAlpha objectForKey:indexKey] objectAtIndex:indexPath.row] picturelinkurl];
    
    
    [cell.headIcon setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"AC_talk_icon.png"]];
    
    if ([[self.contactDictSortByAlpha objectForKey:indexKey] count] != 0) {
        
        cell.nameLabel.text = [[[self.contactDictSortByAlpha objectForKey:indexKey] objectAtIndex:indexPath.row] username];
    }
    
    self.currentContact = nil;  //[self.contactArray objectAtIndex:indexPath.row];
    cell.unSelectedImage.alpha = 0.f;
//    cell.selectButton = nil;

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
    OtherHomepageViewController *homeVC = [[OtherHomepageViewController alloc] init];

    NSString *indexKey = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:indexPath.section];
    NSString *username = [[[self.contactDictSortByAlpha objectForKey:indexKey] objectAtIndex:indexPath.row] username];
    homeVC.userName = username;
    homeVC.contactDict = self.contactDictSortByAlpha;
    [self.navigationController pushViewController:homeVC animated:YES];
    [homeVC release];
}


//- (void)contactHim:(CellButton *)sender
//{
////    NSLog(@"sender.index: %d, cur index: %d", sender.index, self.currentCellButtonIndex);
//    if (sender.indexRow == self.currentCellButtonIndex && self.contactHimView.isAppeared == YES) {
//        return;
//    }
//    else{
//        self.currentCellButtonIndex = sender.index;
//    }
//    if (self.contactHimView.isAppeared) {
//        self.contactHimView.isAppeared = NO;
//        [UIView animateWithDuration:1.f animations:^{
//            self.contactHimView.center = CGPointMake(self.contactHimView.center.x+320, self.contactHimView.center.y);
//        }];
//        return;
//    }
//    self.contactHimView.isAppeared = YES;
//    [UIView animateWithDuration:1.f animations:^{
//        self.contactHimView.center = self.contactTableView.center;
//    }];
//    self.contactTableView.scrollEnabled = NO;
//}

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChanged:) name:kCityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(investmentUserListRefreshed:) name:kInvestmentUserListRefreshed object:nil];
}

- (void)cityChanged:(NSNotification *)noti
{
    NSString *newCity = (NSString *)[noti object];
    self.currentCity = newCity;
}

- (void)investmentUserListRefreshed:(NSNotification *)noti
{
//    NSLog(@"__func__: %@", noti);
    [self.contactArray removeAllObjects];
    [self.contactArray addObjectsFromArray:[noti object]];
    //按字母分组
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (NSString *indexKey in [theCollation sectionTitles]) {
        NSMutableArray *contactArrayTmp = [NSMutableArray new];
        [self.contactDictSortByAlpha setObject:contactArrayTmp forKey:indexKey];
        [contactArrayTmp release];
    }
        
    [self.contactArray enumerateObjectsUsingBlock:^(Contact *contact, NSUInteger idx, BOOL *stop) {
        NSString *indexKey = [NSString stringWithFormat:@"%c", indexTitleOfString([contact.username characterAtIndex:0])];
        [[self.contactDictSortByAlpha objectForKey:indexKey] addObject:contact];
    }];
    
    [self.contactTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
