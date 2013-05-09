//
//  SendEmailViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-10.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "MailInfo.h"
#import "MyInfo.h"

@interface SendEmailViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) UIButton *backBarButton;

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UIImageView *textViewBgImage;
@property (nonatomic, retain) Contact *currentContact;
@property (nonatomic, retain) IBOutlet UITextField *emailTitleTextField;
@property (retain, nonatomic) IBOutlet UIImageView *textfieldBgImage;

@property (retain, nonatomic) IBOutlet UITextView *mailTextView;
@property (nonatomic, retain) NSDictionary *contactDict;

@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *cityId;

@property (nonatomic, copy) NSString *mailSendFrom;
@property (nonatomic, copy) NSString *mailTo;

@property (nonatomic, retain) MailInfo *mail;

@property (nonatomic, retain) MyInfo *myInfo;

@property (nonatomic, assign) BOOL sendFinished;

@end
