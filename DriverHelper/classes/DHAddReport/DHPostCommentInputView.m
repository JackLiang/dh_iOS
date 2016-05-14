//
//  DHPostCommentInputView.m
//  DriverHelper
//
//  Created by Gordon Su on 16/5/2.
//  Copyright © 2016年 S&L. All rights reserved.
//

#import "DHPostCommentInputView.h"

@interface DHPostCommentInputView ()<UITextFieldDelegate>

@end

@implementation DHPostCommentInputView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.placeholder = @"输入详情";
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.placeholder = @"输入详情";
    }
    return self;
}

@end
