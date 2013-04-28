//
//  CityViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-9.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "CityViewController.h"
#import "CityInfo.h"
#import "UserDetail.h"
#import "MyInfo.h"

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
    
    [self setHidesBottomBarWhenPushed:YES];
    
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
    
    self.selectCityArray = [[[NSMutableArray alloc] init] autorelease];
    self.originCityArray = [[[NSMutableArray alloc] init] autorelease];
    
    
//    if ([self.selectCityArray count] == 0) {
//        self.selectCityArray = [[[NSMutableArray alloc] init] autorelease];
//    }
    

    
//    NSLog(@"已选城市: %@", self.selectCityArray);
    
    [self getResidentCity];

}

- (void)getResidentCity
{
//    NSEntityDescription *myinfoEntity = [NSEntityDescription entityForName:@"MyInfo" inManagedObjectContext:kAppDelegate.managedObjectContext];
//    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
//    [fetch setEntity:myinfoEntity];
//    
//    NSError *error = nil;
//    MyInfo *myinfo = [[kAppDelegate.managedObjectContext executeFetchRequest:fetch error:&error] lastObject];
    
    MyInfo *myInfo = [[MyInfo findAll] lastObject];
    [myInfo.areaList enumerateObjectsUsingBlock:^(CityInfo *cityInfo, BOOL *stop) {
        [self.selectCityArray addObject:cityInfo];
        [self.originCityArray addObject:cityInfo];
    }];
}

//- (MyInfo *)getMyInfo
//{
//    NSEntityDescription *myinfoEntity = [NSEntityDescription entityForName:@"MyInfo" inManagedObjectContext:kAppDelegate.managedObjectContext];
//    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
//    [fetch setEntity:myinfoEntity];
//    
//    NSError *error = nil;
//    return [[kAppDelegate.managedObjectContext executeFetchRequest:fetch error:&error] lastObject];
//}

- (void)confirmSelect:(UIButton *)sender
{
    if (self.isAddResident) {
        
    //上传数据
    //para: changezsarea.json provcityid userid
        
        NSString *userid = [kAppDelegate userId];
        NSMutableString *provcityid = [[NSMutableString alloc] init];
        [self.selectCityArray enumerateObjectsUsingBlock:^(CityInfo *cityInfo, NSUInteger idx, BOOL *stop) {
            [provcityid appendFormat:@"%@:%@,", self.provinceid, cityInfo.cityid];
        }];
        
        if ([provcityid isValid]) {
            provcityid = [NSMutableString stringWithString:[provcityid substringToIndex:provcityid.length-1]];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请至少选择一个偏好，以方便他人和您联系" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }

        

        NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:provcityid, @"provcityid", userid, @"userid", @"changezsarea.json", @"path", nil];

        NSLog(@"para dict %@", paraDict);

        [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
        [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
                [self updateDB];
                [[NSNotificationCenter defaultCenter] postNotificationName:kAddResidentNotification object:nil];
                [self.navigationController popToViewController:self.homePageVC animated:YES];
            }
            else{
                [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        }];
        


    }
}

//- (void)updateDB
//{
//    NSMutableSet *areaList = [[[NSMutableSet alloc] init] autorelease];
//    [self.selectCityArray enumerateObjectsUsingBlock:^(CityInfo *cityInfo, NSUInteger idx, BOOL *stop) {
//        [areaList addObject:cityInfo];
//    }];
//    
//    [self getMyInfo].areaList = areaList;
//    
//    NSMutableArray *notChangeCityArray = [[[NSMutableArray alloc] init] autorelease];
//    for (CityInfo *originCity in self.originCityArray) {
//        for (CityInfo *selectCity in self.selectCityArray) {
//            if ([selectCity.cityid isEqualToString:originCity.cityid]) {
//                [notChangeCityArray addObject:selectCity];
//                continue;
//            }
//        }
//    }
//    
//    //把新地区除去相同的填到常驻地区
//    
//    MyInfo *myInfo = [self getMyInfo];
//    for (CityInfo *originCity in self.originCityArray) {
//        int idx = 0;
//        for (CityInfo *notChangeCity in notChangeCityArray) {
//            if (![notChangeCity.cityid isEqualToString:originCity.cityid]) {
//                idx++;
//                if (idx == notChangeCityArray.count) {
//                    CityInfo *deleteCity = nil;
//                    for (CityInfo *deleteCityTmp in myInfo.areaList) {
//                        if ([deleteCity.cityid isEqualToString:originCity.cityid]) {
//                            if ([deleteCity.cityname isEqualToString:[PersistenceHelper dataForKey:KGpsCityName]]) {
//                                continue;
//                            }
//                            else{
//                                NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
//                                NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserDetail" inManagedObjectContext:kAppDelegate.managedObjectContext];
//                                [fetch setEntity:entity];
//                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"city.cityid == %@", deleteCity.cityid];
//                                [fetch setPredicate:predicate];
//                                
//                                NSError *error = nil;
//                                NSArray *deleteContactArray = [kAppDelegate.managedObjectContext executeFetchRequest:fetch error:&error];
//                                if (error) {
//                                    NSLog(@"error %@", error);
//                                }
//                                for (UserDetail *user in deleteContactArray) {
//                                    [kAppDelegate.managedObjectContext deleteObject:user];
//                                }
//                            }
//                        }
//                    }
//                    
//                    
//                    
//                    
//                }
//            }
//        }
//    }
//    
//    NSError *error = nil;
//    if (![kAppDelegate.managedObjectContext save:&error]) {
//        NSLog(@"error %@", error);
//    }
//}

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
    

    if (self.isAddResident) {
        CityInfo *city = [self.cityArray objectAtIndex:indexPath.row];
        NSLog(@"city: %@", city);
        NSLog(@"已选城市: %@", self.selectCityArray);
        if ([self haveSelectTheCity:city]) {
            cell.selectImage.image = [UIImage imageNamed:@"selected.png"];
        }
        else{
            cell.selectImage.image = [UIImage imageNamed:@"unselected.png"];
        }
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

//- (void)getGpsCityUsers:(CityInfo *)city
//{
//    NSString *gpsCityId = [Utility getCityIdByCityName:city.cityname];
//    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
//    NSEntityDescription *user = [NSEntityDescription entityForName:@"UserDetail" inManagedObjectContext:kAppDelegate.managedObjectContext];
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"city.cityid == %@", gpsCityId];
//    [fetch setPredicate:pred];
//    [fetch setEntity:user];
//    NSError *error = nil;
//    NSArray *contactArray = [kAppDelegate.managedObjectContext executeFetchRequest:fetch error:&error];
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"YES", @"getDataFromLocal", contactArray, @"contactArray", nil];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kInvestmentUserListRefreshed object:dict];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

//- (void)getCityUserWhenNotLogined:(CityInfo *)city
//{
//    NSString *userId = kAppDelegate.userId;
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:city.cityid, @"cityid", city.provinceid, @"provinceid", userId, @"userid", @"getInvestmentUserList.json", @"path", nil];
//    NSLog(@"parameter: %@", dict);
//    
//    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
//    hub.labelText = @"获取商家列表";
//    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
//        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
//            //                    [self clearUserDB];
//            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
//            
//            //            self.username = nil;
//            //            self.tel = nil;
//            //            self.mailbox = nil;
//            //            self.picturelinkurl = nil;
//            //            self.col1 = nil;
//            //            self.col2 = nil;
//            //            self.col3 = nil;;
//            
//            
//            //            NSLog(@"商家列表：%@", json);
//            NSMutableArray *contactArray = [NSMutableArray new];
//            NSMutableSet *residentUserSet = [[[NSMutableSet alloc] init] autorelease];
//            [[json objectForKey:@"InvestmentUserList"] enumerateObjectsUsingBlock:^(NSDictionary *contactDict, NSUInteger idx, BOOL *stop) {
//                //                NSLog(@"contact Dict: %@", contactDict);
////                UserDetail *userDetail = [NSEntityDescription insertNewObjectForEntityForName:@"UserDetail" inManagedObjectContext:kAppDelegate.managedObjectContext];
//                
//                
//                userDetail.userid = [[contactDict objForKey:@"id"] stringValue];
//                userDetail.username = [contactDict objForKey:@"username"];
//                userDetail.tel = [contactDict objForKey:@"tel"];
//                userDetail.mailbox = [contactDict objectForKey:@"mailbox"];
//                userDetail.picturelinkurl = [contactDict objectForKey:@"picturelinkurl"];
//                userDetail.col1 = [contactDict objectForKey:@"col1"];
//                userDetail.col2 = [contactDict objectForKey:@"col2"];
//                userDetail.col2 = [contactDict objectForKey:@"col2"];
////                userDetail.city =  city;
//                [contactArray addObject:userDetail];
//                [residentUserSet addObject:userDetail];
//            }];
//            
//            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:contactArray, @"contactArray", city.cityname, @"cityName", nil];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:kInvestmentUserListRefreshed object:dict];
//            
//            [self.navigationController popToRootViewControllerAnimated:YES];
//            
//        } else {
//            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
//            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
//        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
//    }];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //parameter: provinceid, cityid, userid(用来取备注),
    
    CityInfo *city = [self.cityArray objectAtIndex:indexPath.row];
    NSString *cityId = city.cityid;
    NSString *cityName = city.cityname;
    

    if (self.isAddResident) {   //选择常驻地区
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
    else{   //选择城市，更新联系人列表
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"city", cityName, nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kInvestmentUserListRefreshed object:dict];
//        [PersistenceHelper setData:cityId forKey:kCityId];
        [PersistenceHelper setData:cityId forKey:kCityId];
        [PersistenceHelper setData:cityName forKey:kCityName];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}

//- (void)clearUserDB
//{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userid != %@", kAppDelegate.userId];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserDetail" inManagedObjectContext:kAppDelegate.managedObjectContext];
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setPredicate:predicate];
//    [request setEntity:entity];
//    NSError *error = nil;
//    NSArray *contactArray = [kAppDelegate.managedObjectContext executeFetchRequest:request error:&error];
//    if (error)
//    {
//        NSLog(@"fetch error");
//    }
//    else
//    {
//        for (NSManagedObject *contact in contactArray) {
//            [kAppDelegate.managedObjectContext deleteObject:contact];
//        }
//        
//        if (![kAppDelegate.managedObjectContext save:&error]) {
//            NSLog(@"error %@", error);
//        }
//    }
//}

@end
