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
#import "ModifyInfoView.h"
#import "MAlertView.h"
#import "SettingViewController.h"


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
    
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.backBarButton];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    self.nameLabel.text = @"王老总";
    self.telLabel.text = @"1234567890";
    self.mailLabel.text = @"123@qq.com";
    
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"debut_light.png"]];
    bgImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:bgImage];
    
    UIImageView *accountBgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myhomepage_bg.png"]];
    accountBgImage.frame = CGRectMake(0, 0, 320, 100);
    [self.view addSubview:accountBgImage];
    
    self.headIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AC_L_icon.png"]];
    self.headIcon.frame = CGRectMake(18, 15, 70, 70);
    [self.view addSubview:self.headIcon];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 150, 25)];
    self.nameLabel.text = @"王老总";
    self.nameLabel.textColor = kContentColor;
    self.nameLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.nameLabel];
    
    self.telLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, 150, 20)];
    self.telLabel.text = @"1234567890";
    self.telLabel.textColor = kContentColor;
    self.telLabel.backgroundColor = [UIColor clearColor];
    self.telLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.telLabel];
    
    self.mailLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 65, 150, 20)];
    self.mailLabel.text = @"123@qq.com";
    self.mailLabel.textColor = kContentColor;
    self.mailLabel.backgroundColor = [UIColor clearColor];
    self.mailLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.mailLabel];
    
    self.modifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.modifyButton.frame = CGRectMake(250, 15, 50, 30);
    [self.modifyButton setImage:[UIImage imageNamed:@"alter_button"] forState:UIControlStateNormal];
    [self.modifyButton setImage:[UIImage imageNamed:@"alter_button_p.png"] forState:UIControlStateHighlighted];
    [self.modifyButton addTarget:self action:@selector(modifyInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.modifyButton];
    
    
    
    UIImage *infoBgImage = [[UIImage imageNamed:@"underframe.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:20];
    UIImageView *infoBgImageView = [[UIImageView alloc] initWithImage:infoBgImage];
    infoBgImageView.userInteractionEnabled = YES;
    infoBgImageView.frame = CGRectMake(20, 120, 280, 200);
    
    [self.view addSubview:infoBgImageView];
    
    for (int i=0; i<3; i++) {
        UIImageView *sepView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator.png"]];
        sepView.frame = CGRectMake(0, infoBgImageView.frame.size.height * (i+1) / 4, 280, 1);
        [infoBgImageView addSubview:sepView];
    }
    
    
    UILabel* residentAreaLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 80, 40)];
    residentAreaLabel.text = @"常驻地区:";
    residentAreaLabel.textColor = kContentBlueColor;
    residentAreaLabel.backgroundColor = [UIColor clearColor];
    [infoBgImageView addSubview:residentAreaLabel];
    
    UILabel* preferLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, 80, 40)];
    preferLabel.text = @"类别偏好:";
    preferLabel.textColor = kContentBlueColor;
    preferLabel.backgroundColor = [UIColor clearColor];
    [infoBgImageView addSubview:preferLabel];
    
    UILabel* balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 105, 80, 40)];
    balanceLabel.text = @"账户余额:";
    balanceLabel.backgroundColor = [UIColor clearColor];
    balanceLabel.textColor = kContentBlueColor;
    [infoBgImageView addSubview:balanceLabel];
    
    UILabel* settingLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 155, 152, 40)];
    settingLabel.userInteractionEnabled = YES;
    settingLabel.text = @"我的设置";
    settingLabel.backgroundColor = [UIColor clearColor];
    settingLabel.font = [UIFont systemFontOfSize:14];
    [infoBgImageView addSubview:settingLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnMySetting:)];
    [settingLabel addGestureRecognizer:tap];
    
    
    UIButton *addAreaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addAreaButton setImage:[UIImage imageNamed:@"more_select.png"] forState:UIControlStateNormal];
    [addAreaButton setImage:[UIImage imageNamed:@"more_select_p.png"] forState:UIControlStateHighlighted];
    [addAreaButton addTarget:self action:@selector(addArea:) forControlEvents:UIControlEventTouchUpInside];
    addAreaButton.frame = CGRectMake(240, 7, 36, 36);
    [infoBgImageView addSubview:addAreaButton];
    
    UIButton *addPreferButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addPreferButton setImage:[UIImage imageNamed:@"more_select.png"] forState:UIControlStateNormal];
    [addPreferButton setImage:[UIImage imageNamed:@"more_select_p.png"] forState:UIControlStateHighlighted];
    [addPreferButton addTarget:self action:@selector(addPrefer:) forControlEvents:UIControlEventTouchUpInside];
    addPreferButton.frame = CGRectMake(240, 57, 36, 36);
    [infoBgImageView addSubview:addPreferButton];
    
    UILabel* balanceLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(200, 105, 80, 40)];
    balanceLabel2.text = @"账户余额:";
    balanceLabel2.backgroundColor = [UIColor clearColor];
    balanceLabel2.textColor = kContentBlueColor;
    [infoBgImageView addSubview:balanceLabel];
    
    
    ContactHimView *contactHimView = [[ContactHimView alloc] initWithFrame:CGRectMake(20, 300, 280, 60)];
    contactHimView.delegate = self;
    contactHimView.contact = nil;
    
    self.residentArray = [[[NSMutableArray alloc] init] autorelease];
    self.preferArray = [[[NSMutableArray alloc] init] autorelease];
    self.residentImageArray = [[[NSMutableArray alloc] init] autorelease];
    self.preferImageArray = [[[NSMutableArray alloc] init] autorelease];
    
    
    for (int i=0; i<2; i++) {
        UIImage *residentImage = [[UIImage imageNamed:@"myhomepage_location_bg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:residentImage];
        imageView.hidden = YES;
        [self.residentImageArray addObject:imageView];
        [infoBgImageView addSubview:imageView];
    }
    
    for (int i=0; i<2; i++) {
        UIImage *preferImage = [[UIImage imageNamed:@"myhomepage_location_bg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:preferImage];
        imageView.hidden = YES;
        [self.preferImageArray addObject:imageView];
        [infoBgImageView addSubview:imageView];
    }
    
    
//    self.modifyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 160)];
    
    
}

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addResidentFinished:) name:kAddResidentNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPreferFinished:) name:kSelectPharFinished object:nil];
}

- (void)addResidentFinished:(NSNotification *)noti
{
    NSLog(@"residentarrray: %@", self.residentArray);
    NSLog(@"new city: %@", noti.object);
    NSString *residentName = noti.object;
    if (![self.residentArray containsObject:residentName]) {
        [self.residentArray addObject:residentName];
        [self.residentArray enumerateObjectsUsingBlock:^(NSString *cityName, NSUInteger idx, BOOL *stop) {
            CGSize size = [cityName stringSizeWithMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:16];
            NSLog(@"string width %f, string height %f", size.width, size.height);
            UILabel *residentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, size.width+15, size.height)];
            residentLabel.backgroundColor = [UIColor clearColor];
            residentLabel.text = cityName;
            residentLabel.textColor = [UIColor whiteColor];
            residentLabel.textAlignment = NSTextAlignmentCenter;
            UIImageView *residentImageView = [self.residentImageArray objectAtIndex:idx];
            if (idx == 0) {
                [residentImageView setFrame:CGRectMake(100, 13, size.width+15, size.height+10)];
                [residentImageView addSubview:residentLabel];
            }
            else{
                UIImageView *lastImage = [self.residentImageArray objectAtIndex:idx-1];
                [residentImageView setFrame:CGRectMake(lastImage.frame.origin.x+lastImage.frame.size.width+10, 13, size.width+15, size.height+10)];
                [residentImageView addSubview:residentLabel];
            }
            [residentImageView setHidden:NO];
        }];
    }
}

- (void)addPreferFinished:(NSNotification *)noti
{
    [self.preferArray removeAllObjects];
    [self.preferArray addObjectsFromArray:noti.object];
    [self.preferArray enumerateObjectsUsingBlock:^(Pharmacology *phar, NSUInteger idx, BOOL *stop) {
        CGSize size = [phar.content stringSizeWithMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:16];
        NSLog(@"string width %f, string height %f", size.width, size.height);
        UILabel *residentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, size.width+15, size.height)];
        residentLabel.backgroundColor = [UIColor clearColor];
        residentLabel.text = phar.content;
        residentLabel.textColor = [UIColor whiteColor];
        residentLabel.textAlignment = NSTextAlignmentCenter;
        UIImageView *residentImageView = [self.preferImageArray objectAtIndex:idx];
        if (idx == 0) {
            [residentImageView setFrame:CGRectMake(100, 63, size.width+15, size.height+10)];
            [residentImageView addSubview:residentLabel];
        }
        else{
            UIImageView *lastImage = [self.preferImageArray objectAtIndex:idx-1];
            [residentImageView setFrame:CGRectMake(lastImage.frame.origin.x+lastImage.frame.size.width+10, 63, size.width+15, size.height+10)];
            [residentImageView addSubview:residentLabel];
        }
        [residentImageView setHidden:NO];
    }];
}

- (void)tapOnMySetting:(UITapGestureRecognizer *)sender
{
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
    [settingVC release];
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)modifyInfo:(UIButton *)sender
{
//    NSLog(@"修改用户信息");
//    ModifyInfoView *modifyView = [[[NSBundle mainBundle] loadNibNamed:@"ModifyInfoView" owner:self options:nil] lastObject];
//    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(50, 50, 100, 50)];
//    textfield.borderStyle = UITextBorderStyleRoundedRect;
////    modifyView.frame = CGRectMake(10, 45, 260, 127);
////    [self.view addSubview:modifyView];
////    modifyView.nameTextfield.delegate = self;
////    modifyView.telTextfield.delegate = self;
////    modifyView.mailTextfield.delegate = self;
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改个人信息" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
////    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
////    [alert addSubview:modifyView];
//    [alert addSubview:textfield];
//    [alert show];
    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 45)];
    self.telField = [[UITextField alloc] initWithFrame:CGRectMake(0, 45, 200, 45)];
    self.mailField = [[UITextField alloc] initWithFrame:CGRectMake(0, 90, 200, 45)];
    
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
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:@"更新失败" andImageName:nil];
        }];
        
        
    }
    else{
        return;
    }
}

//- (void)willPresentAlertView:(UIAlertView *)alertView
//{
//    alertView.frame = CGRectMake(0, 0, 280, 230);
//    alertView.center = self.view.center;
//    int i = 0;
//    for (UIView *view in [alertView subviews]) {
//        if ([view isKindOfClass:[UIButton class]]) {
//            view.frame = CGRectMake(15+i*130, 170, 120, 40);
//            i++;
//        }
//    }
//}

#pragma mark - table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellID = @"cellID";
    PersonalInfoCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonalInfoCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = [self.cellNameArray objectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case 0:
            [cell.setInfoButton addTarget:self action:@selector(addArea:) forControlEvents:UIControlEventTouchUpInside];
            [cell.setInfoButton setImage:[UIImage imageNamed:@"more_select_p.png"] forState:UIControlStateHighlighted];
            break;
        case 1:
            [cell.setInfoButton addTarget:self action:@selector(addPrefer:) forControlEvents:UIControlEventTouchUpInside];
            [cell.setInfoButton setImage:[UIImage imageNamed:@"more_select_p.png"] forState:UIControlStateHighlighted];
            break;
        case 2:
            cell.setInfoButton.hidden = YES;
            break;
        case 3:
            cell.setInfoButton.hidden = YES;
            break;
        default:
            break;
    }
    
    return cell;
    
}

- (void)addArea:(UIButton *)sender
{
    if ([self.residentArray count] == 2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"最多选择两个常驻地区" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    ProvinceViewController *provinceVC = [[ProvinceViewController alloc] init];
    provinceVC.isAddResident = YES;
    provinceVC.homePageVC = self;
    [self.navigationController pushViewController:provinceVC animated:YES];
    [provinceVC release];
}

- (void)addPrefer:(UIButton *)sender
{
    SelectPreferViewController *selectPreferVC = [[SelectPreferViewController alloc] init];
    [self.navigationController pushViewController:selectPreferVC animated:YES];
    [selectPreferVC release];
}

- (void)message:(Contact *)contact
{
    
}

- (void)email:(Contact *)contact
{
    
}

- (void)chat:(Contact *)contact
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_headIcon release];
    [_nameLabel release];
    [_telLabel release];
    [_mailLabel release];
    [_modifyButton release];
    [super dealloc];
}
@end
