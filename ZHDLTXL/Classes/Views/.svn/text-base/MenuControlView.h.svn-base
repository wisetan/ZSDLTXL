//
//  MenuControlView.h
//  ZXCXBlyt
//
//  Created by zly on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MenuDelegate;
@interface MenuControlView : UIView {
    NSMutableArray *buttonsArray;
    UIImageView *bgSlideView;
    NSInteger currentIndex;
    id<MenuDelegate> delegate;
}

@property (nonatomic, assign) id<MenuDelegate>  delegate;
@property (nonatomic, retain) NSMutableArray    *buttonsArray;
@property (nonatomic, retain) UIImageView       *bgSlideView;
@property (nonatomic, assign) NSInteger         currentIndex;

- (id)initWithItemsArray:(NSArray *)array;
- (void)slideBgToIndex:(NSInteger)index;
- (void)updateMenuButtonState;
@end

@protocol MenuDelegate <NSObject>
@required
- (void)menu:(MenuControlView *)menu clickedAtIndex:(NSInteger)index;
@end
