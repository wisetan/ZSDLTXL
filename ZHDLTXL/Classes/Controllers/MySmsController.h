//
//  MyInfoController.h
//  ZXCXBlyt
//
//  Created by zly on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomTableViewBase.h"
#import "MyInfoCell.h"

@interface MySmsController : CustomTableViewBase<MyInfoDelegate, EGOImageViewDelegate> {
    NSDictionary *mCompanyDict;
}

@property (nonatomic, retain) NSDictionary *mCompanyDict;
@property (assign, nonatomic) id delegate;
@end
