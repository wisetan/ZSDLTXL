//
//  HomepageViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-12.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "OtherHomepageViewController.h"
#import "SendMessageViewController.h"
#import "SendEmailViewController.h"
#import "ChatViewController.h"
#import "GroupSendViewController.h"
#import "CityInfo.h"
#import "PreferInfo.h"
#import "TalkViewController.h"
#import "LoginViewController.h"
#import "FriendContact.h"
#import "HomePageCell.h"
#import "UIAlertView+Blocks.h"
#import "MailInfo.h"


@interface OtherHomepageViewController ()

@end

@implementation OtherHomepageViewController

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
	self.title = @"他的主页";
    
    self.hidesBottomBarWhenPushed = YES;
    
    self.preferArray = [[[NSMutableArray alloc] init] autorelease];
    self.areaArray = [[[NSMutableArray alloc] init] autorelease];
    
    //back button
    UIButton *backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
//    //head icon

    self.nameLabel.text = self.contact.username;
    [self.addFriendButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    
    self.commentBg.hidden = YES;
    
    [self.messageButton setImage:[UIImage imageByName:@"button_left_message_p.png"] forState:UIControlStateHighlighted];
    [self.mailButton setImage:[UIImage imageByName:@"button_middle_mail_p.png"] forState:UIControlStateHighlighted];
    [self.chatButton setImage:[UIImage imageByName:@"button_right_chat_p.png"] forState:UIControlStateHighlighted];
    
    [self.messageButton addTarget:self action:@selector(message:) forControlEvents:UIControlEventTouchUpInside];
    [self.mailButton addTarget:self action:@selector(email:) forControlEvents:UIControlEventTouchUpInside];
    [self.chatButton addTarget:self action:@selector(chat:) forControlEvents:UIControlEventTouchUpInside];
    
    self.headIcon.layer.cornerRadius = 8;
    self.headIcon.layer.masksToBounds = YES;
    [self.headIcon setImageWithURL:[NSURL URLWithString:self.contact.picturelinkurl] placeholderImage:[UIImage imageByName:@"AC_L_icon.png"]];
    //默认不是好友
    self.isFriend = NO;
    
    
    //table view source
    self.leftArray = [NSMutableArray arrayWithArray:@[@"招商代理：", @"常驻地区：", @"类别偏好："]];
    self.rightArray = [NSMutableArray array];
    
    
    [self.commentTextField setValue:[UIColor darkGrayColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    
    [self getUserInfo];
}


#pragma mark - table view 
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.leftArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"homePageCell";
    HomePageCell *cell = (HomePageCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomePageCell" owner:self options:nil] lastObject];
    }
    
    
    
    switch (indexPath.row) {
        case 0:{
            int inva = self.contact.invagency.intValue;
            NSString *strInva = nil;
            switch (inva) {
                case 1:
                    strInva = @"招商";
                    break;
                case 2:
                    strInva = @"代理";
                    break;
                case 3:
                    strInva = @"招商、代理";
                    break;
                default:
                    break;
            }
            cell.detailLabel.text = strInva;
        }
            
            break;
        case 1:
            cell.detailLabel.text = self.residentArea;
            break;
            
        case 2:
            cell.detailLabel.text = self.pharmacologyCategory;
            cell.separatorImage.hidden = YES;
            break;
            
        default:
            break;
    }
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.nameLabel.text = [self.leftArray objectAtIndex:indexPath.row];
    cell.nameLabel.textColor = kContentBlueColor;
    
    if (indexPath.row == self.leftArray.count-1) {
        cell.separatorImage.image = nil;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (void)getUserInfo
{
    NSString *peoperid = self.contact.userid;   //好友id
    NSString *userid = [kAppDelegate userId];
    NSString *cityid = [PersistenceHelper dataForKey:kCityId];
    NSString *provinceid = [PersistenceHelper dataForKey:kProvinceId];
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:peoperid, @"peoperid",
                                                                        userid, @"userid",
                                                                        cityid, @"cityid",
                                                                        provinceid, @"provinceid",
                                                                        @"getUserpageDetail.json", @"path", nil];
    
//    NSLog(@"para Dict: %@", paraDict);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hud.labelText = @"获取用户信息";
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        if ([[[json objectForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            NSLog(@"friend json data: %@", json);
            
            
            NSMutableString *areaString = [[NSMutableString alloc] init];
            NSArray *areaList = [json objectForKey:@"AreaList"];
            [areaList enumerateObjectsUsingBlock:^(NSDictionary *cityDict, NSUInteger idx, BOOL *stop) {

                [self.areaArray addObject:[cityDict objForKey:@"cityname"]];
                [areaString appendFormat:@"%@、", [cityDict objForKey:@"cityname"]];
                
            }];
            
            if ([areaString isValid]) {
                areaString = (NSMutableString *)[areaString substringToIndex:[areaString length]-1];
                self.residentArea = areaString;
//                self.residentAreaLabel.text = self.residentArea;
            }

            
            NSMutableString *preferString = [[NSMutableString alloc] init];
            NSArray *preferList = [json objectForKey:@"PreferList"];
            [preferList enumerateObjectsUsingBlock:^(NSDictionary *preferDict, NSUInteger idx, BOOL *stop) {

                [self.preferArray addObject:[preferDict objForKey:@"prefername"]];
                [preferString appendFormat:@"%@、", [preferDict objForKey:@"prefername"]];
            }];

            if ([preferString isValid]) {
                preferString = (NSMutableString *)[preferString substringToIndex:[preferString length]-1];
                self.pharmacologyCategory = preferString;
//                self.cateLabel.text = self.pharmacologyCategory;
            }
            
            NSDictionary *userDetail = [json objectForKey:@"UserDetail"];
            self.contact.autograph = [userDetail objForKey:@"autograph"];
            self.contact.col1 = [userDetail objForKey:@"col1"];
            self.contact.col2 = [userDetail objForKey:@"col2"];
            self.contact.col3 = [userDetail objForKey:@"col3"];
            self.contact.userid = [[userDetail objForKey:@"id"] stringValue];
            self.contact.invagency = [[userDetail objForKey:@"invagency"] stringValue];
            self.contact.mailbox = [userDetail objForKey:@"mailbox"];
            self.contact.picturelinkurl = [userDetail objForKey:@"picturelinkurl"];
            self.contact.remark = [userDetail objForKey:@"remark"];
            self.contact.tel = [userDetail objForKey:@"tel"];
            self.contact.type = [[userDetail objForKey:@"type"] stringValue];
            self.contact.username = [userDetail objForKey:@"username"];
            self.contact.userid = [[userDetail objForKey:@"id"] stringValue];
            self.contact.isreal = [[userDetail objForKey:@"isreal"] stringValue];
            
            if (self.contact.type.intValue == 0) {
                self.isFriend = NO;
                self.addFriendbtnTitleLabel.text = @"加为好友";
            }
            else{
                self.isFriend = YES;
                self.addFriendbtnTitleLabel.text = @"删除好友";
            }
            
            self.useridLabel.text = self.contact.userid;
            
            if ([self.contact.col2 isEqualToString:@"1"]) {
                self.xun_VImage.hidden = NO;
            }
            else{
                self.xun_VImage.hidden = YES;
            }
            
            self.commentTextField.text = self.contact.remark;
            
//            //获得好友备注
//            if ([self.contact.remark isValid])
//            {
//                self.commentTextField.text = self.contact.remark;
//                NSString *remark = [NSString stringWithFormat:@"%@(%@)", self.contact.username, self.contact.remark];
//                self.nameLabel.text = remark;
//            }
            
            [self.tableView reloadData];
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}


- (void)addFriend:(UIButton *)sender
{
    if ([self showLoginAlert]) {
        return;
    }
    
    if (!self.isFriend) {
        NSLog(@"添加好友");
        
        //添加关注, addZsAttentionUser.json, userid, attentionid provinceid cityid
        
        NSString *attentionid =  self.contact.userid;
        NSString *userid = [kAppDelegate userId];
        NSString *cityid = [PersistenceHelper dataForKey:kCityId];
        NSString *provinceid = [PersistenceHelper dataForKey:kProvinceId];
        NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:attentionid, @"attentionid",
                                  userid, @"userid",
                                  cityid, @"cityid",
                                  provinceid, @"provinceid",
                                  @"addZsAttentionUser.json", @"path", nil];
        
//        NSLog(@"para Dict: %@", paraDict);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
        hud.labelText = @"添加好友";
        [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
            if ([[json objectForKey:@"returnCode"] longValue] == 0) {
                [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
                self.isFriend = YES;
                self.addFriendbtnTitleLabel.text = @"删除好友";
                
                [self updateIsFriend:self.isFriend];
                
            }
            else{
                [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
                [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        }];
    }
    else{
        NSLog(@"删除好友");
        
        //添加关注, delZsAttentionUser.json, userid, attentionid provinceid cityid
        
        NSString *attentionid = self.contact.userid;
        NSString *userid = [kAppDelegate userId];
        NSString *cityid = [PersistenceHelper dataForKey:kCityId];
        NSString *provinceid = [PersistenceHelper dataForKey:kProvinceId];
        NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:attentionid, @"attentionid",
                                  userid, @"userid",
                                  cityid, @"cityid",
                                  provinceid, @"provinceid",
                                  @"delZsAttentionUser.json", @"path", nil];
        
//        NSLog(@"para Dict: %@", paraDict);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
        hud.labelText = @"删除好友";
        [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
            long returnCode = [[json objectForKey:@"returnCode"] longValue];
            NSLog(@"returnCode: %ld", returnCode);
            if ([[json objectForKey:@"returnCode"] longValue] == 0) {
                [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
                self.isFriend = NO;
                self.addFriendbtnTitleLabel.text = @"加为好友";
                [self updateIsFriend:self.isFriend];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        }];
    }
}

- (void)updateIsFriend:(BOOL)isFriend
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userid == %@ AND loginid == %@ AND cityid == %@", self.contact.userid, [kAppDelegate userId], [PersistenceHelper dataForKey:kCityId]];
    FriendContact *friendContact = [FriendContact findFirstWithPredicate:pred];
    if (friendContact == nil) {
        friendContact = [FriendContact createEntity];
        friendContact.autograph = self.contact.autograph;
        friendContact.cityid = [PersistenceHelper dataForKey:kCityId];
        friendContact.col1 = self.contact.col1;
        friendContact.col2 = self.contact.col2;
        friendContact.col3 = self.contact.col3;
        friendContact.invagency = self.contact.invagency;
        friendContact.loginid = self.contact.loginid;
        friendContact.mailbox = self.contact.mailbox;
        friendContact.picturelinkurl = self.contact.picturelinkurl;
        friendContact.remark = self.commentTextField.text;
        friendContact.sectionkey = self.contact.sectionkey;
        friendContact.tel = self.contact.tel;
        friendContact.userid = self.contact.userid;
        friendContact.username = self.contact.username;
        friendContact.username_p = self.contact.username_p;
    }

    if (self.isFriend) {
        friendContact.type = @"1";
    }
    else
    {
        friendContact.type = @"0";
    }

    DB_SAVE();

}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    CGRect frame = self.view.frame;
//    [UIView animateWithDuration:0.2f animations:^{
//        self.view.frame = CGRectMake(frame.origin.x, frame.origin.y-160.f, frame.size.width, frame.size.height);
//    }];
    textField.returnKeyType = UIReturnKeyDone;
    self.commentBg.hidden = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    [UIView animateWithDuration:0.2f animations:^{
//        self.view.frame = CGRectMake(0, 0, 320, [kAppDelegate window].frame.size.height-64);
//    }];
    
    NSLog(@"text field edit end");
    
    if ([textField.text isValid] && ![textField.text isEqualToString:@"添加备注"]) {
        NSString *destid = self.contact.userid;
        NSString *userid = kAppDelegate.userId;
        
        NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:userid, @"userid",
                                  destid, @"destid",
                                  textField.text, @"remark",
                                  @"changeuserremark.json", @"path", nil];
        
//        NSLog(@"comment para dict: %@", paraDict);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
        [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
            if ([[json objectForKey:@"returnCode"] longValue] == 0) {
                hud.labelText = @"修改成功";
                [hud hide:YES afterDelay:.3];
//                [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
                //            self.comment = textField.text;
                self.contact.remark = textField.text;
//                self.nameLabel.text = [NSString stringWithFormat:@"%@(%@)", self.contact.username, self.contact.remark];
                DB_SAVE();
            }
            else{
                [MBProgressHUD hideHUDForView:kAppDelegate.window animated:YES];
                [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        }];
    }
    
    self.commentBg.hidden = YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - contact method

- (void)message:(UIButton *)sender
{
    NSLog(@"send message");

    if ([self showLoginAlert]) {
        return;
    }
    
    SendMessageViewController *smVC = [[SendMessageViewController alloc] init];
    smVC.currentContact = self.contact;
    [self.navigationController pushViewController:smVC animated:YES];
    [smVC release];
}

- (void)email:(UIButton *)sender
{
    NSLog(@"send email");
    if ([self showLoginAlert]) {
        return;
    }
    
//    @dynamic userid;
//    @dynamic username;
//    @dynamic loginid;
//    @dynamic thirdaddress;
//    @dynamic address;
//    @dynamic foldername;
//    @dynamic subject;
//    @dynamic content;
//    @dynamic date;
//    @dynamic flags;         //0 未读 1 已读
//    @dynamic messageid;
//    @dynamic state;         //0 发送失败 1 发送成功
//    @dynamic picturelinkurl;
    
    
    
    

    
    
    if ([self.contact.isreal isEqualToString:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该用户只接受短信" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    MailInfo *mail = [MailInfo createEntity];
    mail.userid = self.contact.userid;
    mail.username = self.contact.username;
    mail.loginid = kAppDelegate.userId;
    mail.thirdaddress = self.contact.mailbox;
    mail.address = self.contact.col1;
    mail.foldername = @"OUTBOX";
    mail.subject = @"";
    mail.content = @"";
    mail.date = @"";
    mail.flags = @"";
    mail.messageid = @"";
    mail.state = @"";
    mail.picturelinkurl = self.contact.picturelinkurl;
    
    SendEmailViewController *seVC = [[SendEmailViewController alloc] init];
    seVC.mail = mail;
//    seVC.currentContact = self.contact;
    [self.navigationController pushViewController:seVC animated:YES];
    [seVC release];
}

- (void)chat:(UIButton *)sender
{
    NSLog(@"chat");
    if ([self showLoginAlert]) {
        return;
    }
    
    if ([self.contact.isreal isEqualToString:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该用户只接受短信" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    
    TalkViewController *talk = [[[TalkViewController alloc] initWithNibName:@"TalkViewController" bundle:nil] autorelease];
    talk.username = self.contact.username;
    talk.fid = self.contact.userid;
    talk.fAvatarUrl = self.contact.picturelinkurl;
    NSLog(@"talk.fid %@", talk.fid);
    [self.navigationController pushViewController:talk animated:YES];
    
}

- (BOOL)showLoginAlert
{
    BOOL shouldShow = NO;
    if ([[kAppDelegate userId] isEqualToString:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先登录" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        [alert release];
        shouldShow = YES;
    }
    return shouldShow;
}

#pragma mark - alert delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        [loginVC release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_nameLabel release];
    [_messageButton release];
    [_mailButton release];
    [_chatButton release];
    [_commentBg release];
    [_addFriendButton release];
    [_headIcon release];
    [_tableView release];
    [_commentTextField release];
    [_xunImage release];
    [_xun_VImage release];
    [_xun_BImage release];
    [_useridLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [self setCommentTextField:nil];
    [self setXunImage:nil];
    [self setXun_VImage:nil];
    [self setXun_BImage:nil];
    [self setUseridLabel:nil];
    [super viewDidUnload];
}
@end
