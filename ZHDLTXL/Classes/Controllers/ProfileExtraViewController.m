//
//  ProfileExtraViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-5-7.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "ProfileExtraViewController.h"
#import "ProfileExtraInfo.h"

@interface ProfileExtraViewController ()

@end

@implementation ProfileExtraViewController

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
    self.title = @"账户余额";
    self.hidesBottomBarWhenPushed = YES;
    
    self.profileExtraInfoArray = [NSMutableArray array];
    
    [self initNavBar];
    [self getAccoutExtraFromNet];
}

- (void)initNavBar
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    self.navigationItem.leftBarButtonItem = lBarButton;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getAccoutExtraFromNet
{
    NSDictionary *paraDict = @{@"path": @"getPurchaseInfoForTel.json", @"userid": kAppDelegate.userId};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if ([GET_RETURNCODE(json) isEqualToString:@"0"]) {
            NSLog(@"accout extra json %@", json);
            NSArray *dataList = [json objForKey:@"DataList"];
            [dataList enumerateObjectsUsingBlock:^(NSDictionary *infoDict, NSUInteger idx, BOOL *stop) {
                ProfileExtraInfo *info = [[[ProfileExtraInfo alloc] init] autorelease];
                info.balance = [[infoDict objForKey:@"balance"] stringValue];
                info.createtime = [infoDict objForKey:@"createtime"];
                info.infoId = [[infoDict objForKey:@"id"] stringValue];
                info.income = [[infoDict objForKey:@"income"] stringValue];
                info.outcome = [[infoDict objForKey:@"outcome"] stringValue];
                info.remark = [infoDict objForKey:@"remark"];
                info.userid = [[infoDict objForKey:@"userid"] stringValue];
                [self.profileExtraInfoArray addObject:info];
            }];
            
            NSString *balance = [[self.profileExtraInfoArray lastObject] balance];
            self.accountExtraLabel.text = balance;
            
            CGSize size = [balance sizeWithFont:[UIFont systemFontOfSize:40]];
            CGPoint center = self.accountExtraLabel.center;
            self.accountExtraLabel.frame = CGRectMake(0, 0, size.width, size.height);
            self.accountExtraLabel.center = center;
            
            CGRect accoutFrame = self.accountExtraLabel.frame;
            CGRect tiaoFrame = self.tiaoLabel.frame;
            self.tiaoLabel.frame = CGRectMake(accoutFrame.origin.x+accoutFrame.size.width+2, tiaoFrame.origin.y, tiaoFrame.size.width, tiaoFrame.size.height);
            
            [self.tableView reloadData];
            
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.profileExtraInfoArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = [[self.profileExtraInfoArray objectAtIndex:indexPath.row] createtime];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    cell.detailTextLabel.text = [[self.profileExtraInfoArray objectAtIndex:indexPath.row] remark];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_accountExtraLabel release];
    [_tableView release];
    [_tiaoLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setAccountExtraLabel:nil];
    [self setTableView:nil];
    [self setTiaoLabel:nil];
    [super viewDidUnload];
}
@end
