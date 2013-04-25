//
//  SelectViewController.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-16.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (retain, nonatomic) UITableView *selectTableView;
@property (retain, nonatomic) NSMutableArray *cateArray;
@property (retain, nonatomic) NSMutableArray *selectArray;

@property (retain, nonatomic) UIButton *confirmButton;
@property (retain, nonatomic) UIButton *backBarButton;
@property (retain, nonatomic) UIButton *rightBarButton;
@property (assign, nonatomic) NSInteger zdKind;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;

@end
