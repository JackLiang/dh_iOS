//
//  SUIRefreshControl.m
//  SUIKit
//
//  Created by Gordon Su on 13-10-25.
//  Copyright (c) 2013年 ZAKER. All rights reserved.
//

#import "SUIRefreshControl.h"
#import "SUIActivityIndicatorView.h"
#import <objc/runtime.h>
//#import "SUIFont.h"
#import "SUIColor.h"
//#import "SUIResource.h"

#define INDICATOR_WIDTH   28.f

#define FRAME_SIZE_HEIGHT 40.0f

typedef NS_ENUM (NSInteger, SUIRefreshControlState) {
    SUIRefreshControlNormalState = 0,
    SUIRefreshControlReadyState,
    SUIRefreshControlAnimatingState
};

@interface SUIRefreshControl () {
    BOOL _rotated;
}

@property (nonatomic) SUIRefreshControlState refreshControlState;

@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, weak) UIScrollView *lyingScrollView;

@end

@implementation SUIRefreshControl

- (void)dealloc
{
    if (_arrowImageView) {
        [_arrowImageView removeFromSuperview];
        _arrowImageView = nil;
    }

    if (_remindLabel) {
        [_remindLabel removeFromSuperview];
        _remindLabel = nil;
    }

    if (_activityIndicatorView) {
        if ([_activityIndicatorView isAnimating]) {
            [_activityIndicatorView stopAnimating];
        }
        [_activityIndicatorView removeFromSuperview];
        _activityIndicatorView = nil;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, FRAME_SIZE_HEIGHT)];
    if (self) {
        [self loadSubviews];
    }

    return self;
}

- (void)setRefreshControlStyle:(SUIRefreshControlStyle)refreshControlStyle
{
    _refreshControlStyle = refreshControlStyle;

    if (_refreshControlStyle == SUIRefreshControlBlackStyle) {
        UIImage *arrowImage = [UIImage imageNamed:@"RefreshControlArrowBlack"];
        self.arrowImageView.image = arrowImage;

        self.remindLabel.textColor = [UIColor sui_colorWithRGBHex:0x9d9d9d];
        self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    } else if (_refreshControlStyle == SUIRefreshControlWhiteStyle) {
        UIImage *arrowImage = [UIImage imageNamed:@"RefreshControlArrowWhite"];
        self.arrowImageView.image = arrowImage;

        self.remindLabel.textColor = [UIColor whiteColor];
        self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
}

- (void)setNormalText:(NSString *)normalText
{
    if (_normalText != normalText) {
        _normalText = normalText;

        if (_refreshControlState == SUIRefreshControlNormalState) {
            self.remindLabel.text = [self normalTextForReminder];
        }
    }
}

- (void)setReadyText:(NSString *)readyText
{
    if (_readyText != readyText) {
        _readyText = readyText;

        if (_refreshControlState == SUIRefreshControlReadyState) {
            self.remindLabel.text = [self readyTextForReminder];
        }
    }
}

- (void)setAnimatingText:(NSString *)animatingText
{
    if (_animatingText != animatingText) {
        _animatingText = animatingText;

        if (_refreshControlState == SUIRefreshControlAnimatingState) {
            self.remindLabel.text = [self animatingTextForReminder];
        }
    }
}

- (NSString *)normalTextForReminder
{
    return _normalText ? : @"下拉可以刷新...";
}

- (NSString *)readyTextForReminder
{
    return _readyText ? : @"松开即可刷新...";
}

- (NSString *)animatingTextForReminder
{
    return _animatingText ? : @"加载中...";
}

- (void)loadSubviews
{
    UIImage *arrowImage = [UIImage imageNamed:@"RefreshControlArrowBlack"];

    CGRect imageRect = CGRectMake(20.0, 2.0, 40.0, 40.0);

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageRect];
    imageView.contentMode = UIViewContentModeCenter;
    self.arrowImageView = imageView;
    self.arrowImageView.image = arrowImage;

    [self addSubview:self.arrowImageView];

    CGRect labelRect = CGRectMake((self.bounds.size.width - 100.0) / 2.0, 7.0, 100.0, 30.0);
    UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
    self.remindLabel = label;

    [self.remindLabel setBackgroundColor:[UIColor clearColor]];
    self.remindLabel.textColor = [UIColor sui_colorWithRGBHex:0x9d9d9d];
    self.remindLabel.font = [UIFont systemFontOfSize:12];
    self.remindLabel.textAlignment = NSTextAlignmentCenter;
    self.remindLabel.text = [self normalTextForReminder];
    [self addSubview:self.remindLabel];
    self.refreshControlState = SUIRefreshControlNormalState;

    UIActivityIndicatorView *uiactivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    uiactivityIndicator.frame = CGRectMake(0, 0, 40, 40);
    self.activityIndicatorView = uiactivityIndicator;
    [self addSubview:self.activityIndicatorView];
}

- (void)resetArrow
{
    if (!_rotated) {
        return;
    }
    _rotated = NO;

    [UIView beginAnimations:@"resetArrow" context:nil];
    [UIView setAnimationsEnabled:YES];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.arrowImageView.transform = CGAffineTransformIdentity;
    if ([self isAnimating]) {
        self.remindLabel.text = [self animatingTextForReminder];
    } else {
        self.remindLabel.text = [self normalTextForReminder];
    }

    [UIView commitAnimations];

    self.refreshControlState = SUIRefreshControlNormalState;
}

- (void)rotateArrow
{
    if (_rotated) {
        return;
    }
    _rotated = YES;

    [UIView beginAnimations:@"rotateArrow" context:nil];
    [UIView setAnimationsEnabled:YES];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI - 0.00001);
    self.arrowImageView.transform = transform;
    self.remindLabel.text = [self readyTextForReminder];
    self.refreshControlState = SUIRefreshControlReadyState;
    [UIView commitAnimations];
}

- (BOOL)isAnimating
{
    return [self.activityIndicatorView isAnimating];
}

- (void)stopAnimating
{
    [self stopAnimatingWithControlsHiddenDuration:0.0];
}

- (void)stopAnimatingWithControlsHiddenDuration:(NSTimeInterval)duration
{
    self.arrowImageView.hidden = YES;
    self.remindLabel.hidden = YES;
    self.remindLabel.text = [self normalTextForReminder];
    self.refreshControlState = SUIRefreshControlNormalState;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showArrowAndLabel) object:nil];
    [self performSelector:@selector(showArrowAndLabel) withObject:nil afterDelay:duration];
}

- (void)showArrowAndLabel
{
    self.arrowImageView.hidden = NO;
    self.remindLabel.hidden = NO;
}

- (void)startAnimating
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showArrowAndLabel) object:nil];

    self.arrowImageView.hidden = YES;
    self.arrowImageView.transform = CGAffineTransformIdentity;

    self.remindLabel.hidden = NO;
    self.remindLabel.text = [self animatingTextForReminder];
    self.refreshControlState = SUIRefreshControlAnimatingState;

    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (CGPoint)minimumContentOffsetOfScrollView:(UIScrollView *)scrollView
{
    return CGPointMake(0, 0 - scrollView.contentInset.top);
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];

    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        self.lyingScrollView = (UIScrollView *)newSuperview;
    } else {
        self.lyingScrollView = nil;
    }
}

- (void)update
{
    if ([self canSendControlEvent]) {
        [self rotateArrow];
    } else {
        [self resetArrow];
    }
}

- (BOOL)canSendControlEvent
{
    UIScrollView *scrollView = self.watchingScrollView ? : self.lyingScrollView;
    return [self minimumContentOffsetOfScrollView:scrollView].y - scrollView.contentOffset.y > self.minTriggerDistance;
}

+ (CGFloat)refreshControlHeight
{
    return FRAME_SIZE_HEIGHT;
}

@end
