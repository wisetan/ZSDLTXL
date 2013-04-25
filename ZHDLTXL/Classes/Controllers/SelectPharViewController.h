//
//  SelectPreferViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-15.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyHomePageViewController.h"

@interface SelectPharViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *preferTableView;
@property (nonatomic, retain) UIButton *backBarButton;
@property (nonatomic, retain) NSMutableArray *preferArray;
@property (nonatomic, retain) NSMutableArray *selectArray;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSEntityDescription *pharEntityDescription;

@property (nonatomic, retain) NSMutableSet *originPharSet;
@property (nonatomic, retain) NSMutableSet *newPharSet;

@property (nonatomic, retain) MyInfo *myInfo;



@end
