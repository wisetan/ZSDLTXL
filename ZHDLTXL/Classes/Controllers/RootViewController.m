//
//  RootViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-8.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "RootViewController.h"
#import "ContactCell.h"
#import "Contact.h"
#import "ProvinceViewController.h"
#import "LoginViewController.h"
#import "SendMessageViewController.h"
#import "SendEmailViewController.h"
#import "ChatViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //contact array
    self.contactArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    //nav bar image
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topmargin.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    //bottom image view
	self.bottomImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_bg.png"]] autorelease];
    self.bottomImageView.frame = CGRectMake(0, self.view.frame.size.height-45-44, 320, 45);
    self.bottomImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.bottomImageView];
    [self.bottomImageView release];
    
    //login button
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.loginButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    [self.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.frame = CGRectMake(5, 5, 101, 34);
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 101.f, 34.f)];
    loginLabel.text = @"登录";
    [loginLabel setFont:[UIFont systemFontOfSize:16]];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.textAlignment = NSTextAlignmentCenter;
    [self.loginButton addSubview:loginLabel];
    [self.bottomImageView addSubview:self.loginButton];
    
    
    //select button
    self.selButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.selButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    [self.selButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    self.selButton.frame = CGRectMake(214, 5, 101, 34);
    UILabel *selLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 101, 34)];
    selLabel.text = @"筛选";
    [selLabel setFont:[UIFont systemFontOfSize:16]];
    selLabel.backgroundColor = [UIColor clearColor];
    selLabel.textColor = [UIColor whiteColor];
    selLabel.textAlignment = NSTextAlignmentCenter;
    [self.selButton addSubview:selLabel];
    [self.bottomImageView addSubview:self.selButton];
    
    //contact table view
    self.contactTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44-45)] autorelease];
    [self.contactTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.contactTableView.delegate = self;
    self.contactTableView.dataSource = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [self.contactTableView addGestureRecognizer:tap];
    
    [self.view addSubview:self.contactTableView];
    
    //contactHimView
    self.contactHimView = [[ContactHimView alloc] initWithFrame:CGRectMake(0, 0, 256, 56)];
    [self.view addSubview:self.contactHimView];
    self.contactHimView.center = CGPointMake(self.contactTableView.center.x + 320, self.contactTableView.center.y);
    self.contactHimView.delegate = self;
    
    //left area barbutton
    self.areaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.areaButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.areaButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    [self.areaButton addTarget:self action:@selector(selectArea:) forControlEvents:UIControlEventTouchUpInside];
    self.areaButton.frame = CGRectMake(0, 0, 101, 34);
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 101, 34)];
    areaLabel.text = @"北京";
    [areaLabel setFont:[UIFont systemFontOfSize:16]];
    areaLabel.backgroundColor = [UIColor clearColor];
    areaLabel.textColor = [UIColor whiteColor];
    areaLabel.textAlignment = NSTextAlignmentCenter;
    [self.areaButton addSubview:areaLabel];
    
    UIImageView *areaIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_icon.png"]];
    areaIcon.frame = CGRectMake(7, 3, 28, 28);
    areaIcon.userInteractionEnabled = YES;
    [self.areaButton addSubview:areaIcon];
    
    UIBarButtonItem *lBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.areaButton];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    //left friend barbutton
    self.friendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.friendButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.friendButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    [self.friendButton addTarget:self action:@selector(myFriend:) forControlEvents:UIControlEventTouchUpInside];
    self.friendButton.frame = CGRectMake(0, 0, 101, 34);
    UILabel *friendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 101, 34)];
    friendLabel.text = @"我的好友";
    [friendLabel setFont:[UIFont systemFontOfSize:16]];
    friendLabel.backgroundColor = [UIColor clearColor];
    friendLabel.textColor = [UIColor whiteColor];
    friendLabel.textAlignment = NSTextAlignmentCenter;
    [self.friendButton addSubview:friendLabel];
    
    UIBarButtonItem *rBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.friendButton];
    [self.navigationItem setRightBarButtonItem:rBarButton];
    
    
}

- (void)login:(UIButton *)sender
{
    NSLog(@"login");
    LoginViewController *loginVC = nil;
    if (IS_IPHONE_5) {
        loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController_ip5" bundle:nil];
    }
    else{
        loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:loginVC animated:YES];
    [loginVC release];
}

- (void)select:(UIButton *)sender
{
    NSLog(@"select");
}

- (void)selectArea:(UIButton *)sender
{
    NSLog(@"select area");
    ProvinceViewController *areaVC = [[ProvinceViewController alloc] init];
    [self.navigationController pushViewController:areaVC animated:YES];
    [areaVC release];
}

- (void)myFriend:(UIButton *)sender
{
    NSLog(@"my friend");
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"contactCell";
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    cell.headIcon.image = [UIImage imageNamed:@"AC_talk_icon.png"];
    cell.nameLabel.text = @"姓名";
    [cell.contactButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [cell.contactButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    cell.contactButton.index = indexPath.row;
    [cell.contactButton addTarget:self action:@selector(contactHim:) forControlEvents:UIControlEventTouchUpInside];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnCellButton:)];
//    [cell.contactButton addGestureRecognizer:tap];
    self.currentContact = nil;  //[self.contactArray objectAtIndex:indexPath.row];

    return cell;
}

- (void)contactHim:(CellButton *)sender
{
    NSLog(@"sender.index: %d, cur index: %d", sender.index, self.currentCellButtonIndex);
    if (sender.index == self.currentCellButtonIndex && self.contactHimView.isAppeared == YES) {
        return;
    }
    else{
        self.currentCellButtonIndex = sender.index;
    }
    if (self.contactHimView.isAppeared) {
        self.contactHimView.isAppeared = NO;
        [UIView animateWithDuration:1.f animations:^{
            self.contactHimView.center = CGPointMake(self.contactHimView.center.x+320, self.contactHimView.center.y);
        }];
        return;
    }
    self.contactHimView.isAppeared = YES;
    [UIView animateWithDuration:1.f animations:^{
        self.contactHimView.center = self.contactTableView.center;
    }];
    self.contactTableView.scrollEnabled = NO;
}


- (void)didTapOnTableView:(UIGestureRecognizer*) recognizer
{
    if (self.contactHimView.isAppeared) {
        [UIView animateWithDuration:1.f animations:^{
            self.contactHimView.center = CGPointMake(self.contactTableView.center.x+320, self.contactTableView.center.y);
        }];
        
        self.contactHimView.isAppeared = NO;
        self.contactTableView.userInteractionEnabled = YES;
        self.contactTableView.scrollEnabled = YES;
    }
}

#pragma mark - contactHimView delegate

- (void)message:(Contact *)contact
{
    NSLog(@"send message");
    SendMessageViewController *smVC = [[SendMessageViewController alloc] init];
    [self.navigationController pushViewController:smVC animated:YES];
    [smVC release];
}

- (void)email:(Contact *)contact
{
    NSLog(@"send email");
    SendEmailViewController *seVC = [[SendEmailViewController alloc] init];
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
