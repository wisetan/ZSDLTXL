//
//  AreaViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-9.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "ProvinceViewController.h"
#import "CityViewController.h"
#import "AreaCell.h"
#import "ProvinceInfo.h"
#import "CityInfo.h"

@interface ProvinceViewController ()

@end

@implementation ProvinceViewController

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
	self.title = @"地区选择";
    
    //back button
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);

    UIBarButtonItem *lBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.backBarButton];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    
    //area table view
    self.areaTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44) style:UITableViewStylePlain] autorelease];
    [self.areaTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.areaTableView.delegate = self;
    self.areaTableView.dataSource = self;
    [self.view addSubview:self.areaTableView];
    
//    //read area.plist
//    NSString *areaPlistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
//    self.areaDict = [[[NSMutableDictionary alloc] init] autorelease];
//    self.provinceNameArray = [[[NSMutableArray alloc] init] autorelease];
//    
//    //
//    NSMutableDictionary *allAreaDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:areaPlistPath] autorelease];
//    
//    
//    NSMutableArray *provinceIndexArray = [[[NSMutableArray alloc] initWithArray:[allAreaDict allKeys]] autorelease];
//    NSArray *sortedProvinceIndexArray = [provinceIndexArray sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
//        if (obj1.intValue < obj2.intValue)
//            return NSOrderedAscending;
//        else if (obj1.intValue > obj2.intValue)
//            return NSOrderedDescending;
//        else
//            return NSOrderedSame;
//    }];
////    NSLog(@"sorted all keys: %@", sortedProvinceIndexArray);
//    
//    [sortedProvinceIndexArray enumerateObjectsUsingBlock:^(NSNumber *provinceIndex, NSUInteger idx, BOOL *stop) {
//        NSString *provinceName = [[[allAreaDict objectForKey:provinceIndex] allKeys] objectAtIndex:0];
////        NSLog(@"province name %@", provinceName);
//        [self.provinceNameArray addObject:provinceName];
//        
////        NSLog(@"provinceName: %@", provinceName);
//        NSDictionary *cityDict = [[allAreaDict objectForKey:provinceIndex] objectForKey:provinceName];
//        NSArray *cityIndexArray = [[[allAreaDict objectForKey:provinceIndex] objectForKey:provinceName] allKeys];
//        NSArray *sortedCityIndexArray = [cityIndexArray sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
//            if (obj1.intValue < obj2.intValue)
//                return NSOrderedAscending;
//            else if (obj1.intValue > obj2.intValue)
//                return NSOrderedDescending;
//            else
//                return NSOrderedSame;
//        }];
////        NSLog(@"city index: %@", sortedCityIndexArray);
//        
//        
//        NSMutableArray *cityNameArray = [[NSMutableArray alloc] init];
//        [sortedCityIndexArray enumerateObjectsUsingBlock:^(NSNumber *cityIndex, NSUInteger idx, BOOL *stop) {
//            NSString *cityName = [[[cityDict objectForKey:cityIndex] allKeys] objectAtIndex:0];
////            NSLog(@"cityName %@", cityName);
//            [cityNameArray addObject:cityName];
//        }];
//        [self.areaDict setObject:cityNameArray forKey:provinceName];
//        
//    }];
//    NSLog(@"area info: %@", self.areaDict);
    
    
    //province , city array init
    self.provinceArray = [[NSMutableArray alloc] init];
    self.cityArray = [[NSMutableArray alloc] init];
    self.areaInfoDict = [[NSMutableDictionary alloc] init];
    
    [self getAreaInfo];
}

- (void)getAreaInfo
{
    NSString *areaJsonPath = [[NSBundle mainBundle] pathForResource:@"getProAndCityData" ofType:@"json"];
    NSData *areaJsonData = [[NSData alloc] initWithContentsOfFile:areaJsonPath];
    NSMutableDictionary *areaDictTmp = [NSJSONSerialization JSONObjectWithData:areaJsonData options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *provinceArrayTmp = [areaDictTmp objectForKey:@"AreaList"];
    [provinceArrayTmp enumerateObjectsUsingBlock:^(NSDictionary *proDict, NSUInteger idx, BOOL *stop) {
//        NSLog(@"%@", proDict); 
        ProvinceInfo *province = [[ProvinceInfo alloc] init];
        province.centerlon = [proDict objectForKey:@"centerlon"];
        province.centerlat = [proDict objectForKey:@"centerlat"];
        province.provinceid = [proDict objectForKey:@"provinceid"];
        province.provincename = [proDict objectForKey:@"provincename"];
        province.radius = [proDict objectForKey:@"radius"];
//        [province setValuesForKeysWithDictionary:proDict];
        [self.provinceArray addObject:province];
        
        NSArray *cityArrayJsonTmp = [proDict objectForKey:@"citylist"];
        NSMutableArray *cityArrayTmp = [[NSMutableArray alloc] init];
        [cityArrayJsonTmp enumerateObjectsUsingBlock:^(NSDictionary *cityDict, NSUInteger idx, BOOL *stop) {
//            NSLog(@"city: %@", cityDict);
            CityInfo *city = [[CityInfo alloc] init];
            [city setValuesForKeysWithDictionary:cityDict];
            [cityArrayTmp addObject:city];
        }];
        
        [self.areaInfoDict setObject:cityArrayTmp forKey:province.provinceid];
        [cityArrayTmp release];
        
    }];
    
    [self.provinceArray sortUsingComparator:^NSComparisonResult(ProvinceInfo *pro1, ProvinceInfo *pro2) {
        return [pro1.provinceid compare:pro2.provinceid options:NSNumericSearch];
    }];
    
//    NSLog(@"Area Info :%@", areaDictTmp);
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [self.provinceNameArray count];
    return [self.provinceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"areaCell";
    AreaCell *cell = (AreaCell *)[self.areaTableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AreaCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.areaNameLabel.text = [self.provinceNameArray objectAtIndex:indexPath.row];
    cell.areaNameLabel.text = [[self.provinceArray objectAtIndex:indexPath.row] provincename];
    [cell.areaNameLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateHighlighted];
    cell.selectButton.index = indexPath.row;
    [cell.selectButton addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

- (void)selectCity:(CellButton *)sender
{
    CityViewController *cityVC = [[[CityViewController alloc] init] autorelease];
//    cityVC.cityArray = [self.areaDict objectForKey:[self.provinceNameArray objectAtIndex:sender.index]];
    NSMutableArray *cityNameArr = [[NSMutableArray alloc] init];
    NSString *provinceId = [[self.provinceArray objectAtIndex:sender.index] provinceid];
    [[self.areaInfoDict objectForKey:provinceId] enumerateObjectsUsingBlock:^(CityInfo *city, NSUInteger idx, BOOL *stop) {
        [cityNameArr addObject:city.cityname];
    }];
    cityVC.cityArray = cityNameArr;
    
    [self.navigationController pushViewController:cityVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - table view delegate

@end
