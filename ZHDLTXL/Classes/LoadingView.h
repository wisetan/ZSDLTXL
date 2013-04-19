//
//  LoadingView.h
//  LeheV2
//
//  Created by zhangluyi on 11-10-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingView : UIView {
    
    UILabel *loadingTextLabel;
    
    IBOutlet UIActivityIndicatorView *activeIndicator;
}

@property (nonatomic, retain) IBOutlet UILabel *loadingTextLabel;

@end
