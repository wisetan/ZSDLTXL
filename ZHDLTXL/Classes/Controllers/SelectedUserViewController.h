//
//  SelectedUserViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-16.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedUserViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *selectedUserTableView;

@property (nonatomic, retain) NSMutableDictionary *contactDictSortByAlpha;
@property (nonatomic, retain) UIButton *backBarButton;
@property (nonatomic, retain) NSMutableArray *selectedArray;

@end
