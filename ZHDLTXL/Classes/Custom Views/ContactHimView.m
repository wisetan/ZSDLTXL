//
//  ContactHimView.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-9.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "ContactHimView.h"

@interface ContactButton : UIButton

@property (nonatomic, retain) UILabel *contactLabel;
@property (nonatomic, retain) NSString *bgImageName;
@property (nonatomic, retain) NSString *bgHighlightImageName;
@property (nonatomic, retain) UIImageView *contactIcon;
@property (nonatomic, retain) NSString *iconFilename;
@property (nonatomic, retain) NSString *iconFilename_p;   //pressed image
@property (nonatomic, copy) NSString *contactName;
@property (nonatomic, retain) NSString *btnTitle;

@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) id delegate;

@property (nonatomic, assign) BOOL hasBadge;
@property (nonatomic, copy) NSString *badgeNumber;


@end

@implementation ContactButton

- (id)makeButton
{
    CGFloat width = self.frame.size.width;
    
    if (self.hasBadge) {
        CustomBadge * badge = [CustomBadge customBadgeWithString:self.badgeNumber
                                                       withStringColor:[UIColor whiteColor]
                                                        withInsetColor:[UIColor redColor]
                                                        withBadgeFrame:YES
                                                   withBadgeFrameColor:[UIColor whiteColor] 
                                                             withScale:1.0
                                                           withShining:YES];
        badge.frame = CGRectMake(self.frame.size.width, 0, badge.frame.size.width, badge.frame.size.height);
        [self addSubview:badge];
    }
    
    
    self.contactIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:self.iconFilename]] autorelease];
    CGFloat contactIconWidth = width / 3.f;
    CGFloat contactIconHeight = contactIconWidth * 5.f / 6.f;
    self.contactIcon.frame = CGRectMake(0, 0, (int)contactIconWidth, (int)contactIconHeight);
    self.contactIcon.center = CGPointMake((int)((self.center.x-self.frame.origin.x) / 1.8f), (int)self.center.y);
    [self addSubview:self.contactIcon];
    
    [self setImage:[UIImage imageNamed:self.bgImageName] forState:UIControlStateNormal];
    
    CGFloat contactLabelWidth = width / 2.f;
    CGFloat contactLabelHeight = contactLabelWidth;
    self.contactLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, (int)contactLabelWidth, (int)contactLabelHeight)] autorelease];
    self.contactLabel.text = self.btnTitle;
    self.contactLabel.font = [UIFont systemFontOfSize:15];
    self.contactLabel.textColor = kContentBlueColor;
    self.contactLabel.backgroundColor = [UIColor clearColor];
    self.contactLabel.center = CGPointMake((int)((self.center.x-self.frame.origin.x)*1.5f), (int)(self.center.y));
    [self addSubview:self.contactLabel];
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.contactIcon.image = [UIImage imageNamed:self.iconFilename_p];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.contactIcon.image = [UIImage imageNamed:self.iconFilename];
    [self.delegate performSelector:self.selector withObject:self];
    
}

@end


@interface ContactHimView()

@end

@implementation ContactHimView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        ContactButton *messageButton = [ContactButton buttonWithType:UIButtonTypeCustom];
        messageButton.hasBadge = self.hasBadge;
        messageButton.badgeNumber = [self.badgeNumberArray objectAtIndex:0];
        messageButton.frame = CGRectMake(0, 0, (int)(width / 3.f), (int)height);
        messageButton.iconFilename = @"message.png";
        messageButton.iconFilename_p = @"message_p.png";
        messageButton.bgImageName = @"button_left_message.png";
        messageButton.btnTitle = @"短信";
        messageButton = [messageButton makeButton];
        messageButton.selector = @selector(sendMessage:);
        messageButton.delegate = self;

        
        
        ContactButton *emailButton = [ContactButton buttonWithType:UIButtonTypeCustom];
        emailButton.hasBadge = self.hasBadge;
        emailButton.badgeNumber = [self.badgeNumberArray objectAtIndex:0];
        emailButton.frame = CGRectMake((int)(width / 3.f), 0, (int)(width / 3.f + 1), (int)height);
        emailButton.iconFilename = @"mail.png";
        emailButton.iconFilename_p = @"mail_p.png";
        emailButton.bgImageName = @"button_middle_email.png";
        emailButton.btnTitle = @"邮件";
        emailButton = [emailButton makeButton];
        emailButton.selector = @selector(sendEmail:);
        emailButton.delegate = self;

        
        ContactButton *chatButton = [ContactButton buttonWithType:UIButtonTypeCustom];
        chatButton.hasBadge = self.hasBadge;
        chatButton.badgeNumber = [self.badgeNumberArray objectAtIndex:0];
        chatButton.frame = CGRectMake((int)(2.f * width / 3.f + 1), 0, (int)(width / 3.f), (int)height);
        chatButton.iconFilename = @"talk.png";
        chatButton.iconFilename_p = @"talk_p.png";
        chatButton.bgImageName = @"button_right_chat.png";
        chatButton.btnTitle = @"聊天";
        chatButton = [chatButton makeButton];
        chatButton.selector = @selector(chat:);
        chatButton.delegate = self;
        
        
        [self addSubview:messageButton];
        [self addSubview:emailButton];
        [self addSubview:chatButton];
        
    }
    return self;
}

- (void)sendMessage:(ContactButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(message:)]) {
        [self.delegate performSelector:@selector(message:) withObject:self.contact];
    }
}

- (void)sendEmail:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(email:)]) {
        [self.delegate performSelector:@selector(email:) withObject:self.contact];
    }
}

- (void)chat:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(chat:)]) {
        [self.delegate performSelector:@selector(chat:) withObject:self.contact];
    }
}

@end
