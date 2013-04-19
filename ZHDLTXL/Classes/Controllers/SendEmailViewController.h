//
//  SendEmailViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-10.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface SendEmailViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UIButton *sendButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) UIButton *backBarButton;

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UIImageView *textViewBgImage;
@property (nonatomic, retain) Contact *currentContact;
@property (nonatomic, retain) NSMutableArray *contactArray; //群发联系人
@property (nonatomic, retain) IBOutlet UIButton *addButton;
@property (nonatomic, retain) IBOutlet UITextField *emailTitleTextField;
@property (retain, nonatomic) IBOutlet UIImageView *textfieldBgImage;

@property (retain, nonatomic) IBOutlet UITextView *mailTextView;
@property (nonatomic, retain) NSDictionary *contactDict;

@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *cityId;


@end
