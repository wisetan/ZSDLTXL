//
//  SendMessageViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-10.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "SendMessageViewController.h"
#import "GroupSendViewController.h"
#import "MyInfo.h"
#import "UserDetail.h"



@interface SendMessageViewController ()

@property (nonatomic, assign) CGFloat textViewEditingHeight;
@property (nonatomic, assign) CGFloat textViewHeight;
@property (nonatomic, retain) MyInfo *myInfo;

@end

@implementation SendMessageViewController

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
    self.contactArray = [[NSMutableArray new] autorelease];
    [self.contactArray addObject:self.currentContact];
    
    self.title = @"发送短信";
    
    //nav bar image
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topmargin.png"] forBarMetrics:UIBarMetricsDefault];
    
    //back bar button
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    [self.addButton addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [replyButton setImage:[UIImage imageNamed:@"reply_mail.png"] forState:UIControlStateNormal];
    [replyButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    replyButton.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem *rBarButton = [[[UIBarButtonItem alloc] initWithCustomView:replyButton] autorelease];
    [self.navigationItem setRightBarButtonItem:rBarButton];
    
    
    
    self.nameLabel.text = self.currentContact.username;
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textColor = [UIColor colorWithRed:98.f/255.f green:98.f/255.f blue:98.f/255.f alpha:1.f];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    
    self.textView.text = @"编辑短信";
    self.textView.textColor = [UIColor lightGrayColor];

    
    //add person button

    [self.addButton setImage:[UIImage imageNamed:@"more_select_p.png"] forState:UIControlStateHighlighted];
    [self getMyInfo];
}

- (void)getMyInfo
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userDetail.userid == %@", kAppDelegate.userId];
    self.myInfo = [MyInfo findFirstWithPredicate:pred];
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendMessage:(UIButton *)sender
{
    NSLog(@"send message");
    NSMutableArray *contactArray = [[NSMutableArray alloc] init];
    [self.contactArray enumerateObjectsUsingBlock:^(Contact *contact, NSUInteger idx, BOOL *stop) {
        NSLog(@"tel %@", contact.tel);
        NSNumber *contactId = [NSNumber numberWithLongLong:[contact.userid longLongValue]];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:contactId, @"id", contact.tel, @"telphone", nil];
        [contactArray addObject:dict];
    }];
    
    
    NSString *content = nil;
    NSString *userid = [kAppDelegate userId];
    if ([self.textView.text isEqualToString:@"编辑短信"]) {
        content = @"";
    }
    else{
        content = self.textView.text;
    }

    
    
    NSNumber *count = [NSNumber numberWithInt:contactArray.count];
    
    NSString *tel = self.myInfo.userDetail.tel;
    
    NSDictionary *jsonData = @{@"content":content, @"count":count, @"peoplelist":contactArray, @"tel":tel};
    NSString *jsonDataStr = [jsonData JSONString];
    NSLog(@"jsondata str %@", jsonDataStr);
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:jsonDataStr, @"jsondata", userid, @"userid", @"sendSMSforPeople.json", @"path", nil];
    
//    NSLog(@"sms dict %@", paraDict);
    

    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hud.labelText = @"正在发送";
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            NSInteger sendPeopleNum = self.contactArray.count;
            NSInteger count = self.myInfo.account.integerValue;
            count-=sendPeopleNum;
            self.myInfo.account = [NSNumber numberWithInt:count];
            DB_SAVE();
            [kAppDelegate showWithCustomAlertViewWithText:@"发送成功" andImageName:nil];
            
            double delayInSeconds = .3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // code to be executed on main thread.If you want to run in another thread, create other queue
                [self backToRootVC:nil];
            });
            
            
        }
        else{
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
            
            double delayInSeconds = .3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // code to be executed on main thread.If you want to run in another thread, create other queue
                [self backToRootVC:nil];
            });
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        
        double delayInSeconds = .3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // code to be executed on main thread.If you want to run in another thread, create other queue
            [self backToRootVC:nil];
        });
    }];
    
    [self.view endEditing:YES];
}

- (void)cancelSend:(UIButton *)sender
{
    NSLog(@"cancel send message");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addContact:(UIButton *)sender
{
    NSLog(@"add contact");
    NSLog(@"self.contactArray %@", self.contactArray);
    GroupSendViewController *groupSendVC = [[GroupSendViewController alloc] init];
    groupSendVC.delegate = self;
    [self.navigationController pushViewController:groupSendVC animated:YES];
    [groupSendVC release];
}

//hide keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - textview delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    if (!IS_IPHONE_5) {
        
        CGRect frame = self.view.frame;
        frame.origin.y -= 75;
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
        textView.text = @"编辑短信";
    }
}

#pragma mark - group send delegate

- (void)finishSelectGroupPeople:(NSArray *)groupPeople
{
    [self.contactArray addObjectsFromArray:groupPeople];
    
    NSMutableString *allSendTargetName = [[NSMutableString alloc] init];
    [self.contactArray enumerateObjectsUsingBlock:^(Contact *contact, NSUInteger idx, BOOL *stop) {
        [allSendTargetName appendFormat:@"%@、", contact.username];
    }];
    if ([allSendTargetName isValid]) {
        allSendTargetName = (NSMutableString *)[allSendTargetName substringToIndex:[allSendTargetName length] - 1];
    }
    NSLog(@"all name: %@", allSendTargetName);
    self.nameLabel.text = allSendTargetName;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_addButton release];
    [_textBgImageView release];
    [super dealloc];
}

@end
