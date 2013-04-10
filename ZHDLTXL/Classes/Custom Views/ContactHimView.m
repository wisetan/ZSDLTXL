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
@property (nonatomic, copy) NSString *bgImageName;
@property (nonatomic, retain) UIImageView *contactIcon;
@property (nonatomic, copy) NSString *iconFilename;
@property (nonatomic, copy) NSString *iconFilename_p;   //pressed image
@property (nonatomic, copy) NSString *contactName;

@end

@implementation ContactButton


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        [self setImage:[UIImage imageNamed:self.bgImageName] forState:UIControlStateNormal];
        
        self.contactIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.iconFilename]];
        CGFloat contactIconWidth = width / 3.f;
        CGFloat contactIconHeight = height * 5.f / 6.f;
        self.contactIcon.frame = CGRectMake(0, 0, (int)contactIconWidth, (int)contactIconHeight);
        self.contactIcon.center = CGPointMake((int)((self.center.x-self.frame.origin.x) / 1.8f), (int)self.center.y);
        [self addSubview:self.contactIcon];
        
        CGFloat contactLabelWidth = width / 2.f;
        CGFloat contactLabelHeight = contactLabelWidth;
        self.contactLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, (int)contactLabelWidth, (int)contactLabelHeight)] autorelease];
        self.contactLabel.text = @"邮件";
        self.contactLabel.font = [UIFont systemFontOfSize:15];
        self.contactLabel.textColor = [UIColor blueColor];
        self.contactLabel.backgroundColor = [UIColor clearColor];
        self.contactLabel.center = CGPointMake((int)((self.center.x-self.frame.origin.x)*1.5f), (int)(self.center.y));
        [self addSubview:self.contactLabel];
    }
    return self;
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
        
        //message button
        UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        messageButton.frame = CGRectMake(0, 0, (int)(width / 3.f), (int)height);
        [messageButton setImage:[UIImage imageNamed:@"button_left_message.png"] forState:UIControlStateNormal];
        [messageButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *messageIcon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message.png"]] autorelease];
        CGFloat messageIconWidth = width / 9.f;
        CGFloat messageIconHeight = messageIconWidth * 5.f / 6.f;
        messageIcon.frame = CGRectMake(0, 0, (int)messageIconWidth, (int)messageIconHeight);
        messageIcon.center = CGPointMake((int)(messageButton.center.x / 1.8f), (int)messageButton.center.y);
        [messageButton addSubview:messageIcon];
        
        CGFloat messageLabelWidth = width / 6.f;
        CGFloat messageLabelHeight = messageLabelWidth;
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (int)messageLabelWidth, (int)messageLabelHeight)];
        messageLabel.text = @"短信";
        messageLabel.font = [UIFont systemFontOfSize:15];
        messageLabel.textColor = [UIColor blueColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.center = CGPointMake((int)(messageButton.center.x * 1.5f) , (int)(messageButton.center.y));
        [messageButton addSubview:messageLabel];
        
        
        //email button
        UIButton *emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        emailButton.frame = CGRectMake((int)(width / 3.f), 0, (int)(width / 3.f + 1), (int)height);
        [emailButton setImage:[UIImage imageNamed:@"button_middle_email.png"] forState:UIControlStateNormal];
        [emailButton addTarget:self action:@selector(sendEmail:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *emailIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mail.png"]];
        CGFloat emailIconWidth = width / 9.f;
        CGFloat emailIconHeight = emailIconWidth * 5.f / 6.f;
        emailIcon.frame = CGRectMake(0, 0, emailIconWidth, emailIconHeight);
        emailIcon.center = CGPointMake((emailButton.center.x-emailButton.frame.origin.x) / 1.8f, emailButton.center.y);
        [emailButton addSubview:emailIcon];
        
        CGFloat emailLabelWidth = width / 6.f;
        CGFloat emailLabelHeight = messageLabelWidth;
        UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (int)emailLabelWidth, (int)emailLabelHeight)];
        emailLabel.text = @"邮件";
        emailLabel.font = [UIFont systemFontOfSize:15];
        emailLabel.textColor = [UIColor blueColor];
        emailLabel.backgroundColor = [UIColor clearColor];
        emailLabel.center = CGPointMake((int)((emailButton.center.x-emailButton.frame.origin.x)*1.5f), (int)(emailButton.center.y));
        [emailButton addSubview:emailLabel];
        
//        ContactButton *emailButton = [[ContactButton alloc] initWithFrame:CGRectMake((int)(width/3.f), 0, (int)(width/3.f+1), (int)height)];
//        emailButton.bgImageName = @"button_middle_email.png";
//        emailButton.contactName = @"邮件";
//        emailButton.iconFilename = @"mail.png";
//        emailButton.iconFilename_p = @"mail_p.png";
//        [self addSubview:emailButton];
        
        
        //chat button
        UIButton *chatButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        chatButton.frame = CGRectMake((int)(2.f * width / 3.f + 1), 0, (int)(width / 3.f), (int)height);
        [chatButton setImage:[UIImage imageNamed:@"button_right_chat.png"] forState:UIControlStateNormal];
        [chatButton addTarget:self action:@selector(chat:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *chatIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"talk.png"]];
        CGFloat chatIconWidth = width / 9.f;
        CGFloat chatIconHeight = chatIconWidth * 5.f / 6.f;
        chatIcon.frame = CGRectMake(0, 0, chatIconWidth, chatIconHeight);
        chatIcon.center = CGPointMake((int)((chatButton.center.x-chatButton.frame.origin.x) / 1.8f), (int)chatButton.center.y);
        [chatButton addSubview:chatIcon];
        
        CGFloat chatLabelWidth = width / 6.f;
        CGFloat chatLabelHeight = messageLabelWidth;
        UILabel *chatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (int)chatLabelWidth, (int)chatLabelHeight)];
        chatLabel.text = @"聊天";
        chatLabel.font = [UIFont systemFontOfSize:15];
        chatLabel.textColor = [UIColor blueColor];
        chatLabel.backgroundColor = [UIColor clearColor];
        chatLabel.center = CGPointMake((int)((chatButton.center.x-chatButton.frame.origin.x)*1.5f), (int)(chatButton.center.y));
        [chatButton addSubview:chatLabel];
        
        
        [self addSubview:messageButton];
        [self addSubview:emailButton];
        [self addSubview:chatButton];
        
    }
    return self;
}

- (void)sendMessage:(UIButton *)sender
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
