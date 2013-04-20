//
//  MyHomePageViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-14.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "MyHomePageViewController.h"
#import "PersonalInfoCell.h"
#import "ContactHimView.h"
#import "ProvinceViewController.h"
#import "SelectPreferViewController.h"
#import "Pharmacology.h"
#import "PreferInfo.h"
#import "ModifyInfoView.h"
#import "MAlertView.h"
#import "SettingViewController.h"

#import "HomePageCell.h"
#import "CityInfo.h"
#import "Pharmacology.h"
#import "MyInfoController.h"

#import "UserDetail.h"

#import "UIImageView+WebCache.h"
#import "UIImage+Resizing.h"


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
    
    self.title = @"个人主页";
    
    self.userDetail = [[[UserDetail alloc] init] autorelease];
    
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
    self.selectorNameArray = [[[NSMutableArray alloc] initWithObjects:@"chooseAngencyOrBusiness", @"addArea:", @"addPrefer:", @"showExtra", @"setting", nil] autorelease];
    
    self.selectorArray = [[[NSMutableArray alloc] init] autorelease];
    [self.selectorNameArray enumerateObjectsUsingBlock:^(NSString *selectorName, NSUInteger idx, BOOL *stop) {
        SEL sel = NSSelectorFromString(selectorName);
        [self.selectorArray addObject:[NSValue valueWithPointer:sel]];
    }];
    
    UIImage *tableViewBgImage = [[UIImage imageNamed:@"underframe.png"] stretchableImageWithLeftCapWidth:290 topCapHeight:50];
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
    self.preferArray = [[[NSMutableArray alloc] init] autorelease];
    
    self.residentImageArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<2; i++) {
        UIImage *image = [UIImage imageNamed:@"myhomepage_location_bg.png"];
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
        [self.residentImageArray addObject:imageView];
    }
    
    self.preferImageArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<2; i++) {
        UIImage *image = [UIImage imageNamed:@"myhomepage_location_bg.png"];
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
        [self.preferImageArray addObject:imageView];
    }
    
    self.unreadCountArray = [[[NSMutableArray alloc] init] autorelease];
    
    [self getPersonalInfo];
    
}

- (void)getPersonalInfo
{
    //paradict getMypageDetail.json userid
    NSString *userid = [kAppDelegate userId];
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:userid, @"userid", @"getMypageDetail.json", @"path", nil];
    NSLog(@"get personinfo Dict: %@", paraDict);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hud.labelText = @"获取个人信息";
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        if ([[json objectForKey:@"returnCode"] longValue] == 0) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            NSDictionary *userDetailDict = [json objectForKey:@"UserDetail"];
            
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
            
            
            self.userDetail.userid = [[userDetailDict objectForKey:@"id"] longValue];
            self.userDetail.username = [userDetailDict objForKey:@"username"];
            self.userDetail.tel = [userDetailDict objForKey:@"tel"];
            self.userDetail.mailbox = [userDetailDict objForKey:@"mailbox"];
            self.userDetail.picturelinkurl = [userDetailDict objForKey:@"picturelinkurl"];
            self.userDetail.invagency = [[userDetailDict objForKey:@"invagency"] intValue];
            self.userDetail.autograph = [userDetailDict objForKey:@"autograph"];
            self.userDetail.col1 = [userDetailDict objectForKey:@"col1"];
            self.userDetail.col2 = [userDetailDict objectForKey:@"col2"];
            self.userDetail.col3 = [userDetailDict objectForKey:@"col3"];
            NSLog(@"picturelinkurl: %@", self.userDetail.picturelinkurl);
            
            [self.headIcon setImageWithURL:[NSURL URLWithString:self.userDetail.picturelinkurl] placeholderImage:[UIImage imageNamed:@"AC_L_icon.png"]];
            
            //取得未读消息
            int unreadCount = [[json objectForKey:@"UnreadCount"] intValue];
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
            
            NSArray *residentArray = [json objectForKey:@"AreaList"];
            NSLog(@"residentArray: %@", residentArray);
            [residentArray enumerateObjectsUsingBlock:^(NSDictionary *cityDict, NSUInteger idx, BOOL *stop) {
                if (idx>1) {
                    *stop = YES;
                }else{
                    CityInfo *city = [[CityInfo alloc] init];
                    [city setValuesForKeysWithDictionary:cityDict];
                    [self.residentArray addObject:city];
                    [city release];
                }
            }];
            
            [self addResidentFinished:nil];
            
            NSArray *preferArray = [json objectForKey:@"PreferList"];
            [preferArray enumerateObjectsUsingBlock:^(NSDictionary *preferDict, NSUInteger idx, BOOL *stop) {
                PreferInfo *prefer = [[PreferInfo alloc] init];
                prefer.prefername = [preferDict objectForKey:@"prefername"];
                prefer.preferId = [[preferDict objectForKey:@"id"] longValue];
                [self.preferArray addObject:prefer];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - table view datasouce

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
    }
    else{
        cell.addButton.hidden = YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.nameLabel.text = [self.leftArray objectAtIndex:indexPath.row];
    
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
            
            break;
        case 1:
            
            break;
        case 2:
            [self performSelector:sel];
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

//    NSLog(@"noti.object: %@", noti.object);
//    NSLog(@"residentarrray: %@", self.residentArray);
    
    [noti.object enumerateObjectsUsingBlock:^(CityInfo *city, NSUInteger idx, BOOL *stop) {
        if (![self.residentArray containsObject:city]) {
            [self.residentArray addObject:city];
        }
    }];
//    NSLog(@"residentarrray: %@", self.residentArray);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    
    HomePageCell *cell = (HomePageCell *)[self.infoTableView cellForRowAtIndexPath:indexPath];
    
    [self.residentImageArray enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        [[imageView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        imageView.hidden = YES;
    }];

    [self.residentArray enumerateObjectsUsingBlock:^(CityInfo *city, NSUInteger idx, BOOL *stop) {
        CGSize size = [city.cityname stringSizeWithMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:16];
//        NSLog(@"string width %f, string height %f", size.width, size.height);
        UILabel *residentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 5, size.width+15, size.height)] autorelease];
        residentLabel.backgroundColor = [UIColor clearColor];
        residentLabel.text = city.cityname;
        residentLabel.textColor = [UIColor whiteColor];
        residentLabel.textAlignment = NSTextAlignmentCenter;
        UIImageView *residentImageView = [self.residentImageArray objectAtIndex:idx];
        if (idx == 0) {
            [residentImageView setFrame:CGRectMake(100, 7, size.width+15, size.height+10)];
            [residentImageView addSubview:residentLabel];
        }
        else{
            UIImageView *lastImage = [self.residentImageArray objectAtIndex:idx-1];
            [residentImageView setFrame:CGRectMake(lastImage.frame.origin.x+lastImage.frame.size.width+10, 7, size.width+15, size.height+10)];
            [residentImageView addSubview:residentLabel];
        }
        [cell.contentView addSubview:residentImageView];
        [residentImageView setHidden:NO];
    }];
    [self.infoTableView reloadData];
    
    //上传数据
    //para: changezsarea.json provcityid userid
    NSString *userid = [kAppDelegate userId];
    NSMutableString *provinceid = [[NSMutableString alloc] init];
    [self.residentArray enumerateObjectsUsingBlock:^(CityInfo *city, NSUInteger idx, BOOL *stop) {
        [provinceid appendFormat:@"%@:%@,", city.provinceid, city.cityid];
    }];
    NSLog(@"provcityId: %@", provinceid);
    if (![provinceid isValid]) {
        provinceid = [NSMutableString stringWithString:@"P5:C617"];
    }
    else{
        provinceid = (NSMutableString *)[provinceid substringToIndex:[provinceid length]-1];
    }
    

    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:provinceid, @"provcityid", userid, @"userid", @"changezsarea.json", @"path", nil];
    
    NSLog(@"para dict %@", paraDict);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        NSLog(@"add resident %@", json);
        
        
        [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
    
}

- (void)addPreferFinished:(NSNotification *)noti
{    
//    NSLog(@"noti.object: %@", noti.object);
//    NSLog(@"preferArray: %@", self.preferArray);
    
    [noti.object enumerateObjectsUsingBlock:^(PreferInfo *prefer, NSUInteger idx, BOOL *stop) {
        if (![self.preferArray containsObject:prefer]) {
            [self.preferArray addObject:prefer];
        }
    }];
//    NSLog(@"preferArray: %@", self.preferArray);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    
    HomePageCell *cell = (HomePageCell *)[self.infoTableView cellForRowAtIndexPath:indexPath];
    
    [self.preferImageArray enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        [[imageView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        imageView.hidden = YES;
    }];
    
    [self.preferArray enumerateObjectsUsingBlock:^(PreferInfo *prefer, NSUInteger idx, BOOL *stop) {
        NSString *prefername = [NSString stringWithFormat:@"%@", prefer.prefername];
        
        CGSize size = [prefername stringSizeWithMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:16];
//        NSLog(@"string width %f, string height %f", size.width, size.height);
        CGFloat     labelWidth = MIN(size.width+15, 48);
        UILabel *residentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 5, labelWidth, size.height)] autorelease];
        residentLabel.backgroundColor = [UIColor clearColor];
        residentLabel.text = prefername;
        residentLabel.textColor = [UIColor whiteColor];
        residentLabel.textAlignment = NSTextAlignmentCenter;
        UIImageView *residentImageView = [self.preferImageArray objectAtIndex:idx];
        if (idx == 0) {
            [residentImageView setFrame:CGRectMake(100, 7, labelWidth, size.height+10)];
            [residentImageView addSubview:residentLabel];
        }
        else{
            UIImageView *lastImage = [self.preferImageArray objectAtIndex:idx-1];
            [residentImageView setFrame:CGRectMake(lastImage.frame.origin.x+lastImage.frame.size.width+10, 7, labelWidth, size.height+10)];
            [residentImageView addSubview:residentLabel];
        }
        [cell.contentView addSubview:residentImageView];
        [residentImageView setHidden:NO];
    }];
    [self.infoTableView reloadData];
    
    //上传数据
    //para: changezsarea.json provcityid userid
    NSString *userid = [kAppDelegate userId];
    NSMutableString *preferid = [[NSMutableString alloc] init];
    [self.preferArray enumerateObjectsUsingBlock:^(PreferInfo *prefer, NSUInteger idx, BOOL *stop) {
        [preferid appendFormat:@"%ld,", prefer.preferId];
    }];
//    NSLog(@"provcityId: %@", preferid);
    if (![preferid isValid]) {
        preferid = [NSMutableString stringWithString:@"1"];
    }
    else{
        preferid = (NSMutableString *)[preferid substringToIndex:[preferid length]-1];
    }
    
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:preferid, @"preferid", userid, @"userid", @"changeprefer.json", @"path", nil];
    
    NSLog(@"para dict %@", paraDict);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        NSLog(@"add resident %@", json);
        
        
        [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
    
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
        
        
        //userid mail tel name path
        NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:kAppDelegate.userId, @"userid", name, @"name", tel, @"tel", mail, @"mail", @"updateZsUserDetail.json", @"path", nil];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
        hud.labelText = @"更新用户信息";
        [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            self.nameLabel.text = name;
            self.telLabel.text = tel;
            self.mailLabel.text = mail;
            
            [PersistenceHelper setData:name forKey:@"username"];
            [PersistenceHelper setData:tel forKey:@"tel"];
            [PersistenceHelper setData:mail forKey:@"mail"];
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
    NSLog(@"chooseAngencyOrBusiness");
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

- (void)addPrefer:(UIButton *)sender
{
    SelectPreferViewController *selectPreferVC = [[SelectPreferViewController alloc] init];
    selectPreferVC.selectArray = self.preferArray;
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
    [self.navigationController pushViewController:settingVC animated:YES];
    [settingVC release];
}

#pragma  mark - about contact
- (void)message:(UIButton *)sender
{
    NSLog(@"message");
}

- (void)email:(UIButton *)sender
{
    NSLog(@"email");
}

- (void)chat:(UIButton *)sender
{
    MyInfoController *myInfoController = [[MyInfoController alloc] init];
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
            picker.showsCameraControls = YES;
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
    self.headIcon.image=[info valueForKey:UIImagePickerControllerOriginalImage];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hud.labelText = @"上传头像";
    
    CGFloat scale = self.headIcon.image.size.height / 118.f;
//    UIImage *smallImage = [UIImage imageWithCGImage:self.headIcon.image.CGImage scale:scale orientation:self.headIcon.image.imageOrientation];
    UIImage *smallImage = [self.headIcon.image scaleToFillSize:CGSizeMake(180.f, 180.f)];
    //addAndUpdateUserPic.json image userid imageurl
    NSString *userid = [NSString stringWithFormat:@"%ld", self.userDetail.userid];
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
