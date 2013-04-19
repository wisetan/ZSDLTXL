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
    self.selIndexRow = -1;
    self.selIndexSection = -1;
    
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
    

}

- (void)getSelectProvinceId
{
    NSLog(@"self.provinceArray: %@", self.provinceArray);
    NSLog(@"self.selectCityArray: %@", self.selectCityArray);
    
    [self.selectCityArray enumerateObjectsUsingBlock:^(CityInfo *city, NSUInteger cityIdx, BOOL *stop) {
        [self.provinceArray enumerateObjectsUsingBlock:^(ProvinceInfo *province, NSUInteger provinceIdx, BOOL *stop) {
            if ([city.provinceid isEqualToString:province.provinceid]) {
                [self.addResidentProvinceIdDict setObject:@"YES" forKey:[NSNumber numberWithInt:provinceIdx]];
            }
        }];
    }];
    
    NSLog(@"select province: %@", self.addResidentProvinceIdDict);
}

- (void)getAreaInfo
{
    NSString *areaJsonPath = [[NSBundle mainBundle] pathForResource:@"getProAndCityData" ofType:@"json"];
    NSData *areaJsonData = [[[NSData alloc] initWithContentsOfFile:areaJsonPath] autorelease];
    NSMutableDictionary *areaDictTmp = [NSJSONSerialization JSONObjectWithData:areaJsonData options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *provinceArrayTmp = [areaDictTmp objectForKey:@"AreaList"];
    [provinceArrayTmp enumerateObjectsUsingBlock:^(NSDictionary *proDict, NSUInteger idx, BOOL *stop) {
//        NSLog(@"%@", proDict); 
        ProvinceInfo *province = [[[ProvinceInfo alloc] init] autorelease];
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
            CityInfo *city = [[[CityInfo alloc] init] autorelease];
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
    
    if (self.isAddResident) {
        if ([[self.addResidentProvinceIdDict objectForKey:[NSNumber numberWithInt:indexPath.row]] isEqualToString:@"YES"]) {
            cell.selectImage.image = [UIImage imageNamed:@"selected.png"];
        }
    }else{
        if (indexPath.section == self.selIndexSection && indexPath.row == self.selIndexRow) {
            cell.selectImage.image = [UIImage imageNamed:@"selected.png"];
        }
        else{
            cell.selectImage.image = [UIImage imageNamed:@"unselected.png"];
        }
    }

    

    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AreaCell *cell = (AreaCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectImage.image = [UIImage imageNamed:@"selected.png"];
    
    CityViewController *cityVC = [[[CityViewController alloc] init] autorelease];
    NSMutableArray *cityArr = [[[NSMutableArray alloc] init] autorelease];
    NSString *provinceId = [[self.provinceArray objectAtIndex:indexPath.row] provinceid];
    [[self.areaInfoDict objectForKey:provinceId] enumerateObjectsUsingBlock:^(CityInfo *city, NSUInteger idx, BOOL *stop) {
        [cityArr addObject:city];
    }];
    cityVC.selectCityArray = self.selectCityArray;
    cityVC.cityArray = cityArr;
    cityVC.isAddResident = self.isAddResident;
    cityVC.homePageVC = self.homePageVC;
    self.selIndexRow = indexPath.row;
    self.selIndexSection = indexPath.section;
    
    [self.navigationController pushViewController:cityVC animated:YES];
    self.selIndexSection = -1;
    self.selIndexRow = -1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.f;
}


- (void)selectCity:(CellButton *)sender
{
    CityViewController *cityVC = [[[CityViewController alloc] init] autorelease];
//    cityVC.cityArray = [self.areaDict objectForKey:[self.provinceNameArray objectAtIndex:sender.index]];
    NSMutableArray *cityArr = [[NSMutableArray alloc] init];
    NSString *provinceId = [[self.provinceArray objectAtIndex:sender.indexRow] provinceid];
    [[self.areaInfoDict objectForKey:provinceId] enumerateObjectsUsingBlock:^(CityInfo *city, NSUInteger idx, BOOL *stop) {
        [cityArr addObject:city];
    }];
    cityVC.cityArray = cityArr;
    cityVC.isAddResident = self.isAddResident;
    cityVC.homePageVC = self.homePageVC;
    
    [self.navigationController pushViewController:cityVC animated:YES];
}


#pragma mark - table view delegate

@end
