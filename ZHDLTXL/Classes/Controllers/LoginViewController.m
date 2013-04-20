//
//  LoginViewController.m
//  ZXCXBlyt
//
//  Created by zly on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "CustomAlertView.h"
#import "UIAlertView+MKBlockAdditions.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize autoLoginButton;
@synthesize mTableView;
@synthesize isAutoLogin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"登录";
    }
    return self;
}

- (void)registSucceedAction {
    [self.navigationController popViewControllerAnimated:NO];
//    [kAppDelegate loginFinishedWithAnimation:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isAutoLogin = YES; //永远自动登陆
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registSucceedAction) name:kRegistSucceed object:nil];
    self.view.backgroundColor = bgGreyColor;
    self.mTableView.backgroundColor = bgGreyColor;
    [Utility addShadow:self.navigationController.navigationBar];
    
    
    //back button
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    UIBarButtonItem *button2 = [[[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"忘记密码"] style:UIBarButtonItemStyleBordered target:self action:@selector(forgotPasswordAction:)] autorelease];
    self.navigationController.navigationBar.tintColor = RGBCOLOR(98, 148, 193);
    self.navigationItem.rightBarButtonItem = button2;
    
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setMTableView:nil];
    [self setAutoLoginButton:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRegistSucceed object:nil];
    [mTableView release];
    [autoLoginButton release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (void)configureCell:(ELCTextfieldCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        userName = cell.rightTextField;
        cell.leftLabel.text = @"用户名";
        cell.rightTextField.placeholder = @"请输入用户名";
    } 
    
    if (indexPath.row == 1) {
        password = cell.rightTextField;
        cell.leftLabel.text = @"密码";
        cell.rightTextField.placeholder = @"请输入密码";
        cell.rightTextField.secureTextEntry = YES;
    }
    cell.isEditable = YES;
    cell.indexPath = indexPath;
    cell.ELCDelegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"ELCCell";
    ELCTextfieldCell *cell = (ELCTextfieldCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[[ELCTextfieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    if (indexPath.row == 0) {
//        [cell.rightTextField becomeFirstResponder];
    }
            
    return cell;
}

- (IBAction)autoLoginAction:(id)sender {
//    isAutoLogin = !isAutoLogin;
}

- (IBAction)loginAction:(id)sender {
    
    NSString *name = [userName.text removeSpace];
    if (![name isValid]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了" 
                                                        message:@"请输入有效的用户名" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"知道了" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }

    NSString *pwd = [password.text removeSpace];
    if (![pwd isValid]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了" 
                                                        message:@"请输入有效的密码" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"知道了" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在登录";
    [userName resignFirstResponder];
    [password resignFirstResponder];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"zslogin.json", @"path",
                                                                    name, @"commusername",
                                                                    pwd, @"passwd",
                                                                    kAppDelegate.uuid, @"uuid", nil];
    
    
    NSLog(@"login dict: %@", dict);
    
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];

        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            NSString *userId = [[json objForKey:@"Userid"] stringValue];
            [kAppDelegate setUserId:userId];
            [PersistenceHelper setData:userId forKey:kUserId];
            [PersistenceHelper setData:name forKey:KUserName];
            [PersistenceHelper setData:pwd forKey:KPassWord];
            
            [self backToRootVC:nil];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (IBAction)registAction:(id)sender {
    RegistViewController *regist = [[[RegistViewController alloc] initWithNibName:@"RegistViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:regist animated:YES];
}

- (IBAction)forgotPasswordAction:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"忘记密码提示"
                                                    message:@"请电话联系客服:010-84641808或登录宝来药通官网(www.baolaitong.com)进行修改"
                                                   delegate:nil 
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"知道了", nil];
    [alert show];
    [alert release];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确认"]) {
        NSString *text = [((CustomAlertView *)alertView).textField.text removeSpace];
        if ([text isValid]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"正在发送请求";

            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"getPass.json", @"path", text, @"commusername", nil];
            [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
                    [kAppDelegate showWithCustomAlertViewWithText:@"密码激活联接已发送至您的邮箱中，请查收" andImageName:nil];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
            }];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了" message:@"您输入的用户名或者宝通号不合法，请重新输入" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            alert.tag = 200;
            [alert show];
            [alert release];
        }
    }
}

@end
