//
//  SelectPreferViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-15.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyInfo.h"


@protocol SelectPharViewControllerDelegate <NSObject>

- (void)finishSelectPhar:(NSSet *)pharSet;

@end

@interface SelectPharViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *preferTableView;
@property (nonatomic, retain) UIButton *backBarButton;
@property (nonatomic, retain) NSMutableArray *preferArray;
@property (nonatomic, retain) NSMutableArray *selectArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSEntityDescription *pharEntityDescription;
@property (nonatomic, retain) NSMutableSet *originPharSet;
@property (nonatomic, retain) NSMutableSet *theNewPharSet;
@property (nonatomic, retain) MyInfo *myInfo;
@property (nonatomic, assign) id<SelectPharViewControllerDelegate> delegate;

@end
