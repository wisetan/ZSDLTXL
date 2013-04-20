//
//  SendMessageViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-10.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "SendMessageViewController.h"
#import "GroupSendViewController.h"


@interface SendMessageViewController ()

@property (nonatomic, assign) CGFloat textViewEditingHeight;
@property (nonatomic, assign) CGFloat textViewHeight;

@end

@implementation SendMessageViewController

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
    [self addObserver];
    self.contactArray = [[NSMutableArray new] autorelease];
    [self.contactArray addObject:self.currentContact];
    
    self.title = @"发送短信";
    
    //nav bar image
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topmargin.png"] forBarMetrics:UIBarMetricsDefault];
    
    //back bar button
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    [self.addButton addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.nameLabel.text = self.currentContact.username;
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textColor = [UIColor colorWithRed:98.f/255.f green:98.f/255.f blue:98.f/255.f alpha:1.f];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    
    //send message Button;
    [self.sendButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    [self.sendButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];

    //cancel button

    [self.cancelButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    [self.cancelButton addTarget:self action:@selector(cancelSend:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *editorBgImage = [UIImage stretchableImage:@"editor_area.png" leftCap:40 topCap:40];
    self.textBgImageView.image = editorBgImage;
    
    self.textView.text = @"编辑短信";
    self.textView.textColor = [UIColor lightGrayColor];

    
    //add person button

    [self.addButton setImage:[UIImage imageNamed:@"more_select_p.png"] forState:UIControlStateHighlighted];
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendMessage:(UIButton *)sender
{
    NSLog(@"send message");
    NSMutableArray *telNumArray = [[NSMutableArray alloc] init];
    [self.contactArray enumerateObjectsUsingBlock:^(Contact *contact, NSUInteger idx, BOOL *stop) {
        [telNumArray addObject:contact.tel];
    }];
    
    
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if([MFMessageComposeViewController canSendText])
    {
        if ([self.textView.text isEqualToString:@"编辑短信"]) {
            controller.body = @"";
        }
        else{
            controller.body = self.textView.text;
        }
        controller.recipients = telNumArray;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:^{
            return ;
        }];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:^{
        NSLog(@"发送完成");
    }];
}

- (void)cancelSend:(UIButton *)sender
{
    NSLog(@"cancel send message");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addContact:(UIButton *)sender
{
    NSLog(@"add contact");
    NSLog(@"self.contactArray %@", self.contactArray);
    GroupSendViewController *groupSendVC = [[GroupSendViewController alloc] init];
    groupSendVC.selectedContactArray = self.contactArray;
    groupSendVC.originContact = self.currentContact;
    [self.navigationController pushViewController:groupSendVC animated:YES];
    [groupSendVC release];
}

//hide keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - textview delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    if (!IS_IPHONE_5) {
        
        CGRect frame = self.view.frame;
        frame.origin.y -= 100;
        [UIView animateWithDuration:.5f animations:^{
            self.view.frame = frame;
        }];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (!IS_IPHONE_5) {
        [UIView animateWithDuration:0.5f animations:^{
            self.view.frame = CGRectMake(0, 0, [kAppDelegate window].frame.size.width, [kAppDelegate window].frame.size.height-64);
        }];
    }
    if (textView.text.length == 0) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"编辑邮件";
    }
}

#pragma mark - observer method

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addContactFinished:) name:kSendMessageAddFriendNotification object:nil];
}

- (void)removeObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addContactFinished:(NSNotification *)noti
{
    [noti.object enumerateObjectsUsingBlock:^(Contact *contact, NSUInteger idx, BOOL *stop) {
        if (![self.contactArray containsObject:contact]) {
            [self.contactArray addObject:contact];
        }
    }];
    NSMutableString *allSendTargetName = [[NSMutableString alloc] init];
    [self.contactArray enumerateObjectsUsingBlock:^(Contact *contact, NSUInteger idx, BOOL *stop) {
        [allSendTargetName appendFormat:@"%@、", contact.username];
    }];
    if ([allSendTargetName isValid]) {
        allSendTargetName = (NSMutableString *)[allSendTargetName substringToIndex:[allSendTargetName length] - 1];
    }
    NSLog(@"all name: %@", allSendTargetName);
    self.nameLabel.text = allSendTargetName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self removeObserver];
    [_addButton release];
    [_textBgImageView release];
    [super dealloc];
}

@end
