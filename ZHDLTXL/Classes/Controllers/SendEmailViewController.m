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
    [self addObserver];
    self.contactArray = [[[NSMutableArray alloc] init] autorelease];
    [self.contactArray addObject:self.currentContact];
    
    self.mailSendFrom = [PersistenceHelper dataForKey:KBoraMail];
    self.mailTo = self.currentContact.col1;
    
    //nav bar image
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topmargin.png"] forBarMetrics:UIBarMetricsDefault];
    
    //back bar button
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];

    
    //send message Button;
 
    [self.sendButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    [self.sendButton addTarget:self action:@selector(sendEmail:) forControlEvents:UIControlEventTouchUpInside];
    //cancel button

    [self.cancelButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    [self.cancelButton addTarget:self action:@selector(cancelSend:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //name label
    self.nameLabel.text = self.currentContact.username;
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textColor = [UIColor colorWithRed:98.f/255.f green:98.f/255.f blue:98.f/255.f alpha:1.f];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    
    //add person button
    [self.addButton setImage:[UIImage imageNamed:@"more_select_p.png"] forState:UIControlStateHighlighted];
    [self.addButton addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImage *editorBgImage = [UIImage stretchableImage:@"editor_area.png" leftCap:40 topCap:40];
    self.textViewBgImage.image = editorBgImage;
    
    self.mailTextView.text = @"编辑邮件";
    self.mailTextView.textColor = [UIColor lightGrayColor];
    
    UIImage *emailTitleBgImage = [UIImage stretchableImage:@"editor_area.png" leftCap:40 topCap:40];
    self.textfieldBgImage.image = emailTitleBgImage;
    
    
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendEmail:(UIButton *)sender
{
    NSLog(@"send message");
    
    NSString *mailTile = self.emailTitleTextField.text;
    if (![mailTile isValid]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"此邮件没有主题" message:@"您确定发送吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
        [alert show];
        [alert release];
    }
    else{
//        [self didSendMail];
    }
    
    

    
    
}

//- (void)didSendMail
//{
//    NSString *mailToName = self.currentContact.username;
//    NSString *mailSendFromName = [PersistenceHelper dataForKey:KUserName];
//    NSString *senderPassword = [PersistenceHelper dataForKey:KPassWord];
//    
//    NSString *mailTile = self.emailTitleTextField.text;
//    NSString *mailBody = self.mailTextView.text;
//    CTCoreMessage *mail = [[CTCoreMessage alloc] init];
//    [mail setTo:[NSSet setWithObject:[CTCoreAddress addressWithName:mailToName email:self.mailTo]]];
//    [mail setFrom:[NSSet setWithObject:[CTCoreAddress addressWithName:mailSendFromName email:self.mailSendFrom]]];
//    [mail setBody:mailBody];
//    [mail setSubject:mailTile];
//    
//    NSError *error;
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
//    [hud hide:YES afterDelay:.5];
//    hud.labelText = @"正在发送";
//    BOOL success = [CTSMTPConnection sendMessage:mail
//                                          server:KBoraMailSmtpServer
//                                        username:[kAppDelegate userId]
//                                        password:senderPassword
//                                            port:[KBoraMailSmtpPort intValue]
//                                  connectionType:CTSMTPConnectionTypePlain
//                                         useAuth:YES
//                                           error:&error];
//    if (!success) {
//        [kAppDelegate showWithCustomAlertViewWithText:@"发送失败" andImageName:nil];
//        NSLog(@"send mail error %@", error);
//    }
//    else{
//        [kAppDelegate showWithCustomAlertViewWithText:@"发送成功" andImageName:nil];
//    }
//    
//}

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
    groupSendVC.selectedContactArray = self.contactArray;
    groupSendVC.originContact = self.currentContact;
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
        frame.origin.y -= 100;
        [UIView animateWithDuration:.5f animations:^{
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
        [UIView animateWithDuration:0.5f animations:^{
            self.view.frame = CGRectMake(0, 0, [kAppDelegate window].frame.size.width, [kAppDelegate window].frame.size.height-64);
        }];
    }
    if (textView.text.length == 0) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"编辑邮件";
    }
}


#pragma mark - add observer

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addContactFinished:) name:kSendMessageAddFriendNotification object:nil];
}

- (void)addContactFinished:(NSNotification *)noti
{
    [noti.object enumerateObjectsUsingBlock:^(Contact *contact, NSUInteger idx, BOOL *stop) {
        if (![self.contactArray containsObject:contact]) {
            [self.contactArray addObject:contact];
        }
    }];
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

#pragma mark - alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_sendButton release];
    [_textfieldBgImage release];
    [_mailTextView release];
    [super dealloc];
}
@end
