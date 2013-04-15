//
//  HomepageViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-12.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactHimView.h"

@interface OtherHomepageViewController : UIViewController <ContactHimViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) NSString *headIconName;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *pharmacologyCategory;
@property (nonatomic, retain) NSString *residentArea;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSDictionary *contactDict;
@property (nonatomic, retain) Contact *contact;

@property (nonatomic, copy)   NSString *userId;


@property (nonatomic, retain) UILabel *residentAreaLabel;
@property (nonatomic, retain) UILabel *cateLabel;
@property (nonatomic, retain) NSMutableArray *areaArray;
@property (nonatomic, retain) NSMutableArray *preferArray;

@property (nonatomic ,retain) UILabel *addFriendbtnTitleLabel;
@property (nonatomic, retain) UITextField *commentTextField;

@property (nonatomic, assign) BOOL isFriend;


@end
