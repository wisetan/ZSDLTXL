//
//  MyInfoCell.m
//  ZXCXBlyt
//
//  Created by zly on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyInfoCell.h"

@implementation MyInfoCell

@synthesize labName;
@synthesize labSubTitle;
@synthesize labTime;
@synthesize avatar;
@synthesize delegate;
@synthesize indexPath;
@synthesize bgInfoCount;
@synthesize labInfoCount;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)avatarOnClick:(id)sender {
    if ([delegate respondsToSelector:@selector(myInfoCell:clickAvatarAtIndexPath:)]) {
        [delegate myInfoCell:self clickAvatarAtIndexPath:indexPath];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	
	if(!newSuperview) {
		[avatar cancelImageLoad];
	}
}

- (void)awakeFromNib {
    self.avatar.delegate = self;
}

- (void)imageViewLoadedImage:(EGOImageView*)imageView {
    imageView.image = [imageView.image roundedCornerImage:10 borderSize:2];
}

- (void)dealloc {
    [indexPath release];
    [avatar release];
    [labName release];
    [labSubTitle release];
    [labTime release];
    [labInfoCount release];
    [bgInfoCount release];
    [super dealloc];
}
@end
