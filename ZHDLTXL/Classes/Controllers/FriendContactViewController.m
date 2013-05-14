//
//  FriendContactViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-26.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "FriendContactViewController.h"
#import "ContactCell.h"
#import "FriendContact.h"
#import "OtherHomepageViewController.h"
#import "ProvinceViewController.h"
#import "MyHomePageViewController.h"
#import "LoginViewController.h"

@interface FriendContactViewController ()

@end

@implementation FriendContactViewController

@synthesize fetchedResultsController = _fetchedResultsController;

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

- (NSString *)tabTitle
{
    return @"好友";
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.isFetchingData == NO) {
        self.isFetchingData = YES;
        if ([kAppDelegate.userId isEqualToString:@"0"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先登录" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
        
        if (self.isLogined) {
            [self initContactDict];
            [self.sectionArray removeAllObjects];
            [self getFriendData];
            self.loginLabel.text = @"主页";
        }
        else{
            self.loginLabel.text = @"登录";
            [self.sectionArray removeAllObjects];
            [self.contactDict removeAllObjects];
            [self.mTableView reloadData];
        }
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

- (void)getFriendData
{
    if (![kAppDelegate.userId isEqualToString:@"0"]) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"cityid == %@ AND loginid == %@ AND type == %@", [PersistenceHelper dataForKey:kCityId], [kAppDelegate userId], @"1"];
        NSArray *array = [FriendContact findAllSortedBy:@"sectionkey,username_p" ascending:YES withPredicate:pred];
        if (array.count != 0) {
            [array enumerateObjectsUsingBlock:^(AllContact *contact, NSUInteger idx, BOOL *stop) {
                NSString *contactIndex = [NSString stringWithFormat:@"%c", indexTitleOfString([contact.username characterAtIndex:0])];
                [[self.contactDict objForKey:contactIndex] addObject:contact];
            }];
            
            NSMutableSet *sectionSet = [[[NSMutableSet alloc] init] autorelease];
            [self.contactDict enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSMutableArray *contactArray, BOOL *stop) {
                if (contactArray.count != 0) {
                    [sectionSet addObject:key];
                }
            }];
            
            [sectionSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                [self.sectionArray addObject:obj];
            }];
            
            [self.sectionArray sortUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
                return [obj1 compare:obj2];
            }];
            
            NSLog(@"section array %@", self.sectionArray);
            [self.mTableView reloadData];
        }
        else{
            [self getInvestmentUserListFromServer];
        }
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [PersistenceHelper dataForKey:kCityName];
    self.entityName = @"FriendContact";
//    self.contactType = eFriendContatType;
    self.firstLoadView = YES;
    self.isFetchingData = NO;
    
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
    
    NSLog(@"friend frame %@", NSStringFromCGRect(self.mTableView.frame));
    
    [self.view addSubview:self.mTableView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLoginNoti:) name:kLoginNotification object:nil];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:kCityName
                                               options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                               context:nil];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:kUserId options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    

}

- (void)initContactDict
{
    self.contactDict = [[[NSMutableDictionary alloc] init] autorelease];
    NSArray *indexTitleArray = [[UILocalizedIndexedCollation currentCollation] sectionTitles];
    [indexTitleArray enumerateObjectsUsingBlock:^(NSString *indexTitle, NSUInteger idx, BOOL *stop) {
        [self.contactDict setObject:[NSMutableArray array] forKey:indexTitle];
    }];
    
    self.sectionArray = [NSMutableArray array];
}

- (void)receiveLoginNoti:(NSNotification *)noti
{
    self.loginLabel.text = @"主页";
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

- (void)getInvestmentUserListFromServer
{
    NSLog(@"current city; %@", self.currentCity);
    [self setProvinceIdAndCityIdOfCity:[PersistenceHelper dataForKey:kCityName]];
    //parameter: provinceid, cityid, userid(用来取备注),
    NSString *userid = kAppDelegate.userId;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.curProvinceId, @"provinceid",
                          [PersistenceHelper dataForKey:kCityId], @"cityid",
                          userid, @"userid",
                          @"getZsAttentionUserByArea.json", @"path", nil];
    
//    NSLog(@"all contact dict %@", dict);
    
    
    [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
//            NSLog(@"friend json %@", json);
//            NSLog(@"pred %@", self.fetchedResultsController.fetchRequest.predicate);
            NSArray *friendArray = [Utility deCryptJsonDict:json OfJsonKey:@"DataList"];
//            NSLog(@"friend arrat %@", friendArray);
            
            [friendArray enumerateObjectsUsingBlock:^(NSDictionary *contactDict, NSUInteger idx, BOOL *stop) {
//                NSLog(@"contact Dict: %@", contactDict);
                
                FriendContact *contact = [FriendContact MR_createEntity];
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
                contact.type = @"1";
                contact.username_p = makePinYinOfName(contact.username);
                contact.invagency = [[contactDict objForKey:@"invagency"] stringValue];
                
                
//                NSLog(@"pinyin %@", makePinYinOfName(contact.username));
                
                contact.sectionkey = [NSString stringWithFormat:@"%c", indexTitleOfString([contact.username characterAtIndex:0])];
                [[self.contactDict objForKey:contact.sectionkey] addObject:contact];
                DB_SAVE();
            }];
            
            [self.sectionArray removeAllObjects];
            
            [self.contactDict enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSArray * obj, BOOL *stop) {
                if (obj.count != 0) {
                    [self.sectionArray addObject:key];
                }
            }];
            
            
            [self.sectionArray sortUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
                return [obj1 compare:obj2];
            }];
            
            [self.mTableView reloadData];
            
            
        } else {
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (void)configureCell:(ContactCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    
//    FriendContact *userDetail = [self.fetchedResultsController objectAtIndexPath:indexPath];
    FriendContact *userDetail = [[self.contactDict objForKey:[self.sectionArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    switch (userDetail.invagency.intValue) {
        case 1:
            cell.ZDLabel.text = @"招商";
            break;
        case 2:
            cell.ZDLabel.text = @"代理";
            break;
        case 3:
            cell.ZDLabel.text = @"招商、代理";
            break;
        default:
            break;
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
    
    if ([userDetail.col2 isEqualToString:@"1"]) {
        cell.xun_VImage.hidden = NO;
    }
    else{
        cell.xun_VImage.hidden = YES;
    }
    
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OtherHomepageViewController *otherProfileVC = [[OtherHomepageViewController alloc] init];
    
    otherProfileVC.contact = [[self.contactDict objForKey:[self.sectionArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:otherProfileVC animated:YES];
    [otherProfileVC release];
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
    return [self.sectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.contactDict objForKey:[self.sectionArray objectAtIndex:section]] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionArray objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionArray;
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

#pragma mark - other controller delegate

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
