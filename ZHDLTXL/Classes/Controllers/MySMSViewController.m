//
//  MyInfoViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-5-3.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "MySMSViewController.h"
#import "MyMessageListCell.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "SMSTalkViewController.h"
#import "SMSList.h"

@interface MySMSViewController ()

@end

@implementation MySMSViewController

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
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的短信";
    self.hidesBottomBarWhenPushed = YES;
    self.SMSChatListArray = [[[NSMutableArray alloc] init] autorelease];
    self.page = 0;
    self.maxrow = 5;
    self.shouldClearDB = YES;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self getSMSChatListFromServer];
    }];
    
    [self getSMSChatListFromServer];
    [self initNavBar];
    
}

- (void)initNavBar
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 30, 30);
    [backButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    self.navigationItem.leftBarButtonItem = lBarButton;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getSMSChatListFromDB
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"loginid == %@", kAppDelegate.userId];
    NSArray *SMSChatListTmp = [SMSList findAllSortedBy:@"createtime" ascending:NO withPredicate:pred];
    [self.SMSChatListArray addObjectsFromArray:SMSChatListTmp];
    [self.tableView reloadData];
}

- (void)getSMSChatListFromServer
{
    // getMessageZsPeople.json userid page maxrow
    NSString *page = [NSString stringWithFormat:@"%d", self.page];
    NSString *maxrow = [NSString stringWithFormat:@"%d", self.maxrow];
    NSDictionary *paraDict = @{@"path": @"getSMSPeopers.json",
                               @"userid": kAppDelegate.userId,
                               @"page": page,
                               @"maxrow": maxrow};
    
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hud.labelText = @"获取短信列表";
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        if ([[[json objectForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            //clear DB
            if (self.shouldClearDB) {
                self.shouldClearDB = NO;
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"loginid == %@", kAppDelegate.userId];
                [SMSList deleteAllMatchingPredicate:pred];
                [self.SMSChatListArray removeAllObjects];
                DB_SAVE();
            }
            
            
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            NSLog(@"SMSChatList json %@", json);
            NSArray *array = [json objForKey:@"MessagePeoperList"];
            [array enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {

                SMSList *SMSChatList = [SMSList createEntity];
                SMSChatList.content = [dict objForKey:@"content"];
                SMSChatList.count = [[dict objForKey:@"count"] stringValue];
//                NSString *date = [NSString stringWithFormat:@"%f", [self getTheSecondOfDate:[dict objForKey:@"createtime"]]];
                SMSChatList.createtime = [dict objForKey:@"createtime"];
                SMSChatList.picturelinkurl = [dict objForKey:@"picturelinkurl"];
                SMSChatList.tel = [dict objForKey:@"tel"];
                SMSChatList.type = [dict objForKey:@"type"];
                SMSChatList.userid = [[dict objForKey:@"userid"] stringValue];
                SMSChatList.username = [dict objForKey:@"username"];
                SMSChatList.loginid = kAppDelegate.userId;
//                [self.SMSChatListArray insertObject:SMSChatList atIndex:0];
                [self.SMSChatListArray addObject:SMSChatList];
                
                DB_SAVE();

            }];
            
            if (array.count > 0) {
                self.page++;
            }
            
            NSLog(@"page %d", self.page);
            
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
        }
        else{
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
            [self.tableView.pullToRefreshView stopAnimating];
            [self getSMSChatListFromDB];
        }
    } failure:^(NSError *error) {
        [self.tableView.pullToRefreshView stopAnimating];
        [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        [self getSMSChatListFromDB];
    }];
    
}

- (NSTimeInterval)getTheSecondOfDate:(NSString *)date
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSTimeInterval sec = [[dateFormatter dateFromString:date] timeIntervalSince1970];
    return sec;
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.SMSChatListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"myMessageListCell";
    MyMessageListCell *cell = (MyMessageListCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyMessageListCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (void)configureCell:(MyMessageListCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    SMSList *SMSChatList = [self.SMSChatListArray objectAtIndex:indexPath.row];
    
    cell.headIcon.layer.cornerRadius = 4;
    cell.headIcon.layer.masksToBounds = YES;
    [cell.headIcon setImageWithURL:[NSURL URLWithString:SMSChatList.picturelinkurl] placeholderImage:[UIImage imageNamed:@"AC_L_icon.png"]];
    cell.nameLabel.text = SMSChatList.username;
    cell.subjectLabel.text = SMSChatList.content;
    cell.dateLabel.text = SMSChatList.createtime;
    if ([SMSChatList.count isEqualToString:@"0"] || ![SMSChatList.count isValid]) {
        cell.unreadCountLabel.hidden = YES;
        cell.unreadCountBg.hidden = YES;
    }
    else{
        cell.unreadCountLabel.text = SMSChatList.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMSTalkViewController *smstalkVC = [[SMSTalkViewController alloc] init];
    SMSList *smsList = [self.SMSChatListArray objectAtIndex:indexPath.row];
    smstalkVC.fid = smsList.userid;
    smstalkVC.fAvatarUrl = smsList.picturelinkurl;
    if ([smsList.count intValue] == 0) {
        smstalkVC.hasNewSmsRecord = NO;
    }
    else{
        smstalkVC.hasNewSmsRecord = YES;
    }
    
    smstalkVC.smsList = smsList;
    [self.navigationController pushViewController:smstalkVC animated:YES];
    [smstalkVC release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
