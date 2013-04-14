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


@end
