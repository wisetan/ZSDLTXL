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

@property (nonatomic, assign) NSInteger selIndexSection;
@property (nonatomic, assign) NSInteger selIndexRow;

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

- (void)viewWillAppear:(BOOL)animated
{
    if (self.isAddResident) {
        self.addResidentProvinceIdDict = [[[NSMutableDictionary alloc] init] autorelease];
        [self getSelectProvinceId];
    }
    [self.areaTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"地区选择";
    
    [self setHidesBottomBarWhenPushed:YES];
    
    //back button
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);

    UIBarButtonItem *lBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.backBarButton];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    [lBarButton release];
    
    
    //area table view
    self.areaTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44) style:UITableViewStylePlain] autorelease];
    [self.areaTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.areaTableView.delegate = self;
    self.areaTableView.dataSource = self;
    [self.view addSubview:self.areaTableView];
    
    //province , city array init
    self.provinceArray = [[[NSMutableArray alloc] init] autorelease];
    self.cityArray = [[[NSMutableArray alloc] init] autorelease];
    self.areaInfoDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [self getAreaInfo];
    [self getUserinfoFromDB];
    
}

- (void)getUserinfoFromDB
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userDetail.userid == %@", kAppDelegate.userId];
    self.myInfo = [MyInfo findFirstWithPredicate:pred];
}

- (void)getSelectProvinceId
{
    [self.selectCityArray enumerateObjectsUsingBlock:^(CityInfo *city, NSUInteger cityIdx, BOOL *stop) {
        [self.provinceArray enumerateObjectsUsingBlock:^(ProvinceInfo *province, NSUInteger provinceIdx, BOOL *stop) {
            if ([city.provinceid isEqualToString:province.provinceid]) {
                [self.addResidentProvinceIdDict setObject:@"YES" forKey:[NSNumber numberWithInt:provinceIdx]];
            }
        }];
    }];
}

- (void)getAreaInfo
{
    NSString *areaJsonPath = [[NSBundle mainBundle] pathForResource:@"getProAndCityData" ofType:@"json"];
    NSData *areaJsonData = [[[NSData alloc] initWithContentsOfFile:areaJsonPath] autorelease];
    NSMutableDictionary *areaDictTmp = [NSJSONSerialization JSONObjectWithData:areaJsonData options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *provinceArrayTmp = [areaDictTmp objectForKey:@"AreaList"];
    [provinceArrayTmp enumerateObjectsUsingBlock:^(NSDictionary *proDict, NSUInteger idx, BOOL *stop) {
        ProvinceInfo *province = [[[ProvinceInfo alloc] init] autorelease];
        province.centerlon = [proDict objectForKey:@"centerlon"];
        province.centerlat = [proDict objectForKey:@"centerlat"];
        province.provinceid = [proDict objectForKey:@"provinceid"];
        province.provincename = [proDict objectForKey:@"provincename"];
        province.radius = [proDict objectForKey:@"radius"];
        [self.provinceArray addObject:province];
        
        NSArray *cityArrayJsonTmp = [proDict objectForKey:@"citylist"];
        NSMutableArray *cityArrayTmp = [[NSMutableArray alloc] init];
        [cityArrayJsonTmp enumerateObjectsUsingBlock:^(NSDictionary *cityDict, NSUInteger idx, BOOL *stop) {
            CityInfo *city = [CityInfo createEntity];
            [city setValuesForKeysWithDictionary:cityDict];
            [cityArrayTmp addObject:city];
        }];
        
        
        [self.areaInfoDict setObject:cityArrayTmp forKey:province.provinceid];
        [cityArrayTmp release];
        
    }];
    
//    [self.provinceArray sortUsingComparator:^NSComparisonResult(ProvinceInfo *pro1, ProvinceInfo *pro2) {
//        return [pro1.provinceid compare:pro2.provinceid options:NSNumericSearch];
//    }];
    
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

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
    cell.areaNameLabel.text = [[self.provinceArray objectAtIndex:indexPath.row] provincename];
    [cell.areaNameLabel setFont:[UIFont systemFontOfSize:14]];
    ProvinceInfo *province = [self.provinceArray objectAtIndex:indexPath.row];
    
    
    if (self.isAddResident) {
        
        __block BOOL haveFound = NO;
        [self.myInfo.areaList enumerateObjectsUsingBlock:^(CityInfo *city, BOOL *stop) {
            if ([city.provinceid isEqualToString:province.provinceid]) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CityViewController *cityVC = [[[CityViewController alloc] init] autorelease];
    NSMutableArray *cityArr = [[[NSMutableArray alloc] init] autorelease];
    NSString *provinceId = [[self.provinceArray objectAtIndex:indexPath.row] provinceid];
    [[self.areaInfoDict objectForKey:provinceId] enumerateObjectsUsingBlock:^(CityInfo *city, NSUInteger idx, BOOL *stop) {
        [cityArr addObject:city];
    }];
    cityVC.cityArray = cityArr;
    cityVC.isAddResident = self.isAddResident;
    if (self.isAddResident) {
        cityVC.delegate = self.delegate;
    }
    cityVC.homePageVC = self.homePageVC;
    cityVC.provinceid = provinceId;
    
    [self.navigationController pushViewController:cityVC animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.f;
}

@end
