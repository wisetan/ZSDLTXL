//
//  MyFriendViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-15.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "MyFriendViewController.h"
#import "ContactCell.h"
#import "Contact.h"
#import "OtherHomepageViewController.h"

@interface MyFriendViewController ()

@end

@implementation MyFriendViewController

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
    
    self.title = @"我的好友";
    [self addObserver];
    
    //back button
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    self.title = @"我的好友";
    
    //contact table view
    self.contactTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44)] autorelease];
    [self.contactTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.contactTableView.delegate = self;
    self.contactTableView.dataSource = self;
    
    [self.view addSubview:self.contactTableView];
    
    //contact dict
    self.contactDictSortByAlpha = [[NSMutableDictionary new] autorelease];
    self.contactArray = [[NSMutableArray new] autorelease];
    
    
    
    [self getMyFriend];
    
}

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeleteFriend:) name:kDeleteFriend object:nil];
}

- (void)didDeleteFriend:(NSNotification *)noti
{
    long userid = [noti.object longValue];
    NSMutableArray *contactArrayTmp = [[NSMutableArray alloc] initWithArray:self.contactArray];
    __block Contact *deleteContact = nil;
    [contactArrayTmp enumerateObjectsUsingBlock:^(Contact *contact, NSUInteger idx, BOOL *stop) {
        if ([contact.userid longLongValue] == userid) {
            deleteContact = contact;
            *stop = YES;
        }
    }];
    [contactArrayTmp removeObject:deleteContact];
    [self friendListRefreshed:contactArrayTmp];
    [contactArrayTmp release];
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getMyFriend
{
    //para dict: getZsAttentionUserByArea.json userid provinceid cityid
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:self.userid, @"userid",
                                                                        self.provinceid, @"provinceid",
                                                                        self.cityid, @"cityid",
                                                                        @"getZsAttentionUserByArea.json", @"path", nil];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hud.labelText = @"获取好友";
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        if ([[json objectForKey:@"returnCode"] longValue] == 0) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            NSArray *friendArrayJson = [json objectForKey:@"DataList"];
            NSMutableArray *friendArray = [[NSMutableArray alloc] init];
            [friendArrayJson enumerateObjectsUsingBlock:^(NSDictionary *contactDict, NSUInteger idx, BOOL *stop) {
                Contact *contact = [Contact new];
                contact.userid = [contactDict objectForKey:@"id"];
                contact.username = [contactDict objForKey:@"username"];
                contact.tel = [contactDict objForKey:@"tel"];
                contact.mailbox = [contactDict objectForKey:@"mailbox"];
                contact.picturelinkurl = [contactDict objectForKey:@"picturelinkurl"];
                contact.col1 = [contactDict objectForKey:@"col1"];
                contact.col2 = [contactDict objectForKey:@"col2"];
                contact.col2 = [contactDict objectForKey:@"col2"];
                [friendArray addObject:contact];
                [contact release];
            }];
            [self friendListRefreshed:friendArray];
            [friendArray release];
        }
        else{
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
    
}

- (void)friendListRefreshed:(NSArray *)friendArray
{
    //    NSLog(@"__func__: %@", noti);
    [self.contactArray removeAllObjects];
    [self.contactArray addObjectsFromArray:friendArray];
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
    }];
    
    [self.contactTableView reloadData];
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
//    homeVC.userName = username;
//    homeVC.contactDict = self.contactDictSortByAlpha;
    homeVC.contact = [[self.contactDictSortByAlpha objectForKey:indexKey] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:homeVC animated:YES];
    [homeVC release];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
