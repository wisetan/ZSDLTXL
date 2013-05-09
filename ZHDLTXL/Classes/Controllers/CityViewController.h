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
#import "MyInfo.h"

@protocol CityViewControllerDelegate <NSObject>

- (void)finishSelectCity:(NSSet *)citySet;

@end

@interface CityViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *cityArray;
@property (nonatomic, retain) NSMutableArray *selectCityArray;
@property (nonatomic, retain) NSMutableArray *originCityArray;
@property (nonatomic, retain) UITableView *cityTableView;
@property (nonatomic, retain) UIButton *backBarButton;

@property (nonatomic, assign) BOOL isAddResident;
@property (nonatomic, assign) BOOL isAddInfo;
@property (nonatomic, retain) UIViewController *homePageVC;
@property (nonatomic, retain) NSString *provinceid;
@property (nonatomic, retain) MyInfo *myInfo;
@property (nonatomic, assign) id<CityViewControllerDelegate> delegate;

@end
