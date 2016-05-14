//
//  SUIRefreshControl.h
//  SUIKit
//
//  Created by Gordon Su on 13-10-25.
//  Copyright (c) 2013年 ZAKER. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, SUIRefreshControlStyle) {
    SUIRefreshControlBlackStyle,
    SUIRefreshControlWhiteStyle,
};

@interface SUIRefreshControl : UIView

@property (nonatomic) SUIRefreshControlStyle refreshControlStyle;

@property (nonatomic) CGFloat minTriggerDistance;

@property (nonatomic, weak) UIScrollView *watchingScrollView;

@property (nonatomic, copy) NSString *normalText;
@property (nonatomic, copy) NSString *readyText;
@property (nonatomic, copy) NSString *animatingText;

- (void)resetArrow;
- (void)rotateArrow;

- (BOOL)isAnimating;
- (void)startAnimating;
- (void)stopAnimating;
- (void)stopAnimatingWithControlsHiddenDuration:(NSTimeInterval)duration;

- (void)update;
- (BOOL)canSendControlEvent;

+ (CGFloat)refreshControlHeight;

@end
