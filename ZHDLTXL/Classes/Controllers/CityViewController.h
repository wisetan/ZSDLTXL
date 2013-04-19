//
//  CityViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-9.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellButton.h"
#import "AreaCell.h"

@interface CityViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *cityArray;
@property (nonatomic, retain) NSMutableArray *selectCityArray;
@property (nonatomic, retain) UITableView *cityTableView;
@property (nonatomic, retain) UIButton *backBarButton;

@property (nonatomic, assign) BOOL isAddResident;
@property (nonatomic, retain) UIViewController *homePageVC;
@property (nonatomic, retain) NSString *provinceid;

@end
