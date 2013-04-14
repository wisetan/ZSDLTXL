//
//  RootViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-8.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactHimView.h"
#import <CoreLocation/CoreLocation.h>

@interface RootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ContactHimViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, retain) UIImageView *bottomImageView;
@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) UIButton *selButton;
@property (nonatomic, retain) UIButton *areaButton;
@property (nonatomic, retain) UIButton *friendButton;
@property (nonatomic, retain) UITableView *contactTableView;
@property (nonatomic, retain) NSMutableArray *contactArray;
@property (nonatomic, retain) Contact *currentContact;
@property (nonatomic, retain) ContactHimView *contactHimView;
@property (nonatomic, assign) NSInteger currentCellButtonIndex;
@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, retain) UILabel *areaLabel;
@property (nonatomic, retain) UILabel *loginLabel;

@property (nonatomic, assign) BOOL hasRegisted;
@property (nonatomic, copy) NSString *currentCity;
@property (nonatomic, copy) NSString *originCity;


@property (nonatomic, copy) NSString *curProvinceId;
@property (nonatomic, copy) NSString *curCityId;

@property (nonatomic, retain) NSMutableDictionary *contactDictSortByAlpha;

- (void)getInvestmentUserList;
- (void)setProvinceIdAndCityIdOfCity:(NSString *)city;
- (BOOL)isLogined;

@end
