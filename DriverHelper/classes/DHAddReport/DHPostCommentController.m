//
//  DHPostCommentController.m
//  DriverHelper
//
//  Created by Gordon Su on 16/5/4.
//  Copyright © 2016年 S&L. All rights reserved.
//

#import "DHPostCommentController.h"

@interface DHPostCommentController ()<UITextFieldDelegate>
{
    NSString *_text;
}

@end

@implementation DHPostCommentController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self observeKeyboardNotifications];
    }
    return self;
}

- (UITextField *)inputView
{
    if (!_inputView) {
        _inputView = [[UITextField alloc] initWithFrame:CGRectMake(0, 375, 375, 44)];
        _inputView.delegate = self;
        _inputView.placeholder = @"输入描述";
        _inputView.inputAccessoryView = self.accessoryView;
        _accessoryView.delegate = self;
    }
    return _inputView;
}

- (UITextField *)accessoryView
{
    if (!_accessoryView) {
        _accessoryView = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 375, 44)];
        _accessoryView.backgroundColor = [UIColor whiteColor];
        _accessoryView.placeholder = @"输入描述";
        [_accessoryView sui_addBorderWithColor:[UIColor redColor]];
        _accessoryView.delegate = self;
    }
    return _accessoryView;
}

#pragma mark - private method

- (void)showInView:(UIView *)superView
{
    self.inputView.frame = CGRectMake(0, superView.bounds.size.height - 44, superView.bounds.size.width, 44);
    [superView addSubview:self.inputView];
}

#pragma mark - Keyboard
- (void)observeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(id)sender
{
    self.inputView.hidden = YES;
    [self.accessoryView becomeFirstResponder];
}

- (void)keyboardWillHide:(id)sender
{
    [self.accessoryView resignFirstResponder];
    self.inputView.hidden = NO;
    self.inputView.text = _text;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.accessoryView resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.accessoryView) {
        _text = textField.text;
    }
}

@end
