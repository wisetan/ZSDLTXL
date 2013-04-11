//
//  ELCTextfieldCell.h
//  MobileWorkforce
//
//  Created by ZhangLuyi on 10/22/10.
//  Copyright 2010 ELC Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ELCTextFieldDelegate;
@interface ELCTextfieldCell : UITableViewCell <UITextFieldDelegate> {

	id<ELCTextFieldDelegate> ELCDelegate;
	UILabel *leftLabel;
	UITextField *rightTextField;
	NSIndexPath *indexPath;
    BOOL isEditable;
}

@property (nonatomic, assign) BOOL isEditable;
@property (nonatomic, assign) id<ELCTextFieldDelegate> ELCDelegate;
@property (nonatomic, retain) UILabel *leftLabel;
@property (nonatomic, retain) UITextField *rightTextField;
@property (nonatomic, retain) NSIndexPath *indexPath;

@end

@protocol ELCTextFieldDelegate<NSObject>
@optional
- (void)textFieldDidReturnWithIndexPath:(NSIndexPath*)_indexPath;
- (void)updateTextLabelAtIndexPath:(NSIndexPath*)_indexPath string:(NSString*)_string;
- (void)cell:(ELCTextfieldCell *)cell clickedAtIndexPath:(NSIndexPath *)indexPath;
- (void)updateText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath; //能准确捕捉各种变化
@end