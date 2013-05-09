//
//  GroupSendViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-5-5.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "GroupSendViewController.h"
#import "ContactCell.h"
#import "AllContact.h"
#import "DES3Util.h"

@interface GroupSendViewController ()

@end

@implementation GroupSendViewController

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
    self.hidesBottomBarWhenPushed = YES;
    self.title = @"短信群发";
    self.contactArray = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
    
    self.page = 0;
    
    [self initNavBar];
    [self getAllContactFromDB];
    
}

- (void)initNavBar
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    button.showsTouchWhenHighlighted = YES;
    [button setImage:[UIImage imageByName:@"retreat.png"] forState:UIControlStateNormal];
    UIBarButtonItem *button1 = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    self.navigationItem.leftBarButtonItem = button1;
    
    UIButton *rButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rButton.frame = CGRectMake(0, 0, 80, 30);
    [rButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [rButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"确认";
    [rButton addSubview:label];
    
    
    UIBarButtonItem *rBarButton = [[[UIBarButtonItem alloc] initWithCustomView:rButton] autorelease];
    self.navigationItem.rightBarButtonItem = rBarButton;
}

- (void)confirm:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(finishSelectGroupPeople:)]) {
        [self.delegate performSelector:@selector(finishSelectGroupPeople:) withObject:self.selectArray];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getAllContactFromDB
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"cityid == %@ AND loginid == %@", [PersistenceHelper dataForKey:kCityId], kAppDelegate.userId];
    NSArray *contactArray = [AllContact findAllWithPredicate:pred];
    if (contactArray.count > 0) {
        self.page = ceil(((CGFloat)contactArray.count / 50));
        [self.contactArray addObjectsFromArray:contactArray];
        [self.tableView reloadData];
        [self createTableFooter];
    }
    else{
        //        [self getUserCount];
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
    
    MBProgressHUD *hub = nil;
    //    if (self.page == 1) {
    hub = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hub.labelText = @"获取商家列表";
    //    }
    
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            
            
            NSArray *jsonArray = [self deCryptJsonDict:json OfJsonKey:@"InvestmentUserList"];
            //            [self.mTableView reloadData];
            
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
                //                NSLog(@"idx %d username %@, sectionkey %@", idx, contact.username, contact.sectionkey);
                [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
            }];
            
            
            
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            [self loadDataEnd];
            [self.tableView reloadData];
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

- (NSArray *)deCryptJsonDict:(NSDictionary *)dict OfJsonKey:(NSString *)jsonKey
{
    NSString *jsonEncryptStr = [[dict objForKey:jsonKey] removeSpace];
    NSString *userid = [kAppDelegate userId];
    NSMutableString *key = [NSMutableString stringWithString:[kBaseKey substringToIndex:24-userid.length]];
    [key appendFormat:@"%@", userid];
    NSArray *jsonArray = [[DES3Util decrypt:jsonEncryptStr withKey:key] objectFromJSONString];
    return jsonArray;
}

// 创建表格底部
- (void) createTableFooter
{
    self.tableView.tableFooterView = nil;
    UIView *tableFooterView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 40.0f)] autorelease];
    UILabel *loadMoreText = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 116.0f, 40.0f)] autorelease];
    [loadMoreText setCenter:tableFooterView.center];
    [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    [loadMoreText setText:@"上拉显示更多数据"];
    [tableFooterView addSubview:loadMoreText];
    
    self.tableView.tableFooterView = tableFooterView;
}

#pragma mark - table view 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contactArray.count;
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
    AllContact *userDetail = [self.contactArray objectAtIndex:indexPath.row];
    cell.headIcon.layer.cornerRadius = 4;
    cell.headIcon.layer.masksToBounds = YES;
    [cell.headIcon setImageWithURL:[NSURL URLWithString:userDetail.picturelinkurl] placeholderImage:[UIImage imageByName:@"AC_talk_icon.png"]];
    cell.nameLabel.text = userDetail.username;
    
    if ([self.selectArray containsObject:userDetail]) {
        cell.unSelectedImage.image = [UIImage imageNamed:@"selected.png"];
    }
    else{
        cell.unSelectedImage.image = [UIImage imageNamed:@"unselected.png"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllContact *contact = [self.contactArray objectAtIndex:indexPath.row];
    if ([self.selectArray containsObject:contact]) {
        [self.selectArray removeObject:contact];
    }
    else{
        [self.selectArray addObject:contact];
    }
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.f;
}

#pragma mark - load method
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 下拉到最底部时显示更多数据
    if(!self.reloading && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height)+20))
    {
        [self loadDataBegin];
    }
}

// 开始加载数据
- (void)loadDataBegin
{
    if (self.reloading == NO)
    {
        self.reloading = YES;
        UIActivityIndicatorView *tableFooterActivityIndicator = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(75.0f, 10.0f, 20.0f, 20.0f)] autorelease];
        [tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [tableFooterActivityIndicator startAnimating];
        [self.tableView.tableFooterView addSubview:tableFooterActivityIndicator];
        
        [self getInvestmentUserListFromServer];
    }
}

// 加载数据完毕
- (void)loadDataEnd
{
    self.reloading = NO;
    //    [self showLoadNum];
    
    [self createTableFooter];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
