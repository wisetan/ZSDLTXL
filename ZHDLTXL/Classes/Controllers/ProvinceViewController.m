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
    
    //read area.plist
    NSString *areaPlistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    self.areaDict = [[[NSMutableDictionary alloc] init] autorelease];
    self.provinceNameArray = [[[NSMutableArray alloc] init] autorelease];
    
    //
    NSMutableDictionary *allAreaDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:areaPlistPath] autorelease];
    
    
    NSMutableArray *provinceIndexArray = [[[NSMutableArray alloc] initWithArray:[allAreaDict allKeys]] autorelease];
    NSArray *sortedProvinceIndexArray = [provinceIndexArray sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        if (obj1.intValue < obj2.intValue)
            return NSOrderedAscending;
        else if (obj1.intValue > obj2.intValue)
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    }];
//    NSLog(@"sorted all keys: %@", sortedProvinceIndexArray);
    
    [sortedProvinceIndexArray enumerateObjectsUsingBlock:^(NSNumber *provinceIndex, NSUInteger idx, BOOL *stop) {
        NSString *provinceName = [[[allAreaDict objectForKey:provinceIndex] allKeys] objectAtIndex:0];
//        NSLog(@"province name %@", provinceName);
        [self.provinceNameArray addObject:provinceName];
        
//        NSLog(@"provinceName: %@", provinceName);
        NSDictionary *cityDict = [[allAreaDict objectForKey:provinceIndex] objectForKey:provinceName];
        NSArray *cityIndexArray = [[[allAreaDict objectForKey:provinceIndex] objectForKey:provinceName] allKeys];
        NSArray *sortedCityIndexArray = [cityIndexArray sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
            if (obj1.intValue < obj2.intValue)
                return NSOrderedAscending;
            else if (obj1.intValue > obj2.intValue)
                return NSOrderedDescending;
            else
                return NSOrderedSame;
        }];
//        NSLog(@"city index: %@", sortedCityIndexArray);
        
        
        NSMutableArray *cityNameArray = [[NSMutableArray alloc] init];
        [sortedCityIndexArray enumerateObjectsUsingBlock:^(NSNumber *cityIndex, NSUInteger idx, BOOL *stop) {
            NSString *cityName = [[[cityDict objectForKey:cityIndex] allKeys] objectAtIndex:0];
//            NSLog(@"cityName %@", cityName);
            [cityNameArray addObject:cityName];
        }];
        [self.areaDict setObject:cityNameArray forKey:provinceName];
        
    }];
//    NSLog(@"area info: %@", self.areaDict);
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
    return [self.provinceNameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"areaCell";
    AreaCell *cell = (AreaCell *)[self.areaTableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AreaCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.areaNameLabel.text = [self.provinceNameArray objectAtIndex:indexPath.row];
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
    cityVC.cityArray = [self.areaDict objectForKey:[self.provinceNameArray objectAtIndex:sender.index]];
    [self.navigationController pushViewController:cityVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - table view delegate

@end
