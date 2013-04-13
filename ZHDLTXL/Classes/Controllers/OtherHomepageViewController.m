//
//  HomepageViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-12.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "OtherHomepageViewController.h"
#import "SendMessageViewController.h"
#import "SendEmailViewController.h"
#import "ChatViewController.h"
#import "GroupSendViewController.h"

#define VIEW_GAP 10
#define VIEW_LEFT_MARGIN (20)
#define VIEW_WIDTH (320-2*(VIEW_LEFT_MARGIN))

@interface OtherHomepageViewController ()

@end

@implementation OtherHomepageViewController

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
	self.title = @"他的主页";
    
    UIImageView *backBgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"debut_light.png"]];
    backBgImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    backBgImage.userInteractionEnabled = YES;
    [self.view addSubview:backBgImage];
    [backBgImage release];
    
    //back button
    UIButton *backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    //head icon
    
    self.headIconName = @"AC_L_icon.png";
    UIImageView *headIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.headIconName]];
    headIcon.frame = CGRectMake(VIEW_LEFT_MARGIN, 15.f, 59, 59);
    [self.view addSubview:headIcon];
    [headIcon release];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 15.f, 100, 35.f)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = self.userName;
    nameLabel.font = [UIFont systemFontOfSize:18.f];
    nameLabel.textColor = kContentColor;
    [self.view addSubview:nameLabel];
    
    //resident label
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.f, 48.f, 80.f, 30)];
    areaLabel.backgroundColor = [UIColor clearColor];
    areaLabel.font = [UIFont systemFontOfSize:14.f];
    areaLabel.text = @"常驻地区：";
    areaLabel.textColor = kContentBlueColor;
    [self.view addSubview:areaLabel];
    
    UILabel *residentAreaLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 48.f, 80.f, 30.f)];
    residentAreaLabel.backgroundColor = [UIColor clearColor];
    self.residentArea = @"北京、上海";
    residentAreaLabel.font = [UIFont systemFontOfSize:14];
    residentAreaLabel.text = self.residentArea;
    residentAreaLabel.textColor = kContentBlueColor;
    [self.view addSubview:residentAreaLabel];
    
    //category label
    UILabel *cateLabel = [[UILabel alloc] init];
    cateLabel.backgroundColor = [UIColor clearColor];
    cateLabel.text = self.residentArea;
    cateLabel.textColor = kSubContentColor;
    CGSize cateLabelSize = [self.residentArea sizeWithFont:cateLabel.font
                                         constrainedToSize:CGSizeMake(240.f, MAXFLOAT)
                                             lineBreakMode:NSLineBreakByWordWrapping];
    cateLabel.frame = CGRectMake(20, 20, 240, cateLabelSize.height);
    
    UIImageView *cateBgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"underframe.png"]];
    cateBgImage.frame = CGRectMake(20, 90.f, 280.f, cateLabelSize.height+40.f);
    [cateBgImage addSubview:cateLabel];
    [self.view addSubview:cateBgImage];
    
    //contact him view
    ContactHimView *contactHimView = [[ContactHimView alloc] initWithFrame:CGRectMake(22.f, 160.f, 276.f, 55.f)];
    contactHimView.delegate = self;
    [self.view addSubview:contactHimView];
    
    //comment
    UIImage *commentImage = [[UIImage imageNamed:@"editor_area.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    UIImageView *commentBgImage = [[UIImageView alloc] initWithImage:commentImage];
    commentBgImage.frame = CGRectMake(VIEW_LEFT_MARGIN, 235.f, VIEW_WIDTH, 50.f);
    commentBgImage.userInteractionEnabled = YES;
    
    UITextField *commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 15, VIEW_WIDTH-60, 40.f)];
    commentTextField.placeholder = @"对他添加备注";
    commentTextField.font = [UIFont systemFontOfSize:16.f];
    commentTextField.borderStyle = UITextBorderStyleNone;
    commentTextField.delegate = self;
    [commentBgImage addSubview:commentTextField];
    
    [self.view addSubview:commentBgImage];
    
    
    UIButton *addFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addFriendButton setImage:[UIImage imageNamed:@"addfriend_button.png"] forState:UIControlStateNormal];
    [addFriendButton setImage:[UIImage imageNamed:@"addfriend_button_p.png"] forState:UIControlStateHighlighted];
    UILabel *btnTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 260, 45.f)];
    btnTitleLabel.backgroundColor = [UIColor clearColor];
    btnTitleLabel.text = @"加为好友";
    btnTitleLabel.textAlignment = NSTextAlignmentCenter;
    [btnTitleLabel setFont:[UIFont systemFontOfSize:18.f]];
    [btnTitleLabel setTextColor:[UIColor whiteColor]];
    addFriendButton.frame = CGRectMake(20, 300, 280, 55.f);
    [addFriendButton addSubview:btnTitleLabel];
    [addFriendButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:addFriendButton];
    
    
    
}

- (void)addFriend:(UIButton *)sender
{
    NSLog(@"添加好友");

}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = self.view.frame;
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = CGRectMake(frame.origin.x, frame.origin.y-144.f, frame.size.width, frame.size.height);
    }];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = CGRectMake(0, 0, 320, 460);
    }];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - contactHimView delegate

- (void)message:(Contact *)contact
{
    NSLog(@"send message");
    SendMessageViewController *smVC = [[SendMessageViewController alloc] init];
    smVC.contactDict = self.contactDict;
    [self.navigationController pushViewController:smVC animated:YES];
    [smVC release];
}

- (void)email:(Contact *)contact
{
    NSLog(@"send email");
    SendEmailViewController *seVC = [[SendEmailViewController alloc] init];
    [self.navigationController pushViewController:seVC animated:YES];
    [seVC release];
}

- (void)chat:(Contact *)contact
{
    NSLog(@"chat");
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:chatVC animated:YES];
    [chatVC release];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
