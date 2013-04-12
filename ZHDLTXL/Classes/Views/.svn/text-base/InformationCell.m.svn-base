//
//  InformationCell.m
//  ZXCXBlyt
//
//  Created by zly on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InformationCell.h"

@implementation InformationCell

@synthesize labTip;
@synthesize labSubTitle;
@synthesize labTitle;
@synthesize avatar;
@synthesize specialView;
@synthesize isSpecail;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setIsSpecail:(BOOL)bIsSpecail {
    isSpecail = bIsSpecail;
    if (isSpecail) {
        self.specialView.hidden = NO;
        self.labTip.hidden = YES;
    } else {
        self.specialView.hidden = YES;
        self.labTip.hidden = NO;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	if(!newSuperview) {
		[avatar cancelImageLoad];
	}
}


- (void)dealloc {
    [avatar release];
    [labTitle release];
    [labSubTitle release];
    [labTip release];
    [specialView release];
    [super dealloc];
}
@end
