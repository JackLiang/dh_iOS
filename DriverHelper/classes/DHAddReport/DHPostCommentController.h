//
//  DHPostCommentController.h
//  DriverHelper
//
//  Created by Gordon Su on 16/5/4.
//  Copyright © 2016年 S&L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHPostCommentInputView.h"

@interface DHPostCommentController : NSObject

@property (nonatomic, strong) UITextField *inputView;

@property (nonatomic, strong) UITextField *accessoryView;

- (void)showInView:(UIView *)superView;

@end
