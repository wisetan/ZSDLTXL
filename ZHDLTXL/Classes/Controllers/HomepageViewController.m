//
//  HomepageViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-12.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "HomepageViewController.h"

#define VIEW_GAP 10
#define VIEW_LEFT_MARGIN (20)
#define VIEW_WIDTH (320-2*(VIEW_LEFT_MARGIN))

@interface HomepageViewController ()

@end

@implementation HomepageViewController

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
    UIImageView *headIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.headIconName]];
    headIcon.frame = CGRectMake(VIEW_LEFT_MARGIN, VIEW_GAP, 59, 59);
    [self.view addSubview:headIcon];
    [headIcon release];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 100, 60)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = self.userName;
    nameLabel.font = [UIFont systemFontOfSize:20];
    nameLabel.textColor = kContentColor;
    [self.view addSubview:nameLabel];
    
    //resident label
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 60, 60, 30)];
    areaLabel.backgroundColor = [UIColor clearColor];
    areaLabel.text = @"常驻地区：";
    areaLabel.textColor = kContentBlueColor;
    [self.view addSubview:areaLabel];
    
    UILabel *residentAreaLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 60, 60, 30)];
    residentAreaLabel.backgroundColor = [UIColor clearColor];
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
    cateBgImage.frame = CGRectMake(20, 140, 280.f, cateLabelSize.height+40.f);
    [cateBgImage addSubview:cateLabel];
    [self.view addSubview:cateLabel];
    
    //contact him view
    ContactHimView *contactHimView = [[ContactHimView alloc] initWithFrame:CGRectMake(VIEW_LEFT_MARGIN, 200.f, VIEW_WIDTH, 80.f)];
    contactHimView.delegate = self;
    [self.view addSubview:contactHimView];
    
    //comment
    UIImage *commentImage = [[UIImage imageNamed:@"editor_area.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    UIImageView *commentBgImage = [[UIImageView alloc] initWithImage:commentImage];
    commentBgImage.frame = CGRectMake(VIEW_LEFT_MARGIN, 260, VIEW_WIDTH, 65.f);
    commentBgImage.userInteractionEnabled = YES;
    
    UITextField *commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 15, VIEW_WIDTH-60, 40.f)];
    commentTextField.placeholder = @"对他添加备注";
    commentTextField.font = [UIFont systemFontOfSize:18];
    commentTextField.borderStyle = UITextBorderStyleNone;
    [commentBgImage addSubview:commentTextField];
    
    [self.view addSubview:commentBgImage];
    
    
    UIButton *addFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addFriendButton setImage:[UIImage imageNamed:@"add_friend_button.png"] forState:UIControlStateNormal];
    [addFriendButton setImage:[UIImage imageNamed:@"add_friend_button_p.png"] forState:UIControlStateHighlighted];
    addFriendButton.titleLabel.text = @"加为好友";
    [addFriendButton.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
    [addFriendButton.titleLabel setTextColor:[UIColor whiteColor]];
    addFriendButton.frame = CGRectMake(40, 260, 240, 48);
    [addFriendButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:addFriendButton];
    
    
    
}

#pragma mark - contact him view delegate
- (void)message:(Contact *)contact
{
    
}

- (void)email:(Contact *)contact
{
    
}

- (void)chat:(Contact *)contact
{
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
