//
//  SUIActivityIndicatorView.h
//  ZAKER
//
//  Created by steven mok on 12-11-19.
//
//

#import <UIKit/UIKit.h>

@interface SUIActivityIndicatorView : UIView

- (id)initWithFrame:(CGRect)frame;

- (void)calculateFrame;

- (void)setTintColor:(UIColor *)tintColor;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

@end
