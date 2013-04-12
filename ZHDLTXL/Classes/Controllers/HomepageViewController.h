//
//  HomepageViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-12.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactHimView.h"

@interface HomepageViewController : UIViewController <ContactHimViewDelegate>

//@property (nonatomic, retain) UIImageView *headIcon;
//@property (nonatomic, retain) UILabel *nameLabel;
//@property (nonatomic, retain) UILabel *areaLabel;
//@property (nonatomic, retain) UILabel *categoryLabel;
//
//@property (nonatomic, retain) UIButton *backBarButton;


@property (nonatomic, retain) NSString *headIconName;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *pharmacologyCategory;
@property (nonatomic, retain) NSString *residentArea;
@property (nonatomic, retain) NSString *comment;


@end
