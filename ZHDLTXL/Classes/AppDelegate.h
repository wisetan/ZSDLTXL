//
//  AppDelegate.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-8.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kNetworkErrorMessage        @"您的网络不好哦，检查一下"
#define kEventMyLatlonChanged       @"kEventMyLatlonChanged"
#define kInvalidLocation            0.0f

@class MBProgressHUD;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) UIWindow *window;



@property (nonatomic, copy)   NSString *uuid;
@property (nonatomic, copy)   NSString *UserId;

- (void)showWithCustomAlertViewWithText:(NSString *)text andImageName:(NSString *)image;

@end
