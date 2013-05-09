//
//  MyMailViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-5-1.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "MyMailViewController.h"
#import "SendEmailViewController.h"
#import "MailInfo.h"
#import "MailInfoViewController.h"
#import "MailInfoCell.h"
#import <AudioToolbox/AudioServices.h>

//enum eMailFolderType {
//    eUnknown = -1,
//    eInbox = 0,
//    eOutbox = 1
//    };


#define REGEX_PATTERN (@"(((.|\n|\r)*)!&@#~(.*)~#@&!(.*))")

@interface MyMailViewController ()

@end

@implementation MyMailViewController

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
    
    self.title = @"收件箱";
    CGFloat viewHeight = 0;
    if (IS_IPHONE_5) {
        viewHeight = 548;
    }
    else{
        viewHeight = 460;
    }
    self.title = @"我的邮件";
    self.hidesBottomBarWhenPushed = YES;
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, viewHeight-44-44) style:UITableViewStylePlain] autorelease];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    NSArray * toolBarBtns = @[@{@"image": [UIImage imageNamed:@"button.png"], @"title":@"发件箱"}, @{@"image": [UIImage imageNamed:@"button.png"], @"title":@"收件箱"}];
    [self initNavigationBar];
    [self initToolBarWithButtons:toolBarBtns];
    
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userDetail.userid == %@", kAppDelegate.userId];
    self.myInfo = [MyInfo findFirstWithPredicate:pred];
    
    self.inboxMails = [NSMutableArray array];
    self.outboxMails = [NSMutableArray array];
//    [self getInboxMailFromDB];
    
    self.viewWillAppearing = NO;
    self.isInbox = YES;
    self.checkFinished = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.viewWillAppearing == NO) {
        self.checkMailThread = [[[NSThread alloc] initWithTarget:self selector:@selector(checkUnreadMailInBackground) object:nil] autorelease];
        self.viewWillAppearing = YES;
        [self getInboxMailFromDB];
    }
    
    [super viewWillAppear:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.checkMailThread.isCancelled == NO) {
        [self.checkMailThread cancel];
    }
    self.viewWillAppearing = NO;
}

- (void)initNavigationBar {
    //left item
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageByName:@"retreat.png"] forState:UIControlStateNormal];
    UIBarButtonItem *button1 = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    self.navigationItem.leftBarButtonItem = button1;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initToolBarWithButtons:(NSArray *)buttons
{
    CGFloat viewHeight = 0;
    if (IS_IPHONE_5) {
        viewHeight = 548;
    }
    else{
        viewHeight = 460;
    }
    
    
    
    self.toolBar = [[[UIView alloc] initWithFrame:CGRectMake(0, viewHeight-88, 320, 44)] autorelease];
    UIImageView *toolBarImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_bg.png"]] autorelease];
    toolBarImage.frame = CGRectMake(0, 0, 320, 44);
    toolBarImage.userInteractionEnabled = YES;
    [self.toolBar addSubview:toolBarImage];
    
    [self.view addSubview:self.toolBar];
    
    for (int i = 0; i < [buttons count]; i++) {
        NSDictionary *dict = [buttons objectAtIndex:i];
        UIImage *image = [dict objForKey:@"image"];
        NSString *title  = [dict objForKey:@"title"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        //        button.showsTouchWhenHighlighted = YES;
        button.frame = CGRectMake(10+220*i, 5, 75, 34);
        button.tag = i;
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 34)] autorelease];
        label.text = title;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        [button addSubview:label];
        [self.toolBar addSubview:button];
        
        
        [button addTarget:self action:@selector(toolBarAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)toolBarAction:(UIButton *)button
{
    if (button.tag == 0) {
        if (self.isInbox == YES) {
            self.isInbox = NO;
            [self getOutboxMailFromDB];
        }
    }
    else{
        if (self.isInbox == NO) {
            self.isInbox = YES;
            [self getInboxMailFromDB];
        }
    }
}

- (void)getInboxMailFromDB
{
    self.title = @"收件箱";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"loginid == %@ AND foldername == %@", kAppDelegate.userId, @"INBOX"];
    [self.inboxMails removeAllObjects];
    [self.inboxMails addObjectsFromArray:[MailInfo findAllSortedBy:@"date" ascending:NO withPredicate:pred]];
    
    if(self.inboxMails.count == 0){
        [self getMailFromServer];
    }
    else{
        [self.tableView reloadData];
        if (self.checkFinished == NO) {
            [self.checkMailThread cancel];
            self.checkMailThread = [[[NSThread alloc] initWithTarget:self selector:@selector(checkUnreadMailInBackground) object:nil] autorelease];
            [self.checkMailThread start];
        }
    }
}

- (void)getOutboxMailFromDB
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"loginid == %@ AND foldername == %@", kAppDelegate.userId, @"OUTBOX"];
    self.outboxMails = [NSMutableArray arrayWithArray:[MailInfo findAllWithPredicate:pred]];
//    NSLog(@"self.outboxMails %@", self.outboxMails);
    for (MailInfo *mail in self.outboxMails) {
        NSLog(@"mail %@", mail);
    }
    self.title = @"发件箱";
    [self.tableView reloadData];
}

- (void)checkUnreadMailInBackground
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *username = [PersistenceHelper dataForKey:KUserName];
    NSString *password = [PersistenceHelper dataForKey:KPassWord];
    NSLog(@"username %@ password %@",username, password);
    
    CTCoreAccount *account = [[[CTCoreAccount alloc] init] autorelease];
    
    BOOL success = [account connectToServer:KBoraMailIMAPServer
                                       port:[kBoraMailIMAPPort intValue]
                             connectionType:CTConnectionTypePlain
                                   authType:CTImapAuthTypePlain
                                      login:[PersistenceHelper dataForKey:KUserName]
                                   password:[PersistenceHelper dataForKey:KPassWord]];
    
    
    
    if (!success) {
        NSLog(@"error %@", account.lastError);
    }
    else{
        MailInfo *lastMail = [self.inboxMails objectAtIndex:0];
        
        __block BOOL hasNewMail = NO;
        NSArray *mailArray = [[account folderWithPath:@"INBOX"] messagesFromSequenceNumber:1 to:0 withFetchAttributes:CTFetchAttrEnvelope];
        [mailArray enumerateObjectsUsingBlock:^(CTCoreMessage *msg, NSUInteger idx, BOOL *stop) {
            
            NSTimeInterval mailDate = [[msg senderDate] timeIntervalSince1970];
            NSLog(@"maildate %lf, lastmail date %f", mailDate, lastMail.date.doubleValue);
            if (mailDate > lastMail.date.doubleValue) {
                hasNewMail = YES;
                
                NSString *regex = REGEX_PATTERN;
                NSArray *array = [[[msg body] arrayOfCaptureComponentsMatchedByRegex:regex] objectAtIndex:0];
                //                    NSLog(@"array %@", array);
                
                NSString *content = [array objectAtIndex:2];
                NSString *username = [array objectAtIndex:4];
                NSString *picturelinkurl = [array lastObject];
                
                NSString *msgFrom = [[[[msg from] allObjects] lastObject] email];
                NSString *userId = [[msgFrom componentsSeparatedByString:@"@"] objectAtIndex:0];
                
                
                MailInfo *mail = [MailInfo createEntity];
                mail.userid = userId;
                mail.content = content;
                mail.username = username;
                //                            NSLog(@"msg from %@", [[[[msg from] allObjects] lastObject] email]);
                mail.address = msgFrom;
                //                    mail.date = [msg senderDate];
                mail.date = [NSString stringWithFormat:@"%lf", [[msg senderDate] timeIntervalSince1970]];
                mail.loginid = kAppDelegate.userId;
                mail.messageid = [msg messageId];
                mail.subject = [msg subject];
                mail.foldername = @"INBOX";
                mail.flags = @"0";
                mail.picturelinkurl = picturelinkurl;
                [self.inboxMails insertObject:mail atIndex:0];
                DB_SAVE();
            }
            
            if (hasNewMail)
            {
                [self performSelectorOnMainThread:@selector(checkMailFinished) withObject:nil waitUntilDone:YES];
            }
            self.checkFinished = YES;
        }];
        
    }
    
                
                
//                NSString *msgFrom = [[[[msg from] allObjects] lastObject] email];
//                NSString *userId = [[msgFrom componentsSeparatedByString:@"@"] objectAtIndex:0];
//                NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:@"getUserDetailById.json", @"path", userId, @"peoperid",  nil];
//                [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
//                    if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
//                        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
//                        NSString *username = [[json objForKey:@"UserDetail"] objForKey:@"username"];
////                        NSLog(@"his json info %@", json);
//                        [mailArray enumerateObjectsUsingBlock:^(CTCoreMessage *msg, NSUInteger idx, BOOL *stop) {
//                            MailInfo *mail = [MailInfo createEntity];
//                            mail.userid = userId;
//                            mail.content = [msg body];
//                            mail.username = username;
////                            NSLog(@"msg from %@", [[[[msg from] allObjects] lastObject] email]);
//                            mail.address = [[json objForKey:@"UserDetail"] objForKey:@"mailbox"];;
//                            //                    mail.date = [msg senderDate];
//                            mail.date = [NSString stringWithFormat:@"%lf", [[msg senderDate] timeIntervalSince1970]];
//                            mail.loginid = kAppDelegate.userId;
//                            mail.messageid = [msg messageId];
//                            mail.subject = [msg subject];
//                            mail.foldername = @"INBOX";
//                            mail.flags = @"0";
//                            mail.picturelinkurl = [[json objForKey:@"UserDetail"] objForKey:@"picturelinkurl"];
//                            [self.inboxMails insertObject:mail atIndex:0];
//                            DB_SAVE();
//                            
//                        }];
//                        
//                        
//                        if (hasNewMail) {
//                            [self performSelectorOnMainThread:@selector(checkMailFinished) withObject:nil waitUntilDone:YES];
//                        }
//                        self.checkFinished = YES;
//                    }
//                    
//                } failure:^(NSError *error) {
//
//                }];
//            }
//        }];
//    }
    

    [pool drain];
}

- (void)checkMailFinished
{
    [self.tableView reloadData];
    [kAppDelegate showWithCustomAlertViewWithText:@"收到新邮件" andImageName:nil];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)getMailFromServer
{
    //数据库没有邮件，从服务器取
    NSString *username = [PersistenceHelper dataForKey:KUserName];
    NSString *password = [PersistenceHelper dataForKey:KPassWord];
    NSLog(@"username %@ password %@",username, password);

    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    CTCoreAccount *account = [[CTCoreAccount alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL success = [account connectToServer:KBoraMailIMAPServer
                                           port:[kBoraMailIMAPPort intValue]
                                 connectionType:CTConnectionTypePlain
                                       authType:CTImapAuthTypePlain
                                          login:[PersistenceHelper dataForKey:KUserName]
                                       password:[PersistenceHelper dataForKey:KPassWord]];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
            if (!success) {
                NSLog(@"error %@", account.lastError);
                
            }
            else{
                [kAppDelegate showWithCustomAlertViewWithText:@"收到新邮件" andImageName:nil];
                [self.inboxMails removeAllObjects];
//                __block NSString *username = nil;
                NSString *foldername = @"INBOX";
                
                
                NSArray *mailArray = [[[[account folderWithPath:foldername] messagesFromSequenceNumber:1 to:0 withFetchAttributes:CTFetchAttrEnvelope] reverseObjectEnumerator] allObjects];
//                CTCoreMessage *msg = [mailArray objectAtIndex:0];
//
//                NSString *address = [[[[msg from] allObjects] lastObject] email];
//                NSString *userid = [[address componentsSeparatedByString:@"@"] objectAtIndex:0];
                
                
                
                
                [mailArray enumerateObjectsUsingBlock:^(CTCoreMessage *msg, NSUInteger idx, BOOL *stop) {
                    MailInfo *mail = [MailInfo createEntity];
                    NSString *regex = REGEX_PATTERN;
                    NSArray *array = [[[msg body] arrayOfCaptureComponentsMatchedByRegex:regex] objectAtIndex:0];
//                    NSLog(@"array %@", array);
                    
                    NSString *content = [array objectAtIndex:2];
                    NSString *username = [array objectAtIndex:4];
                    NSString *picturelinkurl = [array lastObject];
                    
                    NSString *address = [[[[msg from] allObjects] lastObject] email];
                    NSString *userid = [[address componentsSeparatedByString:@"@"] objectAtIndex:0];
                    
                    mail.userid = userid;
                    mail.content = content;
                    mail.username = username;
                    //                            NSLog(@"msg from %@", [[[[msg from] allObjects] lastObject] email]);
                    mail.address = address;
                    //                    mail.date = [msg senderDate];
                    mail.date = [NSString stringWithFormat:@"%lf", [[msg senderDate] timeIntervalSince1970]];
                    NSLog(@"mail date %@", mail.date);
                    mail.loginid = kAppDelegate.userId;
                    mail.messageid = [msg messageId];
                    mail.subject = [msg subject];
                    mail.foldername = @"INBOX";
                    mail.flags = @"0";
                    mail.picturelinkurl = picturelinkurl;
                    [self.inboxMails addObject:mail];
                    
                    DB_SAVE();
                    
                }];
                
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                
                [self.tableView reloadData];
                
                
                
//                NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:@"getUserDetailById.json", @"path", userid, @"peoperid",  nil];
//
//
//                [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
//                    if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
//                        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
//                        username = [[json objForKey:@"UserDetail"] objForKey:@"username"];
//                        NSLog(@"his json info %@", json);
//                        [mailArray enumerateObjectsUsingBlock:^(CTCoreMessage *msg, NSUInteger idx, BOOL *stop) {
//                            MailInfo *mail = [MailInfo createEntity];
//                            mail.userid = userid;
//                            mail.content = [msg body];
//                            mail.username = username;
////                            NSLog(@"msg from %@", [[[[msg from] allObjects] lastObject] email]);
//                            mail.address = address;
//                            //                    mail.date = [msg senderDate];
//                            mail.date = [NSString stringWithFormat:@"%lf", [[msg senderDate] timeIntervalSince1970]];
//                            NSLog(@"mail date %@", mail.date);
//                            mail.loginid = kAppDelegate.userId;
//                            mail.messageid = [msg messageId];
//                            mail.subject = [msg subject];
//                            mail.foldername = @"INBOX";
//                            mail.flags = @"0";
//                            mail.picturelinkurl = [[json objForKey:@"UserDetail"] objForKey:@"picturelinkurl"];
//                            [self.inboxMails addObject:mail];
//
//                            DB_SAVE();
//                            
//                        }];
//                        
//                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//
//                        [self.tableView reloadData];
//
//                    }
//                    else{
//                        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
//                        [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
//                    }
//
//                } failure:^(NSError *error) {
//                    [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
//                    [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
//                }];

                NSLog(@"mails %@", self.inboxMails);

            }
        });
    });
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isInbox) {
        return [self.inboxMails count];
    }
    else{
        return [self.outboxMails count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"mailInfoCell";
    MailInfoCell *myInfoCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!myInfoCell) {
        myInfoCell = [[[NSBundle mainBundle] loadNibNamed:@"MailInfoCell" owner:nil options:nil] lastObject];
    }
    
    [self configureCell:myInfoCell atIndexPath:indexPath];
    return myInfoCell;
}

- (void)configureCell:(MailInfoCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    MailInfo *mail = nil;
    if (self.isInbox) {
        mail = [self.inboxMails objectAtIndex:indexPath.row];
    }
    else{
        mail = [self.outboxMails objectAtIndex:indexPath.row];
    }
    
    NSLog(@"content %@", mail.content);
    
    cell.usernameLabel.text = mail.username;
    cell.subjectLabel.text = mail.subject;
    cell.headIcon.layer.cornerRadius = 4;
    cell.headIcon.layer.masksToBounds = YES;
    [cell.headIcon setImageWithURL:[NSURL URLWithString:mail.picturelinkurl] placeholderImage:[UIImage imageNamed:@"AC_L_icon.png"]];
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:mail.date.doubleValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy年M月d日 H:mm"];
    
    cell.dateLabel.text = [dateFormatter stringFromDate:date];
//    NSLog(@"The date is %@", [dateFormatter stringFromDate:date]);
    [dateFormatter release];
    
    
    if ([mail.flags isEqualToString:@"1"]) {
        cell.unreadImage.hidden = YES;
    }
    else{
        cell.unreadImage.hidden = NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MailInfo *mail = nil;
    if (self.isInbox) {
        mail = [self.inboxMails objectAtIndex:indexPath.row];
    }
    else{
        mail = [self.outboxMails objectAtIndex:indexPath.row];
    }
    
    
    MailInfoViewController *mailInfoVC = [[MailInfoViewController alloc] init];
    mailInfoVC.mailInfo = mail;
    if ([mail.flags isEqualToString:@"0"]) {
        mail.flags = @"1";
//        cell.unreadImage.hidden = YES;
    }
    
    
    DB_SAVE();
    [self.navigationController pushViewController:mailInfoVC animated:YES];
    [mailInfoVC release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
