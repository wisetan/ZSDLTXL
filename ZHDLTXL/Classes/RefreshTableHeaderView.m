//
//  RefreshTableHeaderView.m
//  LeheV2
//
//  Created by zhangluyi on 11-4-22.
//  Copyright 2011 Lehe. All rights reserved.
//

#import "RefreshTableHeaderView.h"
#import "UIImage+stretch.h"
#define TEXT_COLOR [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

@interface RefreshTableHeaderView (Private)
- (void)setState:(PullRefreshState)aState;
@end

@implementation RefreshTableHeaderView

@synthesize delegate=_delegate;
@synthesize bgImageView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        self.backgroundColor = RGBCOLOR(244, 244, 244);
//        self.bgImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height)] autorelease];
//        self.bgImageView.image = [UIImage stretchableImage:@"bg_refresh" leftCap:0 topCap:20];
//        [self addSubview:self.bgImageView];
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		[label release];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
		CALayer *layer = [CALayer layer];
//		layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
        layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 50.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageByName:@"arrow.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
		
		
		[self setState:OPullRefreshNormal];
		
    }
	
    return self;
	
}


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {

	if ([_delegate respondsToSelector:@selector(lhRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate lhRefreshTableHeaderDataSourceLastUpdated:self];
		
        NSTimeZone *tzGMT = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [NSTimeZone setDefaultTimeZone:tzGMT];

		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:tzGMT];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"上一次更新: %@", [formatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"RefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[formatter release];
		
	} else {
		_lastUpdatedLabel.text = nil;
	}

}

- (void)setState:(PullRefreshState)aState{
	
	switch (aState) {
		case OPullRefreshPulling:
			
            _statusLabel.text = @"释放立即更新…";
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case OPullRefreshNormal:
			
			if (_state == OPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
            _statusLabel.text = @"下拉即可刷新";
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case OPullRefreshLoading:
			
            _statusLabel.text = @"更新中...";
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)lhRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == OPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;

		if ([_delegate respondsToSelector:@selector(lhRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate lhRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == OPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:OPullRefreshNormal];
		} else if (_state == OPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
			[self setState:OPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)lhRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;

	if ([_delegate respondsToSelector:@selector(lhRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate lhRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {

        [self setState:OPullRefreshLoading];
		if ([_delegate respondsToSelector:@selector(lhRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate lhRefreshTableHeaderDidTriggerRefresh:self];
		}
				
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		
	}
	
}

- (void)lhRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	if (_state == OPullRefreshLoading) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [scrollView setContentInset:UIEdgeInsetsZero];
        [UIView commitAnimations]; 
        // NSLog(@"OpullRefreshLoading!!");
        [self setState:OPullRefreshNormal];
    }
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	self.bgImageView = nil;
	_delegate = nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}


@end
