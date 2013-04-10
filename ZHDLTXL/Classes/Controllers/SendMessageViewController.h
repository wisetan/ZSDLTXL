//
//  SendMessageViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-10.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface SendMessageViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, retain) UIButton *sendButton;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) UIImageView *bottomImageView;
@property (nonatomic, retain) UIButton *backBarButton;

@property (nonatomic, retain) UILabel *sendTargetLabel;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UIPlaceHolderTextView *messageTextView;
@property (nonatomic, retain) UIImageView *textViewBgImage;
@property (nonatomic, retain) Contact *currentContact;
@property (nonatomic, retain) NSArray *contactArray;
@property (nonatomic, retain) UIButton *addButton;

@end
