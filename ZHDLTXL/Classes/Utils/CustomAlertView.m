//
//  CustomAlertView.m
//  Shake
//
//  Created by  on 11-11-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView
@synthesize textField;
@synthesize placeHolder;
@synthesize customAlertDelegate;

- (id)initWithTitle:(NSString *)title
            content:(NSString *)content
           delegate:(id)delegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle
           okButton:(NSString *)okButtonTitle {
    self = [super initWithTitle:title message:@"\n\n\n" delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okButtonTitle, nil];
    if (self) {
        UILabel *smsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(12,40,260,25)] autorelease];        
        smsLabel.font = [UIFont systemFontOfSize:16];
        smsLabel.textColor = [UIColor whiteColor];
        smsLabel.backgroundColor = [UIColor clearColor];
        smsLabel.shadowColor = [UIColor blackColor];
        smsLabel.shadowOffset = CGSizeMake(0, -1);
        smsLabel.textAlignment = UITextAlignmentCenter;
        smsLabel.text = content;
        [self addSubview:smsLabel];
        
        self.textField = [[[UITextField alloc] initWithFrame:CGRectMake(16,83,250,25)] autorelease];
        textField.font = [UIFont systemFontOfSize:18];
        if (placeHolder && [placeHolder length] > 0) {
            textField.text = placeHolder;
        }
        textField.backgroundColor = [UIColor whiteColor];
        textField.keyboardAppearance = UIKeyboardAppearanceAlert;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.delegate = delegate;
        [textField becomeFirstResponder];
        [self addSubview:textField];        
    }
    return self;
}

- (id)initWithAddressBookTitle:(NSString *)title 
                       content:(NSString *)content 
                      delegate:(id)delegate 
             cancelButtonTitle:(NSString *)cancelButtonTitle 
                      okButton:(NSString *)okButtonTitle {
    
    self = [super initWithTitle:title message:@"\n\n\n" delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okButtonTitle, nil];
    if (self) {
        UILabel *smsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(12,40,260,25)] autorelease];
        smsLabel.font = [UIFont systemFontOfSize:16];
        smsLabel.textColor = [UIColor whiteColor];
        smsLabel.backgroundColor = [UIColor clearColor];
        smsLabel.shadowColor = [UIColor blackColor];
        smsLabel.shadowOffset = CGSizeMake(0, -1);
        smsLabel.textAlignment = UITextAlignmentCenter;
        smsLabel.text = content;
        [self addSubview:smsLabel];
        
        self.textField = [[[UITextField alloc] initWithFrame:CGRectMake(16,83,210,25)] autorelease];
        textField.font = [UIFont systemFontOfSize:18];
        if (placeHolder && [placeHolder length] > 0) {
            textField.text = placeHolder;
        }
        textField.backgroundColor = [UIColor whiteColor];
        textField.keyboardAppearance = UIKeyboardAppearanceAlert;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.delegate = delegate;
        [textField becomeFirstResponder];
        [self addSubview:textField];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(230, 83, 25, 25);
        [button addTarget:self action:@selector(addressBookAction) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageByName:@"ico_phone" ofType:@"png"] forState:UIControlStateNormal];
        [self addSubview:button];
    }
    return self;
}

- (void)addressBookAction {
    if ([customAlertDelegate respondsToSelector:@selector(addressBookOnClick)]) {
        [customAlertDelegate addressBookOnClick];
    }
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)dealloc {
    self.placeHolder = nil;
    self.textField = nil;
    [super dealloc];
}

@end
