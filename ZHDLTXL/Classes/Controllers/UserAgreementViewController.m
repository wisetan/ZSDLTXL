//
//  UserAgreementViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-5-5.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "UserAgreementViewController.h"

@interface UserAgreementViewController ()

@end

@implementation UserAgreementViewController

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
    self.title = @"用户协议";
    self.hidesBottomBarWhenPushed = YES;
    
    UIButton *backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [backBarButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    
    NSURL *url = [NSURL URLWithString:[@"http://www.boracloud.com:9101/BLZTCloud/wap/agreement.jsp" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSURLRequest requestWithURL:url];
    request.timeoutInterval = 15.f;
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    
}

#pragma mark - web view delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
}

- (void)backAction
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_webView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
