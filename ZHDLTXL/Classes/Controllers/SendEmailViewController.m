//
//  SendEmailViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-10.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "SendEmailViewController.h"
#import "GroupSendViewController.h"
#import <MailCore/MailCore.h>
#import "MyInfo.h"
#import "UserDetail.h"


@interface SendEmailViewController ()

@property (nonatomic, assign) CGFloat textViewEditingHeight;
@property (nonatomic, assign) CGFloat textViewHeight;

@end

@implementation SendEmailViewController

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
	self.title = @"发送邮件";
    self.hidesBottomBarWhenPushed = YES;
//    [self addObserver];
//    self.contactArray = [[[NSMutableArray alloc] init] autorelease];
//    [self.contactArray addObject:self.currentContact];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userDetail.userid == %@", kAppDelegate.userId];
    self.myInfo = [[MyInfo findAllWithPredicate:pred] lastObject];
    
    self.mailSendFrom = self.myInfo.userDetail.col1;
//    self.mailTo = self.mail.address;


    
    //nav bar image
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topmargin.png"] forBarMetrics:UIBarMetricsDefault];
    
    //back bar button
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [replyButton setImage:[UIImage imageNamed:@"reply_mail.png"] forState:UIControlStateNormal];
    [replyButton addTarget:self action:@selector(reply:) forControlEvents:UIControlEventTouchUpInside];
    replyButton.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem *rBarButton = [[[UIBarButtonItem alloc] initWithCustomView:replyButton] autorelease];
    [self.navigationItem setRightBarButtonItem:rBarButton];
    
    
    //name label
    if (!self.mail) {
        self.nameLabel.text = self.currentContact.username;
    }
    else{
        self.nameLabel.text = self.mail.username;
    }
    
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textColor = [UIColor colorWithRed:98.f/255.f green:98.f/255.f blue:98.f/255.f alpha:1.f];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    
    //add person button
//    [self.addButton setImage:[UIImage imageNamed:@"more_select_p.png"] forState:UIControlStateHighlighted];
//    [self.addButton addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.mailTextView.text = @"编辑邮件";
    self.mailTextView.textColor = [UIColor lightGrayColor];
    
    self.emailTitleTextField.text = @"";
    
    
}

- (void)backToRootVC:(UIButton *)sender
{
    if (self.sendFinished) {
        [self updateDB];
    }
    else{
        [self.mail deleteEntity];
        DB_SAVE();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reply:(UIButton *)sender
{
    NSLog(@"send message");
    
    [self.view endEditing:YES];
    
    NSString *mailTile = self.emailTitleTextField.text;
    if (![mailTile isValid]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填写邮件主题" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else{
        [self didSendMail];
    }
}

- (NSString *)makeMailContent
{
    //append username and picturelinkurl to the mail.content with regex
//    #define REGEX_PATTERN (@"(((.|\n|\r)*)!&@#~(.*)~#@&!(.*))")
    
    NSString *content = self.mailTextView.text;
    
    
    if ([content isEqualToString:@"编辑邮件"]) {
        content = @"";
    }
    
    
    NSMutableString *regexContent = [NSMutableString stringWithFormat:@"%@!&@#~%@~#@&!%@", content, self.myInfo.userDetail.username, self.myInfo.userDetail.picturelinkurl];
    NSLog(@"mail regex %@", regexContent);
    return regexContent;

}

- (void)didSendMail
{
    NSString *mailToName = self.mail.username;

    NSString *mailSendFromName = [PersistenceHelper dataForKey:KUserName];
    NSString *senderPassword = [PersistenceHelper dataForKey:KPassWord];
    
    NSString *mailTitle = self.emailTitleTextField.text;
    NSString *mailBody = [self makeMailContent];

    CTCoreMessage *mail = [[[CTCoreMessage alloc] init] autorelease];
    [mail setTo:[NSSet setWithObject:[CTCoreAddress addressWithName:mailToName email:self.mail.address]]];
    [mail setFrom:[NSSet setWithObject:[CTCoreAddress addressWithName:mailSendFromName email:self.mailSendFrom]]];
    [mail setBody:mailBody];
    [mail setSubject:mailTitle];
    NSLog(@"mailtitle %@", mailTitle);
    
    NSString *title = [mail subject];
    NSLog(@"title %@", title);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hud.labelText = @"正在发送";
    
    NSLog(@"userid %@", kAppDelegate.userId);
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        BOOL success = [CTSMTPConnection sendMessage:mail
                                              server:KBoraMailSmtpServer
                                            username:[kAppDelegate userId]
                                            password:senderPassword
                                                port:[KBoraMailSmtpPort intValue]
                                      connectionType:CTSMTPConnectionTypePlain
                                             useAuth:YES
                                               error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
                [kAppDelegate showWithCustomAlertViewWithText:@"发送失败" andImageName:nil];
                NSLog(@"send mail error %@", error);
                
                double delayInSeconds = .3;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    // code to be executed on main thread.If you want to run in another thread, create other queue
                    [self backToRootVC:nil];
                });
                self.sendFinished = NO;
            }
            else{
                self.sendFinished = YES;
                [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
                [kAppDelegate showWithCustomAlertViewWithText:@"发送成功" andImageName:nil];
//                [self updateDB];
                
                double delayInSeconds = .3;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self backToRootVC:nil];
                });
            }
        });
    });
}

- (void)updateDB
{
//    MailInfo *mail = [MailInfo createEntity];
//    mail.username = self.mail.username;
//    mail.userid = self.mail.userid;
//    mail.loginid = kAppDelegate.userId;
//    mail.date = [NSString stringWithFormat:@"%.lf", [[NSDate date] timeIntervalSince1970]];
//    mail.address = self.mail.address;
//    mail.thirdaddress = self.mail.thirdaddress;
//    mail.state = self.mail.state;
//    mail.foldername = @"OUTBOX";
//    mail.messageid = self.mail.messageid;
//    mail.flags = self.mail.flags;
//    mail.subject = self.emailTitleTextField.text;
//    mail.content = self.mailTextView.text;
    self.mail.date = [NSString stringWithFormat:@"%.lf", [[NSDate date] timeIntervalSince1970]];
    self.mail.state = @"0";
    self.mail.foldername = @"OUTBOX";
    self.mail.messageid = @"";
    self.mail.flags = @"1";
    self.mail.loginid = kAppDelegate.userId;
    self.mail.subject = self.emailTitleTextField.text;
    NSString *content = self.mailTextView.text;
    if ([content isEqualToString:@"编辑邮件"]) {
        content = @"";
    }
    self.mail.content = content;
    
    
    DB_SAVE();
}

- (void)cancelSend:(UIButton *)sender
{
    NSLog(@"cancel send message");
    [self.navigationController popViewControllerAnimated:YES];
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
        frame.origin.y -= 100;
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
        textView.text = @"编辑邮件";
    }
}


#pragma mark - add observer

//- (void)addObserver
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addContactFinished:) name:kSendMessageAddFriendNotification object:nil];
//}

//- (void)addContactFinished:(NSNotification *)noti
//{
//    [noti.object enumerateObjectsUsingBlock:^(Contact *contact, NSUInteger idx, BOOL *stop) {
//        if (![self.contactArray containsObject:contact]) {
//            [self.contactArray addObject:contact];
//        }
//    }];
//    NSMutableString *allSendTargetName = [[NSMutableString alloc] init];
//    [self.contactArray enumerateObjectsUsingBlock:^(Contact *contact, NSUInteger idx, BOOL *stop) {
//        [allSendTargetName appendFormat:@"%@、", contact.username];
//    }];
//    if ([allSendTargetName isValid]) {
//        allSendTargetName = (NSMutableString *)[allSendTargetName substringToIndex:[allSendTargetName length] - 1];
//    }
//    NSLog(@"all name: %@", allSendTargetName);
//    self.nameLabel.text = allSendTargetName;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_textfieldBgImage release];
    [_mailTextView release];
    [super dealloc];
}
@end
