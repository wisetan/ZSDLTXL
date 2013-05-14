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
@property (nonatomic, assign) BOOL deleteMail;

@property (retain, nonatomic) MailInfo *mailInfo;

@property (retain, nonatomic) IBOutlet UIButton *preMail;
@property (retain, nonatomic) IBOutlet UIButton *nextMail;
@property (retain, nonatomic) IBOutlet UIButton *deleteMailBtn;


@end
