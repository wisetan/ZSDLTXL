//
//  MyHomePageViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-14.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "MyHomePageViewController.h"
#import "PersonalInfoCell.h"

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
    
    self.modifyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.modifyButton.frame = CGRectMake(250, 15, 50, 30);
    [self.modifyButton setTitle:@"修改" forState:UIControlStateNormal];
    [self.modifyButton addTarget:self action:@selector(modifyInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.modifyButton];
    
    
    
    UIImage *infoBgImage = [[UIImage imageNamed:@"underframe.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
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
    
    UILabel* settingLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 152, 80, 40)];
    settingLabel.text = @"我的设置";
    settingLabel.backgroundColor = [UIColor clearColor];
    settingLabel.font = [UIFont systemFontOfSize:14];
    [infoBgImageView addSubview:settingLabel];
    
    
    
    
    
    
    
    
    
    
    self.cellNameArray = [NSArray arrayWithObjects:@"常驻地区", @"类别偏好", @"账户余额", @"我的设置", nil];
    
    
    
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)modifyInfo:(UIButton *)sender
{
    NSLog(@"修改用户信息");
}

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
    
}

- (void)addPrefer:(UIButton *)sender
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
