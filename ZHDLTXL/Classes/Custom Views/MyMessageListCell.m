//
//  MyMessageListCell.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-5-3.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "MyMessageListCell.h"

@implementation MyMessageListCell

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
    [_headIcon release];
    [_nameLabel release];
    [_dateLabel release];
    [_subjectLabel release];
    [_unreadCountLabel release];
    [_unreadCountBg release];
    [super dealloc];
}
@end
