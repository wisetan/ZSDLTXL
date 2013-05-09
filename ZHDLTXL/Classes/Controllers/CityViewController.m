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
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
        [confirmButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
        confirmButton.frame = CGRectMake(0, 0, 80, 34);
        [confirmButton addTarget:self action:@selector(confirmSelect:) forControlEvents:UIControlEventTouchUpInside];

        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 34)] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"确认";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [confirmButton addSubview:label];
        
        UIBarButtonItem *rBarButton = [[[UIBarButtonItem alloc] initWithCustomView:confirmButton] autorelease];
        self.navigationItem.rightBarButtonItem = rBarButton;
        
    }

    [self getUserinfoFromDB];
    self.cityTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44) style:UITableViewStylePlain] autorelease];
    [self.cityTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.cityTableView];

    self.cityTableView.dataSource = self;
    self.cityTableView.delegate = self;
    
}

- (void)getUserinfoFromDB
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userDetail.userid == %@", kAppDelegate.userId];
    NSLog(@"userid %@", kAppDelegate.userId);
    self.myInfo = [MyInfo findFirstWithPredicate:pred];
    NSLog(@"myinfo %@", self.myInfo);
}

- (void)confirmSelect:(UIButton *)sender
{
    if (self.isAddResident) {
        
    //上传数据
    //para: changezsarea.json provcityid userid
        
        NSString *userid = [kAppDelegate userId];
        NSMutableString *provcityid = [[NSMutableString alloc] init];
        [self.myInfo.areaList enumerateObjectsUsingBlock:^(CityInfo *cityInfo, BOOL *stop) {
            [provcityid appendFormat:@"%@:%@,", cityInfo.provinceid, cityInfo.cityid];
        }];
        
        if ([provcityid isValid]) {
            provcityid = [NSMutableString stringWithString:[provcityid substringToIndex:provcityid.length-1]];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请至少选择一个地区，以方便他人和您联系" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }

        

        NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:provcityid, @"provcityid", userid, @"userid", @"changezsarea.json", @"path", nil];

//        NSLog(@"para dict %@", paraDict);

        [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
        [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
                if ([self.delegate respondsToSelector:@selector(finishSelectCity:)]) {
                    [self.delegate performSelector:@selector(finishSelectCity:) withObject:self.myInfo.areaList];
                }
                
                DB_SAVE();
                NSLog(@"self myinfo %@", self.myInfo);
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
        __block BOOL haveFound = NO;
        [self.myInfo.areaList enumerateObjectsUsingBlock:^(CityInfo *cityTmp, BOOL *stop) {
            if ([cityTmp.cityid isEqualToString:city.cityid]) {
                cell.selectImage.image = [UIImage imageNamed:@"selected.png"];
                haveFound = YES;
                *stop = YES;
            }
        }];
        if (haveFound == NO) {
            cell.selectImage.image = [UIImage imageNamed:@"unselected.png"];
        }
    }

    return cell;
}

- (BOOL)haveSelectTheCity:(CityInfo *)city
{
    __block BOOL isSelect = NO;
    [self.myInfo.areaList enumerateObjectsUsingBlock:^(CityInfo *selectCity, BOOL *stop) {
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

    if (self.isAddResident) {   //选择常驻地区
        if ((self.myInfo.areaList.count == 2) && ![self haveSelectTheCity:city]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"最多选择两个常住地区" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alert show];
            [alert release];
            return;
        }
        
        if ([self haveSelectTheCity:city]) {
            __block CityInfo *city2remove = nil;
            [self.myInfo.areaList enumerateObjectsUsingBlock:^(CityInfo *cityTmp, BOOL *stop) {
                if ([cityTmp.cityid isEqualToString:city.cityid]) {
                    city2remove = cityTmp;
                }
            }];
            
            [self.myInfo removeAreaListObject:city2remove];
        }
        else{
            CityInfo *newCity = [CityInfo createEntity];
            [[[newCity entity] attributesByName] enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL *stop) {
                NSString *value = [city valueForKey:key];
                [newCity setValue:value forKey:key];
            }];
            [self.myInfo addAreaListObject:newCity];
        }
        [self.cityTableView reloadData];
    }
    else{   //选择城市，更新联系人列表
        [PersistenceHelper setData:city.cityid forKey:kCityId];
        [PersistenceHelper setData:city.cityname forKey:kCityName];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}

@end
