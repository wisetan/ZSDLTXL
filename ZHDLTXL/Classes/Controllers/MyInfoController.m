//
//  MyInfoController.m
//  ZXCXBlyt
//
//  Created by zly on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyInfoController.h"
//#import "OthersProfileViewController.h"
#import "TalkViewController.h"
#import "UIAlertView+MKBlockAdditions.h"

@interface MyInfoController ()

@end

@implementation MyInfoController
@synthesize mCompanyDict;
@synthesize delegate;
- (void)dealloc
{
    self.mCompanyDict = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"我的消息";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageByName:@"bg_mask"]];

    self.tableView.frame = CGRectMake(0, 0, 320, 460-44);
   
    [self initNavigationBar];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self sendUpdateRequestForce:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshAction];
}

- (void)initNavigationBar {    
    //left item
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    button.showsTouchWhenHighlighted = YES;
    [button setImage:[UIImage imageByName:@"retreat.png"] forState:UIControlStateNormal];
    UIBarButtonItem *button1 = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    self.navigationItem.leftBarButtonItem = button1;
}


- (void)refreshAction {
    [self sendUpdateRequestForce:YES];
}

- (void)backAction {
    if ([delegate respondsToSelector:@selector(refreshAction)]) {
        [delegate refreshAction];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (NSDictionary *)urlDictForRefresh {  
    NSString *myUid = [PersistenceHelper dataForKey:kUserId];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"getMessagePeopers.json" forKey:@"path"];
    [dict setValue:myUid forKey:@"userid"];
    [dict setValue:[NSString stringWithFormat:@"%d", currentPage] forKey:@"page"];
    [dict setValue:kDefaultPageSizeString forKey:@"maxrow"];
    
    return dict;
}

- (NSString *)stringForParseJson {
    return @"MessagePeoperList";
}

- (void)agreeWithDict:(NSDictionary *)companyDict {
    if (companyDict) {
        NSString *companyName = [companyDict objForKey:@"username"];
        NSString *userId = [PersistenceHelper dataForKey:kUserId];
        NSString *companyId = [companyDict objForKey:@"userid"];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"comfirmCompanyUserlink.json", @"path", userId, @"userid", companyId, @"companyid", companyName, @"companyname", nil];
        [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
            if (![GET_RETURNCODE(json) isEqualToString:@"0"]) {
                [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
            } else {
                [kAppDelegate showWithCustomAlertViewWithText:@"添加成功" andImageName:nil];
            }
        } failure:^(NSError *error) {
            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        }];
    }
}

- (void)disAgreeWithDict:(NSDictionary *)companyDict {
    if (companyDict) {
        NSString *userId = [PersistenceHelper dataForKey:kUserId];
        NSString *companyId = [companyDict objForKey:@"userid"];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"delCompanyUserlink.json", @"path", userId, @"userid", companyId, @"companyid", nil];
        [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
            if (![GET_RETURNCODE(json) isEqualToString:@"0"]) {
                [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
            }
        } failure:^(NSError *error) {
            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        }];
    }
}

- (void)updateDidFinishedWithKey:(NSString *)key {
    //如果有则移除企业添加员工的数据源
    NSMutableArray *delArray = [NSMutableArray array];    
    for (NSDictionary *dict in self.dataSourceArray) {
        if ([dict isKindOfClass:[NSDictionary class]] && [[dict objForKey:@"type"] isValid] && [[dict objForKey:@"type"] isEqualToString:@"1"]) {
            [delArray addObject:dict];
            self.mCompanyDict = dict;
            [UIAlertView alertViewWithTitle:@"通知"
                                    message:[dict objForKey:@"content"]
                          cancelButtonTitle:@"拒绝" 
                          otherButtonTitles:[NSArray arrayWithObject:@"同意"] 
                                  onDismiss:^(int buttonIndex) {
                                      [self agreeWithDict:self.mCompanyDict];
                                  } 
                                   onCancel:^{
                                       [self disAgreeWithDict:self.mCompanyDict];
                                   }];
        }
    }
    [self.dataSourceArray removeObjectsInArray:delArray];
}

- (UIViewController *)tableView:(UITableView *)_tableView pushRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    TalkViewController *talk = [[[TalkViewController alloc] initWithNibName:@"TalkViewController" bundle:nil] autorelease];
    talk.fid = [dict objForKey:@"userid"];
    NSString *avatarUrl = [dict objForKey:@"picturelinkurl"];
    talk.fAvatarUrl = avatarUrl;
    return talk;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![[self.dataSourceArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]) {
        return 44;
    }
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtNotLastIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellId = @"MyInfoCell";
    
    MyInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellId];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyInfoCell" owner:self options:nil];
        cell = (MyInfoCell *)[nib objectAtIndex:0];
        cell.avatar.placeholderImage = [UIImage imageByName:@"default_avatar"];
        [Utility plainTableView:_tableView changeBgForCell:cell atIndexPath:indexPath];
    }
    
    cell.indexPath = indexPath;
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)theCell atNotLastIndexPath:(NSIndexPath *)indexPath {
    @try {
        NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
        MyInfoCell *cell = (MyInfoCell *)theCell;
        NSString *url = [dict objForKey:@"picturelinkurl"];
        cell.avatar.imageURL = [url isValid] ? [NSURL URLWithString:url] : nil;
        
        cell.labName.text = [[dict objForKey:@"username"] stringValue];
        cell.labSubTitle.text = [[dict objForKey:@"content"] stringValue];
        cell.labTime.text = [[dict objForKey:@"createtime"] stringValue];
        cell.labInfoCount.text = [[dict objForKey:@"count"] stringValue];
        
        if (![cell.labInfoCount.text isValid]) {
            cell.labInfoCount.hidden = YES;
            cell.bgInfoCount.hidden  = YES;
        } else {
            cell.labInfoCount.hidden = NO;
            cell.bgInfoCount.hidden  = NO;
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
    }
    @catch (NSException *exception) {
        
    }
}

- (void)myInfoCell:(MyInfoCell *)cell clickAvatarAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    
//    OthersProfileViewController *otherProfile = [[[OthersProfileViewController alloc] initWithUserId:urerId userName:userName] autorelease];
//    
//    [self.navigationController pushViewController:otherProfile animated:YES];
}

@end
