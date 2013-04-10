//
//  AreaViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-9.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProvinceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UIButton *backBarButton;
@property (nonatomic, retain) UITableView *areaTableView;
@property (nonatomic, retain) NSMutableDictionary *areaDict;
@property (nonatomic, retain) NSMutableArray *provinceNameArray;

@end
