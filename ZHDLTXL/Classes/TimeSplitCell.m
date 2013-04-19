//
//  TimeSplitCell.m
//  ZXCXBlyt
//
//  Created by zly on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TimeSplitCell.h"

@implementation TimeSplitCell
@synthesize labTime;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    
    [labTime release];
    [super dealloc];
}
@end
