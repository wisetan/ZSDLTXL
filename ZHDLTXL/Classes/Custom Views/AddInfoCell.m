//
//  AddInfoCell.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-18.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "AddInfoCell.h"

@implementation AddInfoCell

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
    [_leftLabel release];
    [_rightLabel release];
    [super dealloc];
}
@end
