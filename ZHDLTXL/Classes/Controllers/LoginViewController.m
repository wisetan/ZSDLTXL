//
//  LoginViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-9.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"

enum textFieldTag
{
    eUsernameTag = 0,
    ePasswordTag = 1,
};

@interface LoginViewController ()

@end

@implementation LoginViewController

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
	self.title = @"登录";
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *lBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.backBarButton];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    UIImage *loginButtonImg = [UIImage imageNamed:@"login_button.png"];
    UIImage *loginButtonImg_p = [UIImage imageNamed:@"login_button_p.png"];
    [self.loginButton setBackgroundImage:loginButtonImg forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:loginButtonImg_p forState:UIControlStateHighlighted];
    UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 232, 52)];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.text = @"登录";
    loginLabel.font = [UIFont systemFontOfSize:14];
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.textAlignment = NSTextAlignmentCenter;
    [self.loginButton addSubview:loginLabel];
    [self.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *regButtonImg = [UIImage imageNamed:@"register_button.png"];
    UIImage *reginButtonImg_p = [UIImage imageNamed:@"register_button_p.png"];
    [self.registButton setBackgroundImage:regButtonImg forState:UIControlStateNormal];
    [self.registButton setBackgroundImage:reginButtonImg_p forState:UIControlStateHighlighted];
    UILabel *registLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 232, 52)];
    registLabel.backgroundColor = [UIColor clearColor];
    registLabel.text = @"注册";
    registLabel.font = [UIFont systemFontOfSize:14];
    registLabel.textColor = [UIColor whiteColor];
    registLabel.textAlignment = NSTextAlignmentCenter;
    [self.registButton addSubview:registLabel];
    [self.registButton addTarget:self action:@selector(regist:) forControlEvents:UIControlEventTouchUpInside];
    
    self.usernameTextfield.tag = eUsernameTag;
    self.passwordTextfield.tag = ePasswordTag;
    
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)login:(UIButton *)sender
{
    if (self.usernameTextfield.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"用户名不能为空" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    else if (self.passwordTextfield.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"密码不能为空" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSLog(@"login");
}

- (void)regist:(UIButton *)sender
{
    NSLog(@"regist");
    RegistViewController *registVC = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:registVC animated:YES];
    [registVC release];
}

#pragma mark - text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"begin edit");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == ePasswordTag) {
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}

#pragma mark - UIView touch method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_loginButton release];
    [_registButton release];
    [_usernameTextfield release];
    [_passwordTextfield release];
    [super dealloc];
}
@end
