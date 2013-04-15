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
    
//    self.preferArray = [[NSMutableArray alloc] init];
//    self.areaArray = [[NSMutableArray alloc] init];
    
    UIImageView *backBgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"debut_light.png"]];
    backBgImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    backBgImage.userInteractionEnabled = YES;
    [self.view addSubview:backBgImage];
    [backBgImage release];
    
    //back button
    UIButton *backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    //head icon
    
    self.headIconName = @"AC_L_icon.png";
    UIImageView *headIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.headIconName]];
    headIcon.frame = CGRectMake(VIEW_LEFT_MARGIN, 15.f, 59, 59);
    [self.view addSubview:headIcon];
    [headIcon release];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 15.f, 100, 35.f)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = self.userName;
    nameLabel.font = [UIFont systemFontOfSize:18.f];
    nameLabel.textColor = kContentColor;
    [self.view addSubview:nameLabel];
    
    //resident label
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.f, 48.f, 80.f, 30)];
    areaLabel.backgroundColor = [UIColor clearColor];
    areaLabel.font = [UIFont systemFontOfSize:14.f];
    areaLabel.text = @"常驻地区：";
    areaLabel.textColor = kContentBlueColor;
    [self.view addSubview:areaLabel];
    
    self.residentAreaLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 48.f, 80.f, 30.f)];
    self.residentAreaLabel.backgroundColor = [UIColor clearColor];
    self.residentArea = nil;
    self.residentAreaLabel.font = [UIFont systemFontOfSize:14];
    self.residentAreaLabel.text = self.residentArea;
    self.residentAreaLabel.textColor = kContentBlueColor;
    [self.view addSubview:self.residentAreaLabel];
    
    
    UILabel *cateKeyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 80, 45)];
    cateKeyLabel.text = @"类别偏好：";
    cateKeyLabel.backgroundColor = [UIColor clearColor];
    cateKeyLabel.textColor = kSubContentColor;
    cateKeyLabel.font = [UIFont systemFontOfSize:16];
    
    //category label
    self.cateLabel = [[UILabel alloc] init];
    self.cateLabel.backgroundColor = [UIColor clearColor];
    self.cateLabel.text = self.pharmacologyCategory;
    self.cateLabel.font = [UIFont systemFontOfSize:16];
    self.cateLabel.textColor = kSubContentColor;
 
    
    UIImageView *cateBgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"underframe.png"]];
    cateBgImage.frame = CGRectMake(20, 90.f, 280.f, 60.f);
    [cateBgImage addSubview:self.cateLabel];
    [cateBgImage addSubview:cateKeyLabel];
    [self.view addSubview:cateBgImage];
    
    
    
    
    //contact him view
    ContactHimView *contactHimView = [[ContactHimView alloc] initWithFrame:CGRectMake(22.f, 160.f, 276.f, 55.f)];
    contactHimView.delegate = self;
    contactHimView.contact = self.contact;
    [self.view addSubview:contactHimView];
    
    //comment
    UIImage *commentImage = [[UIImage imageNamed:@"editor_area.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImageView *commentBgImage = [[UIImageView alloc] initWithImage:commentImage];
    commentBgImage.frame = CGRectMake(VIEW_LEFT_MARGIN, 235.f, VIEW_WIDTH, 50.f);
    commentBgImage.userInteractionEnabled = YES;
    
    self.commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 15, VIEW_WIDTH-60, 40.f)];
    self.commentTextField.placeholder = @"对他添加备注";
    self.commentTextField.font = [UIFont systemFontOfSize:16.f];
    self.commentTextField.borderStyle = UITextBorderStyleNone;
    self.commentTextField.delegate = self;
    [commentBgImage addSubview:self.commentTextField];
    
    [self.view addSubview:commentBgImage];
    
    
    UIButton *addFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addFriendButton setImage:[UIImage imageNamed:@"addfriend_button.png"] forState:UIControlStateNormal];
    [addFriendButton setImage:[UIImage imageNamed:@"addfriend_button_p.png"] forState:UIControlStateHighlighted];
    self.addFriendbtnTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 260, 45.f)];
    self.addFriendbtnTitleLabel.backgroundColor = [UIColor clearColor];
//    self.addFriendbtnTitleLabel.text = @"加为好友";
    self.addFriendbtnTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.addFriendbtnTitleLabel setFont:[UIFont systemFontOfSize:18.f]];
    [self.addFriendbtnTitleLabel setTextColor:[UIColor whiteColor]];
    addFriendButton.frame = CGRectMake(20, 300, 280, 55.f);
    [addFriendButton addSubview:self.addFriendbtnTitleLabel];
    [addFriendButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:addFriendButton];
    
    [self getUserInfo];
    
    //默认不是好友
    self.isFriend = NO;
}

- (void)getUserInfo
{
    ///getUserpageDetail.json, peoperid, userid, provinceid, cityid
    
    
    NSNumber *peoperid =  [NSNumber numberWithLong:self.contact.userid];
    NSNumber *userid = [NSNumber numberWithLong:[[kAppDelegate userId] longLongValue]];
    NSString *cityid = [PersistenceHelper dataForKey:@"currentCityId"];
    NSString *provinceid = [PersistenceHelper dataForKey:@"currentProvinceId"];
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
            
            NSMutableString *areaString = [[NSMutableString alloc] init];
            NSArray *areaList = [json objectForKey:@"AreaList"];
            [areaList enumerateObjectsUsingBlock:^(NSDictionary *cityDict, NSUInteger idx, BOOL *stop) {
                CityInfo *cityInfo = [[CityInfo alloc] init];
                [cityInfo setValuesForKeysWithDictionary:cityDict];
                [self.areaArray addObject:cityInfo];
            
                [areaString appendFormat:@"%@、", cityInfo.cityname];

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

            }];

            if ([preferString isValid]) {
                preferString = (NSMutableString *)[preferString substringToIndex:[preferString length]-1];
                self.pharmacologyCategory = preferString;
                self.cateLabel.text = self.pharmacologyCategory;
            }
            
            CGSize cateLabelSize = [self.residentArea sizeWithFont:self.cateLabel.font
                                                 constrainedToSize:CGSizeMake(240.f, MAXFLOAT)
                                                     lineBreakMode:NSLineBreakByWordWrapping];
            self.cateLabel.frame = CGRectMake(100, 20, 240, cateLabelSize.height);
            
            if ([[[json objectForKey:@"UserDetail"] objectForKey:@"type"] longValue] == 0) {
                self.isFriend = NO;
                self.addFriendbtnTitleLabel.text = @"加为好友";
            }
            else{
                self.isFriend = YES;
                self.addFriendbtnTitleLabel.text = @"删除好友";
            }
        
            //获得好友备注
            NSLog(@"friend info %@", json);
            self.comment = [[json objectForKey:@"UserDetail"] objectForKey:@"remark"];
            NSLog(@"friend comment: %@", self.comment);
            self.commentTextField.text = self.comment;
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
        
        NSNumber *attentionid =  [NSNumber numberWithLong:self.contact.userid];
        NSNumber *userid = [NSNumber numberWithLong:[[kAppDelegate userId] longLongValue]];
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
        
        NSNumber *attentionid =  [NSNumber numberWithLong:self.contact.userid];
        NSNumber *userid = [NSNumber numberWithLong:[[kAppDelegate userId] longLongValue]];
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
    
    
    //取消关注, delZsAttentionUser.json, userid, attentionid provinceid cityid
    
    
    
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if (!self.isFriend) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteFriend object:[NSNumber numberWithLong:self.contact.userid]];
    }
}

#pragma mark - textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = self.view.frame;
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = CGRectMake(frame.origin.x, frame.origin.y-144.f, frame.size.width, frame.size.height);
    }];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = CGRectMake(0, 0, 320, 460);
    }];
    
    NSLog(@"text field edit end");
    //comment friend
    //para dict; changeuserremark.json userid destid remark
    NSNumber *destid = [NSNumber numberWithLong:self.contact.userid];
    NSNumber *userid = [NSNumber numberWithLong:[kAppDelegate.userId longLongValue]];
    
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
            self.comment = textField.text;
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

- (void)message:(Contact *)contact
{
    NSLog(@"send message");
    SendMessageViewController *smVC = [[SendMessageViewController alloc] init];
    smVC.currentContact = contact;
    smVC.contactDict = self.contactDict;
    [self.navigationController pushViewController:smVC animated:YES];
    [smVC release];
}

- (void)email:(Contact *)contact
{
    NSLog(@"send email");
    SendEmailViewController *seVC = [[SendEmailViewController alloc] init];
    seVC.currentContact = contact;
    seVC.contactDict = self.contactDict;
    [self.navigationController pushViewController:seVC animated:YES];
    [seVC release];
}

- (void)chat:(Contact *)contact
{
    NSLog(@"chat");
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:chatVC animated:YES];
    [chatVC release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
