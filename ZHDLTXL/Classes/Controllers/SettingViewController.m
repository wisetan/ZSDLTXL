//
//  SettingViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-15.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "SettingViewController.h"
#import "MenuCell.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

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
    
    self.title = @"设置";
    
    //back button
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.backBarButton];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"debut_light.png"]];
    bgImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:bgImageView];
    [bgImageView release];
    
    UIImage *tableBgImage = [[UIImage imageNamed:@"underframe.png"] stretchableImageWithLeftCapWidth:290 topCapHeight:56];
    UIImageView *tableBgImageView = [[UIImageView alloc] initWithImage:tableBgImage];
    tableBgImageView.userInteractionEnabled = YES;
    tableBgImageView.frame = CGRectMake(20, 20, 280, 306);
    [self.view addSubview:tableBgImageView];
    
    
    self.menuTableView = [[[UITableView alloc] initWithFrame:CGRectMake(20, 20, 280, 306) style:UITableViewStylePlain] autorelease];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.scrollEnabled = NO;
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.menuTableView setBackgroundView:tableBgImageView];
    self.menuTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.menuTableView];
    
    self.menuNameArray = [[NSMutableArray alloc] initWithObjects:@"注销登录", @"修改密码", @"意见反馈", @"新手引导", @"应用推荐", @"关于", nil];
    self.selectorNameArray = [[NSMutableArray alloc] initWithObjects:@"registAndLogin", @"modifyPassword", @"feedback", @"newcomer", @"appCommand", @"about", nil];
    
    self.selectorArray = [[NSMutableArray alloc] init];
    [self.selectorNameArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.selectorArray addObject:[NSValue valueWithPointer:NSSelectorFromString([self.selectorNameArray objectAtIndex:idx])]];
    }];
    
}

#pragma mark - table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuNameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"menuCell";
    MenuCell *menuCell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (menuCell == nil) {
        menuCell = [[[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil] lastObject];
    }
    [menuCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    menuCell.nameLabel.text = [self.menuNameArray objectAtIndex:indexPath.row];
    menuCell.nameLabel.textColor = kContentColor;
    if (indexPath.row == self.menuNameArray.count-1) {
        menuCell.separatorImage.image = nil;
    }
    return menuCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:[[self.selectorArray objectAtIndex:indexPath.row] pointerValue]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.f;
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registAndLogin
{
    NSLog(@"registAndLogin");
}

- (void)modifyPassword
{
    NSLog(@"modifyPassword");
}

- (void)feedback
{
    NSLog(@"feedback");
}

- (void)newcomer
{
    NSLog(@"newcomer");
}

- (void)appCommand
{
    NSLog(@"appCommand");
}

- (void)about
{
    NSLog(@"about");
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
