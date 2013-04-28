//
//  SettingViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-15.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "SettingViewController.h"
#import "MenuCell.h"
#import "LoginViewController.h"

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
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"debut_light.png"]];
    bgImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:bgImageView];
    [bgImageView release];
    
    UIImage *tableBgImage = [[UIImage imageNamed:@"table_underframe.png"] stretchableImageWithLeftCapWidth:290 topCapHeight:56];
    UIImageView *tableBgImageView = [[[UIImageView alloc] initWithImage:tableBgImage] autorelease];
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
    
    self.menuNameArray = [[[NSMutableArray alloc] initWithObjects:@"注销登录", @"修改密码", @"意见反馈", @"新手引导", @"应用推荐", @"关于", nil] autorelease];
    self.selectorNameArray = [[[NSMutableArray alloc] initWithObjects:@"logoff", @"modifyPassword", @"feedback", @"newcomer", @"appCommand", @"about", nil] autorelease];
    
    self.selectorArray = [[[NSMutableArray alloc] init] autorelease];
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

- (void)logoff
{
    NSLog(@"registAndLogin");
    [PersistenceHelper setData:@"" forKey:KUserName];
    [PersistenceHelper setData:@"" forKey:kUserId];
    [PersistenceHelper setData:@"" forKey:KPassWord];
    NSString *userDataFile = [PersistenceHelper dataForKey:kUserDataFile];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if ([fileManger fileExistsAtPath:userDataFile]) {
        NSError *error;
        if (![fileManger removeItemAtPath:userDataFile error:&error]) {
            NSLog(@"log off, remove userdata %@", error);
        }
    }
    
//    [self clearData];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
//    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self.MyHomeVC name:kAddResidentNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self.MyHomeVC name:kSelectPharFinished object:nil];
    [self.navigationController pushViewController:loginVC animated:YES];
    [loginVC release];
}

//- (void)clearData
//{
//    //clear all user info
//    NSFetchRequest * allUsers = [[NSFetchRequest alloc] init];
//    [allUsers setEntity:[NSEntityDescription entityForName:@"UserDetail" inManagedObjectContext:kAppDelegate.managedObjectContext]];
//    [allUsers setIncludesPropertyValues:NO]; //only fetch the managedObjectID
//    
//    NSError * error = nil;
//    NSArray * cars = [kAppDelegate.managedObjectContext executeFetchRequest:allUsers error:&error];
//    [allUsers release];
//    for (NSManagedObject * user in cars) {
//        [kAppDelegate.managedObjectContext deleteObject:user];
//    }
//    error = nil;
//    
//    NSFetchRequest *myInfoRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *myInfo = [NSEntityDescription entityForName:@"MyInfo" inManagedObjectContext:kAppDelegate.managedObjectContext];
//    [myInfoRequest setEntity:myInfo];
//    NSArray *myInfos = [kAppDelegate.managedObjectContext executeFetchRequest:myInfoRequest error:&error];
//    [myInfo release];
//    
//    for (NSManagedObject *myinfo in myInfos) {
//        [kAppDelegate.managedObjectContext deleteObject:myinfo];
//    }
//    
//    
//    NSError *saveError = nil;
//    [kAppDelegate.managedObjectContext save:&saveError];
//}

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
