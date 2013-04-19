//
//  ZDCell.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-18.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "ZDCell.h"

@implementation ZDCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_nameLabel release];
    [_selectImage release];
    [super dealloc];
}

- (void)layoutSubviews
{
    CGRect frame = self.contentView.frame;
    
    self.selectImage.frame = CGRectMake(frame.size.width-20-30, 10, 30, 30);
    
    [super layoutSubviews];
}
@end
