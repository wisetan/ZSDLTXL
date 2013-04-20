//
//  SendMessageViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-10.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import <MessageUI/MessageUI.h>

@interface SendMessageViewController : UIViewController <UITextViewDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UIButton *sendButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (retain, nonatomic) IBOutlet UIButton *addButton;

@property (nonatomic, retain) UIButton *backBarButton;

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (retain, nonatomic) IBOutlet UIImageView *textBgImageView;

@property (nonatomic, retain) Contact *currentContact;
@property (nonatomic, retain) NSMutableArray *contactArray;


@end
