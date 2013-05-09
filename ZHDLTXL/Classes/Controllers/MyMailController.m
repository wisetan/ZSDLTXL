//
//  MyInfoController.m
//  ZXCXBlyt
//
//  Created by zly on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyMailController.h"
#import "TalkViewController.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "MailInfo.h"
#import "SendEmailViewController.h"


@interface MyMailController ()

@end

@implementation MyMailController
@synthesize mCompanyDict;
@synthesize delegate;
- (void)dealloc
{
    self.mCompanyDict = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"我的邮件";
    }
    return self;
}

- (void)viewDidLoad
{

//    self.toolBarButtons = @[@{@"image": [UIImage imageNamed:@"button.png"], @"title":@"发件箱"}, @{@"image": [UIImage imageNamed:@"button.png"], @"title":@"收件箱"}];
    [super viewDidLoad];
    NSArray * toolBarBtns = @[@{@"image": [UIImage imageNamed:@"button.png"], @"title":@"发件箱"}, @{@"image": [UIImage imageNamed:@"button.png"], @"title":@"收件箱"}];
    self.mails = [[NSMutableArray alloc] init];

    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageByName:@"bg_mask"]];

    CGFloat tableHight = 0;
    if (IS_IPHONE_5) {
        tableHight = 460;
    }
    else{
        tableHight = 372;
    }

    self.tableView.frame = CGRectMake(0, 0, 320, tableHight);
   
    [self initNavigationBar];
    [self initToolBarWithButtons:toolBarBtns];
}

- (void)initToolBarWithButtons:(NSArray *)buttons
{
    CGFloat viewHeight = 0;
    if (IS_IPHONE_5) {
        viewHeight = 548;
    }
    else{
        viewHeight = 460;
    }
    
    
    
    self.toolBar = [[[UIView alloc] initWithFrame:CGRectMake(0, viewHeight-88, 320, 44)] autorelease];
    UIImageView *toolBarImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_bg.png"]];
    toolBarImage.frame = CGRectMake(0, 0, 320, 44);
    toolBarImage.userInteractionEnabled = YES;
    [self.toolBar addSubview:toolBarImage];
    
    [self.view addSubview:self.toolBar];
    
    for (int i = 0; i < [buttons count]; i++) {
        NSDictionary *dict = [buttons objectAtIndex:i];
        UIImage *image = [dict objForKey:@"image"];
        NSString *title  = [dict objForKey:@"title"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        //        button.showsTouchWhenHighlighted = YES;
        button.frame = CGRectMake(10+220*i, 5, 80, 34);
        button.tag = i;
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 34)] autorelease];
        label.text = title;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        [button addSubview:label];
        [self.toolBar addSubview:button];
        
        
        [button addTarget:self action:@selector(toolBarAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)toolBarAction:(UIButton *)button
{
    if (button.tag == 0) {
        
    }
    else{
        
    }
}


- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
    [self refreshAction];
}

- (void)initNavigationBar {    
    //left item
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    button.showsTouchWhenHighlighted = YES;
    [button setImage:[UIImage imageByName:@"retreat.png"] forState:UIControlStateNormal];
    UIBarButtonItem *button1 = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    self.navigationItem.leftBarButtonItem = button1;
}


- (void)refreshAction {
    [self sendUpdateRequestForce:YES];
}

- (void)backAction {
    if ([delegate respondsToSelector:@selector(refreshAction)]) {
        [delegate refreshAction];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (NSString *)stringForParseJson {
    return @"MessagePeoperList";
}

- (UIViewController *)tableView:(UITableView *)_tableView pushRowAtIndexPath:(NSIndexPath *)indexPath
{
    MailInfo *mail = [self.dataSourceArray objectAtIndex:indexPath.row];
    SendEmailViewController *sendMailVC = [[SendEmailViewController alloc] init];
    sendMailVC.mail = mail;
    return sendMailVC;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtNotLastIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellId = @"MyInfoCell";
    
    MyInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellId];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyInfoCell" owner:self options:nil];
        cell = (MyInfoCell *)[nib objectAtIndex:0];
        cell.avatar.placeholderImage = [UIImage imageByName:@"AC_talk_icon.png"];
        [Utility plainTableView:_tableView changeBgForCell:cell atIndexPath:indexPath];
        [self configureCell:cell atNotLastIndexPath:indexPath];
    }
    
    cell.indexPath = indexPath;
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)theCell atNotLastIndexPath:(NSIndexPath *)indexPath {
    @try {
//        NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
        MailInfo *mail = [self.dataSourceArray objectAtIndex:indexPath.row];
        MyInfoCell *cell = (MyInfoCell *)theCell;
//        cell.avatar.imageURL = [url isValid] ? [NSURL URLWithString:url] : nil;
        
        cell.labName.text = mail.username;
        cell.labSubTitle.text = mail.subject;
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:mail.date.doubleValue];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
        [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
        [dateFormatter setLocale:[NSLocale currentLocale]];

        cell.labTime.text = [dateFormatter stringFromDate:date];
//        NSLog(@"The date is %@", [dateFormatter stringFromDate:date]);
        [dateFormatter release];
        

        cell.labInfoCount.hidden = YES;
        cell.bgInfoCount.hidden  = YES;

        cell.delegate = self;
        cell.indexPath = indexPath;
    }
    @catch (NSException *exception) {
        
    }
}

@end
