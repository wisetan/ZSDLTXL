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

- (void)viewWillAppear:(BOOL)animated
{
    [self.cityTableView reloadData];
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
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    if (self.isAddResident) {
        self.cityTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44-45) style:UITableViewStylePlain] autorelease];
        UIImageView *bottomImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_bg.png"]] autorelease];
        bottomImageView.userInteractionEnabled = YES;
        bottomImageView.frame = CGRectMake(0, self.view.frame.size.height-45-44, 320, 45);
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
        [confirmButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
        confirmButton.frame = CGRectMake(110, 5, 101, 34);
        [confirmButton addTarget:self action:@selector(confirmSelect:) forControlEvents:UIControlEventTouchUpInside];
        [bottomImageView addSubview:confirmButton];
        
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 101, 34)] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"确认";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [confirmButton addSubview:label];
        [self.view addSubview:bottomImageView];
    }
    else{
        self.cityTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44) style:UITableViewStylePlain] autorelease];
        
    }
    [self.cityTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.cityTableView];

    self.cityTableView.dataSource = self;
    self.cityTableView.delegate = self;
    
    
    if ([self.selectCityArray count] == 0) {
        self.selectCityArray = [[[NSMutableArray alloc] init] autorelease];
    }
    
    NSLog(@"已选城市: %@", self.selectCityArray);

}

- (void)confirmSelect:(UIButton *)sender
{
    if (self.isAddResident) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kAddResidentNotification object:self.selectCityArray];
        [self.navigationController popToViewController:self.homePageVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)backToRootVC:(UIButton *)sender
{
    if (self.isAddResident) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kAddResidentNotification object:self.selectCityArray];
        [self.navigationController popToViewController:self.homePageVC animated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.f;
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
    

    CityInfo *city = [self.cityArray objectAtIndex:indexPath.row];
    NSLog(@"city: %@", city);
    NSLog(@"已选城市: %@", self.selectCityArray);
    if ([self haveSelectTheCity:city]) {
        cell.selectImage.image = [UIImage imageNamed:@"selected.png"];
    }
    else{
        cell.selectImage.image = [UIImage imageNamed:@"unselected.png"];
    }
    
    return cell;
}

- (BOOL)haveSelectTheCity:(CityInfo *)city
{
    __block BOOL isSelect = NO;
    [self.selectCityArray enumerateObjectsUsingBlock:^(CityInfo *selectCity, NSUInteger idx, BOOL *stop) {
        if ([selectCity.cityid isEqualToString:city.cityid]) {
            isSelect = YES;
            *stop = YES;
        }
        
    }];
    return isSelect;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //parameter: provinceid, cityid, userid(用来取备注),
    
    CityInfo *city = [self.cityArray objectAtIndex:indexPath.row];
    if (self.isAddResident) {
        if (self.selectCityArray.count == 2 && ![self haveSelectTheCity:city]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"最多选择两个常住地区" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alert show];
            [alert release];
            return;
        }
        CityInfo *city = [self.cityArray objectAtIndex:indexPath.row];
        if ([self haveSelectTheCity:city]) {
            __block CityInfo *selectCity = nil;
            [self.selectCityArray enumerateObjectsUsingBlock:^(CityInfo *cityTmp, NSUInteger idx, BOOL *stop) {
                if ([cityTmp.cityid isEqualToString:city.cityid]) {
                    selectCity = cityTmp;
                    *stop = YES;
                }
            }];
            
            [self.selectCityArray removeObject:selectCity];
        }
        else{
            [self.selectCityArray addObject:city];
        }
        [self.cityTableView reloadData];
    }
    else{
        NSString *cityId = [[self.cityArray objectAtIndex:indexPath.row] cityid];
        NSString *provinceId = [[self.cityArray objectAtIndex:indexPath.row] provinceid];
        [PersistenceHelper setData:cityId forKey:@"cityid"];
        [PersistenceHelper setData:provinceId forKey:@"provinceid"];
        
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
                    contact.userid = [NSNumber numberWithLong:[[contactDict objectForKey:@"id"] longValue]];
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
                
                NSString *cityName = [[self.cityArray objectAtIndex:indexPath.row] cityname];
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:cityName, @"cityName", contactArray, @"contactArray", nil];
                
                //选择成功后 provinceid cityid 保存到本地
                [PersistenceHelper setData:cityId forKey:@"currentCityId"];
                [PersistenceHelper setData:provinceId forKey:@"currentProvinceId"];
                
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kInvestmentUserListRefreshed object:dict];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            } else {
                [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
                [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        }];
    }
}

- (void)selectCity:(CellButton *)sender
{
    //parameter: provinceid, cityid, userid(用来取备注),
    if (self.isAddResident) {
        CityInfo *city = [self.cityArray objectAtIndex:sender.indexRow];
        [[NSNotificationCenter defaultCenter] postNotificationName:kAddResidentNotification object:city];
        [self.navigationController popToViewController:self.homePageVC animated:YES];
    }
    else{
        NSString *cityId = [[self.cityArray objectAtIndex:sender.indexRow] cityid];
        NSString *provinceId = [[self.cityArray objectAtIndex:sender.indexRow] provinceid];
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
                    contact.userid = [NSNumber numberWithLong:[[contactDict objectForKey:@"id"] longValue]];
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
                
                NSString *cityName = [[self.cityArray objectAtIndex:sender.indexRow] cityname];
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:cityName, @"cityName", contactArray, @"contactArray", nil];
                
                //选择成功后 provinceid cityid 保存到本地
                [PersistenceHelper setData:cityId forKey:@"currentCityId"];
                [PersistenceHelper setData:provinceId forKey:@"currentProvinceId"];
                
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kInvestmentUserListRefreshed object:dict];
                
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
}

#pragma mark - table view delegate


@end
