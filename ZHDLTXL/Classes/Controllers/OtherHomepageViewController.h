//
//  HomepageViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-12.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "FriendContact.h"
#import "AllContact.h"
#import "CommendContact.h"

@protocol FriendDidChangeDelegate <NSObject>

- (void)friendDidAdd:(FriendContact *)myFriend;
- (void)friendDidDelete:(FriendContact *)myFriend;

@end

@interface OtherHomepageViewController : UIViewController
<
UITextFieldDelegate,
UIAlertViewDelegate,
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, retain) Contact *contact;

@property (retain, nonatomic) IBOutlet UIImageView *xunImage;
@property (retain, nonatomic) IBOutlet UIImageView *xun_VImage; //实名认证 col1
@property (retain, nonatomic) IBOutlet UIImageView *xun_BImage;





@property (nonatomic, copy) NSString *residentArea;
@property (nonatomic, copy) NSString *pharmacologyCategory;

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *useridLabel;

@property (retain, nonatomic) IBOutlet UIButton *messageButton;
@property (retain, nonatomic) IBOutlet UIButton *mailButton;
@property (retain, nonatomic) IBOutlet UIButton *chatButton;

@property (retain, nonatomic) IBOutlet UIImageView *commentBg;
@property (retain, nonatomic) IBOutlet UITextField *commentTextField;



@property (nonatomic, retain) IBOutlet UILabel *addFriendbtnTitleLabel;
@property (retain, nonatomic) IBOutlet UIButton *addFriendButton;

@property (retain, nonatomic) IBOutlet UIImageView *headIcon;


@property (nonatomic, retain) NSMutableArray *areaArray;
@property (nonatomic, retain) NSMutableArray *preferArray;

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) BOOL isFriend;

@property (nonatomic, copy) NSString *contactId;

@property (nonatomic, retain) NSMutableArray *leftArray;
@property (nonatomic, retain) NSMutableArray *rightArray;

@property (nonatomic, assign) id<FriendDidChangeDelegate> delegate;

@end





