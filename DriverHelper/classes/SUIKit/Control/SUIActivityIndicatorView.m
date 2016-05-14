//
//  SUIActivityIndicatorView.m
//  ZAKER
//
//  Created by steven mok on 12-11-19.
//
//

#import "SUIActivityIndicatorView.h"

#import <QuartzCore/QuartzCore.h>

#define STANDARD_VIEW_SIDE_LENGTH     36
#define STANDARD_INSTANCE_SIED_LENGTH 6
#define STANDARD_INSTANCE_PADDING     7
#define STANDARD_LEFT_MARGIN          4

@interface SUIActivityIndicatorView () {
    BOOL _animating;
    BOOL _shouldAnimate;
    BOOL _paused;

    CGFloat _instanceSideLength;
    CGFloat _instancePadding;
    CGFloat _replicatorLayerSideLength;
    CGFloat _leftMargin;

    CAReplicatorLayer *_replicatorLayer;
}

@property (nonatomic, strong) CALayer *originalRectangle;

@end

@implementation SUIActivityIndicatorView

- (void)dealloc
{
    if (_replicatorLayer) {
        [_replicatorLayer removeFromSuperlayer];
        _replicatorLayer = nil;
    }

    if (_originalRectangle) {
        [_originalRectangle removeFromSuperlayer];
        _originalRectangle = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStateChange:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStateChange:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [self calculateFrame];
        [self configLayers];
    }
    return self;
}

- (void)calculateFrame
{
    CGRect viewFrame = self.frame;
    _replicatorLayerSideLength = floorf(MAX(MIN(viewFrame.size.width, viewFrame.size.width), 0));
    CGFloat scale = _replicatorLayerSideLength / STANDARD_VIEW_SIDE_LENGTH;
    _instanceSideLength = floorf(STANDARD_INSTANCE_SIED_LENGTH * scale);
    _instancePadding = floorf(STANDARD_INSTANCE_PADDING * scale);
    _leftMargin = floorf(STANDARD_LEFT_MARGIN * scale);
}

- (void)configLayers
{
    _originalRectangle = [[CALayer alloc] init];
    _originalRectangle.frame = CGRectMake(_leftMargin, (_replicatorLayerSideLength - _instanceSideLength) / 2, _instanceSideLength, _instanceSideLength);
    _originalRectangle.opacity = 0;
    _originalRectangle.backgroundColor = [UIColor whiteColor].CGColor;

    _replicatorLayer = [[CAReplicatorLayer alloc] init];
    _replicatorLayer.frame = CGRectMake((self.bounds.size.width - _replicatorLayerSideLength) / 2, (self.bounds.size.height - _replicatorLayerSideLength) / 2, _replicatorLayerSideLength, _replicatorLayerSideLength);
    _replicatorLayer.instanceTransform = CATransform3DMakeTranslation((_instancePadding + _instanceSideLength), 0, 0);
    _replicatorLayer.instanceCount = 3;
    _replicatorLayer.instanceDelay = 0.25;

    [_replicatorLayer addSublayer:_originalRectangle];
    [self.layer addSublayer:_replicatorLayer];
}

- (void)updateShouldAnimate:(NSNotification *)notification
{
    // 有superview和window的，可以动画。
    _shouldAnimate = self.window && self.superview;

    // 不可以单纯判断applicationState来判断是否在后台，因为在从后台切换到前台的瞬间，applicationState还是返回UIApplicationStateBackground，会错误地识别为不能动画。所以作以下逻辑：
    // 1. 当知道是正在进入后台时，不能动画。
    // 2. 可能在切换前后台完成后，还有代码会执行，所以在非切换前后台时，如果当前的applicationState是后台，也不能动画。
    if (notification) {
        if ([notification.name isEqualToString:UIApplicationDidEnterBackgroundNotification]) {
            _shouldAnimate = NO;
        }
    } else {
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            _shouldAnimate = NO;
        }
    }
}

- (void)handleStateChange:(NSNotification *)notification
{
    [self updateShouldAnimate:notification];

    if (_shouldAnimate) {
        if (_paused) {
            _paused = NO;
            [self startAnimating];
        }
    } else {
        if (_animating && !_paused) {
            _paused = YES;
            [self stopAnimating];
        }
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];

    [self handleStateChange:nil];
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];

    [self handleStateChange:nil];
}

- (void)startAnimating
{
    if (_animating) {
        return;
    }

    _animating = YES;

    CAMediaTimingFunction *easeInOut = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CAMediaTimingFunction *easeIn = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    CAMediaTimingFunction *easeOut = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

    CAKeyframeAnimation *opacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.duration = 2;
    opacityAnim.values = @[@0, @1, @0, @0];
    opacityAnim.keyTimes = @[@0, @0.2, @0.7, @1];
    opacityAnim.timingFunctions = @[easeIn, easeInOut, easeOut];
    opacityAnim.repeatCount = NSUIntegerMax;
    [self.originalRectangle addAnimation:opacityAnim forKey:@"opacityAnim"];
}

- (void)stopAnimating
{
    if (!_animating) {
        return;
    }

    [self.originalRectangle removeAllAnimations];
    self.originalRectangle.opacity = 0;

    _animating = NO;
}

- (BOOL)isAnimating
{
    return _animating;
}

- (void)setTintColor:(UIColor *)tintColor
{
    if (tintColor) {
        self.originalRectangle.backgroundColor = tintColor.CGColor;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _originalRectangle.frame = CGRectMake(_leftMargin, (_replicatorLayerSideLength - _instanceSideLength) / 2, _instanceSideLength, _instanceSideLength);
    _replicatorLayer.frame = CGRectMake((self.bounds.size.width - _replicatorLayerSideLength) / 2, (self.bounds.size.height - _replicatorLayerSideLength) / 2, _replicatorLayerSideLength, _replicatorLayerSideLength);
}

@end
