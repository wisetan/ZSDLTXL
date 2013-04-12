//
//  PhotoView.h
//  Shake
//
//  Created by zhangluyi on 11-12-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@protocol PhotoviewDelegate;

@interface PhotoView : UIView <UIScrollViewDelegate, EGOImageButtonDelegate>{
    NSMutableArray *photoUrlArray;
	NSMutableArray *photoDescArray;
    NSMutableArray *photosArray;
    UIScrollView *mScrollView;
	UILabel *descLabel;
    NSInteger currentPage;
	id<PhotoviewDelegate> delegate;
    UIActivityIndicatorView *indicator;
}

@property (nonatomic, retain) UIScrollView *mScrollView;
@property (nonatomic, retain) UILabel *descLabel;
@property (nonatomic, retain) NSMutableArray *photosArray;
@property (nonatomic, retain) NSMutableArray *photoUrlArray;
@property (nonatomic, retain) NSMutableArray *photoDescArray;
@property (nonatomic, retain) id<PhotoviewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame urls:(NSArray *)_photoUrlArray atIndex:(NSInteger)index descs:(NSArray *)_photoDescArray;
- (void)showPhotoAddToView:(UIView *)view;
@end

@interface PhotoView ()

- (void)loadPhotoInPage:(int)page;
- (void)removeOtherPhotos;

@end

@protocol PhotoviewDelegate <NSObject>
- (void)PhotoviewDone;
@end