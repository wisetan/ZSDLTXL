//
//  ChatViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-10.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"与张三聊天";
    
    //back button
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.backBarButton];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    
    self.messages = [[NSMutableArray alloc] init];
    self.delegate = self;
    self.dataSource = self;
	// Do any additional setup after loading the view.
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)sendButton
{
    // Override to use a custom send button
    // The button's frame is set automatically for you
//    return [UIButton defaultSendButton];
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin);
    
//    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    UIImage *sendBack = [UIImage imageNamed:@"button.png"]; // resizableImageWithCapInsets:insets];
    UIImage *sendBackHighLighted = [UIImage imageNamed:@"button_p.png"]; //resizableImageWithCapInsets:insets];
    [sendButton setBackgroundImage:sendBack forState:UIControlStateNormal];
    [sendButton setBackgroundImage:sendBack forState:UIControlStateDisabled];
    [sendButton setBackgroundImage:sendBackHighLighted forState:UIControlStateHighlighted];
    
    NSString *title = @"发送";
    [sendButton setTitle:title forState:UIControlStateNormal];
    [sendButton setTitle:title forState:UIControlStateHighlighted];
    [sendButton setTitle:title forState:UIControlStateDisabled];
    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    UIColor *titleShadow = [UIColor colorWithRed:0.325f green:0.463f blue:0.675f alpha:1.0f];
    [sendButton setTitleShadowColor:titleShadow forState:UIControlStateNormal];
    [sendButton setTitleShadowColor:titleShadow forState:UIControlStateHighlighted];
    sendButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
    
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [sendButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateDisabled];
    
    return sendButton;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    [self.messages addObject:text];
    
    [self.timestamps addObject:[NSDate date]];
    
    if((self.messages.count - 1) % 2)
        [JSMessageSoundEffect playMessageSentSound];
    else
        [JSMessageSoundEffect playMessageReceivedSound];
    
    [self finishSend];
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row % 2) ? JSBubbleMessageStyleIncomingCustom : JSBubbleMessageStyleOutgoingCustom;
}

- (JSMessagesViewTimestampPolicy)timestampPolicyForMessagesView
{
//    return JSMessagesViewTimestampPolicyEveryThree;
    return JSMessagesViewTimestampPolicyCustom;
}

- (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // custom implementation here, if using `JSMessagesViewTimestampPolicyCustom`
    return [self shouldHaveTimestampForRowAtIndexPath:indexPath];
}

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.row];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.timestamps objectAtIndex:indexPath.row];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
