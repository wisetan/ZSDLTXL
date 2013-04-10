//
//  AreaCell.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-9.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellButton.h"

@interface AreaCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *areaNameLabel;
@property (assign, nonatomic) BOOL isSelected;
@property (retain, nonatomic) IBOutlet CellButton *selectButton;

@end
