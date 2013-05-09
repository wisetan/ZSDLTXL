//
//  MailInfoCell.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-5-2.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "MailInfoCell.h"

@implementation MailInfoCell

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
    [_unreadImage release];
    [_headIcon release];
    [_usernameLabel release];
    [_dateLabel release];
    [_subjectLabel release];
    [super dealloc];
}
@end
