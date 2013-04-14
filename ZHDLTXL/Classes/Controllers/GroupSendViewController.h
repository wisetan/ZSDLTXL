//
//  GroupSendViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-13.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupSendViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSDictionary *contactDictSortByAlpha;
@property (nonatomic, retain) UITableView *contactTableView;
@property (nonatomic, retain) NSMutableArray *selectedContactArray;
@property (nonatomic, retain) UIView *bottomImageView;
@property (nonatomic, retain) UIButton *confirmSelectButton;
@property (nonatomic, retain) UIButton *backBarButton;

//@property (nonatomic, retain) NSMutableDictionary *selectedContactDict;


@end
