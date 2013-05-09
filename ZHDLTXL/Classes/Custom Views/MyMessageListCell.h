//
//  MyMessageListCell.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-5-3.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMessageListCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *headIcon;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *subjectLabel;
@property (retain, nonatomic) IBOutlet UILabel *unreadCountLabel;
@property (retain, nonatomic) IBOutlet UIImageView *unreadCountBg;

@end
