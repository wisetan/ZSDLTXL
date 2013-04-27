//
//  MyHomePageViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-14.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "MyHomePageViewController.h"
#import "PersonalInfoCell.h"
#import "ProvinceViewController.h"
#import "SelectPharViewController.h"
#import "Pharmacology.h"
#import "PreferInfo.h"
#import "ModifyInfoView.h"
#import "MAlertView.h"
#import "SettingViewController.h"
#import "SendMessageViewController.h"

#import "HomePageCell.h"
#import "CityInfo.h"
#import "MyInfo.h"
#import "Pharmacology.h"
#import "MyInfoController.h"
#import "MySmsController.h"

#import "UserDetail.h"

#import "UIImageView+WebCache.h"
#import "UIImage+Resizing.h"

#import "SBTableAlert.h"
#import "ZDCell.h"

#import "CustomBadge.h"


@interface MyHomePageViewController ()

@property (nonatomic, retain) NSArray *cellNameArray;

@end

@implementation MyHomePageViewController

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
    [self addObserver];
    self.hidesBottomBarWhenPushed = YES;
    
    self.title = @"个人主页";
    
//    self.userDetail = [[[UserDetail alloc] init] autorelease];
    
    self.nameLabel.text = self.name;
    self.telLabel.text = self.tel;
    self.mailLabel.text = self.mail;
    
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnHeadIcon:)] autorelease];
    [self.headIcon addGestureRecognizer:tap];
    
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    [self.modifyButton addTarget:self action:@selector(modifyInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.leftArray = [[[NSMutableArray alloc] initWithObjects:@"招商/代理：", @"常驻地区：", @"类别偏好：", @"账户余额：", @"我的设置", nil] autorelease];
    self.selectorNameArray = [[[NSMutableArray alloc] initWithObjects:@"chooseAngencyOrBusiness", @"addArea:", @"addPhar:", @"showExtra", @"setting", nil] autorelease];
    
    self.selectorArray = [[[NSMutableArray alloc] init] autorelease];
    [self.selectorNameArray enumerateObjectsUsingBlock:^(NSString *selectorName, NSUInteger idx, BOOL *stop) {
        SEL sel = NSSelectorFromString(selectorName);
        [self.selectorArray addObject:[NSValue valueWithPointer:sel]];
    }];
    
    UIImage *tableViewBgImage = [[UIImage imageNamed:@"table_underframe.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    UIImageView *tableViewBgImageView = [[[UIImageView alloc] initWithImage:tableViewBgImage] autorelease];
    [self.infoTableView setBackgroundView:tableViewBgImageView];
    [self.infoTableView setBackgroundColor:[UIColor clearColor]];
    
    
    [self.messageButton setImage:[UIImage imageByName:@"button_left_message_p.png"] forState:UIControlStateHighlighted];
    [self.mailButton setImage:[UIImage imageByName:@"button_middle_mail_p.png"] forState:UIControlStateHighlighted];
    [self.chatButton setImage:[UIImage imageByName:@"button_right_chat_p.png"] forState:UIControlStateHighlighted];
    
    [self.messageButton addTarget:self action:@selector(message:) forControlEvents:UIControlEventTouchUpInside];
    [self.mailButton addTarget:self action:@selector(email:) forControlEvents:UIControlEventTouchUpInside];
    [self.chatButton addTarget:self action:@selector(chat:) forControlEvents:UIControlEventTouchUpInside];
    
    self.residentArray = [[[NSMutableArray alloc] init] autorelease];
    self.pharArray = [[[NSMutableArray alloc] init] autorelease];
    
    self.residentImageArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<2; i++) {
        UIImage *image = [UIImage imageNamed:@"myhomepage_location_bg.png"];
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
        [self.residentImageArray addObject:imageView];
    }
    
    self.pharImageArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<2; i++) {
        UIImage *image = [UIImage imageNamed:@"myhomepage_location_bg.png"];
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
        [self.pharImageArray addObject:imageView];
    }
    
    self.headIcon.layer.cornerRadius = 8;
    self.headIcon.layer.masksToBounds = YES;
    
    self.unreadCountArray = [[[NSMutableArray alloc] init] autorelease];
    self.zdNameArray = @[@"招商", @"代理"];
    
    self.zdDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [self.zdNameArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.zdDict setObject:[NSNumber numberWithInt:0] forKey:obj];
    }];
    self.zdValue = [NSNumber numberWithInt:0];
    
    self.unreadMessageDict = [[[NSMutableDictionary alloc] init] autorelease];
    [self checkUnreadMessage];
    
    
    [self.infoTableView reloadData];

    [self getPersonalInfoFromDB];
    if (self.myInfo) {
        [self showResident];
        [self showPhar];
        [self showBasicInfo];
        [self showMessageBadge];
        [self showZD];
    }
    else{
        [self getPersonalInfoFromNet];
    }
}

- (void)checkUnreadMessage
{
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:@"getUnreadMessageCount.json", @"path", kAppDelegate.userId, @"userid", nil];
    //后台查询 不给提示
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            NSLog(@"uncheck json %@", json);
            [self.unreadMessageDict setObject:[json objForKey:@"UnreadCount"] forKey:@"UnReadCount"];
            [self.unreadMessageDict setObject:[json objForKey:@"UnreadSMSCount"] forKey:@"UnreadSMSCount"];
            [self showMessageBadge];
        }
        else{
            NSLog(@"check unread error %@", GET_RETURNMESSAGE(json));
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", kNetworkError);
    }];
    
    
}

- (void)showZD  //显示招商代理
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    HomePageCell *cell = (HomePageCell *)[self.infoTableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        NSLog(@"cell is nil");
    }
    NSString *invAgencyName = nil;
    switch (self.myInfo.userDetail.invagency.intValue) {
        case 1:
            invAgencyName = @"招商";
            break;
        case 2:
            invAgencyName = @"代理";
            break;
        case 3:
            invAgencyName = @"招商、代理";
            break;
        default:
            break;
    }
    
    
    cell.detailLabel.text = invAgencyName;
}

- (void)showResident
{
    [self.residentArray removeAllObjects];
    [self.myInfo.areaList enumerateObjectsUsingBlock:^(CityInfo *city, BOOL *stop) {
        NSLog(@"city name %@", city.cityname);
        [self.residentArray addObject:city];
    }];
    
    NSLog(@"resident array %@", self.residentArray);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    
    HomePageCell *cell = (HomePageCell *)[self.infoTableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        NSLog(@"cell is nil");
    }
    
    [self.residentImageArray enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        [[imageView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        imageView.hidden = YES;
    }];
    
    [self.residentArray enumerateObjectsUsingBlock:^(CityInfo *city, NSUInteger idx, BOOL *stop) {
        NSString *cityName = city.cityname;
        CGSize labelSize = CGRectZero.size;
        UILabel *residentLabel = [[[UILabel alloc] init] autorelease];
        labelSize = CGSizeMake(50, 36);
        residentLabel.frame = CGRectMake(5, 2, labelSize.width, labelSize.height);
        residentLabel.font = [UIFont systemFontOfSize:12];
        residentLabel.backgroundColor = [UIColor clearColor];
        residentLabel.numberOfLines = 2;
        residentLabel.textAlignment = NSTextAlignmentCenter;
        residentLabel.textColor = [UIColor whiteColor];
        residentLabel.text = cityName;
        NSLog(@"cityname %@", cityName);
        
        
        UIImageView *residentImageView = [self.residentImageArray objectAtIndex:idx];
        if (idx == 0) {
            [residentImageView setFrame:CGRectMake(100, 2, 60, 40)];
            [residentImageView addSubview:residentLabel];
        }
        else{
            UIImageView *lastImage = [self.residentImageArray objectAtIndex:idx-1];
            [residentImageView setFrame:CGRectMake(lastImage.frame.origin.x+lastImage.frame.size.width+10, 2, 60, 40)];
            [residentImageView addSubview:residentLabel];
        }
        [cell.contentView addSubview:residentImageView];
        [residentImageView setHidden:NO];
    }];
    [self.infoTableView reloadData];
}

- (void)showPhar
{
    [self.pharArray removeAllObjects];
    [self.myInfo.pharList enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [self.pharArray addObject:obj];
    }];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];

    HomePageCell *cell = (HomePageCell *)[self.infoTableView cellForRowAtIndexPath:indexPath];

    [self.pharImageArray enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        [[imageView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        imageView.hidden = YES;
    }];

    [self.pharArray enumerateObjectsUsingBlock:^(Pharmacology *phar, NSUInteger idx, BOOL *stop) {
        NSString *prefername = phar.content;
        CGSize labelSize = CGRectZero.size;
        UILabel *pharLabel = [[UILabel alloc] init];
        labelSize = CGSizeMake(50, 36);
        pharLabel.frame = CGRectMake(5, 2, labelSize.width, labelSize.height);
        pharLabel.font = [UIFont systemFontOfSize:12];
        pharLabel.backgroundColor = [UIColor clearColor];
        pharLabel.numberOfLines = 2;
        pharLabel.textAlignment = NSTextAlignmentCenter;
        pharLabel.textColor = [UIColor whiteColor];
        pharLabel.text = prefername;


        UIImageView *residentImageView = [self.pharImageArray objectAtIndex:idx];
        if (idx == 0) {
            [residentImageView setFrame:CGRectMake(100, 2, 60, 40)];
            [residentImageView addSubview:pharLabel];
        }
        else{
            UIImageView *lastImage = [self.pharImageArray objectAtIndex:idx-1];
            [residentImageView setFrame:CGRectMake(lastImage.frame.origin.x+lastImage.frame.size.width+10, 2, 60, 40)];
            [residentImageView addSubview:pharLabel];
        }
        [cell.contentView addSubview:residentImageView];
        [residentImageView setHidden:NO];

    }];
    [self.infoTableView reloadData];
}

- (void)getPersonalInfoFromDB
{
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *myInfoEntity = [NSEntityDescription entityForName:@"MyInfo" inManagedObjectContext:kAppDelegate.managedObjectContext];
    [fetch setEntity:myInfoEntity];
    [fetch setPredicate:nil];
    
    NSError *error = nil;
    NSArray *myInfoArray = [kAppDelegate.managedObjectContext executeFetchRequest:fetch error:&error];
    if (error) {
        NSLog(@"fetch error %@", error);
    }
    else{
        NSLog(@"myinfoarrat count %d", myInfoArray.count);
        self.myInfo = [myInfoArray lastObject];

        NSLog(@"self.myinfo.areaList %@", self.myInfo.areaList);
    }
}


- (void)showBasicInfo
{
    self.nameLabel.text = self.myInfo.userDetail.username;
    self.telLabel.text = self.myInfo.userDetail.tel;
    self.mailLabel.text = self.myInfo.userDetail.mailbox;
}

- (void)showMessageBadge
{
    //取得未读消息
//    int unreadCount = self.myInfo.unreadCount.intValue;
//    NSLog(@"unreadcount: %d", unreadCount);
    NSString *unreadCount = [self.unreadMessageDict objForKey:@"UnreadCount"];
    if ([unreadCount intValue] > 0) {
        
        CustomBadge *badge = [CustomBadge customBadgeWithString:unreadCount
                                                withStringColor:[UIColor whiteColor]
                                                 withInsetColor:[UIColor redColor]
                                                 withBadgeFrame:YES
                                            withBadgeFrameColor:[UIColor whiteColor]
                                                      withScale:1.0
                                                    withShining:YES];
        
        CGRect badgeFrame = badge.frame;
        badgeFrame.origin.y = -5.f;
        badgeFrame.origin.x = self.chatButton.frame.size.width - badgeFrame.size.width + 2.f;
        badge.frame = badgeFrame;
        
        [self.chatButton addSubview:badge];
        [self.view bringSubviewToFront:self.chatButton];
        
    }
    
    NSString * UnreadSMSCount = [self.unreadMessageDict objForKey:@"UnreadSMSCount"];
    if ([UnreadSMSCount intValue] > 0) {
        CustomBadge *badge = [CustomBadge customBadgeWithString:UnreadSMSCount
                                                withStringColor:[UIColor whiteColor]
                                                 withInsetColor:[UIColor redColor]
                                                 withBadgeFrame:YES
                                            withBadgeFrameColor:[UIColor whiteColor]
                                                      withScale:1.0
                                                    withShining:YES];
        
        CGRect badgeFrame = badge.frame;
        badgeFrame.origin.y = -5.f;
        badgeFrame.origin.x = self.chatButton.frame.size.width - badgeFrame.size.width + 2.f;
        badge.frame = badgeFrame;
        
        [self.messageButton addSubview:badge];
        [self.view bringSubviewToFront:self.chatButton];
    }
}

- (void)getPersonalInfoFromNet
{
    //paradict getMypageDetail.json userid
    NSString *userid = [kAppDelegate userId];
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:userid, @"userid", @"getMypageDetail.json", @"path", nil];
    NSLog(@"get personinfo Dict: %@", paraDict);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hud.labelText = @"获取个人信息";
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        if ([[json objectForKey:@"returnCode"] longValue] == 0) {
            NSLog(@"my info json %@", json);
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            NSDictionary *userDetailDict = [json objectForKey:@"UserDetail"];
            
            self.userDetail = [NSEntityDescription insertNewObjectForEntityForName:@"UserDetail" inManagedObjectContext:kAppDelegate.managedObjectContext];
            
            self.name = [userDetailDict objectForKey:@"username"];
            self.tel = [userDetailDict objectForKey:@"tel"];
            self.mail = [userDetailDict objectForKey:@"mailbox"];
            
            self.nameLabel.text = self.name;
            self.telLabel.text = self.tel;
            self.mailLabel.text = self.mail;
            
    //            id: 20086,
    //        username: "liuyue",
    //        tel: "13800000005",
    //        mailbox: "1234@qq.com",
    //        picturelinkurl: "",
    //        invagency: 3,
    //        autograph: "",
    //        col1: "20086@boramail.com",
    //        col2: "",
    //        col3: ""
            
            NSLog(@"my info %@", userDetailDict);
            
            self.userDetail.userid = [[userDetailDict objForKey:@"id"] stringValue];
            self.userDetail.username = [userDetailDict objForKey:@"username"];
            self.userDetail.tel = [userDetailDict objForKey:@"tel"];
            self.userDetail.mailbox = [userDetailDict objForKey:@"mailbox"];
            self.userDetail.picturelinkurl = [userDetailDict objForKey:@"picturelinkurl"];
            self.userDetail.invagency = [[userDetailDict objForKey:@"invagency"] stringValue];
            self.userDetail.autograph = [userDetailDict objForKey:@"autograph"];
            self.userDetail.col1 = [userDetailDict objForKey:@"col1"];
            self.userDetail.col2 = [userDetailDict objForKey:@"col2"];
            self.userDetail.col3 = [userDetailDict objForKey:@"col3"];
            NSLog(@"picturelinkurl: %@", self.userDetail.picturelinkurl);
            
            [self.headIcon setImageWithURL:[NSURL URLWithString:self.userDetail.picturelinkurl] placeholderImage:[UIImage imageNamed:@"AC_L_icon.png"]];
            
            //取得未读消息
            int unreadCount = [[json objForKey:@"UnreadCount"] intValue];
            NSLog(@"unreadcount: %d", unreadCount);
            if (unreadCount > 0) {
                
                CustomBadge *badge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", unreadCount]
                                                        withStringColor:[UIColor whiteColor]
                                                         withInsetColor:[UIColor redColor]
                                                         withBadgeFrame:YES
                                                    withBadgeFrameColor:[UIColor whiteColor]
                                                              withScale:1.0
                                                            withShining:YES];
                
                CGRect badgeFrame = badge.frame;
                badgeFrame.origin.y = -5.f;
                badgeFrame.origin.x = self.chatButton.frame.size.width - badgeFrame.size.width + 2.f;
                badge.frame = badgeFrame;
                
                [self.chatButton addSubview:badge];
                [self.view bringSubviewToFront:self.chatButton];
                
            }
            
            int UnreadSMSCount = [[json objForKey:@"UnreadSMSCount"] intValue];
            if (UnreadSMSCount > 0) {
                CustomBadge *badge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", unreadCount]
                                                        withStringColor:[UIColor whiteColor]
                                                         withInsetColor:[UIColor redColor]
                                                         withBadgeFrame:YES
                                                    withBadgeFrameColor:[UIColor whiteColor]
                                                              withScale:1.0
                                                            withShining:YES];
                
                CGRect badgeFrame = badge.frame;
                badgeFrame.origin.y = -5.f;
                badgeFrame.origin.x = self.chatButton.frame.size.width - badgeFrame.size.width + 2.f;
                badge.frame = badgeFrame;
                
                [self.messageButton addSubview:badge];
                [self.view bringSubviewToFront:self.chatButton];
            }
            
            NSArray *residentArray = [json objectForKey:@"AreaList"];
            NSMutableSet *residentSet = [[[NSMutableSet alloc] init] autorelease];
            NSLog(@"residentArray: %@", residentArray);
            [residentArray enumerateObjectsUsingBlock:^(NSDictionary *cityDict, NSUInteger idx, BOOL *stop) {
                if (idx>1) {
                    *stop = YES;
                }else{
                    CityInfo *city = [[CityInfo alloc] init];
                    [city setValuesForKeysWithDictionary:cityDict];
                    [self.residentArray addObject:city];
                    [residentSet addObject:city];
                    [city release];
                }
            }];
            
            [self addResidentFinished:nil];
            
            NSArray *preferArray = [json objectForKey:@"PreferList"];
            NSMutableSet *preferSet = [[[NSMutableSet alloc] init] autorelease];
            [preferArray enumerateObjectsUsingBlock:^(NSDictionary *preferDict, NSUInteger idx, BOOL *stop) {
                PreferInfo *prefer = [[PreferInfo alloc] init];
                prefer.prefername = [preferDict objForKey:@"prefername"];
                prefer.preferid = [[preferDict objForKey:@"id"] stringValue];
                [self.pharArray addObject:prefer];
                [preferSet addObject:prefer];
                [prefer release];
            }];
            
            
            [self addPreferFinished:nil];
            
            
        } else{
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addResidentFinished:) name:kAddResidentNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPreferFinished:) name:kSelectPharFinished object:nil];
}

- (void)removeObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAddResidentNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSelectPharFinished object:nil];
}

#pragma mark - table view datasouce

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
    SEL sel = [[self.selectorArray objectAtIndex:indexPath.row] pointerValue];
    if (indexPath.row == 1 || indexPath.row == 2) {
        [cell.addButton setImage:[UIImage imageNamed:@"more_select_p.png"] forState:UIControlStateHighlighted];
        [cell.addButton addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
        cell.detailLabel.hidden = YES;
    }
    else{
        cell.addButton.hidden = YES;
    }
    
    if (indexPath.row == 3) {
        cell.detailLabel.text = [NSString stringWithFormat:@"%d 条", self.myInfo.account.intValue];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.nameLabel.text = [self.leftArray objectAtIndex:indexPath.row];
    cell.nameLabel.font = [UIFont systemFontOfSize:18];
    cell.nameLabel.textColor = kContentBlueColor;
    
    if (indexPath.row == self.leftArray.count-1) {
        cell.separatorImage.image = nil;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SEL sel = [[self.selectorArray objectAtIndex:indexPath.row] pointerValue];
    switch (indexPath.row) {
        case 0:
            [self performSelector:sel];
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            [self performSelector:sel];
            break;
        case 4:
            [self performSelector:sel];
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}

- (void)addResidentFinished:(NSNotification *)noti
{
    [self showResident];
}

- (void)addPreferFinished:(NSNotification *)noti
{
    [self showPhar];
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)modifyInfo:(UIButton *)sender
{
    self.nameField = [[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 45)] autorelease];
    self.telField = [[[UITextField alloc] initWithFrame:CGRectMake(0, 45, 200, 45)] autorelease];
    self.mailField = [[[UITextField alloc] initWithFrame:CGRectMake(0, 90, 200, 45)] autorelease];
    
    MAlertView *alert = [[MAlertView alloc] initWithTitle:@"修改个人信息" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
    [alert addTextField:self.nameField placeHolder:@"姓名"];
    [alert addTextField:self.telField placeHolder:@"电话"];
    [alert addTextField:self.mailField placeHolder:@"邮件"];
    [alert show];
    [alert release];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *name = self.nameField.text;
        NSString *tel = self.telField.text;
        NSString *mail = self.mailField.text;
        
        if (![tel isValid] || ![tel isMobileNumber]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的电话号码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }
        
        if (![mail isValid] || ![mail isValidEmail]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的邮件" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }
        
        
        
        //userid mail tel name path
        NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:kAppDelegate.userId, @"userid", name, @"name", tel, @"tel", mail, @"mail", @"updateZsUserDetail.json", @"path", nil];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
        hud.labelText = @"更新用户信息";
        [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
            if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
                [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
                self.myInfo.userDetail.username = name;
                self.myInfo.userDetail.mailbox = mail;
                self.myInfo.userDetail.tel = tel;
                
                NSError *error = nil;
                if (![kAppDelegate.managedObjectContext save:&error]) {
                    NSLog(@"error %@", error);
                }
                else{
                    [self showBasicInfo];
                }
                
            }
            else{
                [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
                [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:@"更新失败" andImageName:nil];
        }];
    }
    else{
        return;
    }
}

- (void)chooseAngencyOrBusiness
{
//    NSLog(@"chooseAngencyOrBusiness");
    NSLog(@"选择招商代理");
    SBTableAlert *tableAlert = [[SBTableAlert alloc] initWithTitle:@"请选择招商代理" cancelButtonTitle:@"确定" messageFormat:nil];
    [tableAlert setType:SBTableAlertTypeMultipleSelct];
    tableAlert.delegate = self;
    tableAlert.dataSource = self;
    [tableAlert show];
}

- (void)addArea:(UIButton *)sender
{

    ProvinceViewController *provinceVC = [[ProvinceViewController alloc] init];
    provinceVC.isAddResident = YES;
    provinceVC.homePageVC = self;
    NSLog(@"residentarrray: %@", self.residentArray);
    provinceVC.selectCityArray = self.residentArray;
    [self.navigationController pushViewController:provinceVC animated:YES];

    [provinceVC release];

}

- (void)addPhar:(UIButton *)sender
{
    SelectPharViewController *selectPreferVC = [[SelectPharViewController alloc] init];
//    selectPreferVC.selectArray = self.pharArray;
    selectPreferVC.myInfo = self.myInfo;
    [self.navigationController pushViewController:selectPreferVC animated:YES];
    [selectPreferVC release];
}

- (void)showExtra
{
    NSLog(@"showExtra");
}

- (void)setting
{
    NSLog(@"setting");
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    settingVC.MyHomeVC = self;
    [self.navigationController pushViewController:settingVC animated:YES];
    [settingVC release];
}

#pragma  mark - about contact
- (void)message:(UIButton *)sender
{
    NSLog(@"message");
    MySmsController *mySmsController = [[MySmsController alloc] init];
    [self.navigationController pushViewController:mySmsController animated:YES];
    [mySmsController release];
}

- (void)email:(UIButton *)sender
{
    NSLog(@"email");
}

- (void)chat:(UIButton *)sender
{
    MyinfoController *myInfoController = [[MyinfoController alloc] init];
    [self.navigationController pushViewController:myInfoController animated:YES];
    [myInfoController release];
}

#pragma mark - tap on head icon
- (void)tapOnHeadIcon:(UITapGestureRecognizer *)tap
{
    NSLog(@"更换头像");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"设置头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选取", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
    
}

#pragma mark - action delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex; %d", buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.showsCameraControls = YES;
            picker.allowsEditing = YES;
            picker.delegate = self;
            [self presentModalViewController:picker animated:YES];
            [picker release];
        }
            break;
        case 1:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];

            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing = YES;
            picker.delegate = self;
            [self presentModalViewController:picker animated:YES];
            [picker release];
        }
            break;
        case 2:
            NSLog(@"设置头像取消");
            break;
        default:
            break;
    }
}

#pragma mark - image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.headIcon.image=[info valueForKey:UIImagePickerControllerEditedImage];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hud.labelText = @"上传头像";
    
    UIImage *smallImage = [self.headIcon.image scaleToFillSize:CGSizeMake(180.f, 180.f)];
    //addAndUpdateUserPic.json image userid imageurl
    NSString *userid = self.myInfo.userDetail.userid;
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:@"addAndUpdateUserPic.json", @"path",
                                                                        userid, @"userid",
                                                                        self.userDetail.picturelinkurl, @"imageurl", nil];
    
    NSLog(@"smallImage width: %f, height: %f", smallImage.size.width, smallImage.size.height);
    
    [DreamFactoryClient postWithParameters:paraDict image:smallImage success:^(id obj) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:@"上传成功" andImageName:nil];
    } failure:^{
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:@"上传失败" andImageName:nil];
    }];
    
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - table alert

#pragma mark - table alert data source
- (NSInteger)numberOfSectionsInTableAlert:(SBTableAlert *)tableAlert
{
    return 1;
}

- (NSInteger)tableAlert:(SBTableAlert *)tableAlert numberOfRowsInSection:(NSInteger)section
{
    return self.zdNameArray.count;
}

- (UITableViewCell *)tableAlert:(SBTableAlert *)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZDCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ZDCell" owner:self options:nil] lastObject];
    cell.nameLabel.text = [self.zdNameArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableAlert:(SBTableAlert *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZDCell *cell = (ZDCell *)[tableAlert.tableView cellForRowAtIndexPath:indexPath];
    NSString *zdString = [self.zdNameArray objectAtIndex:indexPath.row];
    if (![[self.zdDict objectForKey:zdString] intValue] == 0) {
        [self.zdDict setObject:[NSNumber numberWithInt:0] forKey:zdString];
        cell.selectImage.image = [UIImage imageNamed:@"unselected.png"];
    }
    else{
        [self.zdDict setObject:[NSNumber numberWithInt:indexPath.row+1] forKey:zdString];
        cell.selectImage.image = [UIImage imageNamed:@"selected.png"];
    }
}

- (CGFloat)tableAlert:(SBTableAlert *)tableAlert heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.f;
}

- (void)tableAlert:(SBTableAlert *)tableAlert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    __block int zdValueTmp = 0;
    [self.zdDict enumerateKeysAndObjectsUsingBlock:^(id key, NSNumber *num, BOOL *stop) {
        zdValueTmp += num.intValue;
    }];
    self.zdValue = [NSNumber numberWithInt:zdValueTmp];
    switch (zdValueTmp) {
        case 0:
            self.zdName = @"";
            break;
        case 1:
            self.zdName = @"招商";
            break;
        case 2:
            self.zdName = @"代理";
            break;
        case 3:
            self.zdName = @"招商/代理";
            break;
        default:
            break;
    }
    
    for (NSString *key in [self.zdDict allKeys]) {
        [self.zdDict setObject:[NSNumber numberWithInt:0] forKey:key];
    }
    
    //修改招商代理
    NSDictionary *invAgencyDict = [NSDictionary dictionaryWithObjectsAndKeys:@"changeInvAgency.json", @"path", self.zdValue, @"invagency", kAppDelegate.userId, @"userid", nil];
    
    [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    [DreamFactoryClient getWithURLParameters:invAgencyDict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            NSError *error = nil;
            self.myInfo.userDetail.invagency = [NSString stringWithFormat:@"%@",self.zdValue];
            if (![kAppDelegate.managedObjectContext save:&error])
            {
                NSLog(@"error %@", error);
            }
            else{
                [self showZD];
            }
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        }
        
    } failure:^(NSError *error) {
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
    }];
    
    [tableAlert release];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self removeObserver];
    [_headIcon release];
    [_nameLabel release];
    [_telLabel release];
    [_mailLabel release];
    [_modifyButton release];
    [_infoTableView release];
    [_messageButton release];
    [_mailButton release];
    [_chatButton release];
    [super dealloc];
}
@end
