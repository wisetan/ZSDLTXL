//
//  TalkViewController.m
//  ZXCXBlyt
//
//  Created by zly on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define PLACEHOLDER_COLOR	RGBCOLOR(150, 150, 150)
#define SEND_MESSAGE_BUTTON_FONT [UIFont boldSystemFontOfSize:15]
#define TIME_SPLIT_CELL_TAG  @"44444444"

#import "TalkViewController.h"
#import "OtherTalkCell.h"
#import "MyTalkCell.h"
#import "TimeSplitCell.h"
#import "UIImage+RoundedCorner.h"
#import "ChatRecord.h"

@interface TalkViewController ()

@end

@implementation TalkViewController

@synthesize mTableView;
@synthesize dataSourceArray;
@synthesize containerView;
@synthesize fid;
@synthesize fAvatarUrl;
@synthesize timer;
@synthesize lastTime;
@synthesize doneButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    
    [self initGrowTextView];
    [self initNavigationBar];
    
    self.dataSourceArray = [NSMutableArray array];
    
    NSString *title = nil;
    
    if (self.chatList) {
        title = [NSString stringWithFormat:@"与%@留言", self.chatList.username];
    }
    else{
        title = [NSString stringWithFormat:@"与%@留言", self.username];
    }

    
    self.title = title;
//    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(20, 0, 280, 30);
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button setTitle:@"查看更多…" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:button];
//    self.mTableView.tableHeaderView = headerView;
//    self.mTableView.frame = CGRectMake(0, 0, 320, 460-44-40);
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageByName:@"bg_mask"]];
//    self.mTableView.backgroundColor = [UIColor clearColor];
    
    [self talkHistory];
    [self initTimer];
}

- (void)initTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getMessageLoop:) userInfo:nil repeats:YES];
}

- (NSString *)lastTalkTime {
//    NSString *timeString = nil;
//    for (NSDictionary *dict in self.dataSourceArray) {
//        NSString *userid = [dict objForKey:@"userid"];
//        if ([userid isValid] && [userid isEqualToString:fid]) {
//            timeString = [dict objForKey:@"time"];
//        }
//    }
    return self.lastTime ? self.lastTime : @"";
}

- (void)getMessageLoop:(NSTimer*)theTimer {
    
    if ([[self lastTalkTime] isValid]) {
        NSString *userid = [PersistenceHelper dataForKey:kUserId];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"getMessageloop.json", @"path", userid, @"userid", fid, @"destuserid", [self lastTalkTime], @"time", nil];
        [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
            NSArray *array = [json objForKey:@"MessageList"];
            if (array && [array count] > 0) {
//                [self.dataSourceArray addObjectsFromArray:array];
                [array enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
                    ChatRecord *chatRecord = [ChatRecord createEntity];
                    chatRecord.content = [dict objForKey:@"content"];
                    chatRecord.time = [[dict objForKey:@"time"] stringValue];
                    chatRecord.userid = [[dict objForKey:@"userid"] stringValue];
                    chatRecord.loginid = kAppDelegate.userId;
                    [self.dataSourceArray addObject:chatRecord];
                    DB_SAVE();
                }];
                [self.mTableView reloadData];
                
                if ([self.dataSourceArray count] > 0) {
                    [self.mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.dataSourceArray count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            }
         self.lastTime = [[json objForKey:@"LastTime"] stringValue];
         
        } failure:^(NSError *error) {
            
        }];
    }    
}
                  
- (void)viewDidUnload
{
    [self.timer invalidate];
    self.timer = nil;
    [self setMTableView:nil];
    [super viewDidUnload];
}

//- (void)moreAction {
//    NSString *myUid = [PersistenceHelper dataForKey:kUserId];
//    
//    NSString *pageSize = @"5";
//    currentPage++;
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"getMessage.json", @"path", myUid, @"userid", fid, @"destuserid", [NSString stringWithFormat:@"%d", currentPage], @"page", pageSize, @"maxrow", nil];
//    NSLog(@"dict %@", dict);
//    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
//
//        @try {
//            if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
//                NSArray *array = [json objForKey:@"MessageList"];
//
//                for (NSDictionary *dict in array) {
//                    ChatRecord *chatRecord = [ChatRecord createEntity];
//                    chatRecord.content = [dict objForKey:@"content"];
//                    chatRecord.time = [[dict objForKey:@"time"] stringValue];
//                    chatRecord.userid = [[dict objForKey:@"userid"] stringValue];
//                    chatRecord.loginid = kAppDelegate.userId;
//                    [self.dataSourceArray insertObject:chatRecord atIndex:0];
//                    DB_SAVE();
//
//                    
////                    [self.dataSourceArray insertObject:dict atIndex:0];
//                }
//
//                [self.mTableView reloadData];
//            } else {
//                //将当前页减一
//                if (currentPage > 0) {
//                    currentPage--;
//                }
//            }            
//        }
//        @catch (NSException *exception) {
//            
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"error : %@", error);
//    }];    
//}

- (void)talkHistory {
    [self.dataSourceArray removeAllObjects];
    [self.mTableView reloadData];
    
    NSString *pageSize = @"5";
    NSString *myUid = [PersistenceHelper dataForKey:kUserId];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"getMessage.json", @"path", myUid, @"userid", fid, @"destuserid", [NSString stringWithFormat:@"%d", currentPage], @"page", pageSize, @"maxrow", nil];
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {

//        NSLog(@"talk history %@", json);
        @try {
            if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
                self.lastTime = [[json objForKey:@"LastTime"] stringValue];
                NSArray *array = [json objForKey:@"MessageList"];
                for (NSDictionary *dict in array) {
//                    [self.dataSourceArray insertObject:dict atIndex:0];
                    ChatRecord *chatRecord = [ChatRecord createEntity];
                    chatRecord.content = [dict objForKey:@"content"];
                    chatRecord.time = [[dict objForKey:@"time"] stringValue];
                    NSLog(@"server time %@", chatRecord.time);
                    chatRecord.userid = [[dict objForKey:@"userid"] stringValue];
                    chatRecord.loginid = kAppDelegate.userId;
                    [self.dataSourceArray insertObject:chatRecord atIndex:0];
                    DB_SAVE();
                    
                    
                }
                [self.mTableView reloadData];
                if ([self.dataSourceArray count] > 0) {
                    [self.mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.dataSourceArray count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            }            
        }
        @catch (NSException *exception) {
            
        }
    } failure:^(NSError *error) {
        NSLog(@"error : %@", error);
    }];    
}

- (void)addMessage {

    NSString *content = [[textView text] removeSpaceAndNewLine];
    if (![content isValid] || [content isEqualToString:@"请输入要发送的消息"]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"尚未输入信息" andImageName:nil];
        return;
    }
    
    [textView resignFirstResponder];
    
    self.doneButton.enabled = NO;
    NSString *myUid = [PersistenceHelper dataForKey:kUserId];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"addMessage.json", @"path", myUid, @"userid", fid, @"destuserid", content, @"content",nil];
    
    NSLog(@"add message dict %@", dict);
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        if ([GET_RETURNCODE(json) isEqualToString:@"0"]) {
            self.doneButton.enabled = YES;
            [textView clearText];
//            NSString *myUid = [PersistenceHelper dataForKey:kUserId];
//            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:myUid, kUserId, content, @"content", @"", @"time",nil];
            
            ChatRecord *chatRecord = [ChatRecord createEntity];
            chatRecord.content = content;
            chatRecord.time = [NSString stringWithFormat:@"%.lf", [[NSDate date] timeIntervalSince1970]*1000];
            chatRecord.userid = kAppDelegate.userId;
            chatRecord.loginid = kAppDelegate.userId;
            [self.dataSourceArray addObject:chatRecord];
            DB_SAVE();

            [self.mTableView reloadData];
            if ([self.dataSourceArray count] > 0) {
                [self.mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.dataSourceArray count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        } else {
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        self.doneButton.enabled = YES;
        [kAppDelegate showWithCustomAlertViewWithText:@"发送失败，请重试" andImageName:kErrorIcon];
    }];
}

- (void)dealloc {
    [doneButton release];
    [lastTime release];
    [fAvatarUrl release];
    [fid release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [mTableView release];
    [super dealloc];
}

- (void)backAction {
    [self.timer invalidate];
    self.timer = nil;

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshAction {
//    [self talkHistory]; 
}

- (void)initNavigationBar {
    //right item
    UIButton *button = nil;
    UIBarButtonItem *button1 = nil;

    //left item
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    button.showsTouchWhenHighlighted = YES;
    [button setImage:[UIImage imageByName:@"retreat.png"] forState:UIControlStateNormal];
    button1 = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    self.navigationItem.leftBarButtonItem = button1;
}


- (void)initGrowTextView {
    containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)] autorelease];
    
    textView = [[[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 1, 240, 40) placeHolder:@"请输入要发送的消息" placeholderColor:PLACEHOLDER_COLOR] autorelease];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);    
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 4;
	textView.returnKeyType = UIReturnKeyDefault;
	textView.font = [UIFont systemFontOfSize:17.0f];
	textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:containerView];
	
    UIImage *rawEntryBackground = [UIImage imageByName:@"MessageEntryInputField"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[[UIImageView alloc] initWithImage:entryBackground] autorelease];
    entryImageView.frame = CGRectMake(5, 0, 248, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageByName:@"MessageEntryBackground"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:background] autorelease];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:imageView];
    [containerView addSubview:textView];
    [containerView addSubview:entryImageView];
    
    UIImage *sendBtnBackground = [[UIImage imageByName:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageByName:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(containerView.frame.size.width - 69, 8, 63, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"发送" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = SEND_MESSAGE_BUTTON_FONT;
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(addMessage) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;    
    
    self.doneButton = doneBtn;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    ChatRecord *chatRecord = [self.dataSourceArray objectAtIndex:indexPath.row];
//    NSString *uid = [[dict objForKey:@"userid"] stringValue];
//    NSString *content = [dict objForKey:@"content"];
    NSString *uid = chatRecord.userid;
    NSString *content = chatRecord.content;
    if ([uid isEqualToString:fid]) {
        return [OtherTalkCell heightForCellWithContent:content];    
    } else if ([uid isEqualToString:TIME_SPLIT_CELL_TAG]) {
        return 20;
    } else {
        return [MyTalkCell heightForCellWithContent:content];
    }    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kOtherCell  = @"OtherTalkCell";
    static NSString *kMyCell     = @"MyTalkCell";
    static NSString *kTimeCell   = @"TimeSplitCell";
    
    UITableViewCell *cell = nil;
//    NSDictionary *dict = nil;
//
//    dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    ChatRecord *chatRecord = [self.dataSourceArray objectAtIndex:indexPath.row];

//    NSLog(@"message dict %@", dict);
//    NSString *uid = [[dict objForKey:kUserId] stringValue];
    NSString *uid = chatRecord.userid;
    
    if ([uid isEqualToString:fid]) {
        cell = (OtherTalkCell *)[_tableView dequeueReusableCellWithIdentifier:kOtherCell];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OtherTalkCell" owner:self options:nil];
            cell = (OtherTalkCell *)[nib objectAtIndex:0];
            ((OtherTalkCell *)cell).avatar.placeholderImage = [UIImage imageByName:@"AC_talk_icon.png"];
            ((OtherTalkCell *)cell).avatar.delegate = self;
        }
    } else if ([uid isEqualToString:TIME_SPLIT_CELL_TAG]) {
        cell = (TimeSplitCell *)[_tableView dequeueReusableCellWithIdentifier:kTimeCell];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TimeSplitCell" owner:self options:nil];
            cell = (TimeSplitCell *)[nib objectAtIndex:0];
        }
    } else {
        cell = (MyTalkCell *)[_tableView dequeueReusableCellWithIdentifier:kMyCell];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyTalkCell" owner:self options:nil];
            cell = (MyTalkCell *)[nib objectAtIndex:0];
        }        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
//    NSString *content = [dict objForKey:@"content"];
//    NSString *time    = [dict objForKey:@"time"];
    ChatRecord *chatRecord = [self.dataSourceArray objectAtIndex:indexPath.row];
    NSString *content = chatRecord.content;
//    NSString *time    = chatRecord.time;
    NSLog(@"chatRecord.time %@", chatRecord.time);
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:chatRecord.time.doubleValue/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy年M月d日 H:mm"];
    NSString *time = [dateFormatter stringFromDate:date];
    
    if ([cell isKindOfClass:[OtherTalkCell class]]) {
        [[(OtherTalkCell *)cell labContent] setText:content];
        [[(OtherTalkCell *)cell labTime] setText:time];
        ((OtherTalkCell *)cell).avatar.imageURL = [fAvatarUrl isValid] ? [NSURL URLWithString:fAvatarUrl] : nil;
    } else if ([cell isKindOfClass:[TimeSplitCell class]]) {
        [[(TimeSplitCell *)cell labTime] setText:content];
    } else{
        [[(MyTalkCell *)cell labContent] setText:content];
        [[(MyTalkCell *)cell labTime] setText:time];
    }
}

-(void)keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    CGRect tableViewFrame = self.mTableView.frame;
    CGFloat viewHeight = 0.f;
    if (IS_IPHONE_5) {
        viewHeight = 504.f;
    }
    else{
        viewHeight = 416.f;
    }
    
    
    tableViewFrame.size.height = viewHeight - keyboardBounds.size.height - 40;
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
//    NSLog(@"containerView : %@", containerView);
	containerView.frame = containerFrame;
	self.mTableView.frame = tableViewFrame;
	// commit animations
	[UIView commitAnimations];
    
    if ([self.dataSourceArray count] > 0) {
        [self.mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.dataSourceArray count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

-(void)keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
    CGRect tableViewFrame = self.mTableView.frame;
    CGFloat viewHeight = 0.f;
    if (IS_IPHONE_5) {
        viewHeight = 548.f;
    }
    else{
        viewHeight = 460;
    }
    
    tableViewFrame.size.height = viewHeight - 44 - 40;
    
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	containerView.frame = containerFrame;
	self.mTableView.frame = tableViewFrame;
	// commit animations
	[UIView commitAnimations];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([textView isFirstResponder]) {
        [textView resignFirstResponder];
    }
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
}

- (void)imageViewLoadedImage:(EGOImageView*)imageView {
    imageView.image = [imageView.image roundedCornerImage:10 borderSize:2];
}

@end
