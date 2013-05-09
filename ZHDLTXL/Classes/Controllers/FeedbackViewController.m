//
//  FeedbackViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-5-2.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "FeedbackViewController.h"

#define PLACE_HOLDER @"请输入您的宝贵意见"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

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
    self.title = @"反馈";
    self.hidesBottomBarWhenPushed = YES;
    
    self.textView.text = PLACE_HOLDER;
    self.textView.textColor = [UIColor lightGrayColor];
    
    [self initNavigationBar];
}

- (void)initNavigationBar {
    //left item
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
    [rButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    [rButton addTarget:self action:@selector(issue:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"发表";
    [rButton addSubview:label];
    
    
    UIBarButtonItem *rBarButton = [[[UIBarButtonItem alloc] initWithCustomView:rButton] autorelease];
    self.navigationItem.rightBarButtonItem = rBarButton;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)issue:(UIButton *)sender
{
    [self.view endEditing:YES];
    NSString *content = self.textView.text;
    if ([content isEqualToString:PLACE_HOLDER]) {
        content = @"";
    }
    
    NSDictionary *paraDict = @{@"userid": kAppDelegate.userId,
                               @"content": content,
                               @"uuid": kAppDelegate.uuid,
                               @"path": @"addfeedback.json"};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:@"发表成功" andImageName:nil];
            
        }
        else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
        double delayInSeconds = .3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self backAction];
        });
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        double delayInSeconds = .3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self backAction];
        });
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - text view delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    if (!IS_IPHONE_5) {
        
        CGRect frame = self.view.frame;
        frame.origin.y -= 20;
        [UIView animateWithDuration:.3f animations:^{
            self.view.frame = frame;
        }];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (!IS_IPHONE_5) {
        [UIView animateWithDuration:0.3f animations:^{
            self.view.frame = CGRectMake(0, 0, [kAppDelegate window].frame.size.width, [kAppDelegate window].frame.size.height-64);
        }];
    }
    if (textView.text.length == 0) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = PLACE_HOLDER;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_textBgImage release];
    [_textView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTextBgImage:nil];
    [self setTextView:nil];
    [super viewDidUnload];
}
@end
