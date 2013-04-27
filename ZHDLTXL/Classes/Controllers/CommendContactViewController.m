//
//  CommendContactViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-26.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "CommendContactViewController.h"

@interface CommendContactViewController ()

@end

@implementation CommendContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *)tabImageName
{
    return nil;
}

// Setting the title of the tab.
- (NSString *)tabTitle
{
    return @"推荐";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"推荐";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topmargin.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)triggerCityUpdate
{
    NSLog(@"city update");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
