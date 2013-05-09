//
//  MailInfoViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-5-1.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailInfo.h"

@interface MailInfoViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIImageView *headIcon;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *addressLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *subjectLabel;
@property (retain, nonatomic) IBOutlet UITextView *contentTextView;


@property (retain, nonatomic) MailInfo *mailInfo;



@end
