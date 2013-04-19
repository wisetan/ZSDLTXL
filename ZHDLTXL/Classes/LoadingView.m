//
//  LoadingView.m
//  LeheV2
//
//  Created by zhangluyi on 11-10-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LoadingView.h"


@implementation LoadingView
@synthesize loadingTextLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [loadingTextLabel release];
    [activeIndicator release];
    [super dealloc];
}

@end
