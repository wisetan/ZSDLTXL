//
//  RefreshTableHeaderView.h
//  LeheV2
//
//  Created by zhangluyi on 11-4-22.
//  Copyright 2011 Lehe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	OPullRefreshPulling = 0,
	OPullRefreshNormal,
	OPullRefreshLoading,	
} PullRefreshState;

@protocol RefreshTableHeaderDelegate;
@interface RefreshTableHeaderView : UIView {
	
	id _delegate;
	PullRefreshState _state;

	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
    UIImageView *bgImageView;
}

@property(nonatomic,assign) id <RefreshTableHeaderDelegate> delegate;
@property(nonatomic,retain) UIImageView *bgImageView;

- (void)setState:(PullRefreshState)aState;
- (void)refreshLastUpdatedDate;
- (void)lhRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)lhRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)lhRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end
@protocol RefreshTableHeaderDelegate
- (void)lhRefreshTableHeaderDidTriggerRefresh:(RefreshTableHeaderView*)view;
- (BOOL)lhRefreshTableHeaderDataSourceIsLoading:(RefreshTableHeaderView*)view;
@optional
- (NSDate*)lhRefreshTableHeaderDataSourceLastUpdated:(RefreshTableHeaderView*)view;
@end
