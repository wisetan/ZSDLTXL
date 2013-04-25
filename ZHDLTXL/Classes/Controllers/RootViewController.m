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
#import "CityInfo.h"

@interface RootViewController ()

@property (nonatomic, retain) NSMutableArray *sectionTitleArray;

@end

@implementation RootViewController

@synthesize fetchedResultsController = _fetchedResultsController;

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
    
////    if ([[PersistenceHelper dataForKey:kUserId] isValid]) {
//    [PersistenceHelper setData:self.currentCity forKey:kCityName];
//    if ([self isLogined]) {
//        [self getInvestmentUserListFromLocal];
//    }
//    else{
//        [self getInvestmentUserListFromServer];
//    }
////    }
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
    
    [self.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
}

    //首次，如果通过gps已经查到城市名，从服务器取数据，存到本地
//    if (self.currentCity) {
//        [self getInvestmentUserListFromServer];
//    }
//}

//- (void)getInvestmentUserList
//{
//    self.contactArray = [NSMutableArray arrayWithArray:[self getInvestmentUserListFromLocal]];
//    if (self.contactArray.count == 0) {
//        [self getInvestmentUserListFromServer];
//    }
//    else{
////        NSLog(@"self.contact array %@", self.contactArray);
//        NSDictionary *contactDict = [NSDictionary dictionaryWithObjectsAndKeys:self.currentCity, @"cityName", self.contactArray, @"contactArray", nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kInvestmentUserListRefreshed object:contactDict];
//    }
//}

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

- (void)getInvestmentUserListFromLocal
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userid != %@", kAppDelegate.userId];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserDetail" inManagedObjectContext:kAppDelegate.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSError *error=nil;
    NSArray *contactArray = [NSMutableArray arrayWithArray:[kAppDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    NSDictionary *notiDict = [NSDictionary dictionaryWithObjectsAndKeys:contactArray, @"contactArray", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kInvestmentUserListRefreshed object:notiDict];

}

- (void)getInvestmentUserListFromServer
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
//    NSLog(@"dict: %@", dict);
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            
            CityInfo *gpsCity = [NSEntityDescription insertNewObjectForEntityForName:@"CityInfo" inManagedObjectContext:kAppDelegate.managedObjectContext];
            gpsCity.cityname = [PersistenceHelper dataForKey:kCityName];
            gpsCity.cityid = [PersistenceHelper dataForKey:kGpsCityId];
            [[json objectForKey:@"InvestmentUserList"] enumerateObjectsUsingBlock:^(NSDictionary *contactDict, NSUInteger idx, BOOL *stop) {
//                NSLog(@"contact Dict: %@", contactDict);

                UserDetail *contact = [NSEntityDescription insertNewObjectForEntityForName:@"UserDetail" inManagedObjectContext:kAppDelegate.managedObjectContext];
                contact.userid = [[contactDict objForKey:@"id"] stringValue];
                contact.username = [contactDict objForKey:@"username"];
                contact.tel = [contactDict objForKey:@"tel"];
                contact.mailbox = [contactDict objForKey:@"mailbox"];
                contact.picturelinkurl = [contactDict objForKey:@"picturelinkurl"];
                contact.col1 = [contactDict objForKey:@"col1"];
                contact.col2 = [contactDict objForKey:@"col2"];
                contact.col2 = [contactDict objForKey:@"col2"];
                contact.city = gpsCity;
                contact.sectionkey = [NSString stringWithFormat:@"%c", indexTitleOfString([contact.username characterAtIndex:0])];
                [gpsCity addUsersObject:contact];
            }];
            
            NSError *error;
            if (![kAppDelegate.managedObjectContext save:&error]) {
                NSLog(@"save error %@", error);
            }
            
//            [self.contactTableView reloadData];

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
    myFriendVC.provinceid = [PersistenceHelper dataForKey:kProvinceId];
    myFriendVC.cityid = [PersistenceHelper dataForKey:kCityId];
    myFriendVC.userid = kAppDelegate.userId;
    [self.navigationController pushViewController:myFriendVC animated:YES];
    [myFriendVC release];
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return [self.indexArray count];
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return  [[self.fetchedResultsController sectionIndexTitles] objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sectionIndexTitles];
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
    
    
    UserDetail *userDetail = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.headIcon.layer.cornerRadius = 4;
    cell.headIcon.layer.masksToBounds = YES;
    [cell.headIcon setImageWithURL:[NSURL URLWithString:userDetail.picturelinkurl] placeholderImage:[UIImage imageByName:@"AC_talk_icon.png"]];

    
    cell.nameLabel.text = userDetail.username;
    
    cell.unSelectedImage.hidden = YES;
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
    
//    NSString *indexKey = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:indexPath.section];
//    homeVC.contact = [[self.contactDictSortByAlpha objectForKey:indexKey] objectAtIndex:indexPath.row];
    
    homeVC.contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:homeVC animated:YES];
    [homeVC release];
}

#pragma mark - notification

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(investmentUserListRefreshed:) name:kInvestmentUserListRefreshed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registSucceed:) name:kRegistSuccedd object:nil];
    
    
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:kCityName options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    //inspect city
//    [kAppDelegate addObserver:self forKeyPath:@"newCity" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"city changed");
    NSString * newValue = [change objForKey:@"new"];
    NSString * oldValue = [change objForKey:@"old"];

    NSLog(@"newCity : %@, oldCity : %@", newValue, oldValue);
    if (![newValue isEqualToString:oldValue]){
        
        self.currentCity = newValue;
//        [PersistenceHelper setData:self.currentCity forKey:kCityName];
        self.areaLabel.text = self.currentCity;
        
        [NSFetchedResultsController deleteCacheWithName:nil];
        self.fetchedResultsController = nil;
        
        [self.contactTableView reloadData]; //when will get new user list, clear tableview first
        
        NSError *error;
        if (![self.fetchedResultsController performFetch:&error]) {
            NSLog(@"Error in tag retrieval %@, %@", error, [error userInfo]);
            abort();
        }
        
        int count = self.fetchedResultsController.fetchedObjects.count;
        NSLog(@"count = %d", count);
        
        if (self.fetchedResultsController.fetchedObjects.count == 0) {
            
            [self getInvestmentUserListFromServer];
            
        }
        else{
            [self.contactTableView reloadData];
        }
    }
}

- (void)registSucceed:(NSNotification *)noti
{
    NSLog(@"regist succeed");
    self.loginLabel.text = @"我的主页";
}

//- (void)investmentUserListRefreshed:(NSNotification *)noti
//{
//    self.currentCity = [noti.object objForKey:@"city"];
//}


#pragma mark - fetch result controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"UserDetail" inManagedObjectContext:kAppDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"sectionkey" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:200];
    
    NSString *cityname = [PersistenceHelper dataForKey:kCityName];
    NSLog(@"cityname = %@", cityname);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"city.cityname == %@", [PersistenceHelper dataForKey:kCityName]];
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:kAppDelegate.managedObjectContext sectionNameKeyPath:@"sectionkey"
                                                   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.contactTableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.contactTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(ContactCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.contactTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.contactTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.contactTableView endUpdates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
