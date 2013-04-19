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

@property (nonatomic, retain) NSMutableArray *provinceArray;
@property (nonatomic, retain) NSMutableArray *cityArray;
@property (nonatomic, retain) NSMutableDictionary *areaInfoDict;

@property (nonatomic, assign) BOOL isAddResident;
@property (nonatomic, retain) NSMutableArray *selectCityArray;
@property (nonatomic, retain) UIViewController *homePageVC;

@property (nonatomic, retain) NSMutableDictionary *addResidentProvinceIdDict;


@end
