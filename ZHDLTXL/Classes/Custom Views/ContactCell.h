//
//  ContactCell.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-9.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CellButton.h"
#import "SelectImageView.h"

@interface ContactCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *headIcon;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
//@property (retain, nonatomic) IBOutlet CellButton *contactButton;
@property (retain, nonatomic) IBOutlet UIImageView *xun_VImage;
@property (retain, nonatomic) IBOutlet UILabel *ZDLabel;
@property (retain, nonatomic) IBOutlet  SelectImageView *unSelectedImage;
//@property (retain, nonatomic) IBOutlet CellButton *selectButton;
@end
