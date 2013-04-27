//
//  HomepageViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-12.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"



@interface OtherHomepageViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) Contact *contact;

@property (nonatomic, copy) NSString *residentArea;
@property (nonatomic, copy) NSString *pharmacologyCategory;

@property (nonatomic, retain) IBOutlet UILabel *residentAreaLabel;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *cateLabel;


@property (retain, nonatomic) IBOutlet UIButton *messageButton;
@property (retain, nonatomic) IBOutlet UIButton *mailButton;
@property (retain, nonatomic) IBOutlet UIButton *chatButton;

@property (retain, nonatomic) IBOutlet UIImageView *commentBg;
@property (nonatomic, retain) IBOutlet UITextField *commentTextField;

@property (nonatomic, retain) IBOutlet UILabel *addFriendbtnTitleLabel;
@property (retain, nonatomic) IBOutlet UIButton *addFriendButton;

@property (retain, nonatomic) IBOutlet UIImageView *headIcon;


@property (nonatomic, retain) NSMutableArray *areaArray;
@property (nonatomic, retain) NSMutableArray *preferArray;

@property (nonatomic, assign) enum eContactType contactyType;


@property (nonatomic, assign) BOOL isFriend;

@property (nonatomic, copy) NSString *contactId;


@end
