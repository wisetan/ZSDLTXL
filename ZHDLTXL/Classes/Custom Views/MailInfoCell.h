//
//  MailInfoCell.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-5-2.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailInfoCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *unreadImage;
@property (retain, nonatomic) IBOutlet UIImageView *headIcon;
@property (retain, nonatomic) IBOutlet UILabel *usernameLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *subjectLabel;

@end
