//
//  PhotoView.m
//  Shake
//
//  Created by zhangluyi on 11-12-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PhotoView.h"

@implementation PhotoView

@synthesize photoUrlArray,photoDescArray;
@synthesize photosArray;
@synthesize mScrollView,descLabel;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame urls:(NSArray *)_photoUrlArray atIndex:(NSInteger)index descs:(NSArray *)_photoDescArray;
{
    self = [super initWithFrame:frame];
    if (self) {
        indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
        indicator.frame = CGRectMake(0, 0, 30, 30);
        indicator.center = CGPointMake(160, 230);
        indicator.hidesWhenStopped = YES;
        [self addSubview:indicator];
        [indicator startAnimating];
        
        self.backgroundColor = RGBACOLOR(0,0,0,0.9);
        self.photoUrlArray = [NSMutableArray array];
		self.photoDescArray = [NSMutableArray array];
        
        if (_photoUrlArray && [_photoUrlArray count] > 0) {
            [self.photoUrlArray addObjectsFromArray:_photoUrlArray];
			
			if (index > [photoUrlArray count]-1) {
				index = [photoUrlArray count]-1;
			}
        }
		
		if (_photoDescArray && [_photoDescArray count] > 0) {
            [self.photoDescArray addObjectsFromArray:_photoDescArray];
        }
        
        self.photosArray = [NSMutableArray array];
        for (int i = 0; i < [photoUrlArray count]; i++)
        {
            [self.photosArray addObject:[NSNull null]];
        } 
		
        self.mScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, (480-320)/2, 320, 320)] autorelease];
        [self addSubview:self.mScrollView];
        mScrollView.pagingEnabled = YES;
        mScrollView.contentSize = CGSizeMake(320 * [self.photoUrlArray count], mScrollView.frame.size.height);
        mScrollView.showsHorizontalScrollIndicator = YES;
        mScrollView.showsVerticalScrollIndicator = NO;
        mScrollView.delegate = self;
		mScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
		
        if (self.photoDescArray && [photoDescArray count]>index) {
            self.descLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 430, 320, 30)] autorelease];
            [self addSubview:descLabel];
            descLabel.backgroundColor = [UIColor clearColor];
            descLabel.textColor = [UIColor whiteColor];
            descLabel.font = [UIFont systemFontOfSize:14];
            descLabel.lineBreakMode = UILineBreakModeTailTruncation;
            descLabel.numberOfLines = 1;
            descLabel.textAlignment = UITextAlignmentCenter;		
			descLabel.text = [photoDescArray objectAtIndex:index];
		}
        
        currentPage = index;
        
        [self loadPhotoInPage:(currentPage-1)];
        [self loadPhotoInPage:currentPage];
        [self loadPhotoInPage:(currentPage+1)];
        
        [mScrollView setContentOffset:CGPointMake(320*currentPage, 0) animated:NO];        
    }
    return self;
}

- (void)showPhotoAddToView:(UIView *)view {
    self.alpha = 0;
    [[kAppDelegate window] addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)backAction {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if ([delegate respondsToSelector:@selector(PhotoviewDone)]) {
            [delegate PhotoviewDone];
        }
//        [self didEndAction];
        [self removeFromSuperview];
    }];	
}

- (void)didEndAction {
//    for (HJManagedImageV *imageView in photosArray) {
//        if ([imageView isKindOfClass:[HJManagedImageV class]]) {
//            [imageView clear];
//        }
//    }
//    [self removeFromSuperview];
}

- (void)loadPhotoInPage:(NSInteger)page {
    if (page < 0 || page >= [photoUrlArray count]) {
        return;
    }
    EGOImageButton *photoImageView = [self.photosArray objectAtIndex:page];
    if ((NSNull *)photoImageView == [NSNull null]) {
        photoImageView = [[[EGOImageButton alloc] 
                           initWithFrame:CGRectMake(320*page, 0,320,mScrollView.frame.size.height)] autorelease];
        photoImageView.delegate = self;
        if (photoUrlArray && [photoUrlArray count] > page) {
            id url = [photoUrlArray objectAtIndex:page];
            if ([url isKindOfClass:[NSURL class]] ) {
                photoImageView.imageURL = url;
            } else {
                photoImageView.imageURL = [NSURL URLWithString:[photoUrlArray objectAtIndex:page]];
            }
        }
        
        [self.photosArray replaceObjectAtIndex:page withObject:photoImageView];
    }
    photoImageView.adjustsImageWhenHighlighted = NO;
    [photoImageView addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    if (photoImageView.superview == nil) {
        [self.mScrollView addSubview:photoImageView];
    }
}

- (void)imageButtonLoadedImage:(EGOImageButton*)imageButton {
    imageButton.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        imageButton.alpha = 1;
    }];
    [indicator stopAnimating];
}

- (void)imageButtonFailedToLoadImage:(EGOImageButton*)imageButton error:(NSError*)error {
    [indicator stopAnimating];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    int page = floor((mScrollView.contentOffset.x - 320 / 2) / 320) + 1;
    if (page != currentPage) {
        currentPage = page;
		if (currentPage > [photoUrlArray count]) {
			currentPage = [photoUrlArray count];
		}
        [self loadPhotoInPage:currentPage - 1];
        [self loadPhotoInPage:currentPage];
        [self loadPhotoInPage:currentPage + 1];
        [self removeOtherPhotos];    
    }
	if (self.photoDescArray && [photoDescArray count]>currentPage) {
		descLabel.text = [photoDescArray objectAtIndex:currentPage];
	}
}

- (void)removePhotoInPage:(NSInteger)page {
    if (page < 0 || page >= [photoUrlArray count]) {
        return;
    }
    
    EGOImageButton *photoImageView = [self.photosArray objectAtIndex:page];
    if ((NSNull *)photoImageView != [NSNull null]) {
        [photoImageView removeFromSuperview];
        [self.photosArray replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)removeOtherPhotos {
    for (int i = 0; i < [photosArray count]; i++) {
        if (i < (currentPage - 1) || i > (currentPage + 1)) {
            [self removePhotoInPage:i];
        }
    }
}

- (void)imageOnClick:(id)sender {
    [(EGOImageButton *)sender cancelImageLoad];
	[self backAction];
}

- (void)dealloc
{ 
    self.mScrollView    = nil;
    self.photosArray    = nil;
    self.photoUrlArray  = nil;
	self.photoDescArray = nil;
	self.descLabel = nil;
	self.delegate = nil;
    [super dealloc];
}

@end
