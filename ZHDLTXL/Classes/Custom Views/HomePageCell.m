//
//  HomePageCell.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-16.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "HomePageCell.h"

@implementation HomePageCell

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
    [_addButton release];
    [_separatorImage release];
    [_detailLabel release];
    [super dealloc];
}
@end
