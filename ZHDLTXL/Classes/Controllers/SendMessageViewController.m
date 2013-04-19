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
    
    //bg image
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"debut_light.png"]];
    bgImage.userInteractionEnabled = YES;
    bgImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:bgImage];
    [bgImage release];
    
    //nav bar image
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topmargin.png"] forBarMetrics:UIBarMetricsDefault];
    
    //back bar button
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    //bottom image view
	self.bottomImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_bg.png"]] autorelease];
    self.bottomImageView.frame = CGRectMake(0, self.view.frame.size.height-45-44, 320, 45);
    self.bottomImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.bottomImageView];
    
    //send message Button;
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.sendButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    [self.sendButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    self.sendButton.frame = CGRectMake(10, 5, 101, 34);
    [self.sendButton setTitle:@"确认发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UILabel *sendLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 101.f, 34.f)] autorelease];
    sendLabel.text = @"确认发送";
    [sendLabel setFont:[UIFont systemFontOfSize:16]];
    sendLabel.backgroundColor = [UIColor clearColor];
    sendLabel.textColor = [UIColor whiteColor];
    sendLabel.textAlignment = NSTextAlignmentCenter;
    [self.sendButton addSubview:sendLabel];
    [self.bottomImageView addSubview:self.sendButton];
    
    //cancel button
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.cancelButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    [self.cancelButton addTarget:self action:@selector(cancelSend:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.frame = CGRectMake(209, 5, 101, 34);
    UILabel *cancelLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 101, 34)] autorelease];
    cancelLabel.text = @"取消";
    [cancelLabel setFont:[UIFont systemFontOfSize:16]];
    cancelLabel.backgroundColor = [UIColor clearColor];
    cancelLabel.textColor = [UIColor whiteColor];
    cancelLabel.textAlignment = NSTextAlignmentCenter;
    [self.cancelButton addSubview:cancelLabel];
    [self.bottomImageView addSubview:self.cancelButton];
    
    //发送对象 label
    self.sendTargetLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 160, 40)] autorelease];
    self.sendTargetLabel.text = @"发送对象：";
    self.sendTargetLabel.font = [UIFont systemFontOfSize:14];
    self.sendTargetLabel.textColor = [UIColor colorWithRed:98.f/255.f green:98.f/255.f blue:98.f/255.f alpha:1.f];
    self.sendTargetLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.sendTargetLabel];
    
    //name label
    self.nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 50, 210, 40)] autorelease];
    self.nameLabel.text = self.currentContact.username;
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textColor = [UIColor colorWithRed:98.f/255.f green:98.f/255.f blue:98.f/255.f alpha:1.f];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.nameLabel];
    
    
    UIImage *editorBgImage = [UIImage stretchableImage:@"editor_area.png" leftCap:10 topCap:10];
    self.textViewBgImage = [[[UIImageView alloc] initWithImage:editorBgImage] autorelease];
    if (IS_IPHONE_5) {
        self.textViewBgImage.frame = CGRectMake(10, 90, 300, 160);
    }
    else{
        self.textViewBgImage.frame = CGRectMake(10, 90, 300, 240);
    }
    [self.view addSubview:self.textViewBgImage];
    self.textViewBgImage.userInteractionEnabled = YES;
    
    if (IS_IPHONE_5) {
        self.textViewHeight = 140;
    }
    else{
        self.textViewHeight = 220;
    }
//    self.textViewEditingHeight = self.textViewHeight - 130;
//    
//    self.messageTextView = [[[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(5, 10, self.textViewBgImage.frame.size.width-10, self.textViewHeight)] autorelease];
    self.messageTextView.delegate = self;
//    self.messageTextView.placeholder = @"短信";
//    [self.textViewBgImage addSubview:self.messageTextView];
    
    //add person button
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton.frame = CGRectMake(255, 50, 36, 36);
    [self.addButton setImage:[UIImage imageNamed:@"more_select.png"] forState:UIControlStateNormal];
    [self.addButton setImage:[UIImage imageNamed:@"more_select_p.png"] forState:UIControlStateHighlighted];
    [self.addButton addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addButton];
    
    
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
        controller.body = self.messageTextView.text;
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
    [self.contactArray removeAllObjects];
    [self.contactArray addObject:self.currentContact];
    GroupSendViewController *groupSendVC = [[GroupSendViewController alloc] init];
    groupSendVC.contactDictSortByAlpha = self.contactDict;
    [self.navigationController pushViewController:groupSendVC animated:YES];
    [groupSendVC release];
}

//hide keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - textview delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
//    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, self.textViewEditingHeight);
    textView.textColor = [UIColor blackColor];
    textView.text = @"";
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
//    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, self.textViewHeight);
    if([textView.text length] == 0)
    {
        textView.text = @"编辑邮件";
        textView.textColor = [UIColor lightGrayColor];
        textView.tag = 0;
    }
}

#pragma mark - observer method

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addContactFinished:) name:kSendMessageAddFriendNotification object:nil];
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
    [super dealloc];
}

@end
