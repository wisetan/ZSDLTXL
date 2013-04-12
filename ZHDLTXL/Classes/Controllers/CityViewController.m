//
//  CityViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-9.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "CityViewController.h"
#import "CityInfo.h"
#import "Contact.h"

@interface CityViewController ()

@end

@implementation CityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"选择城市";
    
    //back button
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.backBarButton];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    self.cityTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44) style:UITableViewStylePlain] autorelease];
    [self.cityTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.cityTableView];
    self.cityTableView.dataSource = self;
    self.cityTableView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cityArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"areaCell";
    AreaCell *cell = (AreaCell *)[self.cityTableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AreaCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.areaNameLabel.text = [[self.cityArray objectAtIndex:indexPath.row] cityname];
    [cell.areaNameLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateHighlighted];
    cell.selectButton.index = indexPath.row;
    [cell.selectButton addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

- (void)selectCity:(CellButton *)sender
{
    //parameter: provinceid, cityid, userid(用来取备注),
    
    NSString *cityId = [[self.cityArray objectAtIndex:sender.index] cityid];
    NSString *provinceId = [[self.cityArray objectAtIndex:sender.index] provinceid];
    long userId = [kAppDelegate.userId longLongValue];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:cityId, @"cityid", provinceId, @"provinceid", [NSNumber numberWithLong:userId], @"userid", @"getInvestmentUserList.json", @"path", nil];
    NSLog(@"parameter: %@", dict);
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hub.labelText = @"获取商家列表";
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            
//            self.username = nil;
//            self.tel = nil;
//            self.mailbox = nil;
//            self.picturelinkurl = nil;
//            self.col1 = nil;
//            self.col2 = nil;
//            self.col3 = nil;;
            
            
//            NSLog(@"商家列表：%@", json);
            NSMutableArray *contactArray = [NSMutableArray new];
            [[json objectForKey:@"InvestmentUserList"] enumerateObjectsUsingBlock:^(NSDictionary *contactDict, NSUInteger idx, BOOL *stop) {
//                NSLog(@"contact Dict: %@", contactDict);
                Contact *contact = [Contact new];
                contact.userid = [[contactDict objectForKey:@"id"] longValue];
                contact.username = [contactDict objForKey:@"username"];
                contact.tel = [contactDict objForKey:@"tel"];
                contact.mailbox = [contactDict objectForKey:@"mailbox"];
                contact.picturelinkurl = [contactDict objectForKey:@"picturelinkurl"];
                contact.col1 = [contactDict objectForKey:@"col1"];
                contact.col2 = [contactDict objectForKey:@"col2"];
                contact.col2 = [contactDict objectForKey:@"col2"];
                [contactArray addObject:contact];
                [contact release];
            }];
            
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kInvestmentUserListRefreshed object:contactArray];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            
            //            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kRegistSucceed object:nil];
        } else {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

#pragma mark - table view delegate


@end
