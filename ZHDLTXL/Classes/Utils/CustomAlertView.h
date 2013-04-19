//
//  CustomAlertView.h
//  Shake
//
//  Created by  on 11-11-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

//#import <AddressBook/AddressBook.h>
//#import <AddressBookUI/AddressBookUI.h>

@protocol CustomAlertViewDelegate;

@interface CustomAlertView : UIAlertView {
    UITextField *textField;
    NSString *placeHolder;
    id<CustomAlertViewDelegate> customAlertDelegate;
}

@property (nonatomic, retain) NSString *placeHolder;
@property (nonatomic, assign) id<CustomAlertViewDelegate> customAlertDelegate;
@property (nonatomic, retain) UITextField *textField;

- (id)initWithAddressBookTitle:(NSString *)title 
                       content:(NSString *)content 
                      delegate:(id)delegate 
             cancelButtonTitle:(NSString *)cancelButtonTitle 
                      okButton:(NSString *)okButtonTitle;

- (id)initWithTitle:(NSString *)title
            content:(NSString *)content
           delegate:(id)delegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle
           okButton:(NSString *)okButtonTitle;


@end

@protocol CustomAlertViewDelegate <NSObject>

- (void)addressBookOnClick;

@end