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
@property (nonatomic, retain) UITableView *cityTableView;
@property (nonatomic, retain) UIButton *backBarButton;

@end
