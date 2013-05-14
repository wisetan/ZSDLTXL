//
//  SettingViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-15.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "SettingViewController.h"
#import "MenuCell.h"
#import "LoginViewController.h"
#import "MAlertView.h"
#import "FeedbackViewController.h"
#import "AboutViewController.h"
#import "MyInfo.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

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
    
    self.title = @"设置";
    self.hidesBottomBarWhenPushed = YES;
    
    //back button
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    
    UIImage *tableBgImage = [UIImage imageByName:@"setting_bg.png"];
    UIImageView *tableBgImageView = [[[UIImageView alloc] initWithImage:tableBgImage] autorelease];
    tableBgImageView.userInteractionEnabled = YES;
    tableBgImageView.frame = CGRectMake(18, 20, 283, 253);
    [self.view addSubview:tableBgImageView];
    
    
    self.menuTableView = [[[UITableView alloc] initWithFrame:CGRectMake(20, 21, 280, 250) style:UITableViewStylePlain] autorelease];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.scrollEnabled = NO;
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.menuTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.menuTableView];
    
    self.menuNameArray = [[[NSMutableArray alloc] initWithObjects:@"注销登录", @"修改密码", @"意见反馈", @"新手引导", @"关于", nil] autorelease];
    self.selectorNameArray = [[[NSMutableArray alloc] initWithObjects:@"logoff", @"modifyPassword", @"feedback", @"newcomer", @"about", nil] autorelease];
    
    self.selectorArray = [[[NSMutableArray alloc] init] autorelease];
    [self.selectorNameArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.selectorArray addObject:[NSValue valueWithPointer:NSSelectorFromString([self.selectorNameArray objectAtIndex:idx])]];
    }];
    
    
    
}

#pragma mark - table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuNameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"menuCell";
    MenuCell *menuCell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (menuCell == nil) {
        menuCell = [[[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil] lastObject];
    }
    [menuCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    menuCell.nameLabel.text = [self.menuNameArray objectAtIndex:indexPath.row];
    menuCell.nameLabel.textColor = kContentColor;
    if (indexPath.row == self.menuNameArray.count-1) {
        menuCell.separatorImage.image = nil;
    }
    return menuCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:[[self.selectorArray objectAtIndex:indexPath.row] pointerValue]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)logoff
{
    NSLog(@"registAndLogin");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否确认退出" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = 2001;
    [alert show];
    [alert release];
}

- (void)modifyPassword
{
    NSLog(@"modifyPassword");
    self.oldPwdField = [[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 45)] autorelease];
    self.oldPwdField.secureTextEntry = YES;
    self.theNewPwdField = [[[UITextField alloc] initWithFrame:CGRectMake(0, 45, 200, 45)] autorelease];
    self.theNewPwdField.secureTextEntry = YES;
    self.reNewPwdField = [[[UITextField alloc] initWithFrame:CGRectMake(0, 90, 200, 45)] autorelease];
    self.reNewPwdField.secureTextEntry = YES;
    
    MAlertView *alert = [[MAlertView alloc] initWithTitle:@"修改密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
    alert.tag = 1001;
    [alert addTextField:self.oldPwdField placeHolder:@"旧密码"];
    [alert addTextField:self.theNewPwdField placeHolder:@"新密码"];
    [alert addTextField:self.reNewPwdField placeHolder:@"重复新密码"];
    [alert show];
    [alert release];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            NSString *oldPwd = self.oldPwdField.text;
            NSString *newPwd = self.theNewPwdField.text;
            NSString *reNewPwd = self.reNewPwdField.text;
            
            if (![oldPwd isValid] || ![newPwd isValid] || ![reNewPwd isValid]) {
                [kAppDelegate showWithCustomAlertViewWithText:@"密码无效" andImageName:nil];
                return;
            }
            
            if (newPwd.length < 6) {
                [kAppDelegate showWithCustomAlertViewWithText:@"密码长度必须大于6位" andImageName:nil];
                return;
            }
            
            if (![newPwd isEqualToString:reNewPwd]) {
                [kAppDelegate showWithCustomAlertViewWithText:@"两次输入的密码不同" andImageName:nil];
                return;
            }
            
            //userid mail tel name path
            NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:kAppDelegate.userId, @"userid", newPwd, @"newpasswd", oldPwd, @"oldpasswd", @"changeZsUserPassword.json", @"path", nil];
            [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
            [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
                if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
                    [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
                    
                    [PersistenceHelper setData:newPwd forKey:KPassWord];
                    [kAppDelegate showWithCustomAlertViewWithText:@"修改成功" andImageName:nil];
                    
                }
                else{
                    [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
                    [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
                }
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
                [kAppDelegate showWithCustomAlertViewWithText:@"更新失败" andImageName:nil];
            }];
        }
        else{
            return;
        }
    }
    else if (alertView.tag == 2001){
        if (buttonIndex == 1) {
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"userDetail.userid == %@", kAppDelegate.userId];
            MyInfo *myInfo = [MyInfo findFirstWithPredicate:pred];
            [myInfo deleteEntity];
            //    DB_SAVE();
            
            
            [PersistenceHelper setData:@"" forKey:KUserName];
            [PersistenceHelper setData:@"" forKey:kUserId];
            [PersistenceHelper setData:@"" forKey:KPassWord];
            
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
            [loginVC release];
        }
    }
    
}

- (void)feedback
{
    NSLog(@"feedback");
    FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
    [self.navigationController pushViewController:feedbackVC animated:YES];
    [feedbackVC release];
}

- (void)newcomer
{
    NSLog(@"newcomer");
}

- (void)about
{
    NSLog(@"about");
    AboutViewController *aboutVC = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:aboutVC animated:YES];
    [aboutVC release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
