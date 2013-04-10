//
//  CityViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-9.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "CityViewController.h"

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
    cell.areaNameLabel.text = [self.cityArray objectAtIndex:indexPath.row];
    [cell.areaNameLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
    [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateHighlighted];
    cell.selectButton.index = indexPath.row;
    [cell.selectButton addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

- (void)selectCity:(CellButton *)sender
{
    NSLog(@"选中城市");
}

#pragma mark - table view delegate


@end
