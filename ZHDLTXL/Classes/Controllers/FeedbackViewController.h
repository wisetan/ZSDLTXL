//
//  FeedbackViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-5-2.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController <UITextViewDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *textBgImage;
@property (retain, nonatomic) IBOutlet UITextView *textView;
@end
