//
//  RegistViewController.h
//  ZXCXBlyt
//
//  Created by zly on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCTextfieldCell.h"
#import "AddInfoViewController.h"

#define kRegistSucceed @"RegistSuccess"

@interface RegistViewController : UIViewController
<
ELCTextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource,
AddInfoViewControllerDelegate
>
{
    NSArray *leftArray;
    NSArray *rightArray;
    NSMutableArray *registInfo;
    BOOL alreadyGetValidationCode;
}

@property (retain, nonatomic) NSArray *leftArray;
@property (retain, nonatomic) NSArray *rightArray;
@property (retain, nonatomic) IBOutlet UITableView *mTableView;
@property (retain, nonatomic) NSMutableArray *registInfo;





@end
