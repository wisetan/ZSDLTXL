//
//  MyInfoViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-5-3.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyMessageListCell.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "TalkViewController.h"

@interface MyInfoViewController ()

@end

@implementation MyInfoViewController

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
    
    
    self.title = @"留言板";
    self.hidesBottomBarWhenPushed = YES;
    self.chatListArray = [[[NSMutableArray alloc] init] autorelease];
    self.page = 0;
    self.maxrow = 5;
    self.shouldClearDB = YES;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self getChatListFromServer];
    }];
    
    [self getChatListFromServer];
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

- (void)getChatListFromDB
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"loginid == %@", kAppDelegate.userId];
    NSArray *chatListTmp = [ChatList findAllSortedBy:@"createtime" ascending:NO withPredicate:pred];
    [self.chatListArray addObjectsFromArray:chatListTmp];
    [self.tableView reloadData];
}

- (void)getChatListFromServer
{
    // getMessageZsPeople.json userid page maxrow
    NSString *page = [NSString stringWithFormat:@"%d", self.page];
    NSString *maxrow = [NSString stringWithFormat:@"%d", self.maxrow];
    NSDictionary *paraDict = @{@"path": @"getMessageZsPeople.json",
                               @"userid": kAppDelegate.userId,
                               @"page": page,
                               @"maxrow": maxrow};
    
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hud.labelText = @"获取最新聊天内容";
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        if ([[[json objectForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            //clear DB
            if (self.shouldClearDB) {
                self.shouldClearDB = NO;
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"loginid == %@", kAppDelegate.userId];
                [ChatList deleteAllMatchingPredicate:pred];
                [self.chatListArray removeAllObjects];
                DB_SAVE();
            }
            
            
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            NSLog(@"chatlist json %@", json);
//            NSArray *array = [[[json objForKey:@"MessagePeoperList"] reverseObjectEnumerator] allObjects];
            NSArray *array = [json objForKey:@"MessagePeoperList"];
            [array enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {

                ChatList *chatList = [ChatList createEntity];
                chatList.content = [dict objForKey:@"content"];
                chatList.count = [[dict objForKey:@"count"] stringValue];
                NSString *date = [NSString stringWithFormat:@"%.lf", [self getTheSecondOfDate:[dict objForKey:@"createtime"]]];
                chatList.createtime = date;
                NSLog(@"create time %@", [dict objForKey:@"createtime"]);
                chatList.picturelinkurl = [dict objForKey:@"picturelinkurl"];
                chatList.tel = [dict objForKey:@"tel"];
                chatList.type = [dict objForKey:@"type"];
                chatList.userid = [[dict objForKey:@"userid"] stringValue];
                chatList.username = [dict objForKey:@"username"];
                chatList.loginid = kAppDelegate.userId;
//                [self.chatListArray insertObject:chatList atIndex:0];
                [self.chatListArray addObject:chatList];
                
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
            [self getChatListFromDB];
        }
    } failure:^(NSError *error) {
        [self.tableView.pullToRefreshView stopAnimating];
        [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        [self getChatListFromDB];
    }];
    
}

- (NSTimeInterval)getTheSecondOfDate:(NSString *)date
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSTimeInterval sec = [[dateFormatter dateFromString:date] timeIntervalSince1970];
    return sec;
}

- (NSString *)getHumanDateFromSecond:(NSTimeInterval)second
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    return [dateFormatter stringFromDate:date];
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.chatListArray count];
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
//    ChatList *chatList = [self.chatListArray objectAtIndex:indexPath.row];
    ChatList *chatList = [self.chatListArray objectAtIndex:self.chatListArray.count - indexPath.row - 1];
    
    cell.headIcon.layer.cornerRadius = 4;
    cell.headIcon.layer.masksToBounds = YES;
    [cell.headIcon setImageWithURL:[NSURL URLWithString:chatList.picturelinkurl] placeholderImage:[UIImage imageNamed:@"AC_L_icon.png"]];
    cell.nameLabel.text = chatList.username;
    cell.subjectLabel.text = chatList.content;
    cell.dateLabel.text = [self getHumanDateFromSecond:chatList.createtime.doubleValue];
    if ([chatList.count isEqualToString:@"0"] || ![chatList.count isValid]) {
        cell.unreadCountLabel.hidden = YES;
        cell.unreadCountBg.hidden = YES;
    }
    else{
        cell.unreadCountLabel.text = chatList.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TalkViewController *talkVC = [[TalkViewController alloc] init];
    ChatList *chatList = [self.chatListArray objectAtIndex:indexPath.row];
    talkVC.fid = chatList.userid;
    talkVC.fAvatarUrl = chatList.picturelinkurl;
    talkVC.chatList = chatList;
    [self.navigationController pushViewController:talkVC animated:YES];
    [talkVC release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
