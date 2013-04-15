//
//  SelectPreferViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-15.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectPreferViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *preferTableView;
@property (nonatomic, retain) UIButton *backBarButton;
@property (nonatomic, retain) NSMutableArray *preferArray;
@property (nonatomic, retain) NSMutableArray *selectArray;




@end
