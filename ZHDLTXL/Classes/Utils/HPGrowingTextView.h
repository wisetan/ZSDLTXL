//
//  HPGrowingTextView.h
//  Lehe
//
//  Created by zhangluyi on 11-11-23.
//  Copyright 2011 Lehe. All rights reserved.
//


#import <UIKit/UIKit.h>

@class HPGrowingTextView;
@class HPTextViewInternal;

@protocol HPGrowingTextViewDelegate

@optional
- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView;
- (BOOL)growingTextViewShouldEndEditing:(HPGrowingTextView *)growingTextView;

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView;
- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView;

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView;

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height;
- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height;

- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView;
- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView;
@end

@interface HPGrowingTextView : UIView <UITextViewDelegate> {
	HPTextViewInternal *internalTextView;	
	
	int minHeight;
	int maxHeight;
	
	int maxNumberOfLines;
	int minNumberOfLines;
	
	BOOL animateHeightChange;
	
	NSObject <HPGrowingTextViewDelegate> *delegate;
	NSString *text;
	UIFont *font;
	UIColor *textColor;
	UITextAlignment textAlignment; 
	NSRange selectedRange;
	BOOL editable;
	UIDataDetectorTypes dataDetectorTypes;
	UIReturnKeyType returnKeyType;
    
    UIEdgeInsets contentInset;
    NSString *placeHolder;
    UIColor *placeHolderColor;
    UIColor *contentColor;
}

@property (nonatomic, retain) UIColor *contentColor;
@property (nonatomic, retain) UIColor *placeHolderColor;
@property (nonatomic, copy)   NSString *placeHolder;
@property int maxNumberOfLines;
@property int minNumberOfLines;
@property BOOL animateHeightChange;
@property (retain) UITextView *internalTextView;	

@property(assign) NSObject<HPGrowingTextViewDelegate> *delegate;
@property(nonatomic,assign) NSString *text;
@property(nonatomic,assign) UIFont *font;
@property(nonatomic,assign) UIColor *textColor;
@property(nonatomic) UITextAlignment textAlignment;
@property(nonatomic) NSRange selectedRange;
@property(nonatomic,getter=isEditable) BOOL editable;
@property(nonatomic) UIDataDetectorTypes dataDetectorTypes;
@property (nonatomic) UIReturnKeyType returnKeyType;
@property (assign) UIEdgeInsets contentInset;

- (id)initWithFrame:(CGRect)frame placeHolder:(NSString *)placeholder placeholderColor:(UIColor *)color;
- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;
- (BOOL)isFirstResponder;
- (BOOL)hasText;
- (void)scrollRangeToVisible:(NSRange)range;
- (void)clearText;
@end
