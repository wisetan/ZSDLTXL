//
//  ContactCell.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-9.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellButton.h"

@interface ContactCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *headIcon;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet CellButton *contactButton;

@end
