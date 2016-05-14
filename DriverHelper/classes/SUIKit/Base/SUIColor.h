//
//  SUIColor.h
//  SUIKit
//
//  Created by gordon on 16/3/4.
//  Copyright © 2016年 syshop. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat SUIPerceivedBrightnessInvalid;

#if !TARGET_OS_WATCH
extern UIColor * SUIGetFirstLineCompositionColorWithView(UIView *view);
extern UIColor * SUIGetFirstLineCompositionColorWithImage(UIImage *image);
#endif

@interface UIColor (SUIAdditions)

+ (UIColor *)sui_colorWithRGBHex:(NSUInteger)hex;
+ (UIColor *)sui_colorWithRGBHex:(NSUInteger)hex alpha:(CGFloat)alpha;

+ (UIColor *)sui_colorWithRGBString:(NSString *)string alpha:(CGFloat)alpha;
+ (UIColor *)sui_colorWithRGBString:(NSString *)string;

- (NSString *)sui_RGBStringRepresentation;

- (NSString *)sui_RGBStringRepresentationWitAlpha:(BOOL)alphaFlag;

+ (UIColor *)sui_focusOrange;

+ (UIColor *)sui_lighterSeparatorGray;

+ (UIColor *)sui_separatorGray;

+ (UIColor *)sui_subtitleGray;

+ (UIColor *)sui_titleBlack;

- (UIColor *)sui_colorWithAlpha:(CGFloat)alpha;

- (UIColor *)sui_colorByInterpolatingWith:(UIColor *)color factor:(CGFloat)factor;

- (CGFloat)sui_perceivedBrightness;

- (BOOL)sui_prefersLightContent;

@end
