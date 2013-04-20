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

#define VIEW_GAP 10
#define VIEW_LEFT_MARGIN (20)
#define VIEW_WIDTH (320-2*(VIEW_LEFT_MARGIN))

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

    UIImage *commentImage = [[UIImage imageNamed:@"editor_area.png"] stretchableImageWithLeftCapWidth:40 topCapHeight:40];
    self.commentBg.image = commentImage;
    
    [self.messageButton setImage:[UIImage imageByName:@"button_left_message_p.png"] forState:UIControlStateHighlighted];
    [self.mailButton setImage:[UIImage imageByName:@"button_middle_mail_p.png"] forState:UIControlStateHighlighted];
    [self.chatButton setImage:[UIImage imageByName:@"button_right_chat_p.png"] forState:UIControlStateHighlighted];
    
    [self.messageButton addTarget:self action:@selector(message:) forControlEvents:UIControlEventTouchUpInside];
    [self.mailButton addTarget:self action:@selector(email:) forControlEvents:UIControlEventTouchUpInside];
    [self.chatButton addTarget:self action:@selector(chat:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.headIcon setImageWithURL:[NSURL URLWithString:self.contact.picturelinkurl] placeholderImage:[UIImage imageByName:@"AC_L_icon.png"]];
    //默认不是好友
    self.isFriend = NO;
    
    [self getUserInfo];
}

- (void)getUserInfo
{
    ///getUserpageDetail.json, peoperid, userid, provinceid, cityid
    
    
    NSString *peoperid = self.contact.userid;
    NSString *userid = [kAppDelegate userId];
    NSString *cityid = [PersistenceHelper dataForKey:kCityId];
    NSString *provinceid = [PersistenceHelper dataForKey:kProvinceId];
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:peoperid, @"peoperid",
                                                                        userid, @"userid",
                                                                        cityid, @"cityid",
                                                                        provinceid, @"provinceid",
                                                                        @"getUserpageDetail.json", @"path", nil];
    
    NSLog(@"para Dict: %@", paraDict);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hud.labelText = @"获取用户信息";
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        if ([[json objectForKey:@"returnCode"] longValue] == 0) {
            NSLog(@"friend json data: %@", json);
            
            
            NSMutableString *areaString = [[NSMutableString alloc] init];
            NSArray *areaList = [json objectForKey:@"AreaList"];
            [areaList enumerateObjectsUsingBlock:^(NSDictionary *cityDict, NSUInteger idx, BOOL *stop) {
                CityInfo *cityInfo = [[CityInfo alloc] init];
                [cityInfo setValuesForKeysWithDictionary:cityDict];
                [self.areaArray addObject:cityInfo];
                [areaString appendFormat:@"%@、", cityInfo.cityname];
                [cityInfo release];
            }];
            
            if ([areaString isValid]) {
                areaString = (NSMutableString *)[areaString substringToIndex:[areaString length]-1];
                self.residentArea = areaString;
                self.residentAreaLabel.text = self.residentArea;
            }

            
            NSMutableString *preferString = [[NSMutableString alloc] init];
            NSArray *preferList = [json objectForKey:@"PreferList"];
            [preferList enumerateObjectsUsingBlock:^(NSDictionary *preferDict, NSUInteger idx, BOOL *stop) {
                PreferInfo *preferInfo = [[PreferInfo alloc] init];
                preferInfo.preferId = [[preferDict objectForKey:@"id"] longValue];
                preferInfo.prefername = [preferDict objectForKey:@"prefername"];
                [self.preferArray addObject:preferInfo];
                [preferString appendFormat:@"%@、", preferInfo.prefername];
                [preferInfo release];

            }];

            if ([preferString isValid]) {
                preferString = (NSMutableString *)[preferString substringToIndex:[preferString length]-1];
                self.pharmacologyCategory = preferString;
                self.cateLabel.text = self.pharmacologyCategory;
            }
            
            NSDictionary *userDetail = [json objectForKey:@"UserDetail"];
            self.contact = [[[Contact alloc] init] autorelease];
            self.contact.autograph = [userDetail objForKey:@"autograph"];
            self.contact.col1 = [userDetail objForKey:@"col1"];
            self.contact.col2 = [userDetail objForKey:@"col2"];
            self.contact.col3 = [userDetail objForKey:@"col3"];
            self.contact.userid = [[userDetail objForKey:@"id"] stringValue];
            self.contact.invagency = [NSNumber numberWithLong:[[userDetail objForKey:@"invagency"] intValue]];
            self.contact.mailbox = [userDetail objForKey:@"mailbox"];
            self.contact.picturelinkurl = [userDetail objForKey:@"picturelinkurl"];
            self.contact.remark = [userDetail objForKey:@"remark"];
            self.contact.tel = [userDetail objForKey:@"tel"];
            self.contact.type = [NSNumber numberWithLong:[[userDetail objForKey:@"type"] intValue]];
            self.contact.username = [userDetail objForKey:@"username"];
            
            if (self.contact.type == 0) {
                self.isFriend = NO;
                self.addFriendbtnTitleLabel.text = @"加为好友";
            }
            else{
                self.isFriend = YES;
                self.addFriendbtnTitleLabel.text = @"删除好友";
            }
            
            //获得好友备注
            self.commentTextField.text = self.contact.remark;
        }
     
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}


- (void)addFriend:(UIButton *)sender
{
    if (!self.isFriend) {
        NSLog(@"添加好友");
        
        //添加关注, addZsAttentionUser.json, userid, attentionid provinceid cityid
        
        NSString *attentionid =  self.contact.userid;
        NSString *userid = [kAppDelegate userId];
        NSString *cityid = [PersistenceHelper dataForKey:@"currentCityId"];
        NSString *provinceid = [PersistenceHelper dataForKey:@"currentProvinceId"];
        NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:attentionid, @"attentionid",
                                  userid, @"userid",
                                  cityid, @"cityid",
                                  provinceid, @"provinceid",
                                  @"addZsAttentionUser.json", @"path", nil];
        
        NSLog(@"para Dict: %@", paraDict);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
        hud.labelText = @"添加好友";
        [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
            if ([[json objectForKey:@"returnCode"] longValue] == 0) {
                [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
                self.isFriend = YES;
                self.addFriendbtnTitleLabel.text = @"删除好友";
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        }];
    }
    else{
        NSLog(@"删除好友");
        
        //添加关注, delZsAttentionUser.json, userid, attentionid provinceid cityid
        
        NSString *attentionid =  self.contact.userid;
        NSString *userid = [kAppDelegate userId];
        NSString *cityid = [PersistenceHelper dataForKey:@"currentCityId"];
        NSString *provinceid = [PersistenceHelper dataForKey:@"currentProvinceId"];
        NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:attentionid, @"attentionid",
                                  userid, @"userid",
                                  cityid, @"cityid",
                                  provinceid, @"provinceid",
                                  @"delZsAttentionUser.json", @"path", nil];
        
        NSLog(@"para Dict: %@", paraDict);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
        hud.labelText = @"删除好友";
        [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
            long returnCode = [[json objectForKey:@"returnCode"] longValue];
            NSLog(@"returnCode: %ld", returnCode);
            if ([[json objectForKey:@"returnCode"] longValue] == 0) {
                [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
                self.isFriend = NO;
                self.addFriendbtnTitleLabel.text = @"加为好友";
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        }];
    }

}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if (!self.isFriend) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteFriend object:self.contact.userid];
    }
}

#pragma mark - textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = self.view.frame;
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = CGRectMake(frame.origin.x, frame.origin.y-160.f, frame.size.width, frame.size.height);
    }];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = CGRectMake(0, 0, 320, [kAppDelegate window].frame.size.height-64);
    }];
    
    NSLog(@"text field edit end");
    //comment friend
    //para dict; changeuserremark.json userid destid remark
    NSString *destid = self.contact.userid;
    NSString *userid = kAppDelegate.userId;
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:userid, @"userid",
                                                                        destid, @"destid",
                                                                        textField.text, @"remark",
                                                                        @"changeuserremark.json", @"path", nil];
    
    NSLog(@"comment para dict: %@", paraDict);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        if ([[json objectForKey:@"returnCode"] longValue] == 0) {
            hud.labelText = @"修改成功";
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
//            self.comment = textField.text;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - contactHimView delegate

- (void)message:(UIButton *)sender
{
    NSLog(@"send message");

    if ([self showLoginAlert]) {
        return;
    } 
    
    SendMessageViewController *smVC = [[SendMessageViewController alloc] init];
    smVC.currentContact = self.contact;
//    smVC.contactDict = self.contactDict;
    [self.navigationController pushViewController:smVC animated:YES];
    [smVC release];
}

- (void)email:(UIButton *)sender
{
    NSLog(@"send email");
    if ([self showLoginAlert]) {
        return;
    }
    SendEmailViewController *seVC = [[SendEmailViewController alloc] init];
    seVC.currentContact = self.contact;
    [self.navigationController pushViewController:seVC animated:YES];
    [seVC release];
}

- (void)chat:(UIButton *)sender
{
    NSLog(@"chat");
    if ([self showLoginAlert]) {
        return;
    }
    
    
    TalkViewController *talk = [[[TalkViewController alloc] initWithNibName:@"TalkViewController" bundle:nil] autorelease];
    talk.fid = self.contact.userid;
    NSLog(@"talk.fid %@", talk.fid);
    [self.navigationController pushViewController:talk animated:YES];
    
}

- (BOOL)showLoginAlert
{
    BOOL shouldShow = NO;
    if ([[kAppDelegate userId] isEqualToString:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"亲" message:@"请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
    [super dealloc];
}
@end
