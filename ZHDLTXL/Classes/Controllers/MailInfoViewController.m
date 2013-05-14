//
//  MailInfoViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-5-1.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "MailInfoViewController.h"
#import "SendEmailViewController.h"

@interface MailInfoViewController ()

@end

@implementation MailInfoViewController

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
    self.title = @"邮件详情";
    self.hidesBottomBarWhenPushed = YES;
    self.nameLabel.text = self.mailInfo.username;
    self.addressLabel.text = self.mailInfo.address;

    self.subjectLabel.text = self.mailInfo.subject;
    self.contentTextView.text = self.mailInfo.content;
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy年M月d日 H:mm"];
    NSDate *mailDate = [NSDate dateWithTimeIntervalSince1970:[self.mailInfo.date doubleValue]];
    NSString *dateStr = [dateFormatter stringFromDate:mailDate];
    self.dateLabel.text = dateStr;
    
    
    UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [replyButton setImage:[UIImage imageNamed:@"reply_mail.png"] forState:UIControlStateNormal];
    [replyButton addTarget:self action:@selector(reply:) forControlEvents:UIControlEventTouchUpInside];
    replyButton.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem *rBarButton = [[[UIBarButtonItem alloc] initWithCustomView:replyButton] autorelease];
    [self.navigationItem setRightBarButtonItem:rBarButton];
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    [self.headIcon setImageWithURL:[NSURL URLWithString:self.mailInfo.picturelinkurl] placeholderImage:[UIImage imageNamed:@"AC_L_icon.png"]];
    self.headIcon.layer.cornerRadius = 4;
    self.headIcon.layer.masksToBounds = YES;
    self.deleteMail = YES;
    
    
    [self.preMail addTarget:self action:@selector(preMail:) forControlEvents:UIControlEventTouchUpInside];
    [self.preMail setImage:[UIImage imageByName:@"button_p.png"] forState:UIControlStateHighlighted];
    
    [self.nextMail addTarget:self action:@selector(nextMail:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextMail setImage:[UIImage imageByName:@"button_p.png"] forState:UIControlStateHighlighted];
    
    [self.deleteMailBtn addTarget:self action:@selector(deleteMail:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - pre mail, next mail, delete mail

- (void)preMail:(UIButton *)sender
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"date < %@ AND loginid = %@ AND foldername = %@", self.mailInfo.date, kAppDelegate.userId, @"INBOX"];
    NSArray *mailArray = [MailInfo findAllSortedBy:@"date" ascending:YES withPredicate:pred];
    if (mailArray.count != 0) {
        MailInfo *preMail = [mailArray lastObject];
        self.mailInfo = preMail;
        [self showMail:self.mailInfo];
    }
}

- (void)nextMail:(UIButton *)sender
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"date > %@ AND loginid = %@ AND foldername = %@", self.mailInfo.date, kAppDelegate.userId, @"INBOX"];
    NSArray *mailArray = [MailInfo findAllSortedBy:@"date" ascending:YES withPredicate:pred];
    if (mailArray.count != 0) {
        MailInfo *nextMail = [mailArray objectAtIndex:0];
        self.mailInfo = nextMail;
        [self showMail:self.mailInfo];
    }
}

- (void)showMail:(MailInfo *)mail
{
    self.nameLabel.text = mail.username;
    self.addressLabel.text = mail.address;
    
    self.subjectLabel.text = mail.subject;
    self.contentTextView.text = mail.content;
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy年M月d日 H:mm"];
    NSDate *mailDate = [NSDate dateWithTimeIntervalSince1970:[self.mailInfo.date doubleValue]];
    NSString *dateStr = [dateFormatter stringFromDate:mailDate];
    self.dateLabel.text = dateStr;
    
    [self.headIcon setImageWithURL:[NSURL URLWithString:self.mailInfo.picturelinkurl] placeholderImage:[UIImage imageByName:@"AC_L_icon.png"]];
}

- (void)deleteMail:(UIButton *)sender
{
    self.mailInfo.flags = @"2";
    [self backAction:nil];
}

- (void)reply:(UIButton *)sender
{
    SendEmailViewController *sendEmailVC = [[SendEmailViewController alloc] init];
    self.deleteMail = NO;
    
    sendEmailVC.mail = self.mailInfo;
    [self.navigationController pushViewController:sendEmailVC animated:YES];
    [sendEmailVC release];
}

- (void)backAction:(UIButton *)sender
{
//    [self.mailInfo deleteEntity];
//    if (self.deleteMail) {
//        [self.mailInfo deleteEntity];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_headIcon release];
    [_nameLabel release];
    [_addressLabel release];
    [_dateLabel release];
    [_subjectLabel release];
    [_contentTextView release];
    [_preMail release];
    [_nextMail release];
    [_deleteMailBtn release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setHeadIcon:nil];
    [self setNameLabel:nil];
    [self setAddressLabel:nil];
    [self setDateLabel:nil];
    [self setSubjectLabel:nil];
    [self setContentTextView:nil];
    [self setPreMail:nil];
    [self setNextMail:nil];
    [self setDeleteMailBtn:nil];
    [super viewDidUnload];
}
@end
