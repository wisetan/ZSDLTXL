//
//  OtherTalkCell.m
//  ZXCXBlyt
//
//  Created by zly on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OtherTalkCell.h"

@implementation OtherTalkCell
@synthesize avatar;
@synthesize labTime;
@synthesize labContent;
@synthesize bgImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib {
    self.bgImageView.image = [UIImage stretchableImage:@"bg_OtherTalk" leftCap:16 topCap:13];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    labContent.frame = CGRectMake(60, 15, 200, 0);
    [self.labContent sizeToFit];
    CGSize contentSize = [labContent.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:UILineBreakModeCharacterWrap];
    self.bgImageView.frame = CGRectMake(bgImageView.frame.origin.x, bgImageView.frame.origin.y, contentSize.width+20, contentSize.height + 20);
}

+ (CGFloat)heightForCellWithContent:(NSString *)content {
    CGFloat offset = 15.0f;
    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:UILineBreakModeCharacterWrap];
    return contentSize.height + offset + 20;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	
	if(!newSuperview) {
		[avatar cancelImageLoad];
	}
}

- (void)dealloc {
    [avatar release];
    [labTime release];
    [labContent release];
    [bgImageView release];
    [super dealloc];
}
@end
