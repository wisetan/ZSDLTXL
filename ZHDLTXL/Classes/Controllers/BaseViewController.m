//
//  BaseViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-26.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "BaseViewController.h"
#import "ContactCell.h"
#import "OtherHomepageViewController.h"
#import "MyHomePageViewController.h"
#import "LoginViewController.h"
#import "ProvinceViewController.h"
#import "SVPullToRefresh.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize mTableView = _mTableView;

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
    [super viewWillAppear:animated];
    
    if ([self isLogined]) {
        self.loginLabel.text = @"主页";
    }
    else{
        self.loginLabel.text = @"登录";
    }
    
    self.areaLabel.text = [PersistenceHelper dataForKey:kCityName];
    
//    NSError *error = nil;
//    
//    _fetchedResultsController = nil;
//    if (![self.fetchedResultsController performFetch:&error]) {
//        NSLog(@"error %@", error);
//    }
//    
//    if (self.fetchedResultsController.fetchedObjects.count == 0) {
//        [self getInvestmentUserListFromServer];
//    }
//    
//    [self.mTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topmargin.png"] forBarMetrics:UIBarMetricsDefault];
    
    //login button
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [loginButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    
    loginButton.frame = CGRectMake(5, 5, 80, 34);
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 80.f, 34.f)] autorelease];
    
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.loginLabel setFont:[UIFont systemFontOfSize:16]];
    self.loginLabel.backgroundColor = [UIColor clearColor];
    self.loginLabel.textColor = [UIColor whiteColor];
    self.loginLabel.textAlignment = NSTextAlignmentCenter;
    [loginButton addSubview:self.loginLabel];
    
    UIBarButtonItem *rBarButton = [[UIBarButtonItem alloc] initWithCustomView:loginButton];
    self.navigationItem.rightBarButtonItem = rBarButton;
    
    //left area barbutton
    UIButton * areaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [areaButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [areaButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    [areaButton addTarget:self action:@selector(selectArea:) forControlEvents:UIControlEventTouchUpInside];
    areaButton.frame = CGRectMake(0, 0, 80, 34);
    self.areaLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 0, 70.f, 34)] autorelease];
    self.areaLabel.text = [PersistenceHelper dataForKey:kCityName];
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
    
    self.mTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44-45)] autorelease];
    [self.mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;

    //    [self.mTableView addInfiniteScrollingWithActionHandler:^{
    //        [self insertDataAtBottom];
    //    }];
    [self.view addSubview:self.mTableView];
    
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

- (void)selectArea:(UIButton *)sender
{
    NSLog(@"select area");
    ProvinceViewController *areaVC = [[ProvinceViewController alloc] init];
    areaVC.isAddResident = NO;
    self.fetchedResultsController = nil;
    [self.navigationController pushViewController:areaVC animated:YES];
    [areaVC release];
}

- (void)tapOnLocationIcon
{
    [self selectArea:nil];
}

#pragma mark - observer method

#pragma mark - table view data source

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    return [self.indexArray count];
    NSLog(@"self.entity %@", self.entityName);
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
    NSLog(@"rows %d", [sectionInfo numberOfObjects]);
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OtherHomepageViewController *otherProfileVC = nil;
    if (IS_IPHONE_5) {
        otherProfileVC = [[OtherHomepageViewController alloc] initWithNibName:@"OtherHomepageViewController_ip5" bundle:nil];
    }
    else{
        otherProfileVC = [[OtherHomepageViewController alloc] initWithNibName:@"OtherHomepageViewController" bundle:nil];
    }
    
    //    NSString *indexKey = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:indexPath.section];
    //    homeVC.contact = [[self.contactDictSortByAlpha objectForKey:indexKey] objectAtIndex:indexPath.row];
    
    otherProfileVC.contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:otherProfileVC animated:YES];
    [otherProfileVC release];
}

#pragma mark - fetch controller

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.mTableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.mTableView;
    
    //    NSLog(@"current = %@, main = %@", [NSThread currentThread], [NSThread mainThread]);
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(ContactCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            //            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
            [self.mTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.mTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    
    [self.mTableView endUpdates];
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

#pragma mark - notification

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSLog(@"self.entityname %@", self.entityName);
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName
                                              inManagedObjectContext:kAppDelegate.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"sectionkey" ascending:YES];
    
    NSSortDescriptor *sort2 = [NSSortDescriptor sortDescriptorWithKey:@"username"
                                                           ascending:YES
                                                            selector:@selector(localizedCaseInsensitiveCompare:)];
    
    [fetchRequest setSortDescriptors:@[sort1, sort2]];
    
    NSLog(@"city id %@", [PersistenceHelper dataForKey:kCityId]);
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"cityid == %@", [PersistenceHelper dataForKey:kCityId]];
    [fetchRequest setPredicate:pred];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:kAppDelegate.managedObjectContext
                                                                      sectionNameKeyPath:@"sectionkey"
                                                                               cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
